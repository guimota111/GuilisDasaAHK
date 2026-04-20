; =========================================================
; Bexiga — Tumor (peça)
; Arquivo: scripts\BexigaTumorPeca.ahk
; Função chamada no menu: Mask_BexigaTumorPeca()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_BexigaTumorPeca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Bexiga — Tumor (peça)")
    g.MarginX := 12, g.MarginY := 12

    ; =========================
    ; TIPO + % (quando aplicável)
    ; =========================
    g.AddText("w170", "Tipo (OMS 2016)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Carcinoma urotelial papilífero invasivo",
        "Carcinoma urotelial invasivo",
        "Carcinoma de células escamosas",
        "Carcinoma urotelial com diferenciação escamosa",
        "Carcinoma urotelial com diferenciação glandular",
        "Carcinoma urotelial com diferenciação trofoblástica",
        "Carcinoma urotelial com diferenciação mülleriana",
        "Carcinoma urotelial, variante em ninhos",
        "Carcinoma urotelial, variante microscístico",
        "Carcinoma urotelial, variante linfoepitelioma-símile",
        "Carcinoma urotelial, variante micropapilífero",
        "Carcinoma urotelial, variante difuso (plasmocitoide / células em anel de sinete)",
        "Carcinoma urotelial, variante com células gigantes",
        "Carcinoma urotelial, variante sarcomatoide",
        "Carcinoma urotelial, variante rico em lipídios",
        "Carcinoma urotelial, variante células claras",
        "Carcinoma urotelial, variante pouco diferenciado",
        "Carcinoma verrucoso",
        "Adenocarcinoma tipo entérico",
        "Adenocarcinoma tipo mucinoso",
        "Adenocarcinoma misto (entérico + mucinoso)",
        "Carcinoma neuroendócrino de pequenas células",
        "Carcinoma neuroendócrino de grandes células",
        "Carcinoma neuroendócrino bem diferenciado"
    ])

    g.AddText("xm y+10 w170", "% componente (quando aplicável)")
    edtPerc := g.AddEdit("x+8 w120")
    g.AddText("x+10 yp+3 w420", "(para diferenciações e carcinomas neuroendócrinos)")
    edtPerc.Enabled := false

    g.AddText("xm y+12 w170", "Grau")
    ddlGrau := g.AddDropDownList("x+8 w220 Choose1", ["alto", "baixo"])

    ; =========================
    ; DIMENSÃO
    ; =========================
    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; ARQUITETURA
    ; =========================
    g.AddText("xm y+12 w170", "Arquitetura tumoral")
    ddlArq := g.AddDropDownList("x+8 w520 Choose1", [
        "papilífera",
        "plana",
        "ulcerada",
        "sólido (nodular)"
    ])

    ; =========================
    ; LOCALIZAÇÃO (até 3)
    ; =========================
    g.AddText("xm y+12 w170", "Localização (1)")
    ddlLoc1 := g.AddDropDownList("x+8 w520 Choose1", [
        "trígono vesical",
        "parede lateral direita",
        "parede lateral esquerda",
        "parede anterior",
        "parede posterior",
        "cúpula vesical"
    ])

    g.AddText("xm y+10 w170", "Localização (2)")
    ddlLoc2 := g.AddDropDownList("x+8 w520 Choose1", [
        "—",
        "trígono vesical",
        "parede lateral direita",
        "parede lateral esquerda",
        "parede anterior",
        "parede posterior",
        "cúpula vesical"
    ])

    g.AddText("xm y+10 w170", "Localização (3)")
    ddlLoc3 := g.AddDropDownList("x+8 w520 Choose1", [
        "—",
        "trígono vesical",
        "parede lateral direita",
        "parede lateral esquerda",
        "parede anterior",
        "parede posterior",
        "cúpula vesical"
    ])

    ; =========================
    ; PROFUNDIDADE (com víscera adjacente)
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade de infiltração")
    ddlProf := g.AddDropDownList("x+8 w520 Choose1", [
        "lâmina própria (tecido conjuntivo subepitelial)",
        "metade interna da camada muscular própria superficialmente",
        "metade externa da camada muscular própria profundamente",
        "tecido adiposo perivesical à microscopia",
        "tecido adiposo perivesical à macroscopia",
        "víscera adjacente"
    ])

    g.AddText("xm y+8 w170", "Víscera adjacente")
    edtVisc := g.AddEdit("x+8 w520")
    edtVisc.Enabled := false

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["presente", "não detectada"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["presente", "não detectada"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["presente", "não detectada"])

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
    ddlTipo.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))

    ddlProf.OnEvent("Change", (*) => (
        edtVisc.Enabled := (ddlProf.Value = 6),
        (ddlProf.Value != 6 ? edtVisc.Value := "" : edtVisc.Focus()),
        UpdatePreview()
    ))

    for ctrl in [ddlTipo, edtPerc, ddlGrau, edtDimA, edtDimB, ddlArq, ddlLoc1, ddlLoc2, ddlLoc3, ddlProf, edtVisc, ddlIVS, ddlIVL, ddlIPN] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    g.Show()
    ApplyRules()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ApplyRules() {
        ; % só para: diferenciações (4-7) e neuroendócrinos (22-24 do nosso ddl)
        needsPerc := (ddlTipo.Value >= 4 && ddlTipo.Value <= 7) || (ddlTipo.Value >= 22 && ddlTipo.Value <= 24)
        edtPerc.Enabled := needsPerc
        if (!needsPerc)
            edtPerc.Value := ""
    }

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        ; dimensão
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

        ; % componente (quando aplicável)
        perc := StrReplace(Trim(edtPerc.Value), ",", ".")
        if (perc = "")
            perc := "{%}"

        ; tipo final (com inserção do % quando necessário)
        t := ddlTipo.Text
        if (ddlTipo.Value >= 4 && ddlTipo.Value <= 7) {
            ; diferenciações
            t := ddlTipo.Text " - correspondendo a " perc "% do total da neoplasia"
        } else if (ddlTipo.Value >= 22 && ddlTipo.Value <= 24) {
            ; neuroendócrinos
            t := ddlTipo.Text " - porcentagem de componente neuroendócrino: " perc "%"
        }

        header := t " (OMS 2016) de " ddlGrau.Text " grau"

        ; localização (1..3), ignorando "—"
        locs := []
        locs.Push(ddlLoc1.Text)
        if (ddlLoc2.Text != "—")
            locs.Push(ddlLoc2.Text)
        if (ddlLoc3.Text != "—")
            locs.Push(ddlLoc3.Text)

        locTxt := ""
        if (locs.Length = 1) {
            locTxt := locs[1]
        } else if (locs.Length = 2) {
            locTxt := locs[1] " e " locs[2]
        } else {
            locTxt := locs[1] ", " locs[2] " e " locs[3]
        }

        ; profundidade
        if (ddlProf.Value = 6) {
            visc := Trim(edtVisc.Value)
            profTxt := (visc = "")
                ? "víscera adjacente {citar}"
                : "víscera adjacente (" visc ")"
        } else {
            profTxt := ddlProf.Text
        }

        return (
            header "`n"
            ". Dimensão da neoplasia: " dimTxt "`n"
            ". Arquitetura tumoral: " ddlArq.Text "`n"
            ". Localização: " locTxt "`n"
            ". Profundidade de infiltração: " profTxt "`n"
            ". Invasão vascular sangüínea: " ddlIVS.Text "`n"
            ". Invasão vascular linfática: " ddlIVL.Text "`n"
            ". Invasão perineural: " ddlIPN.Text
        )
    }
}
