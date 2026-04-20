; =========================================================
; Patologia — Biópsia de Próstata (Tumor)
; Versão: 1.2 (Correção de Lógica de Prevalência e Sintaxe)
; =========================================================

Mask_ProstataBiopsiaTumor() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Biópsia de Próstata (Tumor)")
    if IsSet(AplicarIcone)
        AplicarIcone(g)

    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. DADOS DOS FRAGMENTOS ---
    g.AddGroupBox("w760 h100", "Acometimento e Extensão")
    g.AddText("xm+15 yp+25", "Fragmentos:")
    edtFragPos := g.Add("Edit", "x+5 yp w40 Center", "2")
    g.AddText("x+5 yp", "de")
    edtFragTot := g.Add("Edit", "x+5 yp w40 Center", "2")


    g.AddText("xm+15 y+20", "Porcentagens (separe por espaço):")
    edtPercs := g.Add("Edit", "x+5 yp-3 w200", "")
    g.AddText("x+10 yp+3", "Forma:")
    ddlForma := g.Add("DropDownList", "x+5 yp-3 w110 Choose1", ["contínua", "descontínua"])

   ; --- 2. COMPONENTES GLEASON (CÁLCULO AUTOMÁTICO) ---
    g.AddGroupBox("xm y+35 w760 h110", "Componentes de Gleason (Porcentagem Total)")

    ; Coluna da Esquerda: Inputs Manuais
    g.AddText("xp+15 yp+30", "Gleason 4:")
    edtG4 := g.Add("Edit", "x+5 yp-3 w40 Center", "0")
    g.AddText("x+5 yp+3", "%")

    ddlCribri := g.Add("DropDownList", "x+15 yp-3 w210 Choose1", ["sem componente cribriforme", "com componente cribriforme"])
    edtCribriPerc := g.Add("Edit", "x+5 yp w35 Center Hidden", "")

    g.AddText("xm+15 y+20", "Gleason 5:")
    edtG5 := g.Add("Edit", "x+5 yp-3 w40 Center", "0")
    g.AddText("x+5 yp+3", "%")

    ; Coluna da Direita: Resultado Calculado (G3)
    ; O 'x+250' empurra o G3 para o final do GroupBox
    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("x+250 y200 cGray", "Gleason 3 (Restante):") ; Ajuste o y conforme necessário ou use yp
    txtG3 := g.Add("Text", "x+10 yp-5 w50 h25 Center +0x200 BackgroundWhite +Border", "100")
    g.AddText("x+5 yp+5 cGray", "%")
    g.SetFont("s9 Norm", "Segoe UI")


    ; --- 3. OUTROS ---
    g.AddText("xm+15 y+45", "Invasão Perineural:")
    ddlPerineural := g.Add("DropDownList", "x+5 yp-3 w130 Choose1", ["não detectada", "presente"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+40", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r10 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) {
        p4 := IsNumber(edtG4.Value) ? Integer(edtG4.Value) : 0
        p5 := IsNumber(edtG5.Value) ? Integer(edtG5.Value) : 0
        p3 := 100 - p4 - p5

        if (p3 < 0) {
            txtG3.Text := "ERR"
            txtG3.SetFont("cRed")
            edtPrev.Value := "ERRO: A soma das porcentagens excede 100%!"
            return
        }

        txtG3.Text := p3
        txtG3.SetFont("cBlack")
        edtPrev.Value := Build(p3, p4, p5)
    }

    ddlCribri.OnEvent("Change", (*) => (
        edtCribriPerc.Visible := (ddlCribri.Value == 2),
        UpdatePreview()
    ))

    campos := [edtFragPos, edtFragTot, edtPercs, ddlForma, edtG4, edtCribriPerc, edtG5, ddlPerineural]
    for c in campos
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build(Integer(txtG3.Text), Integer(edtG4.Value), Integer(edtG5.Value))), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build(Integer(txtG3.Text), Integer(edtG4.Value), Integer(edtG5.Value)))

    g.Show()
    UpdatePreview()

    Build(p3, p4, p5) {
        numPos := IsNumber(edtFragPos.Value) ? Integer(edtFragPos.Value) : 0
        numTot := IsNumber(edtFragTot.Value) ? Integer(edtFragTot.Value) : 0

        fPosStr := Format("{:02}", numPos)
        fTotStr := Format("{:02}", numTot)

        labelFrag := (numTot == 1) ? "fragmento avaliado" : "fragmentos avaliados"
        labelPerc := (numPos == 1) ? "na porcentagem de " : "nas porcentagens de "

        rawPercs := StrSplit(RegExReplace(edtPercs.Value, "\s+", " "), " ")
        percsFormatadas := []
        loop numPos {
            v := (A_Index <= rawPercs.Length && rawPercs[A_Index] != "") ? rawPercs[A_Index] : "[]"
            percsFormatadas.Push(v . "%")
        }
        strPercs := ""
        for i, v in percsFormatadas
            strPercs .= (i=1 ? "" : (i=percsFormatadas.Length ? " e " : ", ")) v

        ; Lógica de Desempate Gleason: Maior grau prevalece se a porcentagem for igual
        comp := [{g:3, p:p3}, {g:4, p:p4}, {g:5, p:p5}]
        loop 2 {
            loop 2 {
                if (comp[A_Index+1].p > comp[A_Index].p) || (comp[A_Index+1].p == comp[A_Index].p && comp[A_Index+1].g > comp[A_Index].g) {
                    temp := comp[A_Index], comp[A_Index] := comp[A_Index+1], comp[A_Index+1] := temp
                }
            }
        }
        prim := comp[1].g
        sec := comp[2].p > 0 ? comp[2].g : comp[1].g

        ; --- TABELA ISUP CORRIGIDA ---
        isup := "0"
        if (prim == 3 && sec == 3)
            isup := "1 (ISUP/OMS)"
        else if (prim == 3 && sec == 4)
            isup := "2 (ISUP/OMS)"
        else if (prim == 3 && sec == 5)
            isup := "4 (ISUP/OMS)"
        else if (prim == 4 && sec == 3)
            isup := "3 (ISUP/OMS)"
        else if (prim == 4 && sec == 4)
            isup := "4 (ISUP/OMS)"
        else if (prim == 4 && sec == 5)
            isup := "5 (ISUP/OMS)"
        else if (prim == 5 && sec == 3)
            isup := "4 (ISUP/OMS)"
        else if (prim == 5 && sec == 4)
            isup := "5 (ISUP/OMS)"
        else if (prim == 5 && sec == 5)
            isup := "5 (ISUP/OMS)"

        cribText := ddlCribri.Text
        if (ddlCribri.Value == 2)
            cribText := "com " (edtCribriPerc.Value || "{}") "% de componente cribriforme"

        texto := "Adenocarcinoma acinar usual, acometendo " fPosStr " de " fTotStr " " labelFrag ", " labelPerc (strPercs || "[]%") ", de forma " ddlForma.Text "."
        texto .= "`r`n. Gleason " prim "+" sec "=" (prim+sec) ", grau grupo " isup
        texto .= "`r`n- Porcentagem de Gleason 4: " p4 "%, " cribText
        texto .= "`r`n- Porcentagem de Gleason 5: " p5 "%"
        texto .= "`r`n. Invasão perineural: " ddlPerineural.Text

        return texto
    }
}