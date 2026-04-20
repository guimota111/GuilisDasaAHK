; =========================================================
; Pele — Melanoma (check + campos numéricos + regras simples)
; Arquivo: scripts\PeleMelanoma.ahk
; Função chamada no menu: Mask_PeleMelanoma()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; Regras:
; - Se "in situ": desabilita Clark/Breslow/mitoses/fase (opcional, mas coerente)
; - Regressão: se "presente" habilita profundidade
; - Nevo associado: se "presente" habilita tipo + relação
; =========================================================

Mask_PeleMelanoma() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pele — Melanoma")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; MELANOMA: invasivo vs in situ + tipo
    ; =========================
    g.AddText("w170", "Melanoma")
    ddlInv := g.AddDropDownList("x+8 w170 Choose1", ["invasivo", "in situ"])

    g.AddText("x+14 w60", "Tipo")
    ddlTipo := g.AddDropDownList("x+8 w420 Choose1", [
        "extensivo superficial",
        "nodular",
        "acral lentiginoso",
        "lentigo maligno",
        "desmoplásico",
        "melanoma surgindo de nevo azul",
        "melanoma surgindo em nevo congênito gigante",
        "melanoma da infância",
        "melanoma nevoide",
        "melanoma persistente",
        "SOE"
    ])

    ; =========================
    ; FASE / ULCERAÇÃO
    ; =========================
    g.AddText("xm y+12 w170", "Fase de crescimento")
    ddlFase := g.AddDropDownList("x+8 w220 Choose1", ["radial", "vertical"])

    g.AddText("x+14 w120", "Ulceração")
    ddlUlc := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; CLARK / BRESLOW
    ; =========================
    g.AddText("xm y+12 w170", "Nível de Clark")
    ddlClark := g.AddDropDownList("x+8 w520 Choose4", [
        "I (epiderme)",
        "II (derme papilar, sem expansão)",
        "III (derme papilar, com expansão)",
        "IV (derme reticular)",
        "V (hipoderme)"
    ])

    g.AddText("xm y+12 w250", "Profundidade (Breslow) (mm)")
    edtBres := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3", "mm")

    ; =========================
    ; MITOSES
    ; =========================
    g.AddText("xm y+12 w250", "Índice mitótico (mitoses / 1,0 mm²)")
    edtMit := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3 w80", "mitoses")

    ddlMitCat := g.AddDropDownList("x+14 w220 Choose1", ["< 1,0/mm²", "≥ 1,0/mm²"])

    ; =========================
    ; INFILTRADO / REGRESSÃO
    ; =========================
    g.AddText("xm y+12 w250", "Infiltrado inflamatório tumoral")
    ddlInf := g.AddDropDownList("x+8 w220 Choose1", ["não detectado", "presente, inativo", "presente, ativo"])

    g.AddText("x+14 w170", "Regressão")
    ddlReg := g.AddDropDownList("x+8 w220 Choose1", ["não detectadas", "presentes"])

    g.AddText("xm y+10 w250", "Profundidade máx. de regressão (mm)")
    edtReg := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3", "mm")
    edtReg.Enabled := false

    ; =========================
    ; INVASÕES / SATELITOSE
    ; =========================
    g.AddText("xm y+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+14 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+14 w170", "Satelitose microscópica")
    ddlSat := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; NEVO ASSOCIADO
    ; =========================
    g.AddText("xm y+12 w170", "Nevo associado")
    ddlNevo := g.AddDropDownList("x+8 w220 Choose1", ["não detectado", "presente"])

    g.AddText("xm y+10 w170", "Tipo de nevo")
    edtNevoTipo := g.AddEdit("x+8 w520")
    edtNevoTipo.Enabled := false

    g.AddText("xm y+10 w220", "Relação com a neoplasia")
    ddlNevoRel := g.AddDropDownList("x+8 w520 Choose1", [
        "presente em meio a neoplasia",
        "presente em área não relacionada à neoplasia"
    ])
    ddlNevoRel.Enabled := false

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r12 ReadOnly -Wrap")

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
    static s_ddlInv := 0, s_ddlTipo := 0, s_ddlFase := 0, s_ddlUlc := 0
    static s_ddlClark := 0, s_edtBres := 0
    static s_edtMit := 0, s_ddlMitCat := 0
    static s_ddlInf := 0, s_ddlReg := 0, s_edtReg := 0
    static s_ddlIVL := 0, s_ddlIVS := 0, s_ddlIPN := 0, s_ddlSat := 0
    static s_ddlNevo := 0, s_edtNevoTipo := 0, s_ddlNevoRel := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev

    s_ddlInv := ddlInv
    s_ddlTipo := ddlTipo
    s_ddlFase := ddlFase
    s_ddlUlc := ddlUlc
    s_ddlClark := ddlClark
    s_edtBres := edtBres
    s_edtMit := edtMit
    s_ddlMitCat := ddlMitCat
    s_ddlInf := ddlInf
    s_ddlReg := ddlReg
    s_edtReg := edtReg
    s_ddlIVL := ddlIVL
    s_ddlIVS := ddlIVS
    s_ddlIPN := ddlIPN
    s_ddlSat := ddlSat
    s_ddlNevo := ddlNevo
    s_edtNevoTipo := edtNevoTipo
    s_ddlNevoRel := ddlNevoRel

    ; =========================
    ; FUNÇÕES
    ; =========================
    FixNum(x, placeholder := "[]") {
        v := StrReplace(Trim(x), ",", ".")
        return (v = "" ? placeholder : v)
    }

    ApplyRules() {
        isInSitu := (s_ddlInv.Value = 2)

        ; Para in situ, normalmente não tem Breslow/Clark/mitoses/fase (pode ajustar se quiser)
        s_ddlFase.Enabled := !isInSitu
        s_ddlClark.Enabled := !isInSitu
        s_edtBres.Enabled := !isInSitu
        s_edtMit.Enabled := !isInSitu
        s_ddlMitCat.Enabled := !isInSitu

        if (isInSitu) {
            s_edtBres.Value := ""
            s_edtMit.Value := ""
        }

        ; Regressão -> profundidade
        regOn := (s_ddlReg.Value = 2)
        s_edtReg.Enabled := regOn
        if (!regOn)
            s_edtReg.Value := ""

        ; Nevo associado -> tipo + relação
        nevoOn := (s_ddlNevo.Value = 2)
        s_edtNevoTipo.Enabled := nevoOn
        s_ddlNevoRel.Enabled := nevoOn
        if (!nevoOn) {
            s_edtNevoTipo.Value := ""
        }
    }

    Build() {
        invTxt := (s_ddlInv.Value = 1 ? "invasivo" : "in situ")

        ; Tipo: se SOE, coloca ", SOE" como no seu modelo
        tipoTxt := s_ddlTipo.Text
        if (tipoTxt = "SOE")
            tipoTxt := ", SOE"

        txt := "Melanoma " invTxt " tipo " tipoTxt "`n"
        txt .= ". Ulceração: " s_ddlUlc.Text "`n"

        if (s_ddlInv.Value = 1) {
            txt .= ". Fase de crescimento: " s_ddlFase.Text "`n"
            txt .= ". Nível de Clark: " s_ddlClark.Text "`n"
            txt .= ". Profundidade de infiltração (Breslow): " FixNum(s_edtBres.Value, "[]") " mm`n"
            txt .= ". Índice mitótico: " FixNum(s_edtMit.Value, "[]") " mitoses / área de 1,0 mm² (" s_ddlMitCat.Text ")`n"
        }

        txt .= ". Infiltrado inflamatório tumoral: " s_ddlInf.Text "`n"
        txt .= ". Áreas de regressão: " s_ddlReg.Text "`n"

        if (s_ddlReg.Value = 2)
            txt .= "- Profundidade máxima de regressão: " FixNum(s_edtReg.Value, "[]") " mm`n"

        txt .= ". Invasão vascular linfática: " s_ddlIVL.Text "`n"
        txt .= ". Invasão vascular sanguínea: " s_ddlIVS.Text "`n"
        txt .= ". Invasão perineural: " s_ddlIPN.Text "`n"
        txt .= ". Satelitose microscópica: " s_ddlSat.Text "`n"
        txt .= ". Nevo associado: " s_ddlNevo.Text

        if (s_ddlNevo.Value = 2) {
            tipoN := Trim(s_edtNevoTipo.Value)
            if (tipoN = "")
                tipoN := "[]"
            txt .= "`n- Tipo: " tipoN ", " s_ddlNevoRel.Text
        }

        return txt
    }

    UpdatePreview(*) {
        ApplyRules()
        s_edtPrev.Value := Build()
    }

    ; =========================
    ; EVENTOS
    ; =========================
    ddlInv.OnEvent("Change", UpdatePreview)
    ddlReg.OnEvent("Change", UpdatePreview)
    ddlNevo.OnEvent("Change", UpdatePreview)

    for ctrl in [ddlTipo, ddlFase, ddlUlc, ddlClark, edtBres, edtMit, ddlMitCat, ddlInf, edtReg
               , ddlIVL, ddlIVS, ddlIPN, ddlSat, edtNevoTipo, ddlNevoRel] {
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
