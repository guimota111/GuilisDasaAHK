; =========================================================
; Imuno-histoquímica — Mama (Painel de Biomarcadores)
; Arquivo: scripts\ihqmama.ahk
; =========================================================

Mask_IhqMama() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — IHQ Mama")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. DIAGNÓSTICO E FENÓTIPO ---
    g.AddGroupBox("w760 h160", "Classificação e Imunofenótipo")

    g.AddText("xp+15 yp+30 w110", "Diagnóstico:")
    ddlDiag := g.AddDropDownList("x140 yp-3 w400 Choose1 +Tabstop", [
        "Carcinoma mamário invasivo tipo não especial", "Carcinoma lobular invasivo clássico",
        "Carcinoma lobular invasivo pleomórfico", "Carcinoma mucinoso", "Carcinoma metáplasico",
        "Adenocarcinoma apócrino", "Carcinoma micropapilífero", "Carcinoma papilífero sólido com áreas de invasão",
        "Carcinoma papilífero encapsulado (intracístico)", "Papiloma intraductal com hiperplasia ductal usual",
        "Papiloma intraductal com área de hiperplasia ductal atípica (HDA)",
        "Papiloma intraductal com área de carcinoma ductal in situ tipo {citar}", "Carcinoma ductal in situ"
    ])

    edtCitar := g.AddEdit("x550 yp w190 +Disabled +Tabstop", "especificar tipo")

    g.AddText("x35 y+40 w110", "Imunofenótipo:")
    ddlFeno := g.AddDropDownList("x140 yp-3 w600 Choose1 +Tabstop", [
        "imunofenótipo Luminal A", "imunofenótipo Luminal B", "imunofenótipo Luminal B HER2 positivo",
        "imunofenótipo Hiperexpressão de HER2", "imunofenótipo Triplo Negativo",
        "com expressão de receptores hormonais", "negativo para expressão de receptores hormonais"
    ])

    ; --- 2. HER2 DETALHADO ---
    g.AddGroupBox("xm y+40 w760 h120", "Status HER2")

    g.AddText("xp+15 yp+30 w110", "Padrão de Marcação:")
    ddlHer2Padrao := g.AddDropDownList("x140 yp-3 w450 Choose1 +Tabstop", [
        "Ausência de expressão na membrana das células neoplásicas invasivas",
        "marcação fraca, pouco perceptível e incompleta da membrana em {}% das células",
        "marcação fraca/moderada e completa da membrana em {}% das células",
        "marcação forte e completa da membrana em {}% das células"
    ])

    g.AddText("x600 yp+3 w30", "%:")
    edtPerc := g.AddEdit("x630 yp-3 w110 +Disabled +Tabstop", "")

    g.AddText("x35 y+40 w110", "Classificação:")
    ddlHer2Class := g.AddDropDownList("x140 yp-3 w250 Choose1 +Tabstop", ["HER2-zero", "HER2-ultra low", "HER2-low", "HER2 duvidoso", "HER2 positivo"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r12 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) {
        ; Controle de campos extras
        edtCitar.Enabled := (ddlDiag.Value = 12)
        edtPerc.Enabled := (ddlHer2Padrao.Value > 1)

        edtPrev.Value := Build()
    }

    for c in [ddlDiag, edtCitar, ddlFeno, ddlHer2Padrao, edtPerc, ddlHer2Class]
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        ; Cabeçalho
        diagTxt := (ddlDiag.Value = 12) ? StrReplace(ddlDiag.Text, "{citar}", edtCitar.Value) : ddlDiag.Text
        res := "O perfil imuno-histoquímico, associado aos achados morfológicos, corrobora o diagnóstico de " diagTxt " " ddlFeno.Text ".`r`n"

        ; HER2 Linha 1
        her2P := ddlHer2Padrao.Text
        if (ddlHer2Padrao.Value > 1)
            her2P := StrReplace(her2P, "{}%", (edtPerc.Value || "[]") "%")

        res .= ". HER2: " her2P " (" ddlHer2Class.Text ")`r`n"

        ; Texto Fixo: Observação CAP 2023
        res .= "`r`nObservação: Sistema de interpretação imunohistoquímica da proteína HER2 para o câncer de mama (CAP 2023)`r`n"
        res .= "Escore 0:`r`n"
        res .= ". HER2-zero: Nenhuma coloração observada nas células neoplásicas`r`n"
        res .= ". HER2-Ultra low: Coloração fraca, pouco perceptível e incompleta da membrana em até 10% das células neoplásicas invasivas`r`n"
        res .= "Escore 1+ (HER2-low): Coloração fraca, pouco perceptível e incompleta da membrana em mais de 10% das células neoplásicas invasivas`r`n"
        res .= "Escore 2+ (Duvidoso): Coloração circunferencial completa da membrana de intensidade fraca/moderada em mais de 10% das células neoplásicas invasivas ou coloração circunferencial completa, uniforme e intensa da membrana em menos de 10% das células neoplásicas invasivas`r`n"
        res .= ". HER2 positivo: Se teste de hibridização positivo para amplificação do HER2`r`n"
        res .= ". HER2-low: Se teste de hibridização negativo para amplificação do HER2`r`n"
        res .= "Escore 3+ (Positivo): Coloração circunferencial completa uniforme e intensa da membrana em mais de 10% das células neoplásicas invasivas`r`n"

        ; Referências
        res .= "`r`nReferências bibliográficas:`r`n"
        res .= "1. Hammond ME, Hayes DF, Dowsett M, et al. American Society of Clinical Oncology/College of American Pathologists guideline recommendations for immunohistochemical testing of estrogen and progesterone receptors in breast cancer. Arch Pathol Lab Med. 2010;134(6):907 922.`r`n"
        res .= "2. Patrick L. Fitzgibbons, James L. Connolly. Template for Reporting Results of Biomarker Testing of Specimens from Patients with Carcinoma of the Breast. College of American Pathologists. Cancer Protocols Templates. March, 2023.`r`n"
        res .= "3. Ivanova M, Porta FM, D'Ercole M, Pescia C, Sajjadi E, Cursano G, De Camilli E, Pala O, Mazzarol G, Venetis K, Guerini-Rocco E, Curigliano G, Viale G, Fusco N. Standardized pathology report for HER2 testing in compliance with 2023 ASCO/CAP updates and 2023 ESMO consensus statements on HER2-low breast cancer. Virchows Arch. 2024 Jan;484(1):3-14.`r`n"
        res .= "4. Tozbikian, G., Bui, M.M., Hicks, D.G., Jaffer, S., Khoury, T., Wen, H.Y., Krishnamurthy, S. and Wei, S. Best practices for achieving consensus in HER2-low expression in breast cancer: current perspectives from practising pathologists. Histopathology, 2024.`r`n"
        res .= "5. Nielsen, Torsten O., et al. Assessment of Ki67 in breast cancer: updated recommendations from the international Ki67 in breast cancer working group. JNCI: Journal of the National Cancer Institute 113.7 (2021): 808-819."

        return res
    }
}