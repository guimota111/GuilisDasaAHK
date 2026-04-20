; =========================================================
; Notas Padronizadas — Pesquisa de Agentes (Dinâmica)
; Arquivo: scripts\NotaBichos.ahk
; =========================================================

Mask_NotaBichos() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Nota — Pesquisa de Agentes")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. SELEÇÃO DO MÉTODO ---
    g.AddGroupBox("w700 h80", "1. Selecione o Método")
    ddlMetodo := g.AddDropDownList("xp+15 yp+30 w670 Choose1 +Tabstop", [
        "Apenas FITE (Micobactérias)",
        "Apenas Ziehl-Neelsen (Micobactérias)",
        "Apenas Grocott (Fungos)",
        "Apenas Giemsa (Protozoários)",
        "Apenas Warthin-Starry (Espiroquetas)",
        "Ziehl-Neelsen + Grocott",
        "FITE + Grocott",
        "Ziehl + Grocott + Giemsa"])

    ; --- 2. SELEÇÃO DO RESULTADO (DEPENDENTE) ---
    g.AddGroupBox("xm y+25 w700 h100", "2. Resultado Específico")

    ; Dropdowns de resultados específicos (escondidos por padrão)
    ddlResNeg := g.AddDropDownList("xp+15 yp+35 w670 Choose1 Hidden +Tabstop", ["resultou negativa"])

    ddlResMico := g.AddDropDownList("xp yp w670 Choose1 Hidden +Tabstop", [
        "resultou negativa",
        "revelou a presença de organismos morfologicamente consistentes com Mycobacterium tuberculosis",
        "revelou a presença de organismos morfologicamente consistentes com Mycobacterium leprae",
        "revelou a presença de organismos morfologicamente consistentes com Mycobacterium avium"])

    ddlResFungos := g.AddDropDownList("xp yp w670 Choose1 Hidden +Tabstop", [
        "resultou negativa",
        "revelou a presença de organismos morfologicamente consistentes com Candida sp",
        "revelou a presença de organismos morfologicamente consistentes com Histoplasma capsulatum",
        "revelou a presença de organismos morfologicamente consistentes com Aspergillus sp",
        "revelou a presença de organismos morfologicamente consistentes com Cryptococcus neoformans",
        "revelou a presença de organismos morfologicamente consistentes com Paracoccidioidis braziliensis"])

    ddlResGiemsa := g.AddDropDownList("xp yp w670 Choose1 Hidden +Tabstop", [
        "resultou negativa",
        "revelou a presença de organismos morfologicamente consistentes com Leishmania braziliensis"])

    ddlResWarthin := g.AddDropDownList("xp yp w670 Choose1 Hidden +Tabstop", [
        "resultou negativa",
        "revelou a presença de organismos morfologicamente consitentes com Treponema pallidum"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Texto da Nota:")
    edtPrev := g.AddEdit("xm w700 r4 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE TRANSIÇÃO ---
    AtualizarLayout(*) {
        m := ddlMetodo.Value
        ; Resetar visibilidade
        ddlResMico.Visible := (m == 1 || m == 2)
        ddlResFungos.Visible := (m == 3)
        ddlResGiemsa.Visible := (m == 4)
        ddlResWarthin.Visible := (m == 5)
        ddlResNeg.Visible := (m >= 6)

        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    ; Registrar eventos
    ddlMetodo.OnEvent("Change", AtualizarLayout)
    for ctrl in [ddlResMico, ddlResFungos, ddlResGiemsa, ddlResWarthin, ddlResNeg]
        ctrl.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlMetodo.Focus()
    AtualizarLayout()

    Build() {
        mText := [
            "micobactérias pelo método FITE",
            "micobactérias pelo método Ziehl-Neelsen",
            "organismos fúngicos pelo método Grocott",
            "protozoários pelo método Giemsa",
            "espiroquetas pelo método Warthin-Starry",
            "micobactérias pelo método Ziehl-Neelsen e de organismos fúngicos pelo método Grocott",
            "micobactérias pelo método FITE e de organismos fúngicos pelo método Grocott",
            "micobactérias pelo método Ziehl-Neelsen, organismos fúngicos pelo método Grocott e de protozoários pelo método Giemsa"
        ]

        m := ddlMetodo.Value
        res := "Nota: A pesquisa de " mText[m] " "

        if (m == 1 || m == 2) {
            res .= ddlResMico.Text
        } else if (m == 3) {
            res .= ddlResFungos.Text
        } else if (m == 4) {
            res .= ddlResGiemsa.Text
        } else if (m == 5) {
            res .= ddlResWarthin.Text
        } else {
            res .= ddlResNeg.Text
        }

        return res "."
    }
}