; =========================================================
; Rim — Wilms pós-QT (COG/SIOP + classificação pós-quimio)
; Arquivo: scripts\RimWilmsQT.ahk
; Função chamada no menu: Mask_RimWilmsQT()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_RimWilmsQT() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Rim — Wilms (pós-QT)")
    g.MarginX := 12, g.MarginY := 12

    stg := ["I", "II", "III", "IV", "V"]

    ; =========================
    ; ESTADIAMENTO
    ; =========================
    g.AddText("xm w720", "Estadiamento patológico")

    g.AddText("xm y+10 w250", "Children´s Oncology Group (COG)")
    ddlCOGStage := g.AddDropDownList("x+8 w120 Choose1", stg)

    g.AddText("x+16 w250", "International Society of Paediatric Oncology (SIOP)")
    ddlSIOPStage := g.AddDropDownList("x+8 w120 Choose1", stg)

    ; =========================
    ; CLASSIFICAÇÃO PÓS-QT
    ; =========================
    g.AddText("xm y+16 w720", "Classificação histológica do Tumor de Wilms pós quimioterapia pré-operatória")

    ; --- COG ---
    g.AddText("xm y+10 w720", "Children´s Oncology Group (COG)")
    g.AddText("xm y+8 w140", "Predominante")
    ddlCOGPred := g.AddDropDownList("x+8 w572 Choose2", [
        "Completamente necrótico (ausência de tumor viável)",
        "Regressivo (menos de 33% de tumor viável, independente dos componentes histológicos)",
        "Blastemal (mais de 33% de tumor viável, sendo mais de 66% do tumor viável constituído pelo componente blastemal)",
        "Epitelial (mais de 33% de tumor viável, sendo mais de 66% do tumor viável constituído pelo componente epitelial)",
        "Mesenquimal (mais de 33% de tumor viável, sendo mais de 66% do tumor viável constituído pelo componente mesenquimal)",
        "Misto (nenhum dos componentes do tumor viável representa mais de 66% do total da lesão)",
        "Anaplasia focal (até 4 focos de anaplasia intratumoral, nenhum deles > 20,0 mm)",
        "Anaplasia difusa (mais de 4 focos de anaplasia intratumoral, ou foco intratumoral > 20,0 mm, ou anaplasia extratumoral/extrarrenal)"
    ])

    g.AddText("xm y+8 w140", "Grupo de risco")
    ddlCOGRisk := g.AddDropDownList("x+8 w572 Choose1", [
        "Risco baixo (Predominante Completamente necrótico)",
        "Risco intermediário (Predominante Regressivo)",
        "Risco intermediário (Predominante Epitelial)",
        "Risco intermediário (Predominante Mesenquimal)",
        "Risco intermediário (Predominante Misto)",
        "Risco alto (Predominante Blastemal)"
    ])

    ; --- SIOP ---
    g.AddText("xm y+14 w720", "International Society of Paediatric Oncology (SIOP)")

    g.AddText("xm y+8 w140", "Tipo tumoral")
    ddlSIOPTipo := g.AddDropDownList("x+8 w572 Choose2", [
        "Completamente necrótico (ausência de tumor viável)",
        "Regressivo (menos de 33% de tumor viável, independente dos componentes histológicos)",
        "Blastemal (mais de 33% de tumor viável, sendo mais de 66% do tumor viável constituído pelo componente blastemal)",
        "Epitelial (mais de 33% de tumor viável, sendo mais de 66% epitelial, e menos de 10% blastemal)",
        "Mesenquimal (mais de 33% de tumor viável, sendo mais de 66% mesenquimal, e menos de 10% blastemal)",
        "Misto (mais de 33% de tumor viável, nenhum componente > 66%, ou epitelial/estromal com > 10% blastemal residual)",
        "Anaplasia focal (até 2 focos de anaplasia intratumoral, nenhum deles > 15,0 mm)",
        "Anaplasia difusa (mais de 2 focos de anaplasia intratumoral, ou foco intratumoral > 15,0 mm, ou anaplasia extratumoral/extrarrenal)"
    ])

    g.AddText("xm y+8 w140", "Grupo de risco")
    ddlSIOPRisk := g.AddDropDownList("x+8 w572 Choose2", [
        "Risco baixo (Tipo tumoral Completamente necrótico)",
        "Risco intermediário (Tipo tumoral Regressivo)",
        "Risco intermediário (Tipo tumoral Epitelial)",
        "Risco intermediário (Tipo tumoral Mesenquimal)",
        "Risco intermediário (Tipo tumoral Misto)",
        "Risco intermediário (Tipo tumoral Anaplasia focal)",
        "Risco alto (Tipo tumoral Blastemal)",
        "Risco alto (Tipo tumoral Anaplasia difusa)"
    ])

    ; =========================
    ; REFERÊNCIA (opcional no texto)
    ; =========================
    cbRef := g.AddCheckBox("xm y+14", "Incluir referência bibliográfica no final")
    cbRef.Value := 0

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

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

    ; =========================
    ; EVENTOS
    ; =========================
    for ctrl in [ddlCOGStage, ddlSIOPStage, ddlCOGPred, ddlCOGRisk, ddlSIOPTipo, ddlSIOPRisk, cbRef] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    g.Show()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        linhas := []

        linhas.Push("Estadiamento patológico:")
        linhas.Push(". Children´s Oncology Group (COG): Estágio " ddlCOGStage.Text)
        linhas.Push(". International Society of Paediatric Oncology (SIOP): Estágio " ddlSIOPStage.Text)

        linhas.Push("CLASSIFICAÇÃO HISTOLÓGICA DO TUMOR DE WILMS PÓS QUIMIOTERAPIA PRÉ-OPERATÓRIA")
        linhas.Push("Children´s Oncology Group (COG):")
        linhas.Push("Predominante:")
        linhas.Push(". " ddlCOGPred.Text)
        linhas.Push("Grupo de risco:")
        linhas.Push(". " ddlCOGRisk.Text)

        linhas.Push("International Society of Paediatric Oncology (SIOP):")
        linhas.Push("Tipo tumoral:")
        linhas.Push(". " ddlSIOPTipo.Text)
        linhas.Push("Grupo de risco:")
        linhas.Push(". " ddlSIOPRisk.Text)

        if (cbRef.Value) {
            linhas.Push("Referência bibliográfica:")
            linhas.Push("Vujanić GM, Parsons LN, D'Hooghe E, Treece AL, Collini P, Perlman EJ. Pathology of Wilms' tumour in International Society of Paediatric Oncology (SIOP) and Children's oncology group (COG) renal tumour studies: Similarities and differences. Histopathology. 2022 Jun;80(7):1026-1037. doi: 10.1111/his.14632. Epub 2022 Mar 24. PMID: 35275409.")
        }

        txt := ""
        for l in linhas
            txt .= l "`n"
        return RTrim(txt, "`n")
    }
}
