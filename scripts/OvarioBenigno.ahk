; =========================================================
; Ovário — Benigno (checkboxes + opções de parênteses e plurais)
; Arquivo: scripts\OvarioBenigno.ahk
; Função chamada no menu: Mask_OvarioBenigno()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_OvarioBenigno() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Ovário — Benigno")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("xm w720", "Marque os achados que entrarão no laudo:")

    ; =========================
    ; 1) Corpo lúteo (cístico) (hemorrágico)
    ; =========================
    cbCL := g.AddCheckBox("xm y+10", "Corpo lúteo")
    cbCL_Cistico := g.AddCheckBox("x+18 yp", "cístico")
    cbCL_Hem := g.AddCheckBox("x+18 yp", "hemorrágico")

    ; =========================
    ; 2) Cisto(s) folicular(es)
    ; =========================
    cbFol := g.AddCheckBox("xm y+10", "Cisto folicular")
    cbFol_PluralCisto := g.AddCheckBox("x+18 yp", "(s) no 'Cistos foliculares'")


    ; =========================
    ; 3) Cisto(s) de inclusão epitelial
    ; =========================
    cbInc := g.AddCheckBox("xm y+10", "Cisto de inclusão epitelial")
    cbInc_Plural := g.AddCheckBox("x+18 yp", "(s) no 'Cisto'")

    ; =========================
    ; 4) Cistoadenoma(s) seroso(s)
    ; =========================
    cbCist := g.AddCheckBox("xm y+10", "Cistoadenoma seroso")
    cbCist_Plural := g.AddCheckBox("x+18 yp", "(s) no 'Cistoadenomas serosos'")

    ; =========================
    ; 5) Corpo(s) albicante(s)
    ; =========================
    cbAlb := g.AddCheckBox("xm y+10", "Corpo albicante")
    cbAlb_PluralCorpo := g.AddCheckBox("x+18 yp", "(s) no 'Corpos albicantes'")

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r8 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ;  STATIC refs (evita #Warn + garante acesso nas internas)
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0
    static s_cbCL := 0, s_cbCL_Cistico := 0, s_cbCL_Hem := 0
    static s_cbFol := 0, s_cbFol_PluralCisto := 0
    static s_cbInc := 0, s_cbInc_Plural := 0
    static s_cbCist := 0, s_cbCist_Plural := 0
    static s_cbAlb := 0, s_cbAlb_PluralCorpo := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev

    s_cbCL := cbCL
    s_cbCL_Cistico := cbCL_Cistico
    s_cbCL_Hem := cbCL_Hem

    s_cbFol := cbFol
    s_cbFol_PluralCisto := cbFol_PluralCisto

    s_cbInc := cbInc
    s_cbInc_Plural := cbInc_Plural

    s_cbCist := cbCist
    s_cbCist_Plural := cbCist_Plural

    s_cbAlb := cbAlb
    s_cbAlb_PluralCorpo := cbAlb_PluralCorpo

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ApplyRules() {
        ; habilita/desabilita opções conforme checkbox principal
        s_cbCL_Cistico.Enabled := (s_cbCL.Value = 1)
        s_cbCL_Hem.Enabled := (s_cbCL.Value = 1)
        if (s_cbCL.Value != 1) {
            s_cbCL_Cistico.Value := 0
            s_cbCL_Hem.Value := 0
        }

        s_cbFol_PluralCisto.Enabled := (s_cbFol.Value = 1)
        if (s_cbFol.Value != 1) {
            s_cbFol_PluralCisto.Value := 0
        }

        s_cbInc_Plural.Enabled := (s_cbInc.Value = 1)
        if (s_cbInc.Value != 1)
            s_cbInc_Plural.Value := 0

        s_cbCist_Plural.Enabled := (s_cbCist.Value = 1)
        if (s_cbCist.Value != 1)
            s_cbCist_Plural.Value := 0

        s_cbAlb_PluralCorpo.Enabled := (s_cbAlb.Value = 1)
        if (s_cbAlb.Value != 1) {
            s_cbAlb_PluralCorpo.Value := 0
        }
    }

    Build() {
        linhas := []

        ; Corpo lúteo (cístico) (hemorrágico)
        if (s_cbCL.Value = 1) {
            l := "Corpo lúteo"
            if (s_cbCL_Cistico.Value = 1)
                l .= " cístico"
            if (s_cbCL_Hem.Value = 1)
                l .= " hemorrágico"
            linhas.Push(l)
        }

       ; Cisto(s) folicular(es)
		if (s_cbFol.Value = 1) {
			cisto := (s_cbFol_PluralCisto.Value = 1)
			? "Cistos foliculares"
			: "Cisto folicular"
			linhas.Push(cisto)
			}


        ; Cisto(s) de inclusão epitelial
		if (s_cbInc.Value = 1) {
			cisto := (s_cbInc_Plural.Value = 1)
			? "Cistos de inclusão epitelial"
			: "Cisto de inclusão epitelial"
			linhas.Push(cisto)
			}


        ; Cistoadenoma(s) seroso(s)
        if (s_cbCist.Value = 1) {
            cist := (s_cbCist_Plural.Value = 1)
            ? "Cistoadenomas serosos"
            : "Cistoadenoma seroso"
            linhas.Push(cist)
        }

        ; Corpo(s) albicante(s)
		if (s_cbAlb.Value = 1) {
			corpo := (s_cbAlb_PluralCorpo.Value = 1)
			? "Corpos albicantes"
			: "Corpo albicante"
			linhas.Push(corpo)
			}


        if (linhas.Length = 0)
            return "[nenhum achado selecionado]"

        txt := ""
        for l in linhas
            txt .= l "`n"
        return RTrim(txt, "`n")
    }

    UpdatePreview(*) {
        ApplyRules()
        s_edtPrev.Value := Build()
    }

    ; =========================
    ; EVENTOS
    ; =========================
    for ctrl in [cbCL, cbCL_Cistico, cbCL_Hem
               , cbFol, cbFol_PluralCisto
               , cbInc, cbInc_Plural
               , cbCist, cbCist_Plural
               , cbAlb, cbAlb_PluralCorpo] {
        try ctrl.OnEvent("Click",  UpdatePreview)
        try ctrl.OnEvent("Change", UpdatePreview)
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
