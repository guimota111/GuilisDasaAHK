; =========================================================
; Apêndice — NET bem diferenciado (OMS 2019)
; Arquivo: scripts\ApendiceNet.ahk
; Função chamada no menu: Mask_ApendiceNet()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ApendiceNet() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Apêndice — NET bem diferenciado")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; GRAU / DIMENSÃO
    ; =========================
    g.AddText("w170", "Grau (OMS 2019)")
    ddlGrau := g.AddDropDownList("x+8 w220 Choose1", ["1 (OMS 2019)", "2 (OMS 2019)", "3 (OMS 2019)"])

    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; LOCALIZAÇÃO
    ; =========================
    g.AddText("xm y+12 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose1", [
        "porção distal do apêndice cecal",
        "porção proximal do apêndice cecal",
        "porção distal e proximal do apêndice cecal"
    ])

    ; =========================
    ; ÍNDICE MITÓTICO
    ; =========================
    g.AddText("xm y+12 w170", "Mitose (42 CGA)")
    edtMitoses := g.AddEdit("x+8 w80")

    g.AddText("x+12 w170", "Categoria (2,0 mm²)")
    ddlMitCat := g.AddDropDownList("x+8 w220 Choose1", ["< 2 mitoses", "2 a 20 mitoses", "> 20 mitoses"])

    ; =========================
    ; PROFUNDIDADE (com víscera adjacente)
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade (microsc.)")
    ddlProf := g.AddDropDownList("x+8 w520 Choose1", [
        "a lâmina própria",
        "a submucosa",
        "a muscular própria",
        "a subserosa (mesoapêndice) sem envolvimento do peritônio visceral",
        "a serosa (peritônio visceral)",
        "víscera adjacente {citar}"
    ])

    g.AddText("xm y+8 w170", "Víscera adjacente")
    edtAdj := g.AddEdit("x+8 w520")
    edtAdj.Enabled := false

    ; =========================
    ; OUTROS
    ; =========================
    g.AddText("xm y+12 w170", "Necrose")
    ddlNec := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("x+12 w170", "Inv. vasc. sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("xm y+12 w170", "Inv. vasc. linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("x+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    ; =========================
    ; APÊNDICE NÃO NEOPLÁSICO
    ; =========================
    g.AddText("xm y+16 w720", "Apêndice não neoplásico")
    ddlNonNeo := g.AddDropDownList("xm w720 Choose1", ["hiperplasia linfoide", "apendicite aguda"])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r11 ReadOnly -Wrap")

    for ctrl in [ddlGrau, edtDimA, edtDimB, ddlLoc, edtMitoses, ddlMitCat, ddlProf, edtAdj
               , ddlNec, ddlIVS, ddlIVL, ddlIPN, ddlNonNeo] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ddlProf.OnEvent("Change", (*) => (
        ToggleAdj(),
        UpdatePreview()
    ))

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := Build()))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    ToggleAdj()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ToggleAdj() {
        if (ddlProf.Value = 6) {
            edtAdj.Enabled := true
            edtAdj.Focus()
        } else {
            edtAdj.Enabled := false
            edtAdj.Value := ""
        }
    }

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        ; Dimensão
        dimA := StrReplace(Trim(edtDimA.Value), ",", ".")
        dimB := StrReplace(Trim(edtDimB.Value), ",", ".")
        if (dimA != "" && dimB != "")
            dimTxt := dimA " x " dimB " cm"
        else if (dimA != "" && dimB = "")
            dimTxt := dimA " cm"
        else if (dimA = "" && dimB != "")
            dimTxt := dimB " cm"
        else
            dimTxt := "[dimensão] x [dimensão] cm"

        ; Mitótico
        nMit := Trim(edtMitoses.Value)
        if (nMit = "")
            nMit := "[número]"

        ; Profundidade com {citar}
        if (ddlProf.Value = 6) {
            adj := Trim(edtAdj.Value)
            profTxt := (adj = "") ? "víscera adjacente {citar}" : "víscera adjacente (" adj ")"
        } else {
            profTxt := ddlProf.Text
        }

        txt := "Tumor neuroendócrino bem diferenciado grau " ddlGrau.Text "`n"
        txt .= ". Dimensões da neoplasia: " dimTxt "`n"
        txt .= ". Localização: " ddlLoc.Text "`n"
        txt .= ". Índice mitótico: " nMit " mitoses em 42 campos de grande aumento (" ddlMitCat.Text " / 2,0 mm²)`n"
        txt .= ". Profundidade de invasão microscópica da neoplasia: tumor invade " profTxt "`n"
        txt .= ". Necrose: " ddlNec.Text "`n"
        txt .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " ddlIPN.Text "`n"
        txt .= "Apêndice não neoplásico: " ddlNonNeo.Text
        return txt
    }
}
