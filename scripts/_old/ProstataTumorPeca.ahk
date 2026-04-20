; =========================================================
; Patologia — Prostatectomia Radical (Peça Cirúrgica)
; Versão: 2.0 (Cálculo por Cassetes e Médias Ponderadas)
; =========================================================

Mask_ProstataTumorPeca() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Prostatectomia (Peça)")
    if IsSet(AplicarIcone)
        AplicarIcone(g)

    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")

    ; --- 1. ENTRADA DE DADOS POR CASSETE ---
    g.AddGroupBox("xm w760 h160", "Entrada de Dados por Cassete (Total: 34)")
    g.AddText("xp+15 yp+25 w730", "Insira as porcentagens de [Tumor Total] [Gleason 4] [Gleason 5] separadas por espaço para cada cassete (uma linha por cassete):`nEx: 20 10 0 (20% tumor, 10% de G4, 0% de G5)")

    ; Edit Multiline para entrada rápida de 34 linhas
    edtDados := g.Add("Edit", "r6 w730 vDados", "")

    ; --- 2. GLEASON RESULTANTE (DIREITA) E LOCALIZAÇÃO (ESQUERDA) ---
    g.AddGroupBox("xm y+20 w480 h150", "Achados Adicionais")
    chkPin := g.Add("Checkbox", "xp+15 yp+25", "PIN de")
    ddlPinGrau := g.Add("DropDownList", "x+5 yp-3 w70 Choose1", ["Alto", "Baixo"])
    g.AddText("x+5 yp+3", "grau")

    chkHNP := g.Add("Checkbox", "xm+30 y+15", "Hiperplasia nodular")
    chkInf := g.Add("Checkbox", "xm+30 y+15", "Processo inflamatório crônico")
    chkAtr := g.Add("Checkbox", "xm+30 y+15", "Atrofia acinar")

    ; Coluna de Invasões
    g.AddText("x260 y215", "Invasão Vascular (S):")
    ddlSang := g.Add("DropDownList", "x+5 yp-3 w90 Choose2", ["presente", "não detectada"])
    g.AddText("x260 y+15", "Invasão Vascular (L):")
    ddlLin := g.Add("DropDownList", "x+5 yp-3 w90 Choose2", ["presente", "não detectada"])
    g.AddText("x260 y+15", "Invasão Perineural:")
    ddlPeri := g.Add("DropDownList", "x+5 yp-3 w90 Choose1", ["presente", "não detectada"])

    ; Groupbox do Resultado Calculado
    g.AddGroupBox("x500 y185 w260 h150", "Cálculos Resultantes")
    g.SetFont("s8 Bold")
    g.AddText("x515 y215", "Volume Neoplasia:")
    txtVol := g.Add("Text", "x+5 w60 h20 Center BackgroundWhite +Border +0x200", "0%")

    g.AddText("x515 y+15", "Média G4:")
    txtMG4 := g.Add("Text", "x+5 w60 h20 Center BackgroundWhite +Border +0x200", "0%")
    g.AddText("x515 y+15", "Média G5:")
    txtMG5 := g.Add("Text", "x+5 w60 h20 Center BackgroundWhite +Border +0x200", "0%")
    g.SetFont("s9 Norm")

    ; --- PRÉVIA ---
    g.AddText("xm y+30", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r12 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE PROCESSAMENTO ---

    UpdatePreview(*) {
        ; Inicialização de Variáveis
        somaTumor := 0
        somaPonderadaG4 := 0
        somaPonderadaG5 := 0
        locaisAcometidos := Map()

        linhas := StrSplit(edtDados.Value, "`n", "`r")

        loop 34 {
            if (A_Index > linhas.Length)
                break

            dados := StrSplit(RegExReplace(linhas[A_Index], "\s+", " "), " ")
            pTumor := (dados.Length >= 1 && IsNumber(dados[1])) ? Float(dados[1]) : 0
            pG4    := (dados.Length >= 2 && IsNumber(dados[2])) ? Float(dados[2]) : 0
            pG5    := (dados.Length >= 3 && IsNumber(dados[3])) ? Float(dados[3]) : 0

            if (pTumor > 0) {
                somaTumor += pTumor
                somaPonderadaG4 += (pG4 * pTumor)
                somaPonderadaG5 += (pG5 * pTumor)

                ; Identificar Localização baseada no índice do cassete
                if (A_Index <= 8) {
                    locaisAcometidos["porção anterior do lobo médio direito"] := 1
                } else if (A_Index <= 16) {
                    locaisAcometidos["porção posterior do lobo médio direito"] := 1
                } else if (A_Index <= 24) {
                    locaisAcometidos["porção anterior do lobo médio esquerdo"] := 1
                } else if (A_Index <= 32) {
                    locaisAcometidos["porção posterior do lobo médio esquerdo"] := 1
                } else if (A_Index == 33) {
                    locaisAcometidos["ápice direito"] := 1
                    locaisAcometidos["ápice esquerdo"] := 1
                } else if (A_Index == 34) {
                    locaisAcometidos["base direita"] := 1
                    locaisAcometidos["base esquerda"] := 1
                }
            }
        }

        volFinal := somaTumor / 34
        mediaG4  := somaTumor > 0 ? somaPonderadaG4 / somaTumor : 0
        mediaG5  := somaTumor > 0 ? somaPonderadaG5 / somaTumor : 0
        mediaG3  := 100 - mediaG4 - mediaG5

        txtVol.Text := Round(volFinal, 1) "%"
        txtMG4.Text := Round(mediaG4, 1) "%"
        txtMG5.Text := Round(mediaG5, 1) "%"

        edtPrev.Value := Build(volFinal, mediaG3, mediaG4, mediaG5, locaisAcometidos)
    }

    edtDados.OnEvent("Change", UpdatePreview)
    for ctrl in [ddlPinGrau, ddlSang, ddlLin, ddlPeri, chkPin, chkHNP, chkInf, chkAtr] {
        try ctrl.OnEvent("Change", UpdatePreview)
        try ctrl.OnEvent("Click",  UpdatePreview)
    }

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, edtPrev.Value), g.Destroy()))

    g.Show()
    UpdatePreview()

    Build(vol, p3, p4, p5, locais) {
        ; Lógica de Gleason (Igual aos anteriores)
        comp := [{g:3, p:p3}, {g:4, p:p4}, {g:5, p:p5}]
        loop 2 {
            loop 2 {
                if (comp[A_Index+1].p > comp[A_Index].p) || (comp[A_Index+1].p == comp[A_Index].p && comp[A_Index+1].g > comp[A_Index].g) {
                    t := comp[A_Index], comp[A_Index] := comp[A_Index+1], comp[A_Index+1] := t
                }
            }
        }
        prim := comp[1].g, sec := comp[2].p > 0 ? comp[2].g : comp[1].g

        ; Formatação da Localização
        strLoc := ""
        itensLoc := []
        for k, v in locais
            itensLoc.Push(k)

        for i, v in itensLoc
            strLoc .= (i==1 ? "" : (i==itensLoc.Length ? " e " : ", ")) v

        res := "Adenocarcinoma acinar usual`r`n"
        res .= ". Graduação histológica: Gleason " prim "+" sec "=" (prim+sec) "`r`n"
        res .= "- Porcentagem de Gleason 4: " Round(p4, 1) "%`r`n"
        res .= "- Porcentagem de Gleason 5: " Round(p5, 1) "%`r`n"
        res .= ". Localização: " (strLoc || "[]") "`r`n"
        res .= ". Volume da neoplasia: " Round(vol, 1) "% do órgão acometido`r`n"
        res .= ". Invasão vascular sanguínea: " ddlSang.Text "`r`n"
        res .= ". Invasão vascular linfática: " ddlLin.Text "`r`n"
        res .= ". Invasão perineural: " ddlPeri.Text "`r`n`n"
        res .= "Tecido prostático adjacente à neoplasia:`r`n"
        if chkPin.Value
            res .= ". Neoplasia intraepitelial prostática (PIN) de " ddlPinGrau.Text " grau`r`n"
        if chkHNP.Value
            res .= ". Hiperplasia nodular`r`n"
        if chkInf.Value
            res .= ". Processo inflamatório crônico`r`n"
        if chkAtr.Value
            res .= ". Atrofia acinar"

        return res
    }
}