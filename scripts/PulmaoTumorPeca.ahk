; =========================================================
; Pulmão — Tumor (peça)
; Arquivo: scripts\TumorPulmaoPeca.ahk
; Função chamada no menu: Mask_TumorPulmaoPeca()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_PulmaoTumorPeca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pulmão — Tumor (peça)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; CABEÇALHO (tipo + diferenciação)
    ; =========================
    g.AddText("xm w170", "Tipo")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Adenocarcinoma",
        "Carcinoma de células escamosas",
        "Tumor carcinoide típico",
        "Tumor carcinoide atípico",
        "Carcinoma neuroendócrino de grandes células"
    ])

    g.AddText("x+12 yp w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    ; =========================
    ; PADRÕES (até 4 linhas)
    ; =========================
    g.AddText("xm y+16 w910", "Padrões da neoplasia e proporções (%)")
    g.AddText("xm y+8 w170", "Padrão 1")
    ddlP1 := g.AddDropDownList("x+8 w260 Choose1", ["sólido", "micropapilífero", "papilífero", "acinar", "lepídico"])
    edtP1 := g.AddEdit("x+10 w80")
    g.AddText("x+6 yp+3", "%")

    g.AddText("xm y+10 w170", "Padrão 2")
    ddlP2 := g.AddDropDownList("x+8 w260 Choose1", ["sólido", "micropapilífero", "papilífero", "acinar", "lepídico"])
    edtP2 := g.AddEdit("x+10 w80")
    g.AddText("x+6 yp+3", "%")
    cbP2 := g.AddCheckBox("x+10 yp-3", "usar")
    cbP2.Value := 0

    g.AddText("xm y+10 w170", "Padrão 3")
    ddlP3 := g.AddDropDownList("x+8 w260 Choose1", ["sólido", "micropapilífero", "papilífero", "acinar", "lepídico"])
    edtP3 := g.AddEdit("x+10 w80")
    g.AddText("x+6 yp+3", "%")
    cbP3 := g.AddCheckBox("x+10 yp-3", "usar")
    cbP3.Value := 0

    g.AddText("xm y+10 w170", "Padrão 4")
    ddlP4 := g.AddDropDownList("x+8 w260 Choose1", ["sólido", "micropapilífero", "papilífero", "acinar", "lepídico"])
    edtP4 := g.AddEdit("x+10 w80")
    g.AddText("x+6 yp+3", "%")
    cbP4 := g.AddCheckBox("x+10 yp-3", "usar")
    cbP4.Value := 0

    ; =========================
    ; DIMENSÕES
    ; =========================
    g.AddText("xm y+16 w910", "Dimensões da neoplasia (cm)")
    g.AddText("xm y+8 w170", "Dimensão total")
    edtTotA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtTotB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    g.AddText("xm y+10 w170", "Componente invasivo")
    edtInvA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtInvB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; LOCALIZAÇÃO / FOCALIDADE
    ; =========================
    g.AddText("xm y+16 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose1", [
        "lobo superior",
        "lobo médio",
        "lobo inferior",
        "brônquio principal",
        "brônquio intermediário",
        "brônquio lobar"
    ])

    g.AddText("xm y+10 w170", "Focalidade")
    ddlFoc := g.AddDropDownList("x+8 w740 Choose1", [
        "nódulo único",
        "nódulos tumorais separados do mesmo tipo histológico no mesmo lobo",
        "nódulos tumorais separados do mesmo tipo histológico em lobos diferentes",
        "nódulos tumorais separados de tipos histológicos diferentes no mesmo lobo",
        "nódulos tumorais separados de tipos histológicos diferentes em lobos diferentes",
        "adenocarcinoma multifocal com características lepídicas",
        "adenocarcinoma tipo pneumônico difuso"
    ])

    ; =========================
    ; INVASÕES / STAS / PLEURA
    ; =========================
    g.AddText("xm y+16 w170", "STAS")
    ddlSTAS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 yp w170", "Pleura visceral")
    ddlPleura := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+10 w170", "Estruturas adjacentes")
    ddlAdj := g.AddDropDownList("x+8 w740 Choose1", [
        "ausência de estruturas adjacentes no espécime avaliado",
        "estruturas adjacentes presentes no espécime avaliado, sem invasão neoplásica",
        "invasão neoplásica do brônquio principal",
        "invasão neoplásica de tecidos moles hilares",
        "invasão neoplásica da carina da traqueia",
        "invasão neoplásica da pleura parietal",
        "invasão neoplásica da parede torácica",
        "invasão neoplásica do nervo frênico",
        "invasão neoplásica do pericárdio parietal",
        "invasão neoplásica do diafragma",
        "invasão neoplásica do mediastino",
        "invasão neoplásica do coração",
        "invasão neoplásica de grandes vasos",
        "invasão neoplásica da traqueia",
        "invasão neoplásica do nervo laríngeo recorrente",
        "invasão neoplásica do esôfago",
        "invasão neoplásica de corpo vertebral"
    ])

    g.AddText("xm y+10 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 yp w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 yp w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; PULMÃO NÃO NEOPLÁSICO (com campos "especificar")
    ; =========================
    g.AddText("xm y+16 w170", "Pulmão não neoplásico")
    ddlNonNeo := g.AddDropDownList("x+8 w520 Choose1", [
        "dentro dos limites histológicos da normalidade",
        "hiperplasia adenomatosa atípica",
        "displasia no epitélio escamoso",
        "metaplasia (especificar)",
        "hiperplasia neuroendócrina difusa",
        "inflamação (especificar tipo)",
        "enfisema",
        "fibrose (identificar se há padrão distinguível)",
        "outro (citar)"
    ])

    g.AddText("xm y+8 w170", "Especificação")
    edtNonNeoSpec := g.AddEdit("x+8 w740")
    edtNonNeoSpec.Enabled := false

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w910 r12 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ; STATIC refs (evita #Warn)
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0
    static s_ddlTipo := 0, s_ddlDiff := 0
    static s_ddlP1 := 0, s_edtP1 := 0
    static s_ddlP2 := 0, s_edtP2 := 0, s_cbP2 := 0
    static s_ddlP3 := 0, s_edtP3 := 0, s_cbP3 := 0
    static s_ddlP4 := 0, s_edtP4 := 0, s_cbP4 := 0
    static s_edtTotA := 0, s_edtTotB := 0, s_edtInvA := 0, s_edtInvB := 0
    static s_ddlLoc := 0, s_ddlFoc := 0
    static s_ddlSTAS := 0, s_ddlPleura := 0, s_ddlAdj := 0
    static s_ddlIVS := 0, s_ddlIVL := 0, s_ddlIPN := 0
    static s_ddlNonNeo := 0, s_edtNonNeoSpec := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev

    s_ddlTipo := ddlTipo
    s_ddlDiff := ddlDiff

    s_ddlP1 := ddlP1
    s_edtP1 := edtP1
    s_ddlP2 := ddlP2
    s_edtP2 := edtP2
    s_cbP2 := cbP2
    s_ddlP3 := ddlP3
    s_edtP3 := edtP3
    s_cbP3 := cbP3
    s_ddlP4 := ddlP4
    s_edtP4 := edtP4
    s_cbP4 := cbP4

    s_edtTotA := edtTotA
    s_edtTotB := edtTotB
    s_edtInvA := edtInvA
    s_edtInvB := edtInvB

    s_ddlLoc := ddlLoc
    s_ddlFoc := ddlFoc

    s_ddlSTAS := ddlSTAS
    s_ddlPleura := ddlPleura
    s_ddlAdj := ddlAdj

    s_ddlIVS := ddlIVS
    s_ddlIVL := ddlIVL
    s_ddlIPN := ddlIPN

    s_ddlNonNeo := ddlNonNeo
    s_edtNonNeoSpec := edtNonNeoSpec

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    NormNum(v) {
        v := Trim(v)
        if (v = "")
            return ""
        return StrReplace(v, ",", ".")
    }

    Dim2(aCtrl, bCtrl, placeholder) {
        a := NormNum(aCtrl.Value)
        b := NormNum(bCtrl.Value)
        if (a != "" && b != "")
            return a " x " b " cm"
        else if (a != "" && b = "")
            return a " cm"
        else if (a = "" && b != "")
            return b " cm"
        else
            return placeholder
    }

    ApplyRules() {
        ; habilita/desabilita linhas 2-4
        s_ddlP2.Enabled := (s_cbP2.Value = 1)
        s_edtP2.Enabled := (s_cbP2.Value = 1)
        if (s_cbP2.Value != 1) {
            s_edtP2.Value := ""
        }

        s_ddlP3.Enabled := (s_cbP3.Value = 1)
        s_edtP3.Enabled := (s_cbP3.Value = 1)
        if (s_cbP3.Value != 1) {
            s_edtP3.Value := ""
        }

        s_ddlP4.Enabled := (s_cbP4.Value = 1)
        s_edtP4.Enabled := (s_cbP4.Value = 1)
        if (s_cbP4.Value != 1) {
            s_edtP4.Value := ""
        }

        ; pulmão não neoplásico: precisa "especificar" quando opção 4/6/8/9
        needSpec := (s_ddlNonNeo.Value = 4) || (s_ddlNonNeo.Value = 6) || (s_ddlNonNeo.Value = 8) || (s_ddlNonNeo.Value = 9)
        s_edtNonNeoSpec.Enabled := needSpec
        if (!needSpec)
            s_edtNonNeoSpec.Value := ""
    }

    Build() {
        ApplyRules()

        ; header
        header := s_ddlTipo.Text " " s_ddlDiff.Text " diferenciado"

        ; padrões
        linhasPad := []
        p1v := NormNum(s_edtP1.Value)
        linhasPad.Push("- Padrão " s_ddlP1.Text ": " (p1v = "" ? "[]%" : p1v "%"))

        if (s_cbP2.Value = 1) {
            v := NormNum(s_edtP2.Value)
            linhasPad.Push("- Padrão " s_ddlP2.Text ": " (v = "" ? "[]%" : v "%"))
        }
        if (s_cbP3.Value = 1) {
            v := NormNum(s_edtP3.Value)
            linhasPad.Push("- Padrão " s_ddlP3.Text ": " (v = "" ? "[]%" : v "%"))
        }
        if (s_cbP4.Value = 1) {
            v := NormNum(s_edtP4.Value)
            linhasPad.Push("- Padrão " s_ddlP4.Text ": " (v = "" ? "[]%" : v "%"))
        }

        dimTot := Dim2(s_edtTotA, s_edtTotB, "[] x [] cm")
        dimInv := Dim2(s_edtInvA, s_edtInvB, "[] x [] cm")

        ; pulmão não neoplásico
        nonNeoTxt := s_ddlNonNeo.Text
        spec := Trim(s_edtNonNeoSpec.Value)
        if ((s_ddlNonNeo.Value = 4) && spec != "")
            nonNeoTxt := "metaplasia (" spec ")"
        else if ((s_ddlNonNeo.Value = 6) && spec != "")
            nonNeoTxt := "inflamação (" spec ")"
        else if ((s_ddlNonNeo.Value = 8) && spec != "")
            nonNeoTxt := "fibrose (" spec ")"
        else if ((s_ddlNonNeo.Value = 9) && spec != "")
            nonNeoTxt := "outro (" spec ")"

        txt := header "`n"
        txt .= ". Padrões da neoplasia e proporções:`n"
        for _, l in linhasPad
            txt .= l "`n"
        txt := RTrim(txt, "`n") "`n"

        txt .= ". Dimensões da neoplasia:`n"
        txt .= "- Dimensão total da neoplasia: " dimTot "`n"
        txt .= "- Dimensão do componente invasivo: " dimInv "`n"

        txt .= ". Localização: " s_ddlLoc.Text "`n"
        txt .= ". Focalidade: " s_ddlFoc.Text "`n"
        txt .= ". Disseminação para espaços aéreos (STAS): " s_ddlSTAS.Text "`n"
        txt .= ". Invasão da pleura visceral: " s_ddlPleura.Text "`n"
        txt .= ". Invasão direta de estruturas adjacentes: " s_ddlAdj.Text "`n"
        txt .= ". Invasão vascular sanguínea: " s_ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " s_ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " s_ddlIPN.Text "`n"
        txt .= "Pulmão não neoplásico: " nonNeoTxt

        return txt
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    ; =========================
    ; EVENTOS
    ; =========================
    ddlNonNeo.OnEvent("Change", UpdatePreview)
    for ctrl in [ddlTipo, ddlDiff
               , ddlP1, edtP1, ddlP2, edtP2, cbP2, ddlP3, edtP3, cbP3, ddlP4, edtP4, cbP4
               , edtTotA, edtTotB, edtInvA, edtInvB
               , ddlLoc, ddlFoc, ddlSTAS, ddlPleura, ddlAdj, ddlIVS, ddlIVL, ddlIPN
               , edtNonNeoSpec] {
        try ctrl.OnEvent("Change", UpdatePreview)
        try ctrl.OnEvent("Click",  UpdatePreview)
    }

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        s_g.Destroy(),
        PasteInto(s_prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := Build()))
    btnCancel.OnEvent("Click", (*) => s_g.Destroy())

    g.Show()
    UpdatePreview()
}
