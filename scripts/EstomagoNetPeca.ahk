; =========================================================
; Máscara — Estômago NET (peça)
; Arquivo (exemplo): scripts\EstomagoNetPeca.ahk
; Requer: função PasteInto(hwnd, txt) já incluída no principal via #Include
; Chamada no menu: (*) => Mask_EstomagoNetPeca()
; =========================================================

Mask_EstomagoNetPeca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Estômago — NET (peça)")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    ; =========================
    ; GRAU (OMS 2019)
    ; =========================
    g.AddText("w170", "Grau (OMS 2019)")
    ddlGrau := g.AddDropDownList("x+8 w220 Choose1", ["1", "2", "3"])

    ; =========================
    ; DIMENSÕES / LOCALIZAÇÃO
    ; =========================
    g.AddText("xm y+12 w170", "Dimensões (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w80")
    g.AddText("x+8 yp+3", "cm")

    g.AddText("xm y+12 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w220 Choose3", ["cárdia", "fundo", "corpo", "antro", "piloro"])

    ; =========================
    ; ÍNDICE MITÓTICO
    ; =========================
    g.AddText("xm y+12 w170", "Mitoses (n)")
    edtMitoses := g.AddEdit("x+8 w80")
    g.AddText("x+8 yp+3", "em 42 CGA")

    g.AddText("x+18 yp-3 w170", "Faixa (OMS)")
    ddlFaixaMit := g.AddDropDownList("x+8 w220 Choose1", ["< 2 mitoses", "2 a 20 mitoses", "> 20 mitoses"])

    ; =========================
    ; PROFUNDIDADE (com víscera adjacente)
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade invasão")
    ddlProf := g.AddDropDownList("x+8 w520 Choose1", [
        "a lâmina própria",
        "a submucosa",
        "a muscular própria",
        "a subserosa, sem envolvimento do peritônio visceral",
        "a serosa (peritônio visceral)",
        "víscera adjacente"
    ])

    g.AddText("xm y+8 w170", "Víscera adjacente")
    edtVisc := g.AddEdit("x+8 w520")
    edtVisc.Enabled := false

    ; =========================
    ; OUTROS ACHADOS
    ; =========================
    g.AddText("xm y+12 w170", "Necrose")
    ddlNecrose := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("x+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("xm y+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("x+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    ; =========================
    ; ESTÔMAGO NÃO NEOPLÁSICO
    ; =========================
    g.AddText("xm y+16 w720", "Estômago não neoplásico")
    g.AddText("xm y+6 w170", "Padrão gastrite")
    ddlPadrao := g.AddDropDownList("x+8 w220 Choose1", ["fúndica", "antral"])

    g.AddText("x+12 w170", "Grau (crônica)")
    ddlGrauG := g.AddDropDownList("x+8 w220 Choose2", ["leve", "moderada", "intensa"])

    g.AddText("xm y+12 w280", "Pesquisa de H. pylori (Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w170 Choose2", ["positiva", "negativa"])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    ; Eventos de update
    for ctrl in [ddlGrau, edtDimA, edtDimB, ddlLoc, edtMitoses, ddlFaixaMit, ddlProf, edtVisc
               , ddlNecrose, ddlIVS, ddlIVL, ddlIPN, ddlPadrao, ddlGrauG, ddlHP] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ddlProf.OnEvent("Change", (*) => (
        edtVisc.Enabled := (ddlProf.Value = 6),
        (ddlProf.Value != 6 ? edtVisc.Value := "" : edtVisc.Focus()),
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
        ; dimensões: aceita 2,3 ou 2.3
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

        mit := Trim(edtMitoses.Value)
        if (mit = "")
            mit := "[quantidade]"

        ; profundidade
        if (ddlProf.Value = 6) {
            visc := Trim(edtVisc.Value)
            profTxt := "tumor invade " (visc = "" ? "víscera adjacente {citar}" : visc)
        } else {
            profTxt := "tumor invade " ddlProf.Text
        }

        gastriteTxt := (
            "Estômago não neoplásico: Gastrite " ddlPadrao.Text
            " crônica " ddlGrauG.Text
            ", sem atividade, sem metaplasia intestinal"
        )

        return (
            "Tumor neuroendócrino bem diferenciado grau " ddlGrau.Text " (OMS 2019)`n"
            ". Dimensões da neoplasia: " dimTxt "`n"
            ". Localização: " ddlLoc.Text "`n"
            ". Índice mitótico: " mit " mitoses em 42 campos de grande aumento (" ddlFaixaMit.Text " / 2,0 mm²)`n"
            ". Profundidade de invasão microscópica da neoplasia: " profTxt "`n"
            ". Necrose: " ddlNecrose.Text "`n"
            ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
            ". Invasão vascular linfática: " ddlIVL.Text "`n"
            ". Invasão perineural: " ddlIPN.Text "`n"
            gastriteTxt "`n"
            ". Pesquisa de H. pylori (coloração especial Giemsa): " ddlHP.Text
        )
    }
}
