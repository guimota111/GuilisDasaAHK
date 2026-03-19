Mask_Meningioma() {
    try {
        prevWin := WinGetID("A")
    } catch {
        prevWin := 0
    }

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Meningioma")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 12, g.MarginY := 12

    ; --- DADOS INICIAIS ---
    g.AddGroupBox("w740 h85", "Dados Iniciais")
    g.AddText("xp+10 yp+25 w110", "Título:")
    edtTitulo := g.AddEdit("x+5 w580", "Meningioma")

    g.AddText("xm+10 y+15 w110", "Índice Mitótico:")
    edtMitoses := g.AddEdit("x+5 w60 Number")
    g.AddText("x+5 yp+3", "mitoses em 10 CGA")

    ; --- CRITÉRIOS DE ATIPIA ---
    g.AddGroupBox("xm y+25 w740 h180", "Critérios Morfológicos / Atipia")
    chkInv := g.AddCheckbox("xp+10 yp+25 w350", "Invasão do parênquima cerebral")
    chkClear := g.AddCheckbox("y+10 w350", "Diferenciação em células claras / cordoides")
    chkHiper := g.AddCheckbox("y+10 w350", "Hipercelularidade")
    chkSmall := g.AddCheckbox("y+10 w350", "Pequenas células")
    chkMacro := g.AddCheckbox("xm+380 yp-90 w350", "Macronucléolo")
    chkDifus := g.AddCheckbox("y+10 w350", "Arquitetura difusa (perda de turbilhões)")
    chkNecro := g.AddCheckbox("y+10 w350", "Necrose")
    chkAnapl := g.AddCheckbox("y+10 w350", "Anaplasia")

    ; --- NOTA ---
    g.AddGroupBox("xm y+25 w740 h70", "Nota / Imuno-histoquímica")
    ddlNota := g.AddDropDownList("xp+10 yp+25 w710 Choose1", [
        "Estudo imuno-histoquímico em andamento para complementação diagnóstica.",
        "É necessário estudo imuno-histoquímico para complementação diagnóstica.",
        "A morfologia é compatível com os achados descritos."
    ])

    g.AddText("xm y+20", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w740 r10 ReadOnly -Wrap")

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()

    for ctrl in [edtTitulo, edtMitoses, ddlNota]
        ctrl.OnEvent("Change", UpdatePreview)

    for cb in [chkInv, chkClear, chkHiper, chkSmall, chkMacro, chkDifus, chkNecro, chkAnapl]
        cb.OnEvent("Click", UpdatePreview)

    ; --- BOTÕES ---
    g.AddButton("xm y+15 w120 Default", "Inserir").OnEvent("Click", (*) => (txt := Build(), g.Destroy(), (prevWin ? PasteInto(prevWin, txt) : A_Clipboard := txt)))
    g.AddButton("x+10 w120", "Copiar").OnEvent("Click", (*) => A_Clipboard := Build())
    g.AddButton("x+10 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; CONSTRUÇÃO DO LAUDO (Definida dentro da função mas chamada pelo g.Show)
    Build() {
        mit := edtMitoses.Value || "XX"
        faixaMit := (Number(edtMitoses.Value || 0) < 4) ? "< 4" : "≥ 4"
        res := edtTitulo.Value "`n"
        res .= ". Índice mitótico: " faixaMit " mitoses/10 CGA (" mit " mitoses/10 CGA)`n"
        res .= ". Invasão do parênquima cerebral adjacente: " (chkInv.Value ? "presente" : "não detectada") "`n"
        res .= ". Diferenciação em células claras/cordoides: " (chkClear.Value ? "presente" : "não detectada") "`n"
        res .= ". Hipercelularidade: " (chkHiper.Value ? "presente" : "não detectada") "`n"
        res .= ". Diferenciação em pequenas células: " (chkSmall.Value ? "presente" : "não detectada") "`n"
        res .= ". Macronucléolo: " (chkMacro.Value ? "presente" : "não detectada") "`n"
        res .= ". Arquitetura difusa: " (chkDifus.Value ? "presente" : "não detectada") "`n"
        res .= ". Necrose: " (chkNecro.Value ? "presente" : "não detectada") "`n"
        res .= ". Anaplasia: " (chkAnapl.Value ? "presente" : "não detectada") "`n"
        res .= "NOTA: " ddlNota.Text
        return res
    }

    g.Show() ; <--- GARANTA QUE ESTÁ AQUI NO FINAL
    UpdatePreview()
}