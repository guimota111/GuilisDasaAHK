; =========================================================
; Colo uterino — Cone — CEC microinvasor
; Arquivo: scripts\ConeCecMicroinvasor.ahk
; Função chamada no menu: Mask_ConeCecMicroinvasor()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ConeCecMicroinvasor() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Colo uterino — Cone — CEC microinvasor")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TUMOR
    ; =========================
    g.AddText("w200", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    g.AddText("x+12 w160", "Padrão")
    ddlKer := g.AddDropDownList("x+8 w220 Choose2", ["ceratinizante", "não ceratinizante"])

    g.AddText("xm y+12 w200", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose1", [
        "endocérvice",
        "ectocérvice",
        "endocérvice e ectocérvice"
    ])

    ; =========================
    ; MEDIDAS (mm)
    ; =========================
    g.AddText("xm y+12 w260", "Extensão lateral (mm)")
    edtLat := g.AddEdit("x+8 w120")
    g.AddText("x+8 yp+3", "mm")

    g.AddText("xm y+12 w260", "Maior profundidade (mm)")
    edtProf := g.AddEdit("x+8 w120")
    g.AddText("x+8 yp+3", "mm")

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w200", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w200", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+12 w200", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; ACHADOS ASSOCIADOS (checkboxes)
    ; =========================
    g.AddText("xm y+16 w720", "Achados associados")
    cbCerv := g.AddCheckBox("xm y+8", "Cervicite crônica com metaplasia escamosa")
    cbCerv.Value := 1  ; padrão
    cbNaboth := g.AddCheckBox("xm y+8", "Cistos de Naboth")

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    UpdatePreview(*) => edtPrev.Value := Build()

    for ctrl in [ddlDiff, ddlKer, ddlLoc, edtLat, edtProf, ddlIVS, ddlIVL, ddlIPN, cbCerv, cbNaboth] {
        try ctrl.OnEvent("Change", UpdatePreview)
        try ctrl.OnEvent("Click",  UpdatePreview)
    }

    ; =========================
    ; BOTÕES
    ; =========================
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

    ; =========================
    ; TEXTO FINAL
    ; =========================
    Build() {
        lat := StrReplace(Trim(edtLat.Value), ",", ".")
        prof := StrReplace(Trim(edtProf.Value), ",", ".")

        if (lat = "")
            lat := "[]"
        if (prof = "")
            prof := "[@]"

        txt := "Carcinoma de células escamosas " ddlDiff.Text " diferenciado, microinvasivo, " ddlKer.Text "`n"
        txt .= ". Localização: " ddlLoc.Text "`n"
        txt .= "- Medida de extensão lateral da neoplasia: " lat " mm`n"
        txt .= "- Medida da maior profundidade de infiltração: " prof " mm`n"
        txt .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " ddlIPN.Text

        if (cbCerv.Value = 1)
            txt .= "`nCervicite crônica com metaplasia escamosa"
        if (cbNaboth.Value = 1)
            txt .= "`nCistos de Naboth"

        return txt
    }
}
