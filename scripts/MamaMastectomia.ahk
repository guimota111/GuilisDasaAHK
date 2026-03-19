; =========================================================
; Mastopatologia — Peça Cirúrgica (Mastectomia)
; Arquivo: scripts\MamaMastectomia.ahk
; =========================================================

Mask_MamaMastectomia() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Mama: Mastectomia")
    
    if IsSet(AplicarIcone)
        AplicarIcone(g)

    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CLASSIFICAÇÃO E GRADUAÇÃO (TOTALMENTE AUTOMÁTICO) ---
    g.AddGroupBox("w760 h150", "Classificação e Nottingham (Cálculo Automático)")
    g.AddText("xp+15 yp+30 w110", "Tipo Histológico:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w605 Choose1", ["Carcinoma mamário invasivo tipo não especial", "Carcinoma lobular invasivo clássico", "Carcinoma lobular invasivo pleomórfico", "Carcinoma metaplásico", "Carcinoma mucinoso", "Carcinoma tubular", "Carcinoma micropapilífero", "Carcinoma de células altas com polaridade reversa", "Adenocarcinoma apócrino", "Carcinoma papilífero sólido com áreas de invasão", "Cistadenocarcinoma mucinoso", "Carcinoma cribriforme"])

    g.AddText("x35 y+35 w110", "Grau Nuclear:")
    ddlGrauN := g.AddDropDownList("x140 yp-3 w60 Choose2", ["1", "2", "3"])

    g.AddText("x220 yp+3", "Tubular (Escore):")
    ddlTub := g.AddDropDownList("x320 yp-3 w250 Choose2", ["1 (mais de 75% de formação tubular)", "2 (de 10% a 75% de formação tubular)", "3 (menos de 10% de formação tubular)"])
    
    g.AddText("x35 y+35 w110", "Nº de Mitoses:")
    edtMitVal := g.AddEdit("x140 yp-3 w60", "") 
    g.AddText("x210 yp+3 cGray", "(Calcula escore automaticamente para área de 1,96mm²)")

    ; --- 2. EXTENSÃO E INVASÕES ---
    g.AddGroupBox("xm y+25 w760 h150", "Extensão e Invasões")
    g.AddText("xp+15 yp+30 w110", "Dimensão (mm):")
    edtDim1 := g.AddEdit("x140 yp-3 w50", ""), g.AddText("x195 yp+3", "x"), edtDim2 := g.AddEdit("x210 yp-3 w50", ""), g.AddText("x265 yp+3", "mm")

    g.AddText("x310 yp+3", "Multifocalidade:")
    ddlMulti := g.AddDropDownList("x410 yp-3 w120 Choose2", ["presente", "não detectada"])
    g.AddText("x540 yp+3", "Multicentricidade:")
    ddlCentri := g.AddDropDownList("x650 yp-3 w95 Choose2", ["presente", "não detectada"])

    g.AddText("x35 y+35 w110", "Necrose:")
    ddlNec := g.AddDropDownList("x140 yp-3 w150 Choose1", ["não detectada", "presente, focal", "presente, extensa"])
    g.AddText("x310 yp+3", "Reação Desmo.:")
    ddlDesmo := g.AddDropDownList("x410 yp-3 w120 Choose2", ["leve", "moderada", "intensa"])

    g.AddText("x35 y+35 w110", "Invasões (S/L/P):")
    ddlVascS := g.AddDropDownList("x140 yp-3 w80 Choose2", ["S(+)","S(-)"])
    ddlVascL := g.AddDropDownList("x+5 w80 Choose2", ["L(+)","L(-)"])
    ddlNeural := g.AddDropDownList("x+5 w80 Choose2", ["P(+)","P(-)"])

    g.AddText("x400 yp+3", "TILS (%):")
    edtInfPerc := g.AddEdit("x520 yp-3 w40", ""), g.AddText("x+5 yp+3", "%")
    ddlInfGrau := g.AddDropDownList("x+5 yp-3 w140 Choose1", ["leve (até 10%)", "moderado (entre 10% e 60%)", "intenso (mais de 60%)"])

    ; --- 3. COMPONENTE IN SITU (CIS) ---
    g.AddGroupBox("xm y+25 w760 h155", "Componente In Situ Associado")
    cb_InSitu := g.AddCheckbox("xp+15 yp+25", "Presente")
    ddlCISTipo := g.AddDropDownList("x140 yp-3 w80 Choose1", ["ductal", "lobular"])
    ddlCISPad1 := g.AddDropDownList("x+5 w105 Choose1", ["sólido", "cribriforme", "micropapilífero", "papilífero", "comedocarcinoma"])
    ddlCISPad2 := g.AddDropDownList("x+5 w105 Choose2", ["sólido", "cribriforme", "micropapilífero", "papilífero", "comedocarcinoma"])
    g.AddText("x+5 yp+3", "Grau:")
    ddlCISNuc := g.AddDropDownList("x+5 yp-3 w45 Choose2", ["I", "II", "III"])
    
    g.AddText("x35 y+35", "Necrose CIS:")
    ddlCISNec := g.AddDropDownList("x140 yp-3 w160 Choose1", ["sem necrose", "com necrose punctata", "com comedonecrose"])
    g.AddText("x+10 yp+3", "Microcalcificações:")
    ddlCISCalc := g.AddDropDownList("x+5 yp-3 w80 Choose2", ["com", "sem"])
    g.AddText("x+10 yp+3", "% da lesão:")
    edtCISPerc := g.AddEdit("x+5 yp-3 w40", "")

    g.AddText("x35 y+35", "Localização:")
    ddlCISLoc := g.AddDropDownList("x140 yp-3 w320 Choose1", ["presente em meio à neoplasia invasiva", "presente em focos dispersos por toda a mama"])
    g.AddText("x+10 yp+3", "Maior foco (mm):")
    edtCISDim := g.AddEdit("x+5 yp-3 w50", "")

    ; --- 4. PELE, MAMILO E ADJACENTE ---
    g.AddGroupBox("xm y+25 w760 h140", "Pele, Mamilo e Adjacente")
    g.AddText("xp+15 yp+30 w110", "Pele:")
    ddlPele := g.AddDropDownList("x140 yp-3 w605 Choose1", ["livre de neoplasia, dentro dos limites histológicos da normalidade", "infiltração da derme por carcinoma mamário", "êmbolos dérmicos de carcinoma mamário (“linfangite carcinomatosa”)", "ulceração de epiderme por carcinoma mamário", "infiltração da derme por carcinoma mamário, com formação de nódulos subcutâneos", "fibrose dérmica de padrão cicatricial"])

    g.AddText("x35 y+35 w110", "Mamilo:")
    ddlMamilo := g.AddDropDownList("x140 yp-3 w605 Choose1", ["livre de neoplasia, dentro dos limites histológicos da normalidade", "infiltração por carcinoma mamário sem doença de Paget", "infiltração por carcinoma mamário com doença de Paget"])

    cb_Ade := g.AddCheckbox("x140 y+15", "Adenose simples")
    cb_Lip := g.AddCheckbox("x+20", "Lipossubstituição")
    cb_FibE := g.AddCheckbox("x+20", "Fibrose estromal")

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r10 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()

    lista_Change := [ddlTipo, ddlGrauN, ddlTub, edtMitVal, edtDim1, edtDim2, ddlMulti, ddlCentri, ddlNec, ddlDesmo, ddlVascS, ddlVascL, ddlNeural, edtInfPerc, ddlInfGrau, ddlCISTipo, ddlCISPad1, ddlCISPad2, ddlCISNuc, ddlCISNec, ddlCISCalc, edtCISPerc, ddlCISLoc, edtCISDim, ddlPele, ddlMamilo]
    for ctrl in lista_Change
        ctrl.OnEvent("Change", UpdatePreview)

    lista_Click := [cb_InSitu, cb_Ade, cb_Lip, cb_FibE]
    for cb in lista_Click
        cb.OnEvent("Click", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))

    g.Show()
    UpdatePreview()

    Build() {
        ; 1. Lógica Automática de Mitoses
        numMit := (edtMitVal.Value != "" && IsNumber(edtMitVal.Value)) ? Integer(edtMitVal.Value) : 0
        valMit := (numMit <= 7) ? 1 : (numMit <= 14) ? 2 : 3
        txtMit := (valMit == 1) ? "0 a 7 mitoses" : (valMit == 2) ? "8 a 14 mitoses" : "15 ou mais mitoses"

        ; 2. Lógica Automática de Nottingham
        valTub := Integer(SubStr(ddlTub.Text, 1, 1))
        valNuc := Integer(ddlGrauN.Text)
        soma := valTub + valNuc + valMit
        grauFinal := (soma <= 5) ? "1" : (soma <= 7) ? "2" : "3"

        res := ddlTipo.Text " - OMS 2019`r`n"
        res .= ". Grau histológico: grau " grauFinal " de S. B. R. modificado`r`n"
        res .= "- Grau nuclear: " valNuc "`r`n"
        res .= "- Formação tubular: escore " valTub " (" SubStr(ddlTub.Text, 4) ")`r`n"
        res .= "- Índice mitótico: escore " valMit " (" txtMit ") - " numMit " mitoses por 10 CGA – área de 1,96mm²`r`n"
        res .= ". Dimensão da neoplasia invasiva: " (edtDim1.Value || "[]") " x " (edtDim2.Value || "[]") " mm`r`n"
        res .= ". Multifocalidade: " ddlMulti.Text "`r`n"
        res .= ". Multicentricidade: " ddlCentri.Text "`r`n"
        res .= ". Necrose: " ddlNec.Text "`r`n"
        res .= ". Reação desmoplásica: " ddlDesmo.Text "`r`n"
        res .= ". Infiltrado inflamatório no estroma tumoral (TILS): " (edtInfPerc.Value || "[]") "% da superfície invasiva tumoral recoberta por infiltrado inflamatório - " ddlInfGrau.Text "`r`n"
        res .= ". Invasão vascular sangüínea: " (ddlVascS.Text = "S(+)" ? "presente" : "não detectada") "`r`n"
        res .= ". Invasão vascular linfática: " (ddlVascL.Text = "L(+)" ? "presente" : "não detectada") "`r`n"
        res .= ". Invasão perineural: " (ddlNeural.Text = "P(+)" ? "presente" : "não detectada") "`r`n"

        if cb_InSitu.Value {
            locStr := ddlCISLoc.Text
            if (ddlCISLoc.Value == 1) 
                locStr := "presente em meio à neoplasia invasiva, representando cerca de " (edtCISPerc.Value || "{}") "% do total da lesão"
            
            res .= "`r`nCarcinoma " ddlCISTipo.Text " in situ associado, tipos " ddlCISPad1.Text " e " ddlCISPad2.Text ", grau nuclear " ddlCISNuc.Text ", " ddlCISNec.Text ", " ddlCISCalc.Text " microcalcificações, " locStr "`r`n"
            res .= ". Dimensão do maior foco: " (edtCISDim.Value || "[]") " mm`r`n"
        }

        res .= "`r`nParênquima mamário não neoplásico:`r`n"
        if cb_Ade.Value
            res .= ". Adenose simples`r`n"
        if cb_Lip.Value
            res .= ". Lipossubstituição do parênquima mamário`r`n"
        if cb_FibE.Value
            res .= ". Fibrose estromal`r`n"

        res .= "`r`nPele: " ddlPele.Text "`r`n"
        res .= "Mamilo: " ddlMamilo.Text
        return res
    }
}