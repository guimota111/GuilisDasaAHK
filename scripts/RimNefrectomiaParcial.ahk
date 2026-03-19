; =========================================================
; Rim — Nefrectomia parcial
; Arquivo: scripts\RimNefrectomiaParcial.ahk
; Função chamada no menu: Mask_RimNefrectomiaParcial()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_RimNefrectomiaParcial() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Rim — Nefrectomia parcial")
    g.MarginX := 12, g.MarginY := 12

    ; =========================
    ; TIPO + ISUP (condicional)
    ; =========================
    g.AddText("xm w170", "Tipo histológico")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Carcinoma de células renais de células claras",
        "Carcinoma de células renais papilífero tipo 1",
        "Carcinoma de células renais papilífero tipo 2",
        "Carcinoma de células renais cromófobo",
        "Carcinoma de células renais medular",
        "Carcinoma de células renais papilífero de células claras",
        "Carcinoma de células renais mucinoso tubular de células fusiformes",
        "Carcinoma de células renais associado à translocação da família MiTF",
        "Carcinoma de ductos coletores",
        "Neoplasia de células renais multilocular cística de baixo potencial de malignidade"
    ])

    g.AddText("xm y+12 w250", "Graduação histológica (ISUP/OMS)")
    ddlISUP := g.AddDropDownList("x+8 w120 Choose1", ["1", "2", "3", "4"])
    txtISUPNote := g.AddText("x+12 yp+3 cGray", "Somente p/ células claras ou papilífero")

    ; =========================
    ; LOCALIZAÇÃO / MEDIDA
    ; =========================
    g.AddText("xm y+12 w170", "Localização no rim")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose1", [
        "polo superior",
        "polo inferior",
        "região mesorrenal",
        "todo parênquima renal"
    ])

    g.AddText("xm y+12 w170", "Medida (cm)")
    edtDimA := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w90")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; COMPONENTES / NECROSE
    ; =========================
    g.AddText("xm y+12 w210", "Componente sarcomatoide")
    ddlSarc := g.AddDropDownList("x+8 w260 Choose2", [
        "presente, correspondendo a",
        "não detectado"
    ])
    edtSarcPct := g.AddEdit("x+8 w70")
    g.AddText("x+6 yp+3", "%")
    edtSarcPct.Enabled := false

    g.AddText("xm y+12 w210", "Componente rabdoide")
    ddlRhab := g.AddDropDownList("x+8 w260 Choose2", ["presente", "não detectado"])

    g.AddText("xm y+12 w210", "Necrose")
    ddlNec := g.AddDropDownList("x+8 w260 Choose2", [
        "presente, correspondendo a",
        "não detectada"
    ])
    edtNecPct := g.AddEdit("x+8 w70")
    g.AddText("x+6 yp+3", "%")
    edtNecPct.Enabled := false

    ; =========================
    ; INFILTRAÇÃO
    ; =========================
    g.AddText("xm y+16 w720", "Infiltração")
    g.AddText("xm y+8 w170", "Cápsula renal")
    ddlCaps := g.AddDropDownList("x+8 w260 Choose2", ["presente", "não detectada"])

    g.AddText("x+12 w170", "Gordura perirrenal")
    ddlFat := g.AddDropDownList("x+8 w260 Choose2", ["presente", "não detectada"])
    g.AddText("xm y+6 w720 cGray", "Obs: considerar invasão somente em lesão infiltrativa (não exofítica/encapsulada).")

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w210", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w260 Choose2", ["presente", "não detectada"])

    g.AddText("xm y+12 w210", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w260 Choose2", ["presente", "não detectada"])

    g.AddText("xm y+12 w210", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w260 Choose2", ["presente", "não detectada"])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================
    ; EVENTOS
    ; =========================
    for ctrl in [ddlTipo, ddlISUP, ddlLoc, edtDimA, edtDimB, ddlSarc, edtSarcPct, ddlRhab, ddlNec, edtNecPct
               , ddlCaps, ddlFat, ddlIVS, ddlIVL, ddlIPN] {
        try ctrl.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))
        try ctrl.OnEvent("Click",  (*) => (ApplyRules(), UpdatePreview()))
    }

    ddlSarc.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))
    ddlNec.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))
    ddlTipo.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))

    btnInsert.OnEvent("Click", (*) => (
        txt := BuildText(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := BuildText()))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    ApplyRules()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    UpdatePreview() => edtPrev.Value := BuildText()

    ApplyRules() {
        ; ISUP somente para células claras (1) ou papilíferos (2/3)
        isISUP := (ddlTipo.Value = 1) || (ddlTipo.Value = 2) || (ddlTipo.Value = 3)
        ddlISUP.Enabled := isISUP
        txtISUPNote.Visible := true
        if (!isISUP)
            ddlISUP.Choose(1)

        ; % sarcomatoide habilita só se "presente"
        hasSarc := (ddlSarc.Value = 1)
        edtSarcPct.Enabled := hasSarc
        if (!hasSarc)
            edtSarcPct.Value := ""

        ; % necrose habilita só se "presente"
        hasNec := (ddlNec.Value = 1)
        edtNecPct.Enabled := hasNec
        if (!hasNec)
            edtNecPct.Value := ""
    }

    BuildText() {
        ; dimensões aceitam 2,3 ou 2.3
        dimA := NormalizeNum(edtDimA.Value)
        dimB := NormalizeNum(edtDimB.Value)

        if (dimA != "" && dimB != "")
            dimTxt := dimA " x " dimB " cm"
        else if (dimA != "" && dimB = "")
            dimTxt := dimA " cm"
        else if (dimA = "" && dimB != "")
            dimTxt := dimB " cm"
        else
            dimTxt := "[dimensão] x [dimensão] cm"

        txt := ddlTipo.Text "`n"

        if (ddlISUP.Enabled)
            txt .= ". Graduação histológica (ISUP/OMS): " ddlISUP.Text "`n"

        txt .= ". Localização no tecido renal: " ddlLoc.Text "`n"
        txt .= ". Medida da neoplasia: " dimTxt "`n"

        ; Sarcomatoide
        if (ddlSarc.Value = 1) {
            pct := NormalizeNum(edtSarcPct.Value)
            pct := (pct = "" ? "{}" : pct)
            txt .= ". Componente sarcomatoide: presente, correspondendo a " pct "% do total da neoplasia`n"
        } else {
            txt .= ". Componente sarcomatoide: não detectado`n"
        }

        ; Rabdoide
        txt .= ". Componente rabdoide: " ddlRhab.Text "`n"

        ; Necrose
        if (ddlNec.Value = 1) {
            pctN := NormalizeNum(edtNecPct.Value)
            pctN := (pctN = "" ? "{}" : pctN)
            txt .= ". Necrose: presente, correspondendo a " pctN "% da neoplasia`n"
        } else {
            txt .= ". Necrose: não detectada`n"
        }

        txt .= ". Infiltração de:`n"
        txt .= "- Cápsula renal: " ddlCaps.Text "`n"
        txt .= "- Gordura perirrenal: " ddlFat.Text "`n"

        txt .= ". Invasão vascular sanguinea: " ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " ddlIPN.Text

        return txt
    }

    NormalizeNum(v) {
        s := Trim(v)
        if (s = "")
            return ""
        s := StrReplace(s, ",", ".")
        s := RegExReplace(s, "[^0-9.]", "")
        if (InStr(s, ".") && RegExMatch(s, "\..*\.", &m)) {
            first := InStr(s, ".")
            s := SubStr(s, 1, first) RegExReplace(SubStr(s, first+1), "\.", "")
        }
        return s
    }
}
