; =========================================================
; Dermato — Dermatite Perivascular (superficial/profunda) — GUI
; Arquivo: scripts\DermPerivascularSuperficial.ahk
; Função chamada no menu: Mask_DermPerivascularSuperficial()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_DermPerivascularSuperficial() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Dermato — Dermatite perivascular")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; EPIDERME
    ; =========================
    g.AddText("xm w860", "Epiderme")

    g.AddText("xm y+10 w160", "Queratinização")
    ddlKera := g.AddDropDownList("x+8 w660 Choose1", [
        "ortoqueratose",
        "hiperqueratose ortoqueratótica",
        "hiperqueratose compacta",
        "paraqueratose",
        "hiperparaqueratose"
    ])

    g.AddText("xm y+10 w160", "Camada granulosa")
    ddlGran := g.AddDropDownList("x+8 w420 Choose1", [
        "camada granulosa preservada",
        "hipergranulose",
        "hipogranulose",
        "hipogranulose subparaqueratótica"
    ])

    g.AddText("x+12 w160", "Acantose")
    ddlAcant := g.AddDropDownList("x+8 w220 Choose1", [
        "acantose irregular",
        "acantose regular"
    ])

    g.AddText("xm y+10 w160", "Exocitose")
    ddlExo := g.AddDropDownList("x+8 w420 Choose1", [
        "linfócitos típicos",
        "neutrófilos e linfócitos típicos"
    ])

    ; =========================
    ; DERME
    ; =========================
    g.AddText("xm y+16 w860", "Derme")

    g.AddText("xm y+10 w160", "Plano")
    ddlPlano := g.AddDropDownList("x+8 w420 Choose1", [
        "Derme papilar e reticular superficial",
        "Derme reticular (superficial e profunda)"
    ])

    g.AddText("xm y+10 w160", "Infiltrado")
    ddlInf := g.AddDropDownList("x+8 w420 Choose1", [
        "linfocitário",
        "linfo-histiocitário não granulomatoso"
    ])

    g.AddText("x+12 w160", "Componentes")
    ddlComp := g.AddDropDownList("x+8 w420 Choose1", [
        "sem eosinófilos",
        "com eosinófilos",
        "com eosinófilos e neutrófilos",
        "com eosinófilos e plasmócitos",
        "com eosinófilos, neutrófilos e plasmócitos",
        "com neutrófilos e plasmócitos",
        "neutrófilos"
    ])

    cbMast := g.AddCheckBox("xm y+10", "Adicionar “além de mastócitos”")

    g.AddText("xm y+10 w160", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w420 Choose1", [
        "perivascular",
        "perivascular, em manguito"
    ])

    g.AddText("xm y+10 w160", "Achados associados")
    ddlAssoc := g.AddDropDownList("x+8 w660 Choose1", [
        "Observa-se ainda a presença de extravasamento de hemácias",
        "Observa-se ainda a presença de endotélio reativo",
        "Observa-se ainda a presença de extravasamento de hemácias e endotélio reativo",
        "Observa-se ainda a presença de endotélio reativo e cariorrexe (leucocitoclasia)",
        "Observa-se ainda a presença de extravasamento de hemácias, endotélio reativo e cariorrexe (leucocitoclasia)",
        "Não se observam extravasamento de hemácias, endotélio reativo e cariorrexe (leucocitoclasia)"
    ])

    g.AddText("xm y+10 w160", "Edema")
    ddlEdema := g.AddDropDownList("x+8 w420 Choose1", [
        "Nota-se também edema",
        "Não há edema identificável na amostra"
    ])

    ; =========================
    ; HIPODERME
    ; =========================
    g.AddText("xm y+16 w860", "Hipoderme")
    ddlHip := g.AddDropDownList("xm w860 Choose1", [
        "dentro dos limites histológicos da normalidade",
        "não representada na amostra"
    ])

    ; =========================
    ; DIAGNÓSTICO MORFOLÓGICO
    ; =========================
    g.AddText("xm y+16 w860", "Diagnóstico morfológico")

    g.AddText("xm y+10 w160", "Profundidade")
    ddlDxProf := g.AddDropDownList("x+8 w420 Choose1", [
        "superficial",
        "profunda",
        "superficial e profunda"
    ])

    g.AddText("x+12 w160", "Qualificadores")
    ddlDxQual := g.AddDropDownList("x+8 w420 Choose1", [
        "com eosinófilos",
        "com eosinófilos e mastócitos",
        "com eosinófilos e edema",
        "com mastócitos",
        "com mastócitos e edema",
        "com eosinófilos, mastócitos e edema"
    ])

    ; =========================
    ; INTERPRETAÇÃO
    ; =========================
    g.AddText("xm y+16 w860", "Interpretação diagnóstica")

    g.AddText("xm y+10 w160", "Frase")
    ddlInterp := g.AddDropDownList("x+8 w660 Choose1", [
        ", associado aos dados clínicos, corrobora o",
        "favorece o",
        "pode corresponder ao"
    ])

    g.AddText("xm y+10 w160", "Diagnóstico clínico")
    edtClin := g.AddEdit("x+8 w660")

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w860 r12 ReadOnly -Wrap")

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
    static s_ddlKera := 0, s_ddlGran := 0, s_ddlAcant := 0, s_ddlExo := 0
    static s_ddlPlano := 0, s_ddlInf := 0, s_ddlComp := 0, s_cbMast := 0, s_ddlLoc := 0
    static s_ddlAssoc := 0, s_ddlEdema := 0, s_ddlHip := 0
    static s_ddlDxProf := 0, s_ddlDxQual := 0
    static s_ddlInterp := 0, s_edtClin := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev

    s_ddlKera := ddlKera
    s_ddlGran := ddlGran
    s_ddlAcant := ddlAcant
    s_ddlExo := ddlExo

    s_ddlPlano := ddlPlano
    s_ddlInf := ddlInf
    s_ddlComp := ddlComp
    s_cbMast := cbMast
    s_ddlLoc := ddlLoc
    s_ddlAssoc := ddlAssoc
    s_ddlEdema := ddlEdema
    s_ddlHip := ddlHip

    s_ddlDxProf := ddlDxProf
    s_ddlDxQual := ddlDxQual

    s_ddlInterp := ddlInterp
    s_edtClin := edtClin

    ApplyRules() {
        ; Se o DX qualificador contém "mastócitos", marca o checkbox automaticamente
        ; (não trava o usuário: ele pode desmarcar depois)
        if InStr(s_ddlDxQual.Text, "mastócitos")
            s_cbMast.Value := 1
    }

    Build() {
        ApplyRules()

        mastTxt := (s_cbMast.Value = 1) ? ", além de mastócitos" : ""

        clin := Trim(s_edtClin.Value)
        clinTxt := (clin = "") ? "[diagnóstico clínico]" : clin

        return (
            ". Epiderme exibindo " s_ddlKera.Text ", " s_ddlGran.Text ", " s_ddlAcant.Text " e exocitose de " s_ddlExo.Text ", sem espongiose. Não há degeneração hidrópica da camada basal.`n"
            ". " s_ddlPlano.Text " apresentando infiltrado " s_ddlInf.Text " " s_ddlComp.Text mastTxt ", de localização " s_ddlLoc.Text ". " s_ddlAssoc.Text ". " s_ddlEdema.Text ".`n"
            ". Hipoderme " s_ddlHip.Text ".`n"
            ". Ausência de neoplasia no espécime.`n"
            "DIAGNÓSTICO MORFOLÓGICO:`n"
            "Dermatite perivascular " s_ddlDxProf.Text " " s_ddlDxQual.Text "`n"
            "Interpretação diagnóstica:`n"
            "O quadro histológico " s_ddlInterp.Text " diagnóstico de " clinTxt
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    for ctrl in [ddlKera, ddlGran, ddlAcant, ddlExo
               , ddlPlano, ddlInf, ddlComp, cbMast, ddlLoc, ddlAssoc, ddlEdema
               , ddlHip, ddlDxProf, ddlDxQual, ddlInterp, edtClin] {
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
