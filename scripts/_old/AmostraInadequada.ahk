; =========================================================
; Notas Padronizadas — Amostra Inadequada
; Arquivo: scripts\NotasInadequada.ahk
; =========================================================

Mask_NotasInadequada() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Nota — Amostra Inadequada")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    g.AddText("w600", "Selecione a nota de adequabilidade:")

    ; --- LISTA DE NOTAS ---
    ddlNota := g.AddDropDownList("y+10 w570 Choose1 +Tabstop", [
        "Sugere-se, a critério clínico, reabordagem da lesão para obtenção de nova amostra histológica",
        "Não é possível estabelecer o diagnóstico definitivo por representação inadequada da lesão. Sugere-se reabordagem",
        "Não é possível estabelecer o diagnóstico definitivo em decorrência da exiguidade da amostra. Sugere-se reabordagem",
        "Amostra exibindo extensos artefatos de dessecamento. Sugere-se reabordagem",
        "Amostra exibindo extensos artefatos de fulguração. Sugere-se reabordagem",
        "Amostra exibindo extensos artefatos de compressão. Sugere-se reabordagem",
        "Persistindo suspeita clínica de malignidade, sugere-se reabordagem da lesão"])

    ; --- PRÉVIA ---
    g.AddText("y+20", "Texto Completo:")
    edtPrev := g.AddEdit("xm w570 r5 ReadOnly -Wrap")

    ; --- BOTÕES ---
    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA ---
    UpdatePreview(*) => edtPrev.Value := Build()

    ddlNota.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlNota.Focus()
    UpdatePreview()

    Build() {
        ; Mapeamento exato dos textos solicitados
        notas := [
            "Nota: Sugere-se, a critério clínico, reabordagem da lesão para obtenção de nova amostra histológica.",
            "Nota: Não é possível estabelecer o diagnóstico definitivo por representação inadequada da lesão na amostra avaliada. Sugere-se, a critério clínico, reabordagem da lesão para obtenção de nova amostra histológica.",
            "Nota: Não é possível estabelecer o diagnóstico definitivo em decorrência da exiguidade da amostra. Sugere-se, a critério clínico, reabordagem da lesão para obtenção de nova amostra histológica.",
            "Nota: Amostra exibindo extensos artefatos de dessecamento. Sugere-se, a critério clínico, reabordagem da lesão para obtenção de nova amostra histológica.",
            "Nota: Amostra exibindo extensos artefatos de fulguração. Sugere-se, a critério clínico, reabordagem da lesão para obtenção de nova amostra histológica.",
            "Nota: Amostra exibindo extensos artefatos de compressão. Sugere-se, a critério clínico, reabordagem da lesão para obtenção de nova amostra histológica.",
            "Nota: Persistindo suspeita clínica de malignidade, sugere-se, a critério clínico, reabordagem da lesão para obtenção de nova amostra histológica."
        ]
        return notas[ddlNota.Value]
    }
}