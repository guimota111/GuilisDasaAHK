; =========================================================
; Mastopatologia — Biópsia de Fragmento (Core Biopsy)
; Arquivo: scripts\MamaBiopsiaTumor.ahk
; =========================================================

Mask_MamaBiopsiaTumor() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Mama: Biópsia de Tumor")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. TIPO E GRADUAÇÃO ---
    g.AddGroupBox("w760 h160", "Classificação e Escoragem de Nottingham")
    g.AddText("xp+15 yp+30 w110", "Tipo Histológico:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w605 Choose1", ["Carcinoma mamário invasivo tipo não especial", "Carcinoma lobular invasivo clássico", "Carcinoma lobular invasivo pleomórfico", "Carcinoma metaplásico", "Carcinoma mucinoso", "Carcinoma tubular", "Carcinoma micropapilífero", "Carcinoma de células altas com polaridade reversa", "Adenocarcinoma apócrino", "Carcinoma papilífero sólido com áreas de invasão", "Cistadenocarcinoma mucinoso", "Carcinoma cribriforme"])

    g.AddText("x35 y+35 w110", "Grau Nuclear:")
    ddlGrauN := g.AddDropDownList("x140 yp-3 w60 Choose2", ["1", "2", "3"])

    g.AddText("x220 yp+3 w110", "Arquitetural (Tub):")
    ddlTub := g.AddDropDownList("x330 yp-3 w415 Choose2", ["1 (mais de 75% de formação tubular)", "2 (de 10% a 75% de formação tubular)", "3 (menos de 10% de formação tubular)"])

    g.AddText("x35 y+35 w110", "Nº de Mitoses:")
    edtMitVal := g.AddEdit("x140 yp-3 w60", "0")
    g.AddText("x210 yp+3", "O escore mitótico e o grau final serão calculados automaticamente no laudo.")

    ; --- 2. ESTROMA E INVASÕES ---
    g.AddGroupBox("xm y+25 w760 h150", "Estroma e Invasões")
    g.AddText("xp+15 yp+30 w110", "Necrose:")
    ddlNec := g.AddDropDownList("x140 yp-3 w150 Choose1", ["não detectada", "presente, focal", "presente, extensa"])
    g.AddText("x310 yp+3", "Reação Desmo.:")
    ddlDesmo := g.AddDropDownList("x410 yp-3 w120 Choose2", ["leve", "moderada", "intensa"])

    g.AddText("x35 y+35 w110", "Inflamação (%):")
    edtInfPerc := g.AddEdit("x140 yp-3 w50", "0")
    ddlInfGrau := g.AddDropDownList("x230 yp-3 w515 Choose1", ["leve (até 10% da superfície invasiva tumoral recoberta por infiltrado inflamatório)", "moderado (entre 10% e 60% da superfície invasiva tumoral recoberta por infiltrado inflamatório)", "intenso (mais de 60% da superfície invasiva tumoral recoberta por infiltrado inflamatório)"])

    g.AddText("x35 y+35", "Vasc. Sanguínea:")
    ddlVascS := g.AddDropDownList("x140 yp-3 w100 Choose2", ["presente", "não detectada"])
    g.AddText("x255 yp+3", "Vasc. Linfática:")
    ddlVascL := g.AddDropDownList("x350 yp-3 w100 Choose2", ["presente", "não detectada"])
    g.AddText("x465 yp+3", "Perineural:")
    ddlNeural := g.AddDropDownList("x540 yp-3 w100 Choose2", ["presente", "não detectada"])

    ; --- 3. COMPONENTE IN SITU ---
    g.AddGroupBox("xm y+25 w760 h110", "Carcinoma In Situ Associado")
    chkCIS := g.AddCheckbox("xp+15 yp+30 vHasCIS", "Presente (se desmarcado, aparecerá 'não detectado')")
    ddlCISTipo1 := g.AddDropDownList("x140 yp-3 w100 Choose1", ["ductal", "lobular"])
    ddlCISPad1 := g.AddDropDownList("x+5 w100 Choose1", ["sólido", "cribriforme", "micropapilífero", "papilífero", "comedocarcinoma"])
    ddlCISPad2 := g.AddDropDownList("x+5 w100 Choose2", ["sólido", "cribriforme", "micropapilífero", "papilífero", "comedocarcinoma"])
    g.AddText("x+10 yp+3", "Grau Nuc:")
    ddlCISNuc := g.AddDropDownList("x+5 yp-3 w50 Choose2", ["I", "II", "III"])

    g.AddText("x35 y+35", "Necrose:")
    ddlCISNec := g.AddDropDownList("x140 yp-3 w140 Choose1", ["sem necrose", "com necrose punctata", "com comedonecrose"])
    chkCalc := g.AddCheckbox("x295 yp+3", "Microcalcificações")
    g.AddText("x430 yp+0", "% da Lesão:")
    edtCISPerc := g.AddEdit("x510 yp-3 w50", "")

    ; --- 4. NOTAS ---
    g.AddGroupBox("xm y+25 w760 h80", "Notas e Dimensões")
    g.AddText("xp+15 yp+30", "Soma das medidas (mm):")
    edtSoma := g.AddEdit("x160 yp-3 w60", "")
    ddlFid := g.AddDropDownList("x230 yp-3 w410 Choose1", ["representa de maneira fidedigna", "pode não representar de maneira fidedigna"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r10 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE ATUALIZAÇÃO AUTOMÁTICA ---
    UpdatePreview(*) {
        ; 1. Lógica do Infiltrado Inflamatório (TILS) automática
        if IsNumber(edtInfPerc.Value) {
            infPerc := edtInfPerc.Value
            if (infPerc <= 10)
                ddlInfGrau.Choose(1)
            else if (infPerc <= 60)
                ddlInfGrau.Choose(2)
            else
                ddlInfGrau.Choose(3)
        }
        edtPrev.Value := Build()
    }

    ; --- REGISTRO DE EVENTOS (OBRIGATÓRIO PARA ABRIR E FUNCIONAR) ---
    controles_change := [ddlTipo, ddlGrauN, ddlTub, edtMitVal, ddlNec, ddlDesmo, edtInfPerc, ddlInfGrau, ddlVascS, ddlVascL, ddlNeural, ddlCISTipo1, ddlCISPad1, ddlCISPad2, ddlCISNuc, ddlCISNec, edtCISPerc, edtSoma, ddlFid]
    controles_click := [chkCIS, chkCalc]

    for c in controles_change
        c.OnEvent("Change", UpdatePreview)
    for c in controles_click
        c.OnEvent("Click", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        mitVal := IsNumber(edtMitVal.Value) ? edtMitVal.Value : 0
        escM := (mitVal <= 7) ? 1 : (mitVal <= 14) ? 2 : 3
        descM := (escM = 1) ? "1 (0 a 7 mitoses)" : (escM = 2) ? "2 (8 a 14 mitoses)" : "3 (15 ou mais mitoses)"

        soma := ddlGrauN.Value + ddlTub.Value + escM
        grauF := (soma <= 5) ? 1 : (soma <= 7) ? 2 : 3

        res := ddlTipo.Text " - OMS 2019`r`n"
        res .= ". Grau histológico: grau " grauF " de S. B. R. modificado`r`n"
        res .= "  - Grau nuclear: " ddlGrauN.Text "`r`n"
        res .= "  - Formação tubular: escore " ddlTub.Text "`r`n"
        res .= "  - Índice mitótico: escore " descM " - " mitVal " mitoses por 10 campos de grande aumento – área de 1,96mm²`r`n"
        res .= ". Necrose: " ddlNec.Text "`r`n"
        res .= ". Reação desmoplásica: " ddlDesmo.Text "`r`n"
        res .= ". Infiltrado inflamatório no estroma tumoral: " (edtInfPerc.Value || "0") "% da superfície invasiva tumoral recoberta por infiltrado inflamatório - " ddlInfGrau.Text "`r`n"
        res .= ". Invasão vascular sanguínea: " ddlVascS.Text "`r`n"
        res .= ". Invasão vascular linfática: " ddlVascL.Text "`r`n"
        res .= ". Invasão perineural: " ddlNeural.Text "`r`n`n"

        if chkCIS.Value {
            res .= "Carcinoma " ddlCISTipo1.Text " in situ associado, tipos " ddlCISPad1.Text " e " ddlCISPad2.Text ", grau nuclear " ddlCISNuc.Text ", " ddlCISNec.Text ", " (chkCalc.Value ? "com" : "sem") " microcalcificações, presente em meio à neoplasia invasiva, representando cerca de " (edtCISPerc.Value || "0") "% do total da lesão`r`n"
        } else {
            res .= "Carcinoma in situ não detectado.`r`n"
        }

        res .= "`r`nNotas:`r`n"
        res .= "1. O somatório das medidas lineares da neoplasia presente nos fragmentos é de " (edtSoma.Value || "[]") " mm. Tal dimensão " ddlFid.Text " a totalidade da neoplasia.`r`n"
        res .= "2. É necessária a realização de estudo imuno-histoquímico para a pesquisa de fatores preditivos e prognósticos da neoplasia."
        return res
    }
}