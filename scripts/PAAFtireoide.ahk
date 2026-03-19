; =========================================================
; Citopatologia — PAAF de Tireoide (Bethesda)
; Arquivo: scripts\PAAFTireoide.ahk
; =========================================================

Mask_PAAFTireoide() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — PAAF de Tireoide")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CATEGORIA BETHESDA ---
    g.AddGroupBox("w700 h80", "Categoria Bethesda")
    ddlCat := g.AddDropDownList("xp+15 yp+30 w670 Choose1 +Tabstop", [
        "Categoria I: Não diagnóstico",
        "Categoria II: Benigno",
        "Categoria III: Atipia de Significado Indeterminado (AUS)",
        "Categoria IV: Neoplasia Folicular / Suspeito para NF",
        "Categoria V: Suspeito para Malignidade",
        "Categoria VI: Maligno"])

    ; --- 2. SUB-OPÇÕES DINÂMICAS ---
    g.AddGroupBox("xm y+25 w700 h120", "Especificações e Critérios")

    ddlB1 := g.AddDropDownList("xp+15 yp+30 w670 Choose1 Hidden +Tabstop", ["Amostra exibindo extensos artefatos de dessecamento", "Apenas líquido de cisto", "Ausência de células foliculares", "Esfregaços paucicelulares (raras células foliculares)", "Obscurecimento celular por conteúdo sanguinolento"])
    ddlB2 := g.AddDropDownList("xp yp w670 Choose1 Hidden +Tabstop", ["Consistente com Nódulo folicular benigno", "Consistente com Tireoidite granulomatosa", "Consistente com Tireoidite linfocítica", "Consistente com Tireoidite subaguda"])
    ddlB3 := g.AddDropDownList("xp yp w670 Choose1 Hidden +Tabstop", ["Atipia de Significado Indeterminado (AUS-A) - Esfregaços paucicelulares com predominância de microfolículos e ausência de coloide", "Atipia de Significado Indeterminado (AUS-C) - Células foliculares benignas com atipia citológica focal", "Atipia de Significado Indeterminado (AUS-C) - Células foliculares com leve irregularidade nuclear", "Atipia de Significado Indeterminado (AUS-C) - Células linfoides numerosas e relativamente monomórficas", "Atipia de Significado Indeterminado (AUS-C) - Esfregaços escassos com predominância de células oxifílicas", "Atipia de Significado Indeterminado (AUS-C) - Atipia em células de revestimento de lesão cística", "Atipia de Significado Indeterminado (AUS-A) - Escassos agrupamentos com sobreposição celular e escasso coloide"])

    ddlB4_Tipo := g.AddDropDownList("xp yp w300 Choose1 Hidden +Tabstop", ["Neoplasia folicular / Suspeito para neoplasia folicular", "Neoplasia folicular / Suspeito para neoplasia folicular de células oxifílicas"])
    ddlB4_Crit := g.AddDropDownList("x+10 yp w360 Choose1 Hidden +Tabstop", ["Esfregaços hipercelulares com células foliculares monomórficas, predominância de microfolículos e escasso coloide", "Esfregaços hipercelulares com células foliculares monomórficas, com sobreposição celular, formação de placas sinciciais e ausência de coloide", "Esfregaços hipercelulares com células oxifílicas monomórficas, predominância de microfolículos e escasso coloide", "Esfregaços hipercelulares com células oxifílicas monomórficas, com sobreposição celular, formação de placas sinciciais e ausência de coloide"])

    ddlB5 := g.AddDropDownList("x35 yp w670 Choose1 Hidden +Tabstop", ["Suspeito para Carcinoma medular", "Suspeito para Carcinoma metastático", "Suspeito para Carcinoma papilífero", "Suspeito para Linfoma"])
    ddlB6 := g.AddDropDownList("xp yp w670 Choose1 Hidden +Tabstop", ["Consistente com Carcinoma papilífero", "Consistente com Carcinoma de células escamosas", "Consistente com Carcinoma medular", "Consistente com Carcinoma metastático", "Consistente com Carcinoma anaplásico (indiferenciado)", "Consistente com Carcinoma pouco diferenciado", "Consistente com Linfoma não Hodgkin"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w700 r8 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE INTERFACE ---
    AtualizarLayout(*) {
        val := ddlCat.Value
        ddlB1.Visible := (val == 1), ddlB2.Visible := (val == 2), ddlB3.Visible := (val == 3)
        ddlB4_Tipo.Visible := (val == 4), ddlB4_Crit.Visible := (val == 4)
        ddlB5.Visible := (val == 5), ddlB6.Visible := (val == 6)
        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlCat, ddlB1, ddlB2, ddlB3, ddlB4_Tipo, ddlB4_Crit, ddlB5, ddlB6]
    for c in controles
        c.OnEvent("Change", AtualizarLayout)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlCat.Focus()
    AtualizarLayout()

    ; --- FUNÇÃO BUILD CORRIGIDA ---
    Build() {
        v := ddlCat.Value
        res := ddlCat.Text " (Classificação Bethesda, 2007):`n"

        if (v == 1) {
            res .= ddlB1.Text "."
        } else if (v == 2) {
            res .= ddlB2.Text "."
        } else if (v == 3) {
            res .= ddlB3.Text "."
        } else if (v == 4) {
            res := "Categoria IV: " ddlB4_Tipo.Text " (Classificação Bethesda, 2007):`n" ddlB4_Crit.Text "."
        } else if (v == 5) {
            res .= ddlB5.Text "."
        } else if (v == 6) {
            res .= ddlB6.Text "."
        }

        return res
    }
}