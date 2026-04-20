; =========================================================
; Notas Padronizadas — Aprofundamento / Seriados
; Arquivo: scripts\NotaAprofundamento.ahk
; =========================================================

Mask_NotaAprofundamento() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Nota — Aprofundamento de Bloco")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. TIPO DE PROCEDIMENTO ---
    g.AddText("w500", "Selecione o procedimento realizado no bloco:")
    ddlTipo := g.AddDropDownList("y+10 w470 Choose1 +Tabstop", [
        "Cortes aprofundados",
        "Cortes seriados"])

    ; --- 2. ESPECIFICAÇÃO DE NÍVEIS (Dinâmico) ---
    tNiveis := g.AddText("xm y+20 Hidden", "Número de níveis:")
    edtNiveis := g.AddEdit("x+10 yp-3 w60 Hidden +Tabstop", "3")

    ; --- PRÉVIA ---
    g.AddText("xm y+25", "Texto da Nota:")
    edtPrev := g.AddEdit("xm w470 r4 ReadOnly -Wrap")

    ; --- BOTÕES ---
    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE INTERFACE ---
    AtualizarLayout(*) {
        ; Mostra campo de níveis apenas se for "Cortes seriados"
        isSeriado := (ddlTipo.Value == 2)
        tNiveis.Visible := isSeriado
        edtNiveis.Visible := isSeriado

        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    ddlTipo.OnEvent("Change", AtualizarLayout)
    edtNiveis.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlTipo.Focus()
    AtualizarLayout()

    Build() {
        res := "Nota: Foram realizados "

        if (ddlTipo.Value == 1) {
            res .= "cortes aprofundados"
        } else {
            res .= "cortes seriados em " (edtNiveis.Value || "X") " níveis"
        }

        res .= " do(s) bloco(s) de parafina para melhor avaliação morfológica."
        return res
    }
}