; =========================================================
; Colo uterino — Tumor (peça) — OMS 2020
; Arquivo: scripts\ColoUtTumorPeca.ahk
; Função chamada no menu: Mask_ColoUtTumorPeca()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ColoUtTumorPeca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Colo uterino — Tumor (peça)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO / DIFERENCIAÇÃO (com opções especiais p/ NE)
    ; =========================
    g.AddText("w170", "Tipo (OMS 2020)")
    ddlTipo := g.AddDropDownList("x+8 w540 Choose1", [
        "Carcinoma de células escamosas, SOE",
        "Carcinoma de células escamosas HPV-associado",
        "Carcinoma de células escamosas HPV-independente",
        "Adenocarcinoma, SOE",
        "Adenocarcinoma HPV-associado",
        "Adenocarcinoma HPV-independente, SOE",
        "Adenocarcinoma HPV-independente, tipo gástrico",
        "Adenocarcinoma HPV-independente, tipo células claras",
        "Adenocarcinoma HPV-independente, tipo mesonéfrico",
        "Adenocarcinoma endometrioide, SOE",
        "Carcinoma adenoescamoso",
        "Carcinossarcoma",
        "Carcinoma adenoide basal",
        "Carcinoma mucoepidermoide",
        "Tumor neuroendócrino (grau)",
        "Carcinoma neuroendócrino (alto grau)",
        "Carcinoma misto neuroendócrino e não neuroendócrino",
        "Carcinoma pouco diferenciado"
    ])

    g.AddText("xm y+12 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    ; Extras para tipos 15/16
    g.AddText("x+12 w150", "NE (grau)")
    ddlNEGrau := g.AddDropDownList("x+8 w120 Choose1", ["1", "2", "3"])
    ddlNEGrau.Enabled := false

    g.AddText("x+12 w150", "NE alto grau")
    ddlNEHG := g.AddDropDownList("x+8 w160 Choose1", ["pequenas células", "grandes células"])
    ddlNEHG.Enabled := false

    ; =========================
    ; LOCALIZAÇÃO / QUADRANTES
    ; =========================
    g.AddText("xm y+12 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w220 Choose1", [
        "ectocérvice",
        "ectocérvice e endocérvice",
        "endocérvice"
    ])

    g.AddText("x+12 w170", "Quadrante 1")
    ddlQ1 := g.AddDropDownList("x+8 w140 Choose1", ["12-3h", "3-6h", "6-9h", "9-12h"])

    g.AddText("x+12 w170", "Quadrante 2")
    ddlQ2 := g.AddDropDownList("x+8 w140 Choose1", ["—", "12-3h", "3-6h", "6-9h", "9-12h"])

    g.AddText("x+12 w170", "Quadrante 3")
    ddlQ3 := g.AddDropDownList("x+8 w140 Choose1", ["—", "12-3h", "3-6h", "6-9h", "9-12h"])

    ; =========================
    ; DIMENSÃO HORIZONTAL
    ; =========================
    g.AddText("xm y+12 w170", "Dimensão horizontal (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; PROFUNDIDADE / EXTENSÃO / PADRÃO (adenoca)
    ; =========================
    g.AddText("xm y+12 w240", "Profundidade de infiltração")
    ddlProf := g.AddDropDownList("x+8 w360 Choose1", [
        "até 3,0 mm",
        "mais de 3,0 mm até 5,0 mm",
        "mais de 5,0 mm"
    ])

    g.AddText("xm y+12 w240", "Extensão no estroma cervical")
    ddlTerco := g.AddDropDownList("x+8 w220 Choose1", ["superficial", "médio", "profundo"])

    g.AddText("x+12 w240", "Padrão de invasão (adenoca)")
    ddlPadrao := g.AddDropDownList("x+8 w140 Choose1", ["A", "B", "C"])
    ddlPadrao.Enabled := false

    ; =========================
    ; COMPROMETIMENTOS / INVASÕES
    ; =========================
    g.AddText("xm y+12 w240", "Comprometimento do istmo")
    ddlIstmo := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectado"])

    g.AddText("x+12 w240", "Comprom. cavidade endometrial")
    ddlEndom := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectado"])

    g.AddText("xm y+12 w240", "Invasão vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["presente", "não detectada"])

    g.AddText("x+12 w240", "Invasão vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["presente", "não detectada"])

    g.AddText("xm y+12 w240", "Invasão perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["presente", "não detectada"])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    for ctrl in [ddlTipo, ddlDiff, ddlNEGrau, ddlNEHG, ddlLoc, ddlQ1, ddlQ2, ddlQ3, edtDimA, edtDimB
               , ddlProf, ddlTerco, ddlPadrao, ddlIstmo, ddlEndom, ddlIVS, ddlIVL, ddlIPN] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ddlTipo.OnEvent("Change", (*) => (ApplyTypeRules(), UpdatePreview()))

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
    ApplyTypeRules()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ApplyTypeRules() {
        t := ddlTipo.Text

        ; 15: Tumor NE bem diferenciado -> habilita grau
        if (t = "Tumor neuroendócrino (grau)") {
            ddlNEGrau.Enabled := true
            ddlNEHG.Enabled := false
        } else if (t = "Carcinoma neuroendócrino (alto grau)") {
            ddlNEGrau.Enabled := false
            ddlNEHG.Enabled := true
        } else {
            ddlNEGrau.Enabled := false
            ddlNEHG.Enabled := false
        }

        ; Padrão A/B/C só para ADENOCARCINOMAS
        isAdeno := InStr(t, "Adenocarcinoma")
        ddlPadrao.Enabled := isAdeno
        if (!isAdeno)
            ddlPadrao.Choose(1) ; mantém valor, mas não será impresso
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

        ; Tipo final (com extras p/ 15/16)
        tipoFinal := ddlTipo.Text
        if (ddlTipo.Text = "Tumor neuroendócrino (grau)")
            tipoFinal := "Tumor neuroendócrino grau " ddlNEGrau.Text
        else if (ddlTipo.Text = "Carcinoma neuroendócrino (alto grau)")
            tipoFinal := "Carcinoma neuroendócrino de " ddlNEHG.Text " de alto grau"

        header := tipoFinal " " ddlDiff.Text " diferenciado (OMS, 2020)"

        ; Quadrantes (2 e 3 opcionais)
        q := ddlQ1.Text
        if (ddlQ2.Text != "—")
            q .= ", " ddlQ2.Text
        if (ddlQ3.Text != "—")
            q .= " e " ddlQ3.Text

        ; Padrão A/B/C: só adenoca
        padraoLine := ""
        if (ddlPadrao.Enabled) {
            padraoLine := ". Padrão de invasão: padrão " ddlPadrao.Text " (USAR SOMENTE PARA ADENOCARCINOMAS)`n"
        }

        return (
            header "`n"
            ". Localização: " ddlLoc.Text " quadrantes " q "`n"
            ". Dimensão horizontal da neoplasia: " dimTxt "`n"
            ". Medida da profundidade de infiltração: " ddlProf.Text "`n"
            ". Extensão da profundidade de invasão do estroma cervical: terço " ddlTerco.Text "`n"
            padraoLine
            ". Comprometimento do istmo: " ddlIstmo.Text "`n"
            ". Comprometimento da cavidade endometrial: " ddlEndom.Text "`n"
            ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
            ". Invasão vascular linfática: " ddlIVL.Text "`n"
            ". Invasão perineural: " ddlIPN.Text
        )
    }
}
