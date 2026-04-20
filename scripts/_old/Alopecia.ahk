; =========================================================
; Pele — Alopecia (campos + opções)
; Arquivo: scripts\PeleAlopecia.ahk
; Função chamada no menu: Mask_PeleAlopecia()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_Alopecia() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pele — Alopecia")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("xm w820", "Preencha os campos e selecione as opções:")

    ; =========================
    ; Campos numéricos/texto
    ; =========================
    g.AddText("xm y+12 w260", "Nº de folículos com variação (derme superficial)")
    edtFol := g.AddEdit("x+8 w120")  ; aceita 10, 10.5, etc.

    g.AddText("xm y+12 w260", "Relação T:V (T)")
    edtT := g.AddEdit("x+8 w120")
    g.AddText("x+12 yp+3 w30 Center", ":")
    g.AddText("x+8 yp-3 w260", "V")
    edtV := g.AddEdit("x+8 w120")

    ; =========================
    ; Opções
    ; =========================
    g.AddText("xm y+12 w260", "Pêlos terminais na hipoderme")
    ddlHip := g.AddDropDownList("x+8 w340 Choose1", [
        "não são observados",
        "são observados"
    ])

    g.AddText("xm y+12 w260", "Hipótese clínica favorecida")
    ddlHipot := g.AddDropDownList("x+8 w340 Choose1", [
        "alopecia androgenética",
        "eflúvio telógeno"
    ])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w820 r10 ReadOnly -Wrap")

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
    static s_edtFol := 0, s_edtT := 0, s_edtV := 0
    static s_ddlHip := 0, s_ddlHipot := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev
    s_edtFol := edtFol
    s_edtT := edtT
    s_edtV := edtV
    s_ddlHip := ddlHip
    s_ddlHipot := ddlHipot

    FixNum(x, placeholder := "[x]") {
        v := StrReplace(Trim(x), ",", ".")
        return (v = "" ? placeholder : v)
    }

    Build() {
        fol := FixNum(s_edtFol.Value, "[x]")
        t := FixNum(s_edtT.Value, "[x]")
        v := FixNum(s_edtV.Value, "[x]")

        return (
            "Cortes transversais exibem folículos pilosos superficializados com a derme superficial apresentando " fol " folículos com`n"
            "variação no diâmetro das hastes, enquanto que na hipoderme " s_ddlHip.Text " pêlos terminais. Nota-se discreto`n"
            "infiltrado inflamatório envolvendo uma unidade pilossebácea, constituído por pequenos linfócitos.`n"
            "A relação entre o número de pêlos terminais (T) e pêlos velos (V) é de " t ":" v ", o que favorece a hipótese clínica de`n"
            s_ddlHipot.Text ". Entretanto o diagnóstico definitivo deverá ser estabelecido após estreita correlação com`n"
            "aspectos clínicos."
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    for ctrl in [edtFol, edtT, edtV, ddlHip, ddlHipot] {
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
