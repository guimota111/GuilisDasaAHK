Mask_AdrenalMaligna() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Adrenal — Maligna")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO
    ; =========================
    g.AddText("w180", "Tipo")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Carcinoma cortical adrenal convencional",
        "Carcinoma cortical adrenal oncocítico",
        "Carcinoma cortical adrenal mixoide",
        "Carcinoma cortical adrenal sarcomatoide"
    ])

    ; =========================
    ; ÍNDICE MITÓTICO
    ; =========================
    g.AddText("xm y+12 w180", "Índice mitótico")
    edtMitoses := g.AddEdit("x+8 w140")
    g.AddText("x+8 yp+3", "mitoses em 10 CGA")

    ; =========================
    ; DIMENSÃO
    ; =========================
    g.AddText("xm y+16 w180", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w90")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; EXTENSÃO
    ; =========================
    g.AddText("xm y+12 w180", "Extensão")
    ddlExt := g.AddDropDownList("x+8 w520 Choose1", [
        "Confinado ao córtex adrenal",
        "Tumor invade ou atravessa a cápsula adrenal, com invasão do tecido adiposo peri-adrenal",
        "Tumor invade (outras estruturas)"
    ])

    g.AddText("xm y+8 w180", "Estrutura invadida")
    edtExtLivre := g.AddEdit("x+8 w520")
    edtExtLivre.Enabled := false

    ; =========================
    ; INVASÕES
    ; =========================
    g.AddText("xm y+12 w180", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("xm Y+8 w180", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r9 ReadOnly -Wrap")

  ; =========================
    ; EVENTOS
    ; =========================
    UpdatePreview(*) => edtPrev.Value := Build()

    ; Monitorar mudanças nos controles para atualizar a prévia
    for ctrl in [ddlTipo, edtMitoses, edtDimA, edtDimB, ddlExt, edtExtLivre, ddlIVL, ddlIVS] {
        try ctrl.OnEvent("Change", UpdatePreview)
    }

    ; Lógica para habilitar/desabilitar o campo "Estrutura invadida"
    ddlExt.OnEvent("Change", GerenciarCampoLivre)

    GerenciarCampoLivre(ctrl, *) {
        if (ctrl.Value = 3) {
            edtExtLivre.Enabled := true
            edtExtLivre.Focus()
        } else {
            edtExtLivre.Enabled := false
            edtExtLivre.Value := ""
        }
        UpdatePreview()
    }

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (txt := Build(), g.Destroy(), PasteInto(prevWin, txt)))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := Build()))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    ; =========================
    ; CONSTRUÇÃO DO TEXTO
    ; =========================
    Build() {
        ; Cálculo dinâmico do Grau Mitótico
        mitVal := Trim(edtMitoses.Value)

        ; Se estiver vazio, exibe placeholder, senão calcula o grau
        if (mitVal = "") {
            mitTxt := "[]"
            grauTxt := "[Grau não definido]"
        } else {
            mitTxt := mitVal
            ; Lógica do Grau (Corte em 21 conforme sua regra)
            grauTxt := (Number(StrReplace(mitVal, ",", ".")) < 21)
                ? "Baixo grau (menor ou igual a 20 mitoses por 10 mm²)"
                : "Alto grau (maior que 20 mitoses por 10 mm²)"
        }

        ; Dimensões
        dimA := StrReplace(Trim(edtDimA.Value), ",", ".")
        dimB := StrReplace(Trim(edtDimB.Value), ",", ".")
        dimTxt := (dimA != "" || dimB != "") ? (dimA || "[]") " x " (dimB || "[]") " cm" : "[] x [] cm"

        ; Extensão
        if (ddlExt.Value = 1) {
            extTxt := "Confinado ao córtex adrenal"
        } else if (ddlExt.Value = 2) {
            extTxt := "Tumor invade ou atravessa a cápsula adrenal, com invasão do tecido adiposo peri-adrenal"
        } else {
            alvo := Trim(edtExtLivre.Value)
            extTxt := (alvo = "") ? "Tumor invade {citar}" : "Tumor invade " alvo
        }

        return (
            ddlTipo.Text "`n"
            ". Índice mitótico: " mitTxt " mitoses em 10 campos de grande aumento, " grauTxt "`n"
            ". Dimensão da neoplasia: " dimTxt "`n"
            ". Extensão da neoplasia: " extTxt "`n"
            ". Invasão vascular linfática: " ddlIVL.Text "`n"
            ". Invasão vascular sanguínea: " ddlIVS.Text
        )
    }
}