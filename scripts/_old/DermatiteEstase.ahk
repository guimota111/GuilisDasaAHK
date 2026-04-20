; =========================================================
; Dermato — Dermatite de Estase (GUI)
; Arquivo: scripts\DermatiteEstase.ahk
; Função chamada no menu: Mask_DermatiteEstase()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_DermatiteEstase() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Dermato — Dermatite de estase")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; EPIDERME
    ; =========================
    g.AddText("xm w820", "DESCRIÇÃO MICROSCÓPICA — Epiderme")

    g.AddText("xm y+10 w140", "Queratinização")
    ddlKera := g.AddDropDownList("x+8 w660 Choose1", [
        "ortoqueratose",
        "hiperqueratose ortoqueratótica",
        "hiperqueratose compacta",
        "paraqueratose",
        "hiperparaqueratose"
    ])

    g.AddText("xm y+10 w140", "Camada granulosa")
    ddlGran := g.AddDropDownList("x+8 w420 Choose1", [
        "camada granulosa preservada",
        "hipergranulose",
        "hipogranulose",
        "hipogranulose subparaqueratótica"
    ])

    g.AddText("x+12 w140", "Acantose")
    ddlAcant := g.AddDropDownList("x+8 w220 Choose1", [
        "irregular",
        "regular"
    ])

    g.AddText("xm y+10 w140", "Espongiose")
    ddlEsp := g.AddDropDownList("x+8 w420 Choose1", [
        "e espongiose",
        "sem espongiose evidente"
    ])

    ; =========================
    ; DERME SUPERFICIAL
    ; =========================
    g.AddText("xm y+16 w820", "Derme papilar/reticular superficial")

    g.AddText("xm y+10 w140", "Infiltrado")
    ddlInf := g.AddDropDownList("x+8 w420 Choose1", [
        "linfocitário",
        "linfo-histiocitário não granulomatoso",
        "linfoplasmocitário"
    ])

    g.AddText("x+12 w140", "Distribuição")
    ddlDist := g.AddDropDownList("x+8 w220 Choose1", [
        "perivascular",
        "perivascular e perifolicular"
    ])

    g.AddText("xm y+10 w140", "Eosinófilos")
    ddlEos := g.AddDropDownList("x+8 w220 Choose1", [
        "com",
        "sem"
    ])

    ; =========================
    ; INTERPRETAÇÃO (fase)
    ; =========================
    g.AddText("xm y+16 w820", "Interpretação diagnóstica")

    g.AddText("xm y+10 w140", "Frase")
    ddlInterp := g.AddDropDownList("x+8 w660 Choose1", [
        ", associado aos dados clínicos, corrobora o",
        "favorece o",
        "pode corresponder ao"
    ])

    g.AddText("xm y+10 w140", "Fase")
    ddlFase := g.AddDropDownList("x+8 w420 Choose1", [
        "aguda",
        "aguda a subaguda",
        "subaguda",
        "subaguda a crônica",
        "crônica",
        "crônica e em processo de liquenificação (transformação para Líquen Simples Crônico)"
    ])

    ; Checkbox: incluir sinônimo "Eczema de Estase..."
    cbEczema := g.AddCheckBox("x+12 yp+3", "Incluir sinônimo (Eczema de Estase)")

    ; Checkbox: incluir NOTA Perls
    cbNota := g.AddCheckBox("xm y+12", "Incluir nota do Perls (Azul da Prússia)")
    cbNota.Value := 1

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w820 r14 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ; STATIC refs (evita #Warn)
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0
    static s_ddlKera := 0, s_ddlGran := 0, s_ddlAcant := 0, s_ddlEsp := 0
    static s_ddlInf := 0, s_ddlDist := 0, s_ddlEos := 0
    static s_ddlInterp := 0, s_ddlFase := 0
    static s_cbEczema := 0, s_cbNota := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev

    s_ddlKera := ddlKera
    s_ddlGran := ddlGran
    s_ddlAcant := ddlAcant
    s_ddlEsp := ddlEsp

    s_ddlInf := ddlInf
    s_ddlDist := ddlDist
    s_ddlEos := ddlEos

    s_ddlInterp := ddlInterp
    s_ddlFase := ddlFase

    s_cbEczema := cbEczema
    s_cbNota := cbNota

    ; =========================
    ; BUILD
    ; =========================
    Build() {
        fase := s_ddlFase.Text

        ; linha do sinônimo (opcional)
        extraEczema := ""
        if (s_cbEczema.Value = 1) {
            ; se a fase for a última (liquenificação), usa só "crônica" no sinônimo
            faseE := (s_ddlFase.Value = 6) ? "crônica" : fase
            extraEczema := " (Eczema de Estase em fase " faseE ")."
        }

        nota := ""
        if (s_cbNota.Value = 1) {
            nota :=
            (
            "`nNota:`n"
            "Foi realizada coloração especial pelo método Perls (Azul da Prússia), revelando depósitos dérmicos de hemossiderina."
            )
        }

        return (
            "DESCRIÇÃO MICROSCÓPICA:`n"
            ". Epiderme exibindo " s_ddlKera.Text " com área de ulceração, " s_ddlGran.Text ", acantose " s_ddlAcant.Text ", exocitose de linfócitos típicos, " s_ddlEsp.Text ". Não há degeneração hidrópica de camada basal.`n"
            ". Derme papilar e reticular superficial apresentando fibroplasia subepidérmica, neoformação vascular, extravasamento de hemácias, infiltrado " s_ddlInf.Text " " s_ddlDist.Text ", " s_ddlEos.Text " eosinófilos, além de depósitos de hemossiderina.`n"
            ". Derme reticular profunda e hipoderme dentro dos limites histológicos da normalidade.`n"
            ". Ausência de neoplasia no espécime, bem como não se identificam sinais de vasculite propriamente dita (necrose fibrinoide, de endotélio ou de parede vascular), nem depósitos vasculares intramurais de fibrina.`n"
            "DIAGNÓSTICO MORFOLÓGICO:`n"
            "Hiperplasia epidérmica com vasculopatia e eosinófilos.`n"
            "Interpretação diagnóstica:`n"
            "O quadro histológico " s_ddlInterp.Text " diagnóstico de Dermatite de estase em fase " fase "." extraEczema
            . nota
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    for ctrl in [ddlKera, ddlGran, ddlAcant, ddlEsp, ddlInf, ddlDist, ddlEos, ddlInterp, ddlFase, cbEczema, cbNota] {
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
