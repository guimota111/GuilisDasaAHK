; =========================================================
; Pele — Nevo
; Arquivo: scripts\PeleNevo.ahk
; Função chamada no menu: Mask_PeleNevo()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_PeleNevo() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pele — Nevo")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO DE NEVO
    ; =========================
    g.AddText("w170", "Tipo")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "melanocítico intradérmico",
        "melanocítico juncional",
        "melanocítico composto",
        "melanocítico acral",
        "melanocítico atípico juncional com atipia leve",
        "melanocítico atípico juncional com atipia moderada",
        "melanocítico atípico juncional com atipia acentuada",
        "melanocítico atípico composto com atipia leve",
        "melanocítico atípico composto com atipia moderada",
        "melanocítico atípico composto com atipia acentuada",
        "azul",
        "de Reed",
        "de Spitz"
    ])

    ; =========================
    ; MARGENS
    ; =========================
    g.AddText("xm y+12 w170", "Margens periféricas")
    ddlPerif := g.AddDropDownList("x+8 w520 Choose1", [
        "livres de",
        "comprometidas pela",
        "uma das margens comprometida pela"
    ])

    g.AddText("xm y+12 w170", "Margem profunda")
    ddlProf := g.AddDropDownList("x+8 w520 Choose1", [
        "livre de",
        "comprometida pela"
    ])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r7 ReadOnly -Wrap")

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
    static s_ddlTipo := 0, s_ddlPerif := 0, s_ddlProf := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev
    s_ddlTipo := ddlTipo
    s_ddlPerif := ddlPerif
    s_ddlProf := ddlProf

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    Build() {
        return (
            "Nevo " s_ddlTipo.Text "`n"
            ". Margens periféricas: " s_ddlPerif.Text " lesão`n"
            ". Margem profunda: " s_ddlProf.Text " lesão"
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    ; =========================
    ; EVENTOS
    ; =========================
    for ctrl in [ddlTipo, ddlPerif, ddlProf] {
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
