; =========================================================
; Mastopatologia — Protocolo RCB (Calculado)
; Arquivo: scripts\MamaProtocoloQT.ahk
; =========================================================

Mask_MamaProtocoloQT() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Mama: Protocolo RCB")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. ESTADIAMENTO ypTNM ---
    g.AddGroupBox("w760 h70", "Estadiamento Patológico (AJCC 8ª ed.)")
    g.AddText("xp+15 yp+30", "ypT:")
    edtT := g.AddEdit("x+5 yp-3 w60", "")
    g.AddText("x+20 yp+3", "ypN:")
    edtN := g.AddEdit("x+5 yp-3 w60", "")

    ; --- 2. DADOS DO LEITO E CELULARIDADE ---
    g.AddGroupBox("xm y+25 w760 h150", "Avaliação de Resposta Patológica")
    g.AddText("xp+15 yp+30 w120", "Neoplasia Residual:")
    ddlResid := g.AddDropDownList("x150 yp-3 w100 Choose1", ["presente", "ausente"])

    g.AddText("x35 y+35 w120", "Leito Macros (mm):")
    edtL1 := g.AddEdit("x150 yp-3 w50", ""), g.AddText("x+5 yp+3", "x"), edtL2 := g.AddEdit("x+5 yp-3 w50", "")

    g.AddText("x300 yp+3 w120", "Invasiva Micros (mm):")
    edtM1 := g.AddEdit("x420 yp-3 w50", ""), g.AddText("x+5 yp+3", "x"), edtM2 := g.AddEdit("x+5 yp-3 w50", "")

    g.AddText("x35 y+35 w120", "Celularidade %CMI:")
    edtCMI := g.AddEdit("x150 yp-3 w50", ""), g.AddText("x+5 yp+3", "%")

    g.AddText("x300 yp+3 w120", "Celularidade %CDIS:")
    edtCDIS := g.AddEdit("x420 yp-3 w50", ""), g.AddText("x+5 yp+3", "%")

    ; --- 3. LINFONODOS E RCB ---
    g.AddGroupBox("xm y+25 w760 h110", "Dados Linfonodais e Escore RCB")
    g.AddText("xp+15 yp+30 w120", "Linfonodos Comp.:")
    edtNComp := g.AddEdit("x150 yp-3 w50", "")

    g.AddText("x300 yp+3 w120", "Maior Metástase:")
    edtMet := g.AddEdit("x420 yp-3 w50", ""), g.AddText("x+5 yp+3", "mm")

    g.AddText("x35 y+35 w120", "Índice RCB (num):")
    edtRCBVal := g.AddEdit("x150 yp-3 w100", "")

    g.AddText("x300 yp+3 w120", "Classe RCB:")
    ddlClasse := g.AddDropDownList("x420 yp-3 w320 Choose1", [
        "pCR (resposta patológica completa)",
        "RCB-I (doença residual mínima)",
        "RCB-II (doença residual moderada)",
        "RCB-III (doença residual extensa)"
    ])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r10 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()
    controles := [edtT, edtN, ddlResid, edtL1, edtL2, edtM1, edtM2, edtCMI, edtCDIS, edtNComp, edtMet, edtRCBVal, ddlClasse]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        res := "Estadiamento patológico (pTNM AJCC 8ª edição): ypT[" (edtT.Value || "__") "] ypN[" (edtN.Value || "__") "]`r`n`r`n"
        res .= "AVALIAÇÃO DE RESPOSTA PATOLÓGICA PÓS-TRATAMENTO NEOADJUVANTE`r`n"
        res .= "Neoplasia residual microscópica: " ddlResid.Text "`r`n"
        res .= ". Dimensão macroscópica do leito tumoral primário: " (edtL1.Value || "[]") " x " (edtL2.Value || "[]") " mm`r`n"
        res .= ". Dimensão microscópica estimada da neoplasia invasiva residual: " (edtM1.Value || "[]") " x " (edtM2.Value || "[]") " mm`r`n"
        res .= ". Porcentagem da celularidade do carcinoma residual no leito tumoral (%CMI): " (edtCMI.Value || "[]") "%`r`n"
        res .= ". Porcentagem da celularidade do carcinoma `"in situ`" residual no leito tumoral (%CDIS): " (edtCDIS.Value || "[]") "%`r`n"
        res .= ". Número de linfonodos comprometidos: " (edtNComp.Value || "[]") "`r`n"
        res .= ". Maior dimensão da metástase microscópica residual: " (edtMet.Value || "[]") " mm`r`n"
        res .= ". Índice de neoplasia residual (RCB) = " (edtRCBVal.Value || "[]") "`r`n"
        res .= ". Classe de neoplasia residual: " ddlClasse.Text "`r`n`r`n"

        res .= "Referências:`r`n"
        res .= "1. http://www.mdanderson.org;breastcancer_RCB`r`n"
        res .= "2. Measurement of Residual Breast Cancer Burden to Predict Survival After Neoadjuvant Chemotherapy. W. Fraser Symmans, Florentia Peintinger, Christos Hatzis, Radhika Rajan, Henry Kuerer, Vicente Valero, Lina Assad, Anna Poniecka, Bryan Henessy, Marjorie Green, Aman U. Buzdar, S. Eva Singletary. Gabriel N. Hortobagyi, and Lajos Pusztai. Journal of Clinical Oncology. Original Report. vol 25, number 28. October 1 2007."
        return res
    }
}