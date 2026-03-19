; =========================================================
; GDP — Tumor em papila (Ampola) — OMS 2019
; Arquivo: scripts\GDPtumorEmPapila.ahk
; Função chamada no menu: Mask_GDPtumorEmPapila()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_GDPtumorEmPapila() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — GDP — Tumor em papila (OMS 2019)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO / DIFERENCIAÇÃO
    ; =========================
    g.AddText("w170", "Tipo (OMS 2019)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Adenocarcinoma tipo pancreaticobiliar",
        "Adenocarcinoma tipo intestinal",
        "Adenocarcinoma tubular com características mistas (intestinal e pancreáticobiliar)",
        "Adenocarcinoma mucinoso invasivo",
        "Adenocarcinoma invasivo, SOE",
        "Carcinoma medular",
        "Carcinoma com células em anel de sinete",
        "Carcinoma adenoescamoso",
        "Carcinoma neuroendócrino de grandes células",
        "Carcinoma neuroendócrino de pequenas células",
        "Carcinoma indiferenciado com células gigantes tipo osteoclastos",
        "Carcinoma misto adenoneuroendocrino",
        "Carcinoma indiferenciado"
    ])

    g.AddText("xm y+12 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    ; =========================
    ; DIMENSÃO
    ; =========================
    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; LOCALIZAÇÃO
    ; =========================
    g.AddText("xm y+12 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose1", [
        "região intra-ampular",
        "região peri-ampular",
        "regiões intra-ampular e peri-ampular (tumor misto)"
    ])

    ; =========================
    ; EXTENSÃO MICROSCÓPICA
    ; =========================
    g.AddText("xm y+12 w170", "Extensão microscópica")
    ddlExt := g.AddDropDownList("x+8 w520 Choose1", [
        "carcinoma in situ/displasia de alto grau",
        "tumor limitado à ampola de Vater ou esfíncter de Oddi",
        "tumor invade além do esfíncter de Oddi (invasão peri-esfincteriana)",
        "tumor invade a submucosa duodenal",
        "tumor invade a muscular própria do duodeno",
        "tumor invade subserosa duodenal",
        "tumor invade a serosa duodenal",
        "tumor invade diretamente o pâncreas, medindo até 0,5 cm de profundidade de invasão",
        "tumor invade o pâncreas, medindo mais de 0,5 cm de profundidade de invasão",
        "tumor invade tecido adiposo peripancreático",
        "tumor invade órgãos ou estruturas adjacentes além do pâncreas ({citar})",
        "tumor envolve a superfície posterior do pâncreas",
        "tumor envolve a superfície anterior do pâncreas",
        "tumor envolve o sulco vascular"
    ])

    g.AddText("xm y+8 w170", "Estruturas adjacentes")
    edtAdj := g.AddEdit("x+8 w520")
    edtAdj.Enabled := false

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w170", "Inv. via biliar")
    ddlBiliar := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. pâncreas")
    ddlPancreas := g.AddDropDownList("x+8 w300 Choose1", [
        "não detectada",
        "presente, medindo menos de 0,5 cm de profundidade",
        "presente, medindo mais de 0,5 cm de profundidade"
    ])

    g.AddText("xm y+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; VIA BILIAR (NÃO NEOPLÁSICA)
    ; =========================
    g.AddText("xm y+16 w720", "Via biliar")
    ddlVB := g.AddDropDownList("xm w720 Choose1", [
        "livre de neoplasia, dentro dos limites histológicos da normalidade",
        "neoplasia intraepitelial biliar",
        "neoplasia intraductal papilífera"
    ])

    g.AddText("xm y+8 w170", "Grau (BilIN)")
    ddlBilIN := g.AddDropDownList("x+8 w120 Choose1", ["1", "2", "3"])
    ddlBilIN.Enabled := false

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+12", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    ; Eventos de update
    for ctrl in [ddlTipo, ddlDiff, edtDimA, edtDimB, ddlLoc, ddlExt, edtAdj, ddlBiliar, ddlPancreas, ddlIVL, ddlIPN, ddlVB, ddlBilIN] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ; Extensão 11 -> habilita adjacentes
    ddlExt.OnEvent("Change", (*) => (
        ToggleAdj(),
        UpdatePreview()
    ))

    ; Via biliar BilIN -> habilita grau
    ddlVB.OnEvent("Change", (*) => (
        ToggleBilIN(),
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
    ToggleAdj()
    ToggleBilIN()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ToggleAdj() {
        ; opção 11 é "órgãos ou estruturas adjacentes..."
        if (ddlExt.Value = 11) {
            edtAdj.Enabled := true
            edtAdj.Focus()
        } else {
            edtAdj.Enabled := false
            edtAdj.Value := ""
        }
    }

    ToggleBilIN() {
        if (ddlVB.Value = 2) {
            ddlBilIN.Enabled := true
        } else {
            ddlBilIN.Enabled := false
            ddlBilIN.Choose(1)
        }
    }

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
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

        ; extensão (substitui {citar} quando aplicável)
        extTxt := ddlExt.Text
        if (ddlExt.Value = 11) {
            adj := Trim(edtAdj.Value)
            if (adj != "") {
                ; remove o "({citar})" e coloca o texto
                extTxt := StrReplace(extTxt, "({citar})", "(" adj ")")
                extTxt := StrReplace(extTxt, "{citar}", adj)
            }
        }

        ; via biliar (BilIN com grau)
        vbTxt := ddlVB.Text
        if (ddlVB.Value = 2) {
            vbTxt := "neoplasia intraepitelial biliar " ddlBilIN.Text
        }

        txt := ddlTipo.Text " - OMS 2019, " ddlDiff.Text " diferenciado`n"
        txt .= ". Dimensão da neoplasia: " dimTxt "`n"
        txt .= ". Localização: " ddlLoc.Text "`n"
        txt .= ". Extensão microscópica na neoplasia: " extTxt "`n"
        txt .= ". Invasão da via biliar: " ddlBiliar.Text "`n"
        txt .= ". Invasão do pâncreas: " ddlPancreas.Text "`n"
        txt .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " ddlIPN.Text "`n"
        txt .= "Via biliar: " vbTxt
        return txt
    }
}
