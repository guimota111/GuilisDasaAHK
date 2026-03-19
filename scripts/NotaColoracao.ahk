; =========================================================
; Notas Padronizadas — Colorações Especiais
; Arquivo: scripts\NotaColoracao.ahk
; =========================================================

Mask_NotaColoracao() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Nota — Colorações Especiais")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    g.AddText("w600", "Selecione a(s) coloração(ões) realizada(s):")

    ; --- LISTA DE MÉTODOS ---
    ddlMetodo := g.AddDropDownList("y+10 w570 Choose1 +Tabstop", [
        "FITE",
        "PAS",
        "Vermelho do Congo",
        "Verhoeff",
        "Tricrômico de Masson",
        "Reticulina",
        "Giemsa",
        "Ziehl Neelsen e Grocott",
        "Tricrômio de Masson, Reticulina e Giemsa",
        "Tricrômio de Masson, PAS, Perls e Reticulina",
        "PAS Alcian blue",
        "Ziehl Neelsen",
        "Grocott"])

    ; --- PRÉVIA ---
    g.AddText("y+20", "Texto da Nota:")
    edtPrev := g.AddEdit("xm w570 r4 ReadOnly -Wrap")

    ; --- BOTÕES ---
    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA ---
    UpdatePreview(*) => edtPrev.Value := Build()

    ddlMetodo.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlMetodo.Focus()
    UpdatePreview()

    Build() {
        val := ddlMetodo.Value
        res := "Nota: "

        ; Lógica para diferenciar singular de plural (Opções 8, 9 e 10 são plurais)
        if (val == 8 || val == 9 || val == 10) {
            res .= "Foram realizadas colorações especiais pelos métodos "
        } else {
            res .= "Foi realizada coloração especial pelo método "
        }

        ; Adiciona o nome do método conforme a lista
        metodos := [
            "FITE", "PAS", "Vermelho do Congo", "Verhoeff", "Tricrômico de Masson",
            "Reticulina", "Giemsa", "Ziehl Neelsen e Grocott",
            "de Tricrômio de Masson, Reticulina e Giemsa",
            "de Tricrômio de Masson, PAS, Perls e Reticulina",
            "PAS Alcian blue", "Ziehl Neelsen", "Grocott"
        ]

        res .= metodos[val] "."
        return res
    }
}