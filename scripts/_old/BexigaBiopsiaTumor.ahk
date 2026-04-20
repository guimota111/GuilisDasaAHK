; =========================================================
; Bexiga — Biópsia — Tumor
; Arquivo: scripts\BexigaBiopsiaTumor.ahk
; Função chamada no menu: Mask_BexigaBiopsiaTumor()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_BexigaBiopsiaTumor() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Bexiga — Tumor (biópsia)")
    g.MarginX := 12, g.MarginY := 12

    ; =========================
    ; TIPO PRINCIPAL
    ; =========================
    g.AddText("w170", "Tipo")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Carcinoma urotelial",
        "Carcinoma urotelial papilífero",
        "Carcinoma urotelial com áreas de diferenciação escamosa",
        "Carcinoma de células escamosas"
    ])

    ; % diferenciação escamosa (apenas no tipo 3)
    g.AddText("xm y+10 w170", "Dif. escamosa (%)")
    edtPercEsc := g.AddEdit("x+8 w120")
    g.AddText("x+10 yp+3 w420", "(usar apenas quando houver diferenciação escamosa no carcinoma urotelial)")
    edtPercEsc.Enabled := false

    ; Diferenciação do CEC (apenas no tipo 4)
    g.AddText("xm y+10 w170", "CEC — diferenciação")
    ddlSCCDiff := g.AddDropDownList("x+8 w220 Choose2", [
        "bem diferenciado",
        "moderadamente diferenciado",
        "pouco diferenciado"
    ])
    ddlSCCDiff.Enabled := false

    ; =========================
    ; INVASÃO + GRAU
    ; =========================
    g.AddText("xm y+12 w170", "Invasão")
    ddlInv := g.AddDropDownList("x+8 w220 Choose1", ["invasivo", "não invasivo"])

    g.AddText("x+12 w170", "Grau")
    ddlGrau := g.AddDropDownList("x+8 w220 Choose1", ["alto", "baixo"])

    ; =========================
    ; PROFUNDIDADE / DETRUSOR
    ; =========================
    g.AddText("xm y+12 w170", "Profundidade")
    ddlProf := g.AddDropDownList("x+8 w520 Choose1", [
        "lesão restrita à mucosa",
        "lâmina própria",
        "camada muscular própria"
    ])

    g.AddText("xm y+12 w280", "Camada muscular própria (detrusor)")
    ddlDetrusor := g.AddDropDownList("x+8 w410 Choose1", [
        "livre de neoplasia",
        "infiltrada pela neoplasia",
        "não representada nesta amostra"
    ])

    ; =========================
    ; INVASÕES VASCULARES
    ; =========================
    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r9 ReadOnly -Wrap")

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := Build()))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    ; =========================
    ; EVENTOS
    ; =========================
    ddlTipo.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))

    for ctrl in [ddlTipo, edtPercEsc, ddlSCCDiff, ddlInv, ddlGrau, ddlProf, ddlDetrusor, ddlIVS, ddlIVL] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    g.Show()
    ApplyRules()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ApplyRules() {
        ; Tipo 3 -> habilita %; Tipo 4 -> habilita dif. do CEC
        isTipo3 := (ddlTipo.Value = 3)
        isTipo4 := (ddlTipo.Value = 4)

        edtPercEsc.Enabled := isTipo3
        if (!isTipo3)
            edtPercEsc.Value := ""

        ddlSCCDiff.Enabled := isTipo4
    }

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        ; header do carcinoma
        if (ddlTipo.Value = 1) {
            tipoTxt := "Carcinoma urotelial"
        } else if (ddlTipo.Value = 2) {
            tipoTxt := "Carcinoma urotelial papilífero"
        } else if (ddlTipo.Value = 3) {
            p := Trim(edtPercEsc.Value)
            p := StrReplace(p, ",", ".")
            if (p = "")
                p := "{percentual}"
            tipoTxt := "Carcinoma urotelial com áreas de diferenciação escamosa, que correspondem a " p "% do total da neoplasia"
        } else {
            tipoTxt := "Carcinoma de células escamosas " ddlSCCDiff.Text
        }

        header := tipoTxt " " ddlInv.Text " de " ddlGrau.Text " grau"

        return (
            header "`n"
            ". Profundidade de infiltração: " ddlProf.Text "`n"
            ". Camada muscular própria (detrusor): " ddlDetrusor.Text "`n"
            ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
            ". Invasão vascular linfática: " ddlIVL.Text
        )
    }
}
