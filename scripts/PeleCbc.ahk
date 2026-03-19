; =========================================================
; Pele — Carcinoma basocelular (CBC)
; Arquivo: scripts\PeleCBC.ahk
; Função chamada no menu: Mask_PeleCBC()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_PeleCBC() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pele — CBC")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("xm w720", "Selecione o padrão principal e, se quiser, um complemento:")

    ; =========================
    ; PADRÃO PRINCIPAL
    ; =========================
    g.AddText("xm y+10 w170", "Padrão principal")
    ddlMain := g.AddDropDownList("x+8 w520 Choose1", [
        "nodular",
        "superficial",
        "micronodular",
        "infiltrativo",
        "esclerodermiforme"
    ])

    ; =========================
    ; COMPLEMENTO (opcional)
    ; =========================
    g.AddText("xm y+12 w170", "Complemento")
    ddlComp := g.AddDropDownList("x+8 w520 Choose1", [
        "— (nenhum)",
        "e nodular",
        "e superficial",
        "e micronodular",
        "e infiltrativo",
        "e esclerodermiforme",
        ", ulcerado",
        ", pigmentado"
    ])

    ; =========================
    ; INVASÃO PERINEURAL
    ; =========================
    g.AddText("xm y+12 w170", "Invasão perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r6 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ; STATIC refs (evita #Warn + resolve escopo)
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0
    static s_ddlMain := 0, s_ddlComp := 0, s_ddlIPN := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev
    s_ddlMain := ddlMain
    s_ddlComp := ddlComp
    s_ddlIPN := ddlIPN

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    Build() {
        comp := s_ddlComp.Text
        if (comp = "— (nenhum)")
            comp := ""

        header := "Carcinoma basocelular padrão(ões) " s_ddlMain.Text
        if (comp != "")
            header .= " " comp

        return (
            header "`n"
            ". Invasão perineural: " s_ddlIPN.Text
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    ; =========================
    ; EVENTOS
    ; =========================
    for ctrl in [ddlMain, ddlComp, ddlIPN] {
        try ctrl.OnEvent("Change", UpdatePreview)
        try ctrl.OnEvent("Click",  UpdatePreview)
    }

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        s_g.Destroy(),
        PasteInto(s_prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := Build()))
    btnCancel.OnEvent("Click", (*) => s_g.Destroy())

    g.Show()
    UpdatePreview()
}
