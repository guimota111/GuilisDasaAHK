; =========================================================
; Cólon — Biópsia — Colite crônica
; Arquivo: scripts\ColonBiopsiaColiteCronica.ahk
; Função chamada no menu: Mask_ColonBiopsiaColiteCronica()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ColonBiopsiaColiteCronica() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Cólon — Colite crônica (biópsia)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; ATIVIDADE
    ; =========================
    g.AddText("w170", "Atividade")
    ddlAtiv := g.AddDropDownList("x+8 w520 Choose1", [
        "em fase quiescente",
        "em leve atividade",
        "em atividade moderada",
        "em atividade intensa"
    ])

    ; =========================
    ; PRESENÇA DE
    ; =========================
    g.AddText("xm y+12 w170", "Presença de")
    ddlPres := g.AddDropDownList("x+8 w520 Choose1", [
        "distorção arquitetural",
        "distorção arquitetural e criptite",
        "distorção arquitetural, criptite e abscessos de cripta",
        "distorção arquitetural, criptite, abscessos de cripta e granulomas",
        "distorção arquitetural, criptite, abscessos de cripta, granulomas e displasia de (alto ou baixo) grau"
    ])

    ; =========================
    ; AUSÊNCIA DE
    ; =========================
    g.AddText("xm y+12 w170", "Ausência de")
    ddlAus := g.AddDropDownList("x+8 w520 Choose1", [
        "criptite, abscessos de cripta, granulomas, ulceração e displasia",
        "abscessos de cripta, granulomas, ulceração e displasia",
        "granulomas, ulceração e displasia",
        "ulceração e displasia",
        "displasia"
    ])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r6 ReadOnly -Wrap")

    for ctrl in [ddlAtiv, ddlPres, ddlAus] {
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

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        txt := "Colite crônica " ddlAtiv.Text "`n"
        txt .= ". Presença de " ddlPres.Text "`n"
        txt .= ". Ausência de " ddlAus.Text
        return txt
    }
}
