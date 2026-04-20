; =========================================================
; Cabeça e Pescoço — Tireoide Benigna
; Arquivo: scripts\TireoideBenigna.ahk
; =========================================================

Mask_TireoideBenigna() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Tireoide Benigna")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    g.AddText("w400", "Selecione os achados histológicos:")

    ; Checkboxes - Bócio marcado por padrão (Checked)
    cb1 := g.AddCheckbox("y+15 vBocio Checked +Tabstop", "Doença nodular folicular (bócio multinodular)")
    cb2 := g.AddCheckbox("y+10 vTireoidite +Tabstop", "Tireoidite linfocítica")
    cb3 := g.AddCheckbox("y+10 vHiperplasia +Tabstop", "Hiperplasia de células foliculares")

    ; Prévia
    g.AddText("y+25", "Prévia do diagnóstico:")
    edtPrev := g.AddEdit("xm w500 r6 ReadOnly -Wrap")

    ; Botões
    btnIns := g.AddButton("xm y+20 w100 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w100 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w100", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- Lógica de Atualização ---
    Update(*) => edtPrev.Value := BuildDiag()

    cb1.OnEvent("Click", Update)
    cb2.OnEvent("Click", Update)
    cb3.OnEvent("Click", Update)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, BuildDiag()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := BuildDiag())

    g.Show()
    Update()

    BuildDiag() {
        itens := []
        if cb1.Value
            itens.Push("Doença nodular folicular da tireoide (bócio multinodular)")
        if cb2.Value
            itens.Push("Tireoidite linfocítica")
        if cb3.Value
            itens.Push("Hiperplasia de células foliculares")

        ; --- ALTERAÇÃO AQUI ---
        if (itens.Length == 0)
            return "Tecido tireoidiano dentro dos limites histológicos da normalidade."

        if (itens.Length == 1)
            return "Tecido tireoidiano exibindo " itens[1] "."

        ; Se houver mais de um, cria a lista com bullets
        texto := "Tecido tireoidiano exibindo:`n"
        for index, item in itens {
            texto .= ". " item "`n"
        }
        return RTrim(texto, "`n")
    }
}