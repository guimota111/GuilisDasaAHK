; =========================================================
; Imuno-histoquímica — Pulmão (HER2)
; Arquivo: scripts\ihqpulmao.ahk
; =========================================================

Mask_IhqPulmao() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — IHQ Pulmão (HER2)")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. SELEÇÕES ---
    g.AddGroupBox("w760 h100", "Parâmetros do Exame")

    g.AddText("xp+15 yp+30 w110", "Interpretação:")
    ddlPresenca := g.AddDropDownList("x140 yp-3 w150 Choose2 +Tabstop", ["presença", "ausência"])

    g.AddText("x300 yp+3 w60", "Escore:")
    ddlEscore := g.AddDropDownList("x360 yp-3 w100 Choose1 +Tabstop", ["0", "1+", "2+", "3+"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo (Role para ver tudo):")
    edtPrev := g.AddEdit("r12 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlPresenca, ddlEscore]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        ; Cabeçalho dinâmico baseado no seu modelo
        res := "O perfil imuno-histoquímico revela " ddlPresenca.Text " de hiperexpressão da proteína do gene HER2 (Escore " ddlEscore.Text ")`r`n"

        ; Texto Fixo: Tabelas de Interpretação Pulmonar
        res .= "`nSistema de interpretação imunohistoquímica da proteína HER2 nas biópsias pulmonares`r`n"
        res .= "Escore 0 (Negativo): Nenhuma coloração é observada nas células neoplásicas invasivas.`r`n"
        res .= "Escore 1+ (Negativo): Agrupamentos de células neoplásicas* com coloração fraca e minimamente perceptível da membrana independentemente da quantidade de células coradas`r`n"
        res .= "Escore 2+ (Duvidoso): Agrupamentos de células neoplásicas* com coloração fraca a moderada, completa/basolateral ou lateral da membrana independentemente da quantidade de células coradas`r`n"
        res .= "Escore 3+ (Positivo): Agrupamentos de células neoplásicas* com coloração forte, completa/basolateral ou lateral da membrana independentemente da quantidade de células coradas`r`n"
        res .= "* Grupos de células neoplásicas consistindo de agrupamentos de 5 ou mais células neoplásicas`r`n"

        res .= "`nSistema de interpretação imunohistoquímica da proteína HER2 nas ressecções pulmonares`r`n"
        res .= "Escore 0 (Negativo): Nenhuma coloração é observada ou coloração fraca de membrana em menos de 10% das células neoplásicas invasivas`r`n"
        res .= "Escore 1+ (Negativo): Coloração fraca e minimamente perceptível da membrana em 10% ou mais das células neoplásicas. As células são reativas apenas em parte da sua membrana`r`n"
        res .= "Escore 2+ (Duvidoso): Coloração fraca a moderada, completa/basolateral ou lateral da membrana, em 10% ou mais das células neoplásicas`r`n"
        res .= "Escore 3+ (Positivo): Coloração forte, completa/basolateral ou lateral da membrana em 10% ou mais das células neoplásicas`r`n"

        ; Referências Bibliográficas
        res .= "`n`nReferências bibliográficas:`r`n"
        res .= "1. Ren S, Wang J, Ying J, Mitsudomi T, Lee DH, Wang Z, Chu Q, Mack PC, Cheng Y, Duan J, Fan Y, Han B, Hui Z, Liu A, Liu J, Lu Y, Ma Z, Shi M, Shu Y, Song Q, Song X, Song Y, Wang C, Wang X, Wang Z, Xu Y, Yao Y, Zhang L, Zhao M, Zhu B, Zhang J, Zhou C, Hirsch FR. Consensus for HER2 alterations testing in non-small-cell lung cancer. ESMO Open. 2022 Feb;7(1):100395.`r`n"
        res .= "2. Li, Bob T. et al. Trastuzumab deruxtecan in HER2-mutant non–small-cell lung cancer. New England Journal of Medicine, v. 386, n. 3, p. 241-251, 2022.`r`n"
        res .= "3. Angela N. Bartley et al. HER2 Testing and Clinical Decision Making in Gastroesophageal Adenocarcinoma: Guideline From the College of American Pathologists, American Society for Clinical Pathology, and the American Society of Clinical Oncology. JCO 35, 446-464, 2017."

        return res
    }
}