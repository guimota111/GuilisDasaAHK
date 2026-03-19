; =========================================================
; Máscara — Esôfago — Tumor (peça)
; Arquivo: scripts\TumorEsofagoPeca.ahk
; Requer: PasteInto(hwnd, txt) em _lib\gui_utils.ahk (via #Include no principal)
; Chamada no menu: (*) => Mask_TumorEsofagoPeca()
; =========================================================

Mask_TumorEsofagoPeca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Esôfago — Tumor (peça)")
    g.MarginX := 12, g.MarginY := 12

    ; =========================
    ; TIPO / SUBTIPO / GRAU NET
    ; =========================
    g.AddText("w170", "Tipo")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Adenocarcinoma (OMS 2019)",
        "Carcinoma de células escamosas (OMS 2019)",
        "Carcinoma (OMS 2019)",
        "Tumor neuroendócrino bem diferenciado (OMS 2019)"
    ])

    g.AddText("xm y+10 w170", "Subtipo")
    ddlSub := g.AddDropDownList("x+8 w520 Choose1", ["—"])
    ddlSub.Enabled := false

    g.AddText("xm y+10 w170", "Grau NET (OMS 2019)")
    ddlNetGrau := g.AddDropDownList("x+8 w220 Choose1", ["1", "2", "3"])
    ddlNetGrau.Enabled := false

    g.AddText("x+12 yp w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    ; =========================
    ; DIMENSÃO / LOCALIZAÇÃO / JEG
    ; =========================
    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    g.AddText("xm y+12 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose4", [
        "esôfago cervical",
        "esôfago torácico superior",
        "esôfago torácico médio",
        "esôfago distal (torácico inferior)",
        "junção esôfago-gástrica",
        "estômago proximal e junção esôfago-gástrica"
    ])

    g.AddText("xm y+12 w170", "Relação com a JEG")
    ddlJEG := g.AddDropDownList("x+8 w520 Choose1", [
        "tumor localizado inteiramente no esôfago tubular e não envolve a junção esôfago-gástrica",
        "ponto médio tumoral localizado no esôfago distal e tumor envolve a junção esôfago-gástrica",
        "ponto médio tumoral localizado na junção esôfago-gástrica",
        "ponto médio tumoral localizado no estômago proximal e tumor envolve a junção esôfago-gástrica"
    ])

    ; =========================
    ; PROFUNDIDADE (com víscera adjacente)
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade")
    ddlProf := g.AddDropDownList("x+8 w520 Choose1", [
        "restrito à mucosa",
        "invade a lâmina própria",
        "invade a muscular da mucosa",
        "invade a submucosa",
        "invade a muscular própria",
        "ultrapassa a muscular própria e atinge a adventícia",
        "invade vísceras adjacentes"
    ])

    g.AddText("xm y+8 w170", "Víscera adjacente")
    edtVisc := g.AddEdit("x+8 w520")
    edtVisc.Enabled := false

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; NÃO NEOPLÁSICO
    ; =========================
    g.AddText("xm y+16 w720", "Esôfago não neoplásico")
    ddlNonNeo := g.AddDropDownList("xm w720 Choose1", [
        "dentro dos limites histológicos da normalidade",
        "esofagite crônica leve, sem epitélio metaplásico"
    ])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    ; Eventos gerais
    for ctrl in [ddlTipo, ddlSub, ddlNetGrau, ddlDiff, edtDimA, edtDimB, ddlLoc, ddlJEG, ddlProf, edtVisc
               , ddlIVS, ddlIVL, ddlIPN, ddlNonNeo] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ddlTipo.OnEvent("Change", (*) => (
        ApplyTipoRules(),
        UpdatePreview()
    ))

    ddlProf.OnEvent("Change", (*) => (
        edtVisc.Enabled := (ddlProf.Value = 7),
        (ddlProf.Value != 7 ? edtVisc.Value := "" : edtVisc.Focus()),
        UpdatePreview()
    ))

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

    ApplyTipoRules()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ApplyTipoRules() {
        if (ddlTipo.Value = 2) {
            ; CEC -> subtipos
            ddlSub.Delete()
            ddlSub.Add([
                "SOE (OMS 2019)",
                "basaloide (OMS 2019)",
                "de células fusiformes (OMS 2019)",
                "verrucoso (OMS 2019)"
            ])
            ddlSub.Choose(1)
            ddlSub.Enabled := true

            ddlNetGrau.Enabled := false
            ddlDiff.Enabled := true
        } else if (ddlTipo.Value = 3) {
            ; Carcinoma -> subtipos
            ddlSub.Delete()
            ddlSub.Add([
                "mucoepidermoide (OMS 2019)",
                "adenoide cístico (OMS 2019)",
                "linfoepitelioma-símile (OMS 2019)",
                "neuroendócrino de grandes células (OMS 2019)",
                "neuroendócrino de pequenas células (OMS 2019)",
                "misto neuroendócrino e carcinoma de células escamosas (OMS 2019)",
                "misto neuroendócrino e adenocarcinoma (OMS 2019)"
            ])
            ddlSub.Choose(1)
            ddlSub.Enabled := true

            ddlNetGrau.Enabled := false
            ddlDiff.Enabled := true
        } else if (ddlTipo.Value = 4) {
            ; NET bem diferenciado -> habilita grau NET; desabilita diferenciação
            ddlSub.Delete()
            ddlSub.Add(["—"])
            ddlSub.Choose(1)
            ddlSub.Enabled := false

            ddlNetGrau.Enabled := true
            ddlDiff.Enabled := false
        } else {
            ; Adenocarcinoma -> sem subtipo
            ddlSub.Delete()
            ddlSub.Add(["—"])
            ddlSub.Choose(1)
            ddlSub.Enabled := false

            ddlNetGrau.Enabled := false
            ddlDiff.Enabled := true
        }
    }

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        ; Dimensão (aceita 2,3 ou 2.3)
        dimA := StrReplace(Trim(edtDimA.Value), ",", ".")
        dimB := StrReplace(Trim(edtDimB.Value), ",", ".")
        if (dimA != "" && dimB != "")
            dimTxt := dimA " x " dimB " cm"
        else if (dimA != "" && dimB = "")
            dimTxt := dimA " cm"
        else if (dimA = "" && dimB != "")
            dimTxt := dimB " cm"
        else
            dimTxt := "[dimensão] x [dimensão] cm"

        ; Tipo + diferenciação (exatamente como sua máscara pede)
        if (ddlTipo.Value = 1) {
            tipoTxt := "Adenocarcinoma (OMS 2019)"
            diffTxt := ddlDiff.Text " diferenciado"
        } else if (ddlTipo.Value = 2) {
            tipoTxt := "Carcinoma de células escamosas " ddlSub.Text
            diffTxt := ddlDiff.Text " diferenciado"
        } else if (ddlTipo.Value = 3) {
            tipoTxt := "Carcinoma " ddlSub.Text
            diffTxt := ddlDiff.Text " diferenciado"
        } else {
            ; Aqui precisa continuar cumprindo o template: "[... grau X ...] [bem/mod/pouco] diferenciado"
            tipoTxt := "Tumor neuroendócrino bem diferenciado grau " ddlNetGrau.Text " (OMS 2019)"
            diffTxt := ddlDiff.Text " diferenciado"
        }

        header := tipoTxt " " diffTxt

        ; Profundidade
        if (ddlProf.Value = 7) {
            visc := Trim(edtVisc.Value)
            profTxt := "tumor invade " (visc = "" ? "vísceras adjacentes {citar}" : visc)
        } else {
            ; já inclui "tumor ..." no enunciado final
            profTxt := "tumor " ddlProf.Text
        }

        return (
            header "`n"
            ". Dimensão da neoplasia: " dimTxt "`n"
            ". Localização: " ddlLoc.Text "`n"
            ". Relação do tumor com a junção esôfago-gástrica: " ddlJEG.Text "`n"
            ". Profundidade de infiltração: " profTxt "`n"
            ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
            ". Invasão vascular linfática: " ddlIVL.Text "`n"
            ". Invasão perineural: " ddlIPN.Text "`n"
            "Esôfago não neoplásico: " ddlNonNeo.Text
        )
    }
}
