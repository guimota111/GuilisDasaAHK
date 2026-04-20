; =========================================================
; Mastopatologia — Pós-Quimioterapia (Residual / RCB)
; Arquivo: scripts\MamaTumorQT.ahk
; =========================================================

Mask_MamaTumorQT() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Mama: Pós-QT (Residual)")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. TIPO E GRADUAÇÃO ---
    g.AddGroupBox("w760 h190", "Classificação e Nottingham (Residual)")
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

    ; --- 2. LEITO E RCB ---
    g.AddGroupBox("xm y+25 w760 h110", "Dimensões (Leito Tumoral e RCB)")
    g.AddText("xp+15 yp+30 w110", "Leito Macros (mm):")
    edtLeito1 := g.AddEdit("x140 yp-3 w50", ""), g.AddText("x195 yp+3", "x"), edtLeito2 := g.AddEdit("x210 yp-3 w50", ""), g.AddText("x265 yp+3", "mm")

    g.AddText("x35 y+35 w110", "RCB Micros (mm):")
    edtRCB1 := g.AddEdit("x140 yp-3 w50", ""), g.AddText("x195 yp+3", "x"), edtRCB2 := g.AddEdit("x210 yp-3 w50", ""), g.AddText("x265 yp+3", "mm")

    g.AddText("x310 y+12", "Multifocalidade:")
    ddlMulti := g.AddDropDownList("x410 yp-3 w120 Choose2", ["presente", "não detectada"])

    ; --- 3. ESTROMA E INVASÕES ---
    g.AddGroupBox("xm y+25 w760 h120", "Estroma e Invasões")
    g.AddText("xp+15 yp+30 w110", "Necrose:")
    ddlNec := g.AddDropDownList("x140 yp-3 w150 Choose1", ["não detectada", "presente, focal", "presente, extensa"])
    g.AddText("x310 yp+3", "Reação Desmo.:")
    ddlDesmo := g.AddDropDownList("x410 yp-3 w120 Choose2", ["leve", "moderada", "intensa"])

    g.AddText("x35 y+35 w110", "Invasões (V/L/P):")
    ddlVascS := g.AddDropDownList("x140 yp-3 w80 Choose2", ["S(+)","S(-)"])
    ddlVascL := g.AddDropDownList("x+5 w80 Choose2", ["L(+)","L(-)"])
    ddlNeural := g.AddDropDownList("x+5 w80 Choose2", ["P(+)","P(-)"])

    g.AddText("x400 yp+3", "TILS (%):")
    edtInfPerc := g.AddEdit("x520 yp-3 w40", ""), g.AddText("x+5 yp+3", "%")
    ddlInfGrau := g.AddDropDownList("x+5 yp-3 w140 Choose1", ["leve (até 10%)", "moderado (10-60%)", "intenso (>60%)"])

    ; --- 4. COMPONENTE IN SITU RESIDUAL ---
    g.AddGroupBox("xm y+25 w760 h110", "Carcinoma In Situ Residual")
    chkCIS := g.AddCheckbox("xp+15 yp+30 vHasCIS", "Presente")
    ddlCISTipo := g.AddDropDownList("x140 yp-3 w80 Choose1", ["ductal", "lobular"])
    ddlCISPad1 := g.AddDropDownList("x+5 w110 Choose1", ["sólido", "cribriforme", "micropapilífero", "papilífero", "comedocarcinoma"])
    ddlCISPad2 := g.AddDropDownList("x+5 w110 Choose2", ["sólido", "cribriforme", "micropapilífero", "papilífero", "comedocarcinoma"])

    g.AddText("x35 y+35", "Distribuição:")
    ddlCISLoc := g.AddDropDownList("x140 yp-3 w315 Choose1", ["presente em meio à neoplasia invasiva", "presentes em focos isolados dispersos por toda a peça cirúrgica"])
    g.AddText("x465 yp+3", "Maior foco (mm):")
    edtCISDim := g.AddEdit("x580 yp-3 w50", "")

    ; --- 5. ADJACENTE E PELE ---
    g.AddGroupBox("xm y+25 w760 h110", "Adjacente e Pele")
    chkResp := g.AddCheckbox("xp+15 yp+30 vResp Checked", "Resp. proc. prévio")
    chkAde := g.AddCheckbox("x+10 vAde", "Adenose")
    chkLip := g.AddCheckbox("x+10 vLip", "Lipossubst.")
    chkFibE := g.AddCheckbox("x+10 vFibE", "Fibrose")

    g.AddText("x35 y+35", "Pele:")
    ddlPele := g.AddDropDownList("x140 yp-3 w605 Choose1", ["livre de neoplasia, dentro dos limites histológicos da normalidade", "fibrose dérmica de padrão cicatricial"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r8 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()
    controles := [ddlTipo, ddlGrauH, ddlGrauN, ddlTub, ddlMit, edtMitVal, edtLeito1, edtLeito2, edtRCB1, edtRCB2, ddlMulti, ddlNec, ddlDesmo, ddlVascS, ddlVascL, ddlNeural, edtInfPerc, ddlInfGrau, chkCIS, ddlCISTipo, ddlCISPad1, ddlCISPad2, ddlCISLoc, edtCISDim, chkResp, chkAde, chkLip, chkFibE, ddlPele]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        res := ddlTipo.Text " - OMS 2019, residual`r`n"
        res .= ". Grau histológico: grau " ddlGrauH.Text " de S. B. R. modificado`r`n"
        res .= "- Grau nuclear: " ddlGrauN.Text "`r`n"
        res .= "- Formação tubular: escore " SubStr(ddlTub.Text, 1, 1) " (" SubStr(ddlTub.Text, 4) ")`r`n"
        res .= "- Índice mitótico: escore " SubStr(ddlMit.Text, 1, 1) " (" SubStr(ddlMit.Text, 4) ") - " (edtMitVal.Value || "[]") " mitoses por 10 campos de grande aumento – área de 1,96 mm²`r`n"
        res .= ". Dimensão macroscópica do leito tumoral: " (edtLeito1.Value || "[]") " x " (edtLeito2.Value || "[]") " mm`r`n"
        res .= ". Dimensão microscópica estimada da neoplasia invasiva residual (protocolo RCB): " (edtRCB1.Value || "[]") " x " (edtRCB2.Value || "[]") " mm`r`n"
        res .= ". Multifocalidade: " ddlMulti.Text "`r`n"
        res .= ". Necrose: " ddlNec.Text "`r`n"
        res .= ". Reação desmoplásica: " ddlDesmo.Text "`r`n"
        res .= ". Infiltrado inflamatório (TILS): " (edtInfPerc.Value || "[]") "% da superfície invasiva tumoral - " ddlInfGrau.Text "`r`n"
        res .= ". Invasão vascular sanguínea: " (ddlVascS.Text = "S(+)" ? "presente" : "não detectada") "`r`n"
        res .= ". Invasão vascular linfática: " (ddlVascL.Text = "L(+)" ? "presente" : "não detectada") "`r`n"
        res .= ". Invasão perineural: " (ddlNeural.Text = "P(+)" ? "presente" : "não detectada") "`r`n"

        if chkCIS.Value {
            res .= "Carcinoma " ddlCISTipo.Text " in situ residual associado, tipos " ddlCISPad1.Text " e " ddlCISPad2.Text ", " ddlCISLoc.Text ". Dimensão do maior foco: " (edtCISDim.Value || "[]") " mm`r`n"
        }

        ; Bloco que agora é SEMPRE incluído no laudo
        res .= "`r`nParênquima mamário não neoplásico:`r`n"
        res .= ". Fibroplasia, neovascularização e áreas de hemorragia antiga, compatível com resposta a procedimento prévio`r`n"
        res .= ". Adenose simples`r`n"
        res .= ". Lipossubstituição do parênquima mamário`r`n"
        res .= ". Fibrose estromal`r`n`r`n"

        res .= "Pele: " ddlPele.Text "."

        return res
    }
}