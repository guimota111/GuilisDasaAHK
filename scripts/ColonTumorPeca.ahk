; =========================================================
; Cólon/Reto — Tumor (peça) — OMS 2019
; Arquivo: scripts\ColonTumorPeca.ahk
; Função chamada no menu: Mask_ColonTumorPeca()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ColonTumorPeca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Cólon/Reto — Tumor (peça)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO / DIFERENCIAÇÃO
    ; =========================
    g.AddText("w170", "Tipo (OMS 2019)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Adenocarcinoma, SOE",
        "Adenocarcinoma mucinoso",
        "Adenocarcinoma serrilhado",
        "Carcinoma de células em anel de sinete",
        "Carcinoma medular",
        "Carcinoma micropapilífero",
        "Carcinoma adenoescamoso",
        "Carcinoma com componente sarcomatoide",
        "Carcinoma neuroendócrino de grandes células",
        "Carcinoma neuroendócrino de pequenas células",
        "Carcinoma misto neuroendócrino e não neuroendócrino",
        "Carcinoma indiferenciado"
    ])

    g.AddText("xm y+12 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    g.AddText("x+12 w170", "Ulceração")
    ddlUlc := g.AddDropDownList("x+8 w220 Choose1", ["ulcerado", "não ulcerado"])

    ; =========================
    ; LOCALIZAÇÃO / DIMENSÃO
    ; =========================
    g.AddText("xm y+12 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose2", [
        "ceco",
        "cólon ascendente",
        "flexura hepática",
        "cólon transverso",
        "flexura esplênica",
        "cólon descendente",
        "sigmoide",
        "transição retossigmoide",
        "reto",
        "transição reto-canal anal"
    ])

    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; PROFUNDIDADE (com víscera adjacente)
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade")
    ddlProf := g.AddDropDownList("x+8 w520 Choose2", [
        "restrito à mucosa",
        "invade a submucosa",
        "invade a muscular própria",
        "atinge o tecido adiposo subseroso",
        "perfura a serosa",
        "invade víscera adjacente {citar}"
    ])

    g.AddText("xm y+8 w170", "Víscera adjacente")
    edtAdj := g.AddEdit("x+8 w520")
    edtAdj.Enabled := false

    ; =========================
    ; OUTROS PARÂMETROS
    ; =========================
    g.AddText("xm y+12 w170", "Serosa")
    ddlSerosa := g.AddDropDownList("x+8 w520 Choose1", [
        "livre de infiltração neoplásica",
        "infiltrada pela neoplasia"
    ])

    g.AddText("xm y+12 w170", "Fronte de invasão")
    ddlFronte := g.AddDropDownList("x+8 w220 Choose1", ["infiltrativa", "expansiva"])

    g.AddText("x+12 w250", "Budding (0,785 mm²)")
    ddlBuds := g.AddDropDownList("x+8 w220 Choose1", [
        "baixo escore (0 a 4)",
        "escore intermediário (5 a 9)",
        "alto escore (10 ou mais)"
    ])

    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w320", "Depósitos tumorais (gordura pericólica)")
    ddlDep := g.AddDropDownList("x+8 w220 Choose1", ["não detectados", "presentes"])

    ; =========================
    ; CÓLON NÃO NEOPLÁSICO
    ; =========================
    g.AddText("xm y+16 w720", "Cólon não neoplásico")
    ddlNonNeo := g.AddDropDownList("xm w720 Choose1", [
        "dentro dos limites histológicos da normalidade",
        "doença diverticular",
        "serosite aguda",
        "adenoma tubular com displasia de baixo grau",
        "pólipo hiperplásico"
    ])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r12 ReadOnly -Wrap")

    for ctrl in [ddlTipo, ddlDiff, ddlUlc, ddlLoc, edtDimA, edtDimB, ddlProf, edtAdj, ddlSerosa, ddlFronte
               , ddlBuds, ddlIVS, ddlIVL, ddlIPN, ddlDep, ddlNonNeo] {
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

        ; Profundidade com {citar}
        if (ddlProf.Value = 6) {
            adj := Trim(edtAdj.Value)
            profTxt := (adj = "")
                ? "tumor invade víscera adjacente {citar}"
                : "tumor invade víscera adjacente (" adj ")"
        } else {
            profTxt := "tumor " ddlProf.Text
        }

        header := ddlTipo.Text " (OMS 2019) " ddlDiff.Text " diferenciado, " ddlUlc.Text

        txt := header "`n"
        txt .= ". Localização da neoplasia: " ddlLoc.Text "`n"
        txt .= ". Dimensão da neoplasia: " dimTxt "`n"
        txt .= ". Profundidade da infiltração: " profTxt "`n"
        txt .= ". Serosa: " ddlSerosa.Text "`n"
        txt .= ". Fronte de invasão: " ddlFronte.Text "`n"
        txt .= ". Numero de “buds” tumorais em “hotspot” na fronte de invasão (área de 0,785mm²): " ddlBuds.Text "`n"
        txt .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " ddlIPN.Text "`n"
        txt .= ". Nódulos satélites tumorais em gordura pericólica (depósitos tumorais): " ddlDep.Text "`n"
        txt .= "Cólon não neoplásico: " ddlNonNeo.Text
        return txt
    }
}
