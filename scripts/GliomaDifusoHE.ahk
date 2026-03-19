; =========================================================
; SNC — Glioma Difuso de Alto Grau (Grau 4)
; Arquivo: scripts\GliomaAltoGrau.ahk
; =========================================================

Mask_GliomaDifusoHE() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Glioma Difuso — Grau 4")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 12, g.MarginY := 12

    ; --- TÍTULO ---
    g.AddGroupBox("w740 h70", "Diagnóstico")
    g.AddText("xp+10 yp+25 w110", "Conclusão:")
    ddlConcl := g.AddDropDownList("x+5 w580 Choose1", [
        "Glioma difuso, SOE",
        "Glioma difuso, de baixo grau histológico",
        "Glioma difuso de alto grau"
    ])

    ; --- ACHADOS ---
    g.AddGroupBox("xm y+20 w740 h140", "Achados Histopatológicos")

    ; Necrose
    g.AddText("xp+10 yp+25 w150", "Necrose:")
    ddlNecro := g.AddDropDownList("x+5 w300 Choose1", [
        "não detectada",
        "presente, focal",
        "presente, extensa",
		"presente, com pseudopaliçada periférica",
		"presente, extensa, com pseudopaliçada periférica"
    ])

    ; Proliferação
    g.AddText("xm+10 y+15 w150", "Proliferação microvascular:")
    ddlMicro := g.AddDropDownList("x+5 w300 Choose1", [
		"não detectada",
		"presente",
        "presente, com formação de tufos glomeruloides"
    ])

    ; Mitoses
    g.AddText("xm+10 y+15 w150", "Índice mitótico:")
    edtMitoses := g.AddEdit("x+5 w80 Number")
    g.AddText("x+5 yp+3", "mitoses em 10 CGA")

    ; --- NOTA ---
    g.AddGroupBox("xm y+25 w740 h70", "Nota / Estudo Complementar")
    ddlNota := g.AddDropDownList("xp+10 yp+25 w710 Choose1", [
		"Em andamento a realização de estudo imuno-histoquímico para subclassificação da neoplasia.",
		"É necessária a realização de estudo imuno-histoquímico e/ou molecular para subclassificação da neoplasia."
    ])

    ; --- PRÉVIA ---
    g.AddText("xm y+20", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w740 r8 ReadOnly -Wrap")

    ; =========================
    ; EVENTOS
    ; =========================
    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlConcl, ddlNecro, ddlMicro, edtMitoses, ddlNota]
    for ctrl in controles
        ctrl.OnEvent("Change", UpdatePreview)

    ; --- BOTÕES ---
    btnInsert := g.AddButton("xm y+15 w120 Default", "Inserir")
    btnInsert.OnEvent("Click", (*) => (txt := Build(), g.Destroy(), PasteInto(prevWin, txt)))

    g.AddButton("x+10 w120", "Copiar").OnEvent("Click", (*) => A_Clipboard := Build())
    g.AddButton("x+10 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    ; =========================
    ; CONSTRUÇÃO DO TEXTO
    ; =========================
    Build() {
        mit := (Trim(edtMitoses.Value) == "") ? "XX" : edtMitoses.Value

        txt := ddlConcl.Text "`n"
        txt .= ". Necrose: " ddlNecro.Text "`n"
        txt .= ". Proliferação microvascular: " ddlMicro.Text "`n"
        txt .= ". Índice mitótico: " mit " mitoses em 10 campos de grande aumento`n`n"
        txt .= "NOTA: " ddlNota.Text

        return txt
    }
}