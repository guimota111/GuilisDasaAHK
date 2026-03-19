; =========================================================
; Imuno-histoquímica — Estômago (HER2 e Reparo de DNA)
; Arquivo: scripts\ihqestomago.ahk
; =========================================================

Mask_IhqEstomago() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — IHQ Estômago")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. SELEÇÕES ---
    g.AddGroupBox("w760 h120", "Parâmetros do Exame")

    g.AddText("xp+15 yp+30 w110", "Proteína HER2:")
    ddlHer2 := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", [
        "presença de",
        "ausência de",
        "resultado duvidoso (Escore 2+) para"
    ])

    g.AddText("x35 y+40 w110", "Proteínas Reparo:")
    ddlMMR := g.AddDropDownList("x140 yp-3 w605 Choose3 +Tabstop", [
        "perda de expressão das proteínas dos genes MLH-1 e PMS-2",
        "perda de expressão das proteínas dos genes MSH-2 e MSH-6",
        "expressão preservada das proteínas dos genes de reparo do DNA",
        "perda de expressão da proteína do gene PMS-2",
        "perda de expressão da proteína do gene MSH-6"
    ])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo (Role para ver tudo):")
    edtPrev := g.AddEdit("r12 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlHer2, ddlMMR]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        ; Cabeçalho dinâmico
        res := "O perfil imuno-histoquímico revela " ddlHer2.Text " hiperexpressão da proteína do gene HER2 e " ddlMMR.Text ".`r`n"

        ; Texto Fixo: Tabelas HER2
        res .= "`n`nSistema de interpretação imunohistoquímica da proteína HER2 nas biópsias gástricas`r`n"
        res .= "Escore 0 (Negativo) Nenhuma coloração é observada nas células neoplásicas invasivas.`r`n"
        res .= "Escore 1+ (Negativo) Agrupamentos de células neoplásicas* com coloração fraca e minimamente perceptível da membrana independentemente da quantidade de células coradas`r`n"
        res .= "Escore 2+ (Duvidoso) Agrupamentos de células neoplásicas* com coloração fraca a moderada, completa/basolateral ou lateral da membrana independentemente da quantidade de células coradas`r`n"
        res .= "Escore 3+ (Positivo) Agrupamentos de células neoplásicas* com coloração forte, completa/basolateral ou lateral da membrana independentemente da quantidade de células coradas`r`n"
        res .= "* Grupos de células neoplásicas consistindo de agrupamentos de 5 ou mais células neoplásicas`r`n"
        res .= "Sistema de interpretação imunohistoquímica da proteína HER2 nas gastrectomias`r`n"
        res .= "Escore 0 (Negativo) Nenhuma coloração é observada ou coloração fraca de membrana em menos de 10% das células neoplásicas invasivas`r`n"
        res .= "Escore 1+ (Negativo) Coloração fraca e minimamente perceptível da membrana em 10% ou mais das células neoplásicas. As células são reativas apenas em parte da sua membrana`r`n"
        res .= "Escore 2+ (Duvidoso) Coloração fraca a moderada, completa/basolateral ou lateral da membrana, em 10% ou mais das células neoplásicas`r`n"
        res .= "Escore 3+ (Positivo) Coloração forte, completa/basolateral ou lateral da membrana em 10% ou mais das células neoplásicas`r`n`n`n"

		res .= "Imuno-histoquímica sugere status MSS:**`nMLH1(+) PMS2(+) MSH2(+) MSH6(+)`n`nImuno-histoquímica sugere status MSI*. Alta probabilidade de síndrome de Lynch`nMLH1(+) PMS2(+) MSH2(-) MSH6(-)`n`nImuno-histoquímica sugere status MSI*. Alta probabilidade de síndrome de Lynch`nMLH1(+) PMS2(+) MSH2(+) MSH6(-)`n`nImunohistoquímica sugere status MSI*. Alta probabilidade de síndrome de Lynch`nMLH1(+) PMS2(-) MSH2(+) MSH6(-)`n`n*MSI: Alta probabilidade de instabilidade de microssatélites **MSS: Estabilidade de microssatélites`n`nReferências Bibliográficas:`n`n1. Hofmann M, Stoss O, Shi D, et al. Assessment of a HER2 scoring system for gastric cancer: results from a validation study. Histopathology. 2008;52:797-805.`n2. Angela N. Bartley et al. HER2 Testing and Clinical Decision Making in Gastroesophageal Adenocarcinoma: Guideline From the College of American Pathologists, American Society for Clinical Pathology, and the American Society of Clinical Oncology. JCO 35, 446-464 (2017).`n3. Shi C, Badgwell BD, Grabsch HI, Gibson MK, Hong SM, Kumarasinghe P, Lam AK, Lauwers G, O'Donovan M, van der Post RS, Tang L, Ushiku T, Vieth M, Selinger CI, Webster F, Nagtegaal ID. Data Set for Reporting Carcinoma of the Stomach in Gastrectomy. Arch Pathol Lab Med. 2021"

        return res
    }
}