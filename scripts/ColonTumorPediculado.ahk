; =========================================================
; Cólon — Adenocarcinoma em pólipo pediculado (Haggitt)
; Arquivo: scripts\ColonTumorPediculado.ahk
; Função chamada no menu: Mask_ColonTumorPediculado()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ColonTumorPediculado() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Cólon — Tumor pediculado (Haggitt)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; DIFERENCIAÇÃO / LESÃO DE ORIGEM
    ; =========================
    g.AddText("w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", [
        "bem",
        "moderadamente",
        "pouco"
    ])

    g.AddText("x+12 w220", "Surgindo em")
    ddlOrig := g.AddDropDownList("x+8 w420 Choose1", [
        "adenoma tubular com displasia de alto grau",
        "adenoma viloso com displasia de alto grau",
        "adenoma túbulo-viloso com displasia de alto grau",
        "adenoma serrilhado tradicional"
    ])

    ; =========================
    ; PROFUNDIDADE DE INVASÃO (mm)
    ; =========================
    g.AddText("xm y+12 w220", "Profundidade de invasão (mm)")
    edtMm := g.AddEdit("x+8 w120")
    g.AddText("x+8 yp+3", "mm")

    ; =========================
    ; NÍVEL DE HAGGITT
    ; =========================
    g.AddText("xm y+12 w220", "Profundidade da infiltração (Haggitt)")
    ddlHag := g.AddDropDownList("x+8 w520 Choose1", [
        "cabeça do pólipo – nível 1 de Haggitt",
        "colo do pólipo – nível 2 de Haggitt",
        "tumor atinge a haste do pólipo, sem ultrapassá-la – nível 3 de Haggitt",
        "tumor ultrapassa a haste do pólipo – nível 4 de Haggitt"
    ])

    ; =========================
    ; BUDDING
    ; =========================
    g.AddText("xm y+12 w350", "Budding (0,785 mm²)")
    ddlBuds := g.AddDropDownList("x+8 w320 Choose1", [
        "baixo escore (0 a 4)",
        "escore intermediário (5 a 9)",
        "alto escore (10 ou mais)"
    ])

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; ESTADIAMENTO (fixo)
    ; =========================
    g.AddText("xm y+12 w720", "Estadiamento patológico (pTNM AJCC 8ª edição): pT1 pNx")

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    for ctrl in [ddlDiff, ddlOrig, edtMm, ddlHag, ddlBuds, ddlIVS, ddlIVL, ddlIPN] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

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
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        mm := StrReplace(Trim(edtMm.Value), ",", ".")
        if (mm = "")
            mm := "[medida]"

        txt := "Adenocarcinoma " ddlDiff.Text " diferenciado, surgindo em " ddlOrig.Text "`n"
        txt .= ". Medida da profundidade de invasão da neoplasia: " mm " mm`n"
        txt .= ". Profundidade da infiltração: " ddlHag.Text "`n"
        txt .= ". Numero de “buds” tumorais em “hotspot” na fronte de invasão (área de 0,785mm²): " ddlBuds.Text "`n"
        txt .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " ddlIPN.Text "`n"
        txt .= "Estadiamento patológico (pTNM AJCC 8ª edição): pT1 pNx"
        return txt
    }
}
