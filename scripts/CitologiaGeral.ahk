; =========================================================
; Citopatologia — Citologia Geral (Líquidos e Lavados)
; Arquivo: scripts\CitologiaGeral.ahk
; =========================================================

Mask_CitologiaGeral() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Citologia Geral")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CONCLUSÃO PRINCIPAL ---
    g.AddGroupBox("w500 h80", "Conclusão Citológica")
    ddlConclusao := g.AddDropDownList("xp+15 yp+30 w470 Choose1 +Tabstop", [
        "Citologia negativa para malignidade",
        "Citologia suspeita para malignidade",
        "Citologia positiva para malignidade"])

    ; --- 2. ESPECIFICAÇÃO ---
    g.AddGroupBox("xm y+25 w500 h80", "Especificação (Opcional)")
    ddlTipo := g.AddDropDownList("xp+15 yp+30 w470 Choose1 +Tabstop", [
        "(Em branco)",
        "Compatível com Carcinoma",
        "Compatível com Adenocarcinoma",
        "Compatível com Mesotelioma"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w500 r4 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE INTERFACE ---
    UpdatePreview(*) => edtPrev.Value := Build()

    ddlConclusao.OnEvent("Change", UpdatePreview)
    ddlTipo.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlConclusao.Focus()
    UpdatePreview()

    Build() {
        res := ddlConclusao.Text

        ; Se não for a opção "(Em branco)"
        if (ddlTipo.Value > 1) {
            res .= ".`n" ddlTipo.Text "."
        } else {
            res .= "."
        }

        return res
    }
}