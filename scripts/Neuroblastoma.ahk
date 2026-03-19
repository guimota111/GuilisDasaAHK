; =========================================================
; Adrenal/Retroperitônio — Neuroblastoma
; Arquivo: scripts\Neuroblastoma.ahk
; =========================================================

Mask_Neuroblastoma() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Neuroblastoma")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 12, g.MarginY := 12

    ; --- TIPO HISTOLÓGICO ---
    g.AddGroupBox("w740 h110", "Classificação Histológica")
    g.AddText("xp+10 yp+25 w110", "Tipo:")
    ddlTipo := g.AddDropDownList("x+5 w350 Choose1", [
        "Neuroblastoma",
        "Ganglioneuroblastoma nodular",
        "Ganglioneuroblastoma intermisto",
        "Ganglioneuroma maduro",
        "Ganglioneuroma em maturação"
    ])

    g.AddText("x+10 yp", "Diferenciação:")
    ddlDif := g.AddDropDownList("x+5 w200 Choose1", ["Indiferenciado", "Pouco diferenciado", "Em diferenciação", "Em maturação"])

    g.AddText("xm+10 y+15 w110", "Nº de nódulos:")
    edtNodulos := g.AddEdit("x+5 w100 Number Disabled")
    g.AddText("x+5 yp+3", "(apenas para GNB nodular)")

    ; --- MKI E TRATAMENTO ---
    g.AddGroupBox("xm y+25 w740 h110", "Índice Mitose/Cariorrexe (MKI) e Resposta Terapêutica")
    g.AddText("xp+10 yp+25 w110", "MKI:")
    ddlMKI := g.AddDropDownList("x+5 w580 Choose1", [
        "Baixo (menos de 2% de núcleos mitóticos/cariorréxicos)",
        "Moderado (2% a 4% de núcleos mitóticos/cariorréxicos)",
        "Alto (mais de 4% de núcleos mitóticos/cariorréxicos)"
    ])

    g.AddText("xm+10 y+15 w110", "Trat. Prévio:")
    ddlNeo := g.AddDropDownList("x+5 w150 Choose1", ["Não aplicável", "Não detectada", "Presente"])

    g.AddText("x+20 yp", "Necrose:")
    edtNecrose := g.AddEdit("x+5 w45 Number"), g.AddText("x+2 yp+3", "%")

    g.AddText("x+20 yp-3", "Citodiferenciação:")
    edtCito := g.AddEdit("x+5 w45 Number"), g.AddText("x+2 yp+3", "%")

    ; --- DIMENSÃO E EXTENSÃO ---
    g.AddGroupBox("xm y+25 w740 h110", "Extensão e Dimensões")
    g.AddText("xp+10 yp+25 w110", "Dimensão (cm):")
    edtDimA := g.AddEdit("x+5 w60"), g.AddText("x+2 yp+3", "x"), edtDimB := g.AddEdit("x+2 yp-3 w60"), g.AddText("x+5 yp+3", "cm")

    g.AddText("xm+10 y+15 w110", "Extensão:")
    ddlExt := g.AddDropDownList("x+5 w580 Choose1", [
        "Encapsulado",
        "Extracapsular sem envolvimento de órgãos adjacentes",
        "Extracapsular com envolvimento de órgãos adjacentes",
        "Extracapsular com envolvimento do canal espinhal"
    ])

    ; --- INVASÕES E CALCIFICAÇÃO ---
    g.AddGroupBox("xm y+20 w740 h80", "Invasões e Achados")
    g.AddText("xp+10 yp+25 w110", "Calcificações:")
    ddlCalc := g.AddDropDownList("x+5 w120 Choose1", ["Presentes", "Não detectadas"])

    g.AddText("x+20 yp w110", "Vasc. Sanguínea:")
    ddlIVS := g.AddDropDownList("x+5 w120 Choose2", ["Presente", "Não detectada"])

    g.AddText("x+20 yp w110", "Vasc. Linfática:")
    ddlIVL := g.AddDropDownList("x+5 w120 Choose2", ["Presente", "Não detectada"])

    ; --- PRÉVIA ---
    g.AddText("xm y+20", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w740 r10 ReadOnly -Wrap")

    ; =========================
    ; EVENTOS
    ; =========================
    UpdatePreview(*) => edtPrev.Value := Build()

    ; Habilitar/Desabilitar campo de nódulos
    ddlTipo.OnEvent("Change", (ctrl, *) => (
        edtNodulos.Enabled := (ctrl.Text == "Ganglioneuroblastoma nodular"),
        (ctrl.Text != "Ganglioneuroblastoma nodular" ? edtNodulos.Value := "" : ""),
        UpdatePreview()
    ))

    controles := [ddlTipo, ddlDif, edtNodulos, ddlMKI, ddlNeo, edtNecrose, edtCito, edtDimA, edtDimB, ddlExt, ddlCalc, ddlIVS, ddlIVL]
    for ctrl in controles
        try ctrl.OnEvent("Change", UpdatePreview)

    ; Botões
    g.AddButton("xm y+15 w120 Default", "Inserir").OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    g.AddButton("x+10 w120", "Copiar").OnEvent("Click", (*) => A_Clipboard := Build())
    g.AddButton("x+10 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    ; =========================
    ; CONSTRUÇÃO DO LAUDO
    ; =========================
    Build() {
        dA := edtDimA.Value || "[]", dB := edtDimB.Value || "[]"
        nec := edtNecrose.Value || "[]", cito := edtCito.Value || "[]"

        ; Ajuste do nome para GNB Nodular
        tipoBase := ddlTipo.Text
        if (tipoBase == "Ganglioneuroblastoma nodular" && edtNodulos.Value != "")
            tipoBase .= " (" edtNodulos.Value " nódulos)"

        res := tipoBase ", " ddlDif.Text "`n"
        res .= ". Dimensão da neoplasia: " dA " x " dB " cm`n"
        res .= ". Áreas de resposta a tratamento neoadjuvante: " ddlNeo.Text "`n"
        res .= "  - Porcentagem de necrose tumoral: " nec "%`n"
        res .= "  - Porcentagem de citodiferenciação terapia-induzida: " cito "%`n"
        res .= ". Índice mitose/cariorrexe (MKI): " ddlMKI.Text "`n"
        res .= ". Extensão microscópica do tumor: " ddlExt.Text "`n"
        res .= ". Calcificações tumorais: " ddlCalc.Text "`n"
        res .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        res .= ". Invasão vascular linfática: " ddlIVL.Text

        return res
    }
}