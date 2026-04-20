; =========================================================
; Cólon — Biópsia — Tumor
; Arquivo: scripts\ColonBiopsiaTumor.ahk
; Função chamada no menu: Mask_ColonBiopsiaTumor()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ColonBiopsiaTumor() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Cólon — Tumor (biópsia)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO / DIFERENCIAÇÃO
    ; =========================
    g.AddText("w170", "Tipo")
    ddlTipo := g.AddDropDownList("x+8 w220 Choose1", [
        "invasor",
        "intramucoso"
    ])

    g.AddText("x+12 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", [
        "bem",
        "moderadamente",
        "pouco"
    ])

    ; =========================
    ; PROFUNDIDADE
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade da infiltração")
    ddlProf := g.AddDropDownList("x+8 w520 Choose1", [
        "lâmina própria",
        "submucosa"
    ])

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", [
        "não detectada",
        "presente"
    ])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", [
        "não detectada",
        "presente"
    ])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r6 ReadOnly -Wrap")

    for ctrl in [ddlTipo, ddlDiff, ddlProf, ddlIVS, ddlIVL] {
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
        txt := "Adenocarcinoma " ddlTipo.Text " " ddlDiff.Text " diferenciado`n"
        txt .= ". Profundidade da infiltração: " ddlProf.Text "`n"
        txt .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text
        return txt
    }
}
