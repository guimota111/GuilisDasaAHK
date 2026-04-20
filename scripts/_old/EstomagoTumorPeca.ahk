
Mask_EstomagoTumorPeca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Estômago — Tumor (peça)")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    ; =========================
    ; TUMOR — CLASSIFICAÇÕES
    ; =========================
    g.AddText("w170", "Tipo (OMS 2019)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Adenocarcinoma tubular",
        "Adenocarcinoma papilífero",
        "Adenocarcinoma mucinoso",
        "Adenocarcinoma pouco coesivo, com células em anel de sinete",
        "Adenocarcinoma micropapilífero",
        "Adenocarcinoma com estroma linfoide",
        "Adenocarcinoma hepatoide",
        "Adenocarcinoma de glândulas tipo fúndicas",
        "Carcinoma adenoescamoso",
        "Carcinoma de células escamosas",
        "Carcinoma neuroendócrino de pequenas células",
        "Carcinoma neuroendócrino de grandes células",
        "Gastroblastoma"
    ])

    g.AddText("xm y+12 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    g.AddText("x+12 w170", "Lauren")
    ddlLauren := g.AddDropDownList("x+8 w220 Choose1", ["intestinal", "difuso", "misto"])

    ; =========================
    ; DIMENSÃO / LOCALIZAÇÃO
    ; =========================
    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
	edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    g.AddText("xm y+12 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose1", [
        "parede anterior do corpo",
        "parede posterior do corpo",
        "pequena curvatura do corpo",
        "grande curvatura do corpo",
        "pequena curvatura do antro",
        "grande curvatura do antro",
        "piloro",
        "transição corpo-antro"
    ])

    ; =========================
    ; PROFUNDIDADE / SEROSA
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade")
    ddlProf := g.AddDropDownList("x+8 w520 Choose1", [
        "restrito à mucosa",
        "invade a submucosa",
        "invade a muscular própria",
        "invade o tecido adiposo subseroso",
        "perfura a serosa",
        "invade víscera adjacente"
    ])

    g.AddText("xm y+8 w170", "Víscera adjacente")
    edtVisc := g.AddEdit("x+8 w520")
    edtVisc.Enabled := false

    g.AddText("xm y+12 w170", "Serosa")
    ddlSerosa := g.AddDropDownList("x+8 w520 Choose1", [
        "livre de infiltração neoplásica",
        "infiltrada pela neoplasia"
    ])

    ; =========================
    ; INVASÕES / DEPÓSITOS
    ; =========================
    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Depósitos tumorais")
    ddlDep := g.AddDropDownList("x+8 w220 Choose1", ["não detectados", "presentes"])

    ; =========================
    ; ESTÔMAGO NÃO NEOPLÁSICO
    ; =========================
    g.AddText("xm y+16 w720", "Estômago não neoplásico")
    g.AddText("xm y+6 w170", "Padrão")
    ddlPadrao := g.AddDropDownList("x+8 w220 Choose1", ["fúndica", "antral"])

    g.AddText("x+12 w170", "Gastrite crônica")
    ddlGrauG := g.AddDropDownList("x+8 w220 Choose1", ["leve", "moderada", "intensa"])

    g.AddText("xm y+12 w170", "Atividade")
    ddlAtivG := g.AddDropDownList("x+8 w220 Choose1", ["com atividade", "sem atividade"])

    g.AddText("x+12 w170", "Metaplasia intestinal")
    ddlMIG := g.AddDropDownList("x+8 w220 Choose1", ["com metaplasia intestinal", "sem metaplasia intestinal"])

    g.AddText("xm y+12 w280", "Pesquisa de H. pylori (Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w170 Choose1", ["negativa", "positiva"])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r9 ReadOnly -Wrap")

    ; eventos de update
    for ctrl in [ddlTipo, ddlDiff, ddlLauren, edtDimA, edtDimB, ddlLoc, ddlProf, edtVisc, ddlSerosa
               , ddlIVS, ddlIVL, ddlIPN, ddlDep, ddlPadrao, ddlGrauG, ddlAtivG, ddlMIG, ddlHP] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ddlProf.OnEvent("Change", (*) => (
        edtVisc.Enabled := (ddlProf.Value = 6),
        (ddlProf.Value != 6 ? edtVisc.Value := "" : 0),
        UpdatePreview()
    ))

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (
        txt := Build(),
        A_Clipboard := txt
    ))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        dimA := StrReplace(Trim(edtDimA.Value), ",", ".")
		dimB := StrReplace(Trim(edtDimB.Value), ",", ".")
        if (dimA != "" && dimB != "")
            dimTxt := dimA " x " dimB " cm"
        else if (dimA != "" && dimB = "")
            dimTxt := dimA " cm"
        else if (dimA = "" && dimB != "")
            dimTxt := dimB " cm"
        else
            dimTxt := "[dimensão] x [dimensão] cm"

  if (ddlProf.Value = 6) {
    visc := Trim(edtVisc.Value)
    ; se vazio, mantém placeholder {citar}; se preenchido, substitui pelo texto digitado
    profTxt := "tumor invade víscera adjacente " (visc = "" ? "{citar}" : visc)
} else {
    profTxt := "tumor " ddlProf.Text
}


       gastriteTxt := (
    "Estômago não neoplásico: gastrite " ddlPadrao.Text
    " crônica " ddlGrauG.Text
    ", " ddlAtivG.Text
    ", " ddlMIG.Text
)


        return (
            ddlTipo.Text " " ddlDiff.Text " diferenciado (OMS 2019)`n"
            "Adenocarcinoma tipo " ddlLauren.Text " (classificação de Lauren)`n"
            ". Dimensão da neoplasia: " dimTxt "`n"
            ". Localização: " ddlLoc.Text "`n"
            ". Profundidade da infiltração: " profTxt "`n"
            ". Serosa: " ddlSerosa.Text "`n"
            ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
            ". Invasão vascular linfática: " ddlIVL.Text "`n"
            ". Invasão perineural: " ddlIPN.Text "`n"
            ". Depósitos tumorais: " ddlDep.Text "`n"
            gastriteTxt "`n"
            ". Pesquisa de H. pylori (coloração especial Giemsa): " ddlHP.Text
        )
    }
}
