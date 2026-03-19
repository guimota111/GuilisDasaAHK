; =========================================================
; SNC — Metástases
; Arquivo: scripts\SNC_Metastase.ahk
; =========================================================

Mask_SNCMetastase() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — SNC — Metástase")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 12, g.MarginY := 12

    ; --- CONCLUSÃO ---
    g.AddGroupBox("w740 h70", "Diagnóstico Histopatológico")
    g.AddText("xp+10 yp+25 w110", "Conclusão:")
    ddlConcl := g.AddDropDownList("x+5 w580 Choose1", [
        "Infiltração por Carcinoma",
        "Infiltração por Adenocarcinoma",
        "Infiltração por Neoplasia maligna de células epitelioides",
        "Infiltração por Neoplasia pouco diferenciada"
    ])

    ; --- NOTA / IHQ ---
    g.AddGroupBox("xm y+20 w740 h100", "Nota / Estudo Complementar")
    g.AddText("xp+10 yp+25 w110", "Nota Sugerida:")
    ddlNota := g.AddDropDownList("x+5 w580 Choose1", [
        "É necessária a realização de estudo imuno-histoquímico para pesquisa de sítio primário da neoplasia.",
        "Em andamento a realização de estudo imuno-histoquímico para pesquisa de sítio primário da neoplasia.",
        "É necessária a realização de estudo imuno-histoquímico para complementação diagnóstica/pesquisa de sítio primário da neoplasia.",
        "Em andamento a realização de estudo imuno-histoquímico para complementação diagnóstica/pesquisa de sítio primário da neoplasia."
    ])

    ; --- PRÉVIA ---
    g.AddText("xm y+20", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w740 r6 ReadOnly -Wrap")

    ; =========================
    ; EVENTOS
    ; =========================
    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlConcl, ddlNota]
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
        txt := ddlConcl.Text "`n`n"
        txt .= "NOTA: " ddlNota.Text
        return txt
    }
}