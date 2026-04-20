; =========================================================
; Pênis — Carcinoma de Células Escamosas (CEC)
; Arquivo: scripts\PenisCEC.ahk
; =========================================================

Mask_PenisCEC() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pênis — Carcinoma Escamoso")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 12, g.MarginY := 12

    ; --- DIFERENCIAÇÃO E TIPO ---
    g.AddGroupBox("w740 h80", "Classificação")
    g.AddText("xp+10 yp+25 w110", "Diferenciação:")
    ddlDif := g.AddDropDownList("x+5 w200 Choose1", ["Bem diferenciado", "Moderadamente diferenciado", "Pouco diferenciado"])

    g.AddText("xm+10 y+15 w110", "Tipo Histológico:")
    ddlTipo := g.AddDropDownList("x+5 w580 Choose1", [
        "Usual (ceratinizante, não relacionado ao HPV)", "Verrucoso (não relacionado ao HPV)", "Condilomatoso (relacionado ao HPV)",
        "Basaloide (relacionado ao HPV)", "Papilífero, SOE (não relacionado ao HPV)", "Pseudohiperplásico (não relacionado ao HPV)",
        "Cuniculatum (não relacionado ao HPV)", "Pseudoglandular (acantolítico, não relacionado ao HPV)", "Adenoescamoso (não relacionado ao HPV)",
        "Sarcomatoide (não relacionado ao HPV)", "Papilífero-basaloide (relacionado ao HPV)", "Condilomatoso-basaloide (relacionado ao HPV)",
        "Células claras (relacionado ao HPV)", "Linfoepitelioma-símile (relacionado ao HPV)", "Misto (mais que 70%)"
    ])

    ; --- LOCALIZAÇÃO E EXTENSÃO (Dinâmico) ---
    g.AddGroupBox("xm y+20 w740 h110", "Localização e Extensão Microscópica")
    g.AddText("xp+10 yp+25 w110", "Sede do Tumor:")
    ddlSede := g.AddDropDownList("x+5 w200 Choose1", ["Glande", "Sulco balanoprepucial", "Prepúcio", "Corpo peniano"])

    g.AddText("xm+10 y+15 w110", "Envolvimento:")
    ddlExtensao := g.AddDropDownList("x+5 w580 Choose1", ["Lâmina própria"]) ; Inicia com opções da Glande

    ; --- DADOS QUANTITATIVOS E INVASÃO ---
    g.AddGroupBox("xm y+20 w740 h140", "Parâmetros de Invasão")
    g.AddText("xp+10 yp+25 w150", "Espessura (mm):")
    edtEspessura := g.AddEdit("x+5 w80")

    g.AddText("x+20 yp w110", "Borda Invasão:")
    ddlBorda := g.AddDropDownList("x+5 w150 Choose1", ["Compressiva", "Grandes blocos", "Pequenos blocos", "Células isoladas"])

    g.AddText("xm+10 y+15 w150", "Vascular Sanguínea:")
    ddlIVS := g.AddDropDownList("x+5 w150 Choose1", ["Não detectada", "Presente focal", "Presente extensa"])

    g.AddText("x+20 yp w110", "Vascular Linfática:")
    ddlIVL := g.AddDropDownList("x+5 w150 Choose1", ["Não detectada", "Presente focal", "Presente extensa"])

    g.AddText("xm+10 y+15 w150", "Invasão Perineural:")
    ddlPNI := g.AddDropDownList("x+5 w150 Choose1", ["Não detectada", "Presente"])

    ; --- PRÉVIA ---
    g.AddText("xm y+20", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w740 r8 ReadOnly -Wrap")

    ; =========================
    ; LÓGICA DE EVENTOS
    ; =========================
    UpdatePreview(*) => edtPrev.Value := Build()

    ; Atualiza a lista de extensão baseado na sede
    OnSedeChange(ctrl, *) {
        opcoes := []
        switch ctrl.Text {
            case "Glande": opcoes := ["Lâmina própria", "Corpo esponjoso", "Túnica albugínea", "Corpo cavernoso"]
            case "Sulco balanoprepucial": opcoes := ["Lâmina própria", "Dartos", "Fáscia de Buck"]
            case "Prepúcio": opcoes := ["Lâmina própria", "Dartos", "Pele prepucial"]
            case "Corpo peniano": opcoes := ["Pele", "Dartos", "Fáscia de Buck", "Corpo esponjoso", "Corpo cavernoso"]
        }
        ddlExtensao.Delete()
        ddlExtensao.Add(opcoes)
        ddlExtensao.Value := 1
        UpdatePreview()
    }

    ddlSede.OnEvent("Change", OnSedeChange)

    ; Monitorar todos os campos para a prévia
    for ctrl in [ddlDif, ddlTipo, ddlSede, ddlExtensao, edtEspessura, ddlBorda, ddlIVS, ddlIVL, ddlPNI]
        ctrl.OnEvent("Change", UpdatePreview)

    ; Botões
    g.AddButton("xm y+15 w120 Default", "Inserir").OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    g.AddButton("x+10 w120", "Copiar").OnEvent("Click", (*) => A_Clipboard := Build())
    g.AddButton("x+10 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    ; =========================
    ; CONSTRUÇÃO DO TEXTO
    ; =========================
    Build() {
        esp := Trim(edtEspessura.Value) == "" ? "[]" : edtEspessura.Value

        txt := "Carcinoma de células escamosas " ddlDif.Text "`n"
        txt .= ". Tipo: " ddlTipo.Text "`n"
        txt .= ". Sede: " ddlSede.Text "`n"
        txt .= ". Extensão microscópica: Tumor envolve " ddlExtensao.Text "`n"
        txt .= ". Espessura do tumor (profundidade de invasão): " esp " mm`n"
        txt .= ". Borda de invasão: " ddlBorda.Text "`n"
        txt .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " ddlPNI.Text

        return txt
    }
}