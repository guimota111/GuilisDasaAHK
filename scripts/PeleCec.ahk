; =========================================================
; Pele — Carcinoma espinocelular (CEC) invasivo
; Arquivo: scripts\PeleCEC.ahk
; Função chamada no menu: Mask_PeleCEC()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_PeleCEC() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pele — CEC invasivo")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; DIFERENCIAÇÃO
    ; =========================
    g.AddText("w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    ; =========================
    ; DIMENSÃO
    ; =========================
    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w90")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; PROFUNDIDADE
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade (mm)")
    edtProf := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3", "mm")

    ; =========================
    ; NÍVEL ANATÔMICO
    ; =========================
    g.AddText("xm y+12 w170", "Nível anatômico")
    ddlNivel := g.AddDropDownList("x+8 w520 Choose2", [
        "epiderme",
        "derme papilar",
        "derme reticular",
        "hipoderme"
    ])

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r9 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ;  STATIC refs (evita #Warn + resolve escopo)
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0
    static s_ddlDiff := 0, s_edtDimA := 0, s_edtDimB := 0, s_edtProf := 0
    static s_ddlNivel := 0, s_ddlIVL := 0, s_ddlIVS := 0, s_ddlIPN := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev

    s_ddlDiff := ddlDiff
    s_edtDimA := edtDimA
    s_edtDimB := edtDimB
    s_edtProf := edtProf
    s_ddlNivel := ddlNivel
    s_ddlIVL := ddlIVL
    s_ddlIVS := ddlIVS
    s_ddlIPN := ddlIPN

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    Build() {
        FixNum(x, placeholder := "[]") {
            v := StrReplace(Trim(x), ",", ".")
            return (v = "" ? placeholder : v)
        }

        dimA := FixNum(s_edtDimA.Value, "[]")
        dimB := FixNum(s_edtDimB.Value, "[]")
        prof := FixNum(s_edtProf.Value, "[]")

        return (
            "Carcinoma de células escamosas invasivo, " s_ddlDiff.Text " diferenciado`n"
            ". Dimensão da neoplasia: " dimA " x " dimB " cm`n"
            ". Profundidade de infiltração: " prof " mm`n"
            ". Nível anatômico de invasão: " s_ddlNivel.Text "`n"
            ". Invasão vascular linfática: " s_ddlIVL.Text "`n"
            ". Invasão vascular sanguínea: " s_ddlIVS.Text "`n"
            ". Invasão perineural: " s_ddlIPN.Text
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    ; =========================
    ; EVENTOS
    ; =========================
    for ctrl in [ddlDiff, edtDimA, edtDimB, edtProf, ddlNivel, ddlIVL, ddlIVS, ddlIPN] {
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
