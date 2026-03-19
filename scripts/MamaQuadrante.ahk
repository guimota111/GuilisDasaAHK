; =========================================================
; Mastopatologia — Peça Cirúrgica (Quadrante / Mastectomia)
; Arquivo: scripts\MamaQuadrante.ahk
; =========================================================

Mask_MamaQuadrante() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Mama: Quadrante/Cirurgia")
    
    if IsSet(AplicarIcone)
        AplicarIcone(g)

    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. TIPO E GRADUAÇÃO ---
    g.AddGroupBox("w760 h190", "Classificação e Escoragem (Nottingham)")
    g.AddText("xp+15 yp+30 w110", "Tipo Histológico:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w605 Choose1", ["Carcinoma mamário invasivo tipo não especial", "Carcinoma lobular invasivo clássico", "Carcinoma lobular invasivo pleomórfico", "Carcinoma metaplásico", "Carcinoma mucinoso", "Carcinoma tubular", "Carcinoma micropapilífero", "Carcinoma de células altas com polaridade reversa", "Adenocarcinoma apócrino", "Carcinoma papilífero sólido com áreas de invasão", "Cistadenocarcinoma mucinoso", "Carcinoma cribriforme"])

    g.AddText("x35 y+35 w110", "Grau Histológico:")
    ddlGrauH := g.AddDropDownList("x140 yp-3 w60 Choose2", ["1", "2", "3"])
    g.AddText("x210 yp+3", "Grau Nuclear:")
    ddlGrauN := g.AddDropDownList("x300 yp-3 w60 Choose2", ["1", "2", "3"])

    g.AddText("x35 y+35 w110", "Tubular (Escore):")
    ddlTub := g.AddDropDownList("x140 yp-3 w250 Choose2", ["1 (> 75%)", "2 (10% a 75%)", "3 (< 10%)"])
    g.AddText("x400 yp+3", "Mitótico (Escore):")
    ddlMit := g.AddDropDownList("x520 yp-3 w140 Choose1", ["1 (0-7 mitoses)", "2 (8-14 mitoses)", "3 (>= 15 mitoses)"])
    edtMitVal := g.AddEdit("x670 yp-0 w75", "")

    ; --- 2. DIMENSÕES E ESTROMA ---
    g.AddGroupBox("xm y+25 w760 h150", "Extensão e Estroma")
    g.AddText("xp+15 yp+30 w110", "Dimensão (mm):")
    edtDim1 := g.AddEdit("x140 yp-3 w50", ""), g.AddText("x195 yp+3", "x"), edtDim2 := g.AddEdit("x210 yp-3 w50", ""), g.AddText("x265 yp+3", "mm")

    g.AddText("x310 yp+3", "Multifocalidade:")
    ddlMulti := g.AddDropDownList("x410 yp-3 w120 Choose2", ["presente", "não detectada"])

    g.AddText("x35 y+35 w110", "Necrose:")
    ddlNec := g.AddDropDownList("x140 yp-3 w150 Choose1", ["não detectada", "presente, focal", "presente, extensa"])
    g.AddText("x310 yp+3", "Reação Desmo.:")
    ddlDesmo := g.AddDropDownList("x410 yp-3 w120 Choose2", ["leve", "moderada", "intensa"])

    g.AddText("x35 y+35 w110", "Invasões (V/L/P):")
    ddlVascS := g.AddDropDownList("x140 yp-3 w80 Choose2", ["S(+)","S(-)"])
    ddlVascL := g.AddDropDownList("x+5 w80 Choose2", ["L(+)","L(-)"])
    ddlNeural := g.AddDropDownList("x+5 w80 Choose2", ["P(+)","P(-)"])

    g.AddText("x400 yp+3", "Inflamação (TILS):")
    edtInfPerc := g.AddEdit("x520 yp-3 w40", ""), g.AddText("x+5 yp+3", "%")
    ddlInfGrau := g.AddDropDownList("x+5 yp-3 w140 Choose1", ["leve (até 10%)", "moderado (10-60%)", "intenso (>60%)"])

    ; --- 3. COMPONENTE IN SITU ---
    g.AddGroupBox("xm y+25 w760 h110", "Carcinoma In Situ Associado")
    chkCIS := g.AddCheckbox("xp+15 yp+30", "Presente")
    ddlCISTipo := g.AddDropDownList("x140 yp-3 w80 Choose1", ["ductal", "lobular"])
    ddlCISPad1 := g.AddDropDownList("x+5 w110 Choose1", ["sólido", "cribriforme", "micropapilífero", "papilífero", "comedocarcinoma"])
    ddlCISPad2 := g.AddDropDownList("x+5 w110 Choose2", ["sólido", "cribriforme", "micropapilífero", "papilífero", "comedocarcinoma"])
    g.AddText("x+5 yp+3", "Grau:")
    ddlCISNuc := g.AddDropDownList("x+5 yp-3 w40 Choose2", ["I", "II", "III"])

    g.AddText("x35 y+35", "Localização:")
    ddlCISLoc := g.AddDropDownList("x140 yp-3 w315 Choose1", ["presente em meio à neoplasia invasiva", "presente em focos dispersos por toda a mama"])
    g.AddText("x465 yp+3", "Maior foco (mm):")
    edtCISDim := g.AddEdit("x580 yp-3 w50", "")

    ; --- 4. ADJACENTE E PELE ---
    g.AddGroupBox("xm y+25 w760 h100", "Adjacente e Pele")
    chkAde := g.AddCheckbox("xp+15 yp+30", "Adenose simples")
    chkLip := g.AddCheckbox("x+20", "Lipossubstituição")
    chkFibE := g.AddCheckbox("x+20", "Fibrose estromal")

    g.AddText("x35 y+35", "Pele:")
    ddlPele := g.AddDropDownList("x140 yp-3 w605 Choose1", ["livre de neoplasia, dentro dos limites histológicos da normalidade", "fibrose dérmica de padrão cicatrical"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r8 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE ATUALIZAÇÃO ---
    ; Esta função reconstrói a prévia toda vez que algo muda
    UpdatePreview(*) => edtPrev.Value := Build()

    ; Loop para Edits e DropDowns (Evento: Change)
    for ctrl in [ddlTipo, ddlGrauH, ddlGrauN, ddlTub, ddlMit, edtMitVal, edtDim1, edtDim2, ddlMulti, ddlNec, ddlDesmo, ddlVascS, ddlVascL, ddlNeural, edtInfPerc, ddlInfGrau, ddlCISTipo, ddlCISPad1, ddlCISPad2, ddlCISNuc, ddlCISLoc, edtCISDim, ddlPele]
        ctrl.OnEvent("Change", UpdatePreview)

    ; Loop para Checkboxes (Evento: Click)
    for cb in [chkCIS, chkAde, chkLip, chkFibE]
        cb.OnEvent("Click", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))

    g.Show()
    UpdatePreview()

    Build() {
        res := ddlTipo.Text " - OMS 2019`r`n"
        res .= ". Grau histológico: grau " ddlGrauH.Text " de Nottingham (S. B. R. modificado)`r`n"
        res .= "- Grau nuclear: " ddlGrauN.Text "`r`n"
        res .= "- Formação tubular: escore " SubStr(ddlTub.Text, 1, 1) "`r`n"
        res .= "- Índice mitótico: escore " SubStr(ddlMit.Text, 1, 1) " (" (edtMitVal.Value || "[]") " mitoses)`r`n"
        res .= ". Dimensão: " (edtDim1.Value || "0") " x " (edtDim2.Value || "0") " mm`r`n"
        res .= ". Multifocalidade: " ddlMulti.Text "`r`n"
        res .= ". Necrose: " ddlNec.Text "`r`n"
        res .= ". Reação desmoplásica: " ddlDesmo.Text "`r`n"
        res .= ". Invasão vascular: " (ddlVascS.Text = "S(+)" ? "presente" : "não detectada") " / " (ddlVascL.Text = "L(+)" ? "presente" : "não detectada") "`r`n"

        if chkCIS.Value {
            res .= "`r`nComponente in situ associado: " ddlCISTipo.Text " " ddlCISPad1.Text " grau " ddlCISNuc.Text "`r`n"
        }

        res .= "`r`nParênquima mamário adjacente:`r`n"
        if chkAde.Value
            res .= "- Adenose simples`r`n"
        if chkLip.Value
            res .= "- Lipossubstituição`r`n"
        if chkFibE.Value
            res .= "- Fibrose estromal`r`n"

        res .= "`r`nPele: " ddlPele.Text "."
        return res
    }
}