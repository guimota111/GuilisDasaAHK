; =========================================================
; Corpo uterino — Biópsia — Tumor (OMS 2020)
; Arquivo: scripts\UteroBiopsiaTumor.ahk
; Função chamada no menu: Mask_UteroBiopsiaTumor()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_UteroBiopsiaTumor() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Útero — Biópsia — Tumor")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO (OMS 2020)
    ; =========================
    g.AddText("w170", "Tipo (OMS 2020)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Carcinoma endometrioide, SOE",
        "Adenocarcinoma de células claras",
        "Carcinoma seroso",
        "Carcinoma mucinoso tipo intestinal",
        "Carcinossarcoma",
        "Carcinoma neuroendócrino de grandes células",
        "Carcinoma neuroendócrino de pequenas células"
    ])

    ; =========================
    ; GRADUAÇÕES (só para endometrioide e mucinoso)
    ; =========================
    g.AddText("xm y+12 w220", "Grau histológico (FIGO)")
    ddlFIGO := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    g.AddText("xm y+10 w220", "Grau nuclear")
    ddlNuclear := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    g.AddText("x+24 yp w220", "Grau arquitetural")
    ddlArq := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r8 ReadOnly -Wrap")

    ; =========================
    ; EVENTOS
    ; =========================
    ddlTipo.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))
    for ctrl in [ddlFIGO, ddlNuclear, ddlArq] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ; =========================
    ; BOTÕES
    ; =========================
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

    g.Show()
    ApplyRules()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ApplyRules() {
        ; Só endometrioide e mucinoso tipo intestinal recebem graduação
        isEndometrioide := (ddlTipo.Value = 1)
        isMucinoso      := (ddlTipo.Value = 4)
        on := (isEndometrioide || isMucinoso)

        ddlFIGO.Enabled := on
        ddlNuclear.Enabled := on
        ddlArq.Enabled := on
    }

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        header := ddlTipo.Text " (OMS 2020)"

        ; Só imprime graduação se aplicável
        isEndometrioide := (ddlTipo.Value = 1)
        isMucinoso      := (ddlTipo.Value = 4)

        if (isEndometrioide || isMucinoso) {
            return (
                header "`n"
                ". Grau histológico (FIGO): grau " ddlFIGO.Text "`n"
                "- Grau nuclear: " ddlNuclear.Text "`n"
                "- Grau arquitetural: " ddlArq.Text
            )
        } else {
            return header
        }
    }
}
