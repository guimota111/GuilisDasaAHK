; =========================================================
; Apêndice — Tumor (OMS 2019)
; Arquivo: scripts\ApendiceTumor.ahk
; Função chamada no menu: Mask_ApendiceTumor()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ApendiceTumor() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Apêndice — Tumor (OMS 2019)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO / DIFERENCIAÇÃO
    ; =========================
    g.AddText("w170", "Tipo (OMS 2019)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Adenocarcinoma (OMS 2019)",
        "Adenocarcinoma mucinoso (OMS 2019)",
        "Carcinoma com células em anel de sinete (OMS 2019)",
        "Neoplasia mucinosa apendicular de baixo grau (OMS 2019)",
        "Neoplasia mucinosa apendicular de alto grau (OMS 2019)",
        "Adenocarcinoma de células caliciformes (OMS 2019)",
        "Carcinoma neuroendócrino de grandes células (OMS 2019)",
        "Carcinoma neuroendócrino de pequenas células (OMS 2019)",
        "Carcinoma medular (OMS 2019)",
        "Carcinoma adenoescamoso (OMS 2019)",
        "Carcinoma misto adenoneuroendócrino (OMS 2019)",
        "Carcinoma indiferenciado (OMS 2019)"
    ])

    g.AddText("xm y+12 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    ; =========================
    ; LOCALIZAÇÃO / DIMENSÃO
    ; =========================
    g.AddText("xm y+12 w170", "Localização da neoplasia")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose1", [
        "metade proximal do apêndice, sem envolvimento da base",
        "metade proximal do apêndice, com envolvimento da base",
        "metade distal do apêndice",
        "metades proximal e distal do apêndice cecal"
    ])

    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; PROFUNDIDADE — CÉLULAS EPITELIAIS
    ; =========================
    g.AddText("xm y+14 w720", "Profundidade da infiltração — células epiteliais")
    ddlProfEpi := g.AddDropDownList("xm w720 Choose1", [
        "invade lâmina própria ou muscular da mucosa",
        "invade a submucosa",
        "invade a muscular própria",
        "atinge o tecido adiposo subseroso ou de mesoapêndice, sem perfuração da serosa",
        "perfura a serosa",
        "invade víscera adjacente {citar}"
    ])

    g.AddText("xm y+8 w170", "Víscera adjacente")
    edtAdj := g.AddEdit("x+8 w520")
    edtAdj.Enabled := false

    ; =========================
    ; PROFUNDIDADE — MUCINA ACELULAR
    ; =========================
    g.AddText("xm y+14 w720", "Profundidade da infiltração — mucina acelular")
    ddlMucAcel := g.AddDropDownList("xm w720 Choose1", [
        "contida pela muscular própria",
        "atinge o tecido adiposo subseroso ou de mesoapêndice, sem perfuração da serosa",
        "perfura a serosa"
    ])

    ; =========================
    ; OUTROS PARÂMETROS
    ; =========================
    g.AddText("xm y+12 w170", "Serosa")
    ddlSerosa := g.AddDropDownList("x+8 w520 Choose1", [
        "livre de infiltração neoplásica",
        "infiltrada pela neoplasia"
    ])

    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w250", "Depósitos tumorais (gordura pericólica)")
    ddlDep := g.AddDropDownList("x+8 w220 Choose2", ["presentes", "não detectados"])

    ; =========================
    ; APÊNDICE NÃO NEOPLÁSICO
    ; =========================
    g.AddText("xm y+16 w720", "Apêndice não neoplásico")
    ddlNonNeo := g.AddDropDownList("xm w720 Choose1", [
        "dentro dos limites histológicos da normalidade",
        "apendicite aguda",
        "serosite aguda",
        "doença diverticular"
    ])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r12 ReadOnly -Wrap")

    for ctrl in [ddlTipo, ddlDiff, ddlLoc, edtDimA, edtDimB, ddlProfEpi, edtAdj, ddlMucAcel
               , ddlSerosa, ddlIVS, ddlIVL, ddlIPN, ddlDep, ddlNonNeo] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ddlProfEpi.OnEvent("Change", (*) => (
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
        if (ddlProfEpi.Value = 6) {
            edtAdj.Enabled := true
            edtAdj.Focus()
        } else {
            edtAdj.Enabled := false
            edtAdj.Value := ""
        }
    }

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        ; Dimensão (aceita 2,3 ou 2.3)
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

        ; Profundidade epitelial com víscera adjacente
        if (ddlProfEpi.Value = 6) {
            adj := Trim(edtAdj.Value)
            epiTxt := (adj = "") ? "tumor invade víscera adjacente {citar}" : "tumor invade víscera adjacente (" adj ")"
        } else {
            epiTxt := "tumor " ddlProfEpi.Text
        }

        txt := ddlTipo.Text " " ddlDiff.Text " diferenciado`n"
        txt .= ". Localização da neoplasia: " ddlLoc.Text "`n"
        txt .= ". Dimensão da neoplasia: " dimTxt "`n"
        txt .= ". Profundidade da infiltração:`n"
        txt .= "- Células epiteliais: " epiTxt "`n"
        txt .= "- Mucina acelular: " ddlMucAcel.Text "`n"
        txt .= ". Serosa: " ddlSerosa.Text "`n"
        txt .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " ddlIPN.Text "`n"
        txt .= ". Nódulos satélites tumorais em gordura pericólica (depósitos tumorais): " ddlDep.Text "`n"
        txt .= "Apêndice não neoplásico: " ddlNonNeo.Text
        return txt
    }
}
