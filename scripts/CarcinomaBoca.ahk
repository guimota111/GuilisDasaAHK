; =========================================================
; Cabeça e Pescoço — Carcinoma de Cavidade Oral (Boca)
; Arquivo: scripts\CarcinomaBoca.ahk
; =========================================================

Mask_CarcinomaBoca() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Carcinoma de Boca")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. TIPO E DIFERENCIAÇÃO ---
    g.AddGroupBox("w760 h110", "Classificação Histológica")
    g.AddText("xp+15 yp+30 w110", "Tipo de Tumor:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", [
        "Carcinoma de células escamosas convencional ceratinizante (OMS 2017)",
        "Carcinoma de células escamosas acantolítico (OMS 2017)",
        "Carcinoma adenoescamoso (OMS 2017)",
        "Carcinoma de células escamosas basaloide (OMS 2017)",
        "Carcinoma cuniculatum (OMS 2017)",
        "Carcinoma de células escamosas papilar (OMS 2017)",
        "Carcinoma de células escamosas de células fusiformes (OMS 2017)",
        "Carcinoma de células escamosas verrucoso (OMS 2017)",
        "Carcinoma linfoepitelial (OMS 2017)",
        "Carcinoma mucoepidermoide (OMS 2017)",
        "Carcinoma adenoide cístico (OMS 2017)",
        "Adenocarcinoma polimórfico (OMS 2017)"])

    g.AddText("x35 y+15 w110", "Diferenciação:")
    ddlDif := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["bem diferenciado", "moderadamente diferenciado", "pouco diferenciado"])

    g.AddText("x400 yp+3 w340", "(Para Muco/Adeno/Polim, especificar grau/padrão nas notas)")

    ; --- 2. DIMENSÕES E PADRÃO ---
    g.AddGroupBox("xm y+25 w760 h120", "Dimensões e Infiltração")
    g.AddText("xp+15 yp+30 w110", "Extensão Lat. (cm):")
    edtDim1 := g.AddEdit("x140 yp-3 w60 +Tabstop"), g.AddText("x205 yp+3", "x"), edtDim2 := g.AddEdit("x220 yp-3 w60 +Tabstop")

    g.AddText("x400 yp+0 w110", "Profundidade (DOI):")
    edtDOI := g.AddEdit("x520 yp-3 w60 +Tabstop"), g.AddText("x585 yp+3", "mm")

    g.AddText("x35 y+15 w110", "Padrão (WPOA):")
    ddlPadrao := g.AddDropDownList("x140 yp-3 w620 Choose1 +Tabstop", [
        "Tipo 1: fronte de invasão expansivo largo",
        "Tipo 2: fronte de invasão expansivo com projeções digitiformes",
        "Tipo 3: blocos com mais de 15 células na periferia do tumor",
        "Tipo 4: células isoladas, cordões ou blocos com menos de 15 células na periferia do tumor",
        "Tipo 5: nódulos satélites separados por 1 mm ou mais de tecido normal",
        "Tipo 5: invasão perineural extratumoral",
        "Tipo 5: invasão vascular extratumoral"])

    ; --- 3. INFILTRAÇÃO DE ESTRUTURAS ---
    g.AddGroupBox("xm y+25 w760 h110", "Infiltração de Estruturas")
    g.AddText("xp+15 yp+30 w110", "Músc. Esquelética:")
    ddlMusc := g.AddDropDownList("x140 yp-3 w130 Choose1 +Tabstop", ["não detectada", "presente, superficial", "presente, extensa"])

    g.AddText("x290 yp+3 w80", "Ossea:")
    ddlOssea := g.AddDropDownList("x345 yp-3 w130 Choose1 +Tabstop", ["não detectada", "presente, superficial", "presente, extensa"])

    g.AddText("x495 yp+3 w110", "Gls. Salivares:")
    ddlSaliv := g.AddDropDownList("x590 yp-3 w160 Choose1 +Tabstop", ["não detectada", "presente"])

    ; --- 4. ESTROMA E INVASÕES ---
    g.AddGroupBox("xm y+25 w760 h180", "Estroma e Invasões")
    g.AddText("xp+15 yp+35 w110", "Reação Desmoplas.:")
    ddlDesmo := g.AddDropDownList("x140 yp-3 w140 Choose1 +Tabstop", ["não detectada", "leve", "moderada", "intensa"])

    g.AddText("x400 yp+3 w110", "Infil. Inflamat.:")
    ddlInflam := g.AddDropDownList("x520 yp-3 w140 Choose1 +Tabstop", ["não detectado", "leve", "moderado/intenso"])

    g.AddText("x35 y+15 w110", "Inv. Vasc (L/S):")
    ddlVascL := g.AddDropDownList("x140 yp-3 w140 Choose2 +Tabstop", ["L: presente", "L: não detectada"])
    ddlVascS := g.AddDropDownList("x+10 w140 Choose2 +Tabstop", ["S: presente", "S: não detectada"])

    g.AddText("x35 y+15 w110", "Invasão Neural:")
    ddlNeural := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["não detectada", "presente, tipo perineural", "presente, tipo intraneural"])
    g.AddText("x400 yp+3 w110", "Diâm. Nervo:")
    edtNervo := g.AddEdit("x520 yp-3 w60 +Tabstop"), g.AddText("x585 yp+3", "mm")

    g.AddText("x35 y+15 w110", "Comp. In Situ:")
    ddlInSitu := g.AddDropDownList("x140 yp-3 w240 Choose2 +Tabstop", ["presente", "não detectado"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w760 r10 ReadOnly -Wrap")
    edtPrev := g.AddEdit("r15 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()
    controles := [ddlTipo, ddlDif, edtDim1, edtDim2, edtDOI, ddlPadrao, ddlMusc, ddlOssea, ddlSaliv, ddlDesmo, ddlInflam, ddlVascL, ddlVascS, ddlNeural, edtNervo, ddlInSitu]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlTipo.Focus()
    UpdatePreview()

    Build() {
        res := ddlTipo.Text ", " ddlDif.Text ".`n"
        res .= ". Dimensões da neoplasia:`n"
        res .= "  - Extensão lateral: " (edtDim1.Value || "[]") " x " (edtDim2.Value || "[]") " cm.`n"
        res .= "  - Profundidade máxima da infiltração (espessura da lesão): " (edtDOI.Value || "[]") " mm.`n"
        res .= ". Padrão de infiltração: " ddlPadrao.Text ".`n"
        res .= ". Infiltração de musculatura esquelética: " ddlMusc.Text ".`n"
        res .= ". Infiltração óssea: " ddlOssea.Text ".`n"
        res .= ". Infiltração de glândulas salivares menores: " ddlSaliv.Text ".`n"
        res .= ". Reação desmoplásica intratumoral: " ddlDesmo.Text ".`n"
        res .= ". Infiltrado inflamatório associado ao tumor: " ddlInflam.Text ".`n"

        vL := (ddlVascL.Text == "L: presente") ? "presente" : "não detectada"
        res .= ". Invasão vascular linfática: " vL ".`n"
        vS := (ddlVascS.Text == "S: presente") ? "presente" : "não detectada"
        res .= ". Invasão vascular sanguínea: " vS ".`n"

        res .= ". Invasão neural: " ddlNeural.Text ".`n"
        res .= "  - Diâmetro do maior nervo comprometido: " (edtNervo.Value || "[]") " mm.`n"
        res .= "Componente in situ associado: " ddlInSitu.Text "."
        return res
    }
}