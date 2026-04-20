; =========================================================
; MÁSCARA — ESTÔMAGO (BIÓPSIA) — TUMOR (AutoHotkey v2)
; Arquivo para ser usado via #Include
; =========================================================

; Função "pública" para o menu chamar
EstomagoBiopsiaTumor_Run() {
    Mask_EstomagoBiopsiaTumor()
}

Mask_EstomagoBiopsiaTumor() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Estômago (biópsia) — Tumor")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    ; --- Linha 1: subtipo OMS + grau de diferenciação
    g.AddText("w170", "Adenocarcinoma (OMS)")
    ddlOMS := g.AddDropDownList("x+8 w240 Choose1", [
        "tubular",
        "de células pouco coesas"
    ])

    g.AddText("x+12 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose1", [
        "bem",
        "moderadamente",
        "pouco"
    ])

    ; --- Linha 2: Lauren
    g.AddText("xm y+12 w170", "Lauren")
    ddlLauren := g.AddDropDownList("x+8 w240 Choose1", [
        "intestinal",
        "difuso",
        "misto"
    ])

    ; --- H. pylori
    g.AddText("xm y+12 w280", "Pesquisa de H. pylori (Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w170 Choose1", ["negativa", "positiva"])

    ; --- Prévia
    g.AddText("xm y+12", "Prévia")
    edtPrev := g.AddEdit("xm w720 r5 ReadOnly -Wrap")

    for ctrl in [ddlOMS, ddlDiff, ddlLauren, ddlHP]
        ctrl.OnEvent("Change", (*) => UpdatePreview())

    ; --- Botões
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

    ; -------- internas --------
    UpdatePreview() {
        edtPrev.Value := Build()
    }

    Build() {
        return (
            "Adenocarcinoma " ddlOMS.Text " " ddlDiff.Text " diferenciado (classificação OMS)`n"
            "Adenocarcinoma tipo " ddlLauren.Text " (classificação de Lauren)`n"
            ". Pesquisa de H. pylori (coloração especial Giemsa): " ddlHP.Text
        )
    }
}