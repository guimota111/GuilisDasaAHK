; =========================================================
; Patologia — RTU de Próstata (Maligno)
; Versão: 1.2 (Sintaxe v2 Ultra-Safe e Desempate por Grau)
; =========================================================

Mask_RTUmaligno() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — RTU de Próstata (Maligno)")
    if IsSet(AplicarIcone)
        AplicarIcone(g)

    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. EXTENSÃO DO TUMOR ---
    g.AddGroupBox("w760 h80", "Extensão Tumoral")
    g.AddText("xp+15 yp+35", "Porcentagem total de acometimento do parênquima:")
    edtAcometimento := g.Add("Edit", "x+10 yp-3 w60 Center", "")
    g.AddText("x+5 yp+3", "%")

    ; --- 2. COMPONENTES GLEASON ---
    g.AddGroupBox("xm y+30 w760 h110", "Componentes de Gleason (Porcentagem Total)")

    g.AddText("xp+15 yp+30", "Gleason 3:")
    txtG3 := g.Add("Text", "x+5 yp w40 Center BackgroundWhite +Border", "100")
    g.AddText("x+5", "%")

    g.AddText("x+30", "Gleason 4:")
    edtG4 := g.Add("Edit", "x+5 yp-3 w40 Center", "0")
    g.AddText("x+5 yp+3", "%")

    ddlCribri := g.Add("DropDownList", "x+10 yp-3 w210 Choose1", ["sem componente cribriforme", "com componente cribriforme"])
    edtCribriPerc := g.Add("Edit", "x+5 yp w30 Center Hidden", "")

    g.AddText("xm+15 y+20", "Gleason 5:")
    edtG5 := g.Add("Edit", "x+5 yp-3 w40 Center", "0")
    g.AddText("x+5 yp+3", "%")

    ; --- 3. ACHADOS ADICIONAIS ---
    g.AddGroupBox("xm y+35 w760 h110", "Achados Adicionais")

    g.AddText("xp+15 yp+30", "Carcinoma Intraductal:")
    ddlIntraductal := g.Add("DropDownList", "x+5 yp-3 w120 Choose1", ["não detectado", "presente"])
    g.AddText("x+20", "Invasão Perineural:")
    ddlPerineural := g.Add("DropDownList", "x+5 yp-3 w120 Choose1", ["não detectada", "presente"])
    g.AddText("xm+15 y+20", "Invasão Vascular (Sang.):")
    ddlSanguinea := g.Add("DropDownList", "x+5 yp-3 w120 Choose1", ["não detectada", "presente"])
    g.AddText("x+17", "Invasão Vascular (Linf.):")
    ddlLinfatica := g.Add("DropDownList", "x+5 yp-3 w120 Choose1", ["não detectada", "presente"])

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
            txtG3.Text := "ERR", txtG3.SetFont("cRed")
            edtPrev.Value := "ERRO: A soma das porcentagens excede 100%!"
            return
        }
        txtG3.Text := p3, txtG3.SetFont("cBlack")
        edtPrev.Value := Build(p3, p4, p5)
    }

    ddlCribri.OnEvent("Change", (*) => (
        edtCribriPerc.Visible := (ddlCribri.Value == 2),
        UpdatePreview()
    ))

    campos := [edtAcometimento, edtG4, edtCribriPerc, edtG5, ddlIntraductal, ddlPerineural, ddlSanguinea, ddlLinfatica]
    for c in campos
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build(Integer(txtG3.Text), Integer(edtG4.Value), Integer(edtG5.Value))), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build(Integer(txtG3.Text), Integer(edtG4.Value), Integer(edtG5.Value)))

    g.Show()
    UpdatePreview()

    Build(p3, p4, p5) {
        ; Desempate: Se % igual, o maior grau ganha (5 > 4 > 3)
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

        ; --- TABELA ISUP (FORMATO TRADICIONAL PARA EVITAR ERRO DE ELSE) ---
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

        texto := "Tecido prostático exibindo:`r`n"
        texto .= "Adenocarcinoma acinar usual, acometendo " (edtAcometimento.Value || "[]") "% do total de fragmentos avaliados.`r`n"
        texto .= ". Gleason " prim "+" sec "=" (prim+sec) ", grau grupo " isup "`r`n"
        texto .= "- Porcentagem de Gleason 4: " p4 "%, " cribText "`r`n"
        texto .= "- Porcentagem de Gleason 5: " p5 "%`r`n"
        texto .= ". Carcinoma intraductal: " ddlIntraductal.Text "`r`n"
        texto .= ". Invasão vascular sanguínea: " ddlSanguinea.Text "`r`n"
        texto .= ". Invasão vascular linfática: " ddlLinfatica.Text "`r`n"
        texto .= ". Invasão perineural: " ddlPerineural.Text

        return texto
    }
}