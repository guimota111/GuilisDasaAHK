; =========================================================
; Cabeça e Pescoço — Displasia Epitelial Oral
; Arquivo: scripts\DisplasiaOral.ahk
; =========================================================

Mask_DisplasiaOral() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Displasia Epitelial Oral")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. GRADUAÇÃO ---
    g.AddGroupBox("w600 h110", "Graduação da Displasia")

    g.AddText("xp+15 yp+30 w120", "Classificação OMS:")
    ddlOMS := g.AddDropDownList("x150 yp-3 w200 Choose1 +Tabstop", ["Leve", "Moderada", "Acentuada"])

    g.AddText("x35 y+15 w120", "Sistema Binário:")
    ddlBin := g.AddDropDownList("x150 yp-3 w200 Choose1 +Tabstop", ["Baixo grau", "Alto grau"])

    g.AddText("x370 yp+3 w200", "(OMS 2017 / 2022)")

    ; --- 2. ACHADOS ARQUITETURAIS E CITOLÓGICOS ---
    g.AddGroupBox("xm y+25 w600 h130", "Critérios Observados")

    g.AddText("xp+15 yp+30 w120", "Arquitetura:")
    ddlArq := g.AddDropDownList("x150 yp-3 w420 Choose1 +Tabstop", [
        "Hiperplasia da camada basal/parabasal",
        "Gotas acantóticas (retes de cristas bulbosas)",
        "Perda da polaridade dos ceratinócitos basais",
        "Desorganização da estratificação epitelial",
        "Ceratinização prematura (pérolas córneas intraepiteliais)"])

    g.AddText("x35 y+15 w120", "Citologia:")
    ddlCit := g.AddDropDownList("x150 yp-3 w420 Choose1 +Tabstop", [
        "Pleomorfismo celular e nuclear",
        "Aumento da relação núcleo/citoplasma",
        "Núcleos hipercromáticos e nucléolos proeminentes",
        "Presença de mitoses em terços superiores do epitélio",
        "Mitoses atípicas"])

    ; --- 3. ALTERAÇÕES DE SUPERFÍCIE ---
    g.AddGroupBox("xm y+25 w600 h80", "Alterações Adjacentes")
    g.AddText("xp+15 yp+30 w120", "Superfície:")
    ddlSup := g.AddDropDownList("x150 yp-3 w420 Choose1 +Tabstop", [
        "Ortoqueratose",
        "Paraqueratose",
        "Acantose sem atipias",
        "Atrofia epitelial"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Diagnóstico:")
    edtPrev := g.AddEdit("xm w600 r6 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlOMS, ddlBin, ddlArq, ddlCit, ddlSup]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlOMS.Focus()
    UpdatePreview()

    Build() {
        res := "DISPLASIA EPITELIAL " StrUpper(ddlOMS.Text) " (" StrUpper(ddlBin.Text) ").`n`n"
        res .= ". Epitélio escamoso exibindo " ddlSup.Text ".`n"
        res .= ". Presença de " ddlArq.Text ".`n"
        res .= ". Observa-se " ddlCit.Text ".`n"
        res .= ". Ausência de sinais de invasão da membrana basal no material examinado."

        return res
    }
}