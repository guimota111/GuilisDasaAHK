; =========================================================
; Apêndice — Não neoplásico
; Arquivo: scripts\ApendiceNormal.ahk
; Função chamada no menu: Mask_ApendiceNormal()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ApendiceNormal() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Apêndice — Não neoplásico")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("xm w720", "Apêndice não neoplásico (selecionar uma ou mais opções):")

    cbNormal := g.AddCheckBox("xm y+8",  "Dentro dos limites histológicos da normalidade")
    cbAA     := g.AddCheckBox("xm y+6",  "Apendicite aguda")
    cbSer    := g.AddCheckBox("xm y+6",  "Serosite aguda")
    cbDiv    := g.AddCheckBox("xm y+6",  "Doença diverticular")
    cbHL     := g.AddCheckBox("xm y+6",  "Hiperplasia linfoide")

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+14", "Prévia")
    edtPrev := g.AddEdit("xm w720 r6 ReadOnly -Wrap")

    UpdatePreview(*) {
        edtPrev.Value := BuildText()
    }

    for cb in [cbNormal, cbAA, cbSer, cbDiv, cbHL]
        cb.OnEvent("Click", UpdatePreview)

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := BuildText(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))

    btnCopy.OnEvent("Click", (*) => (A_Clipboard := BuildText()))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    ; =========================
    ; FUNÇÃO DE TEXTO
    ; =========================
    BuildText() {
        linhas := []

        if (cbNormal.Value)
            linhas.Push("Dentro dos limites histológicos da normalidade")
        if (cbAA.Value)
            linhas.Push("Apendicite aguda")
        if (cbSer.Value)
            linhas.Push("Serosite aguda")
        if (cbDiv.Value)
            linhas.Push("Doença diverticular")
        if (cbHL.Value)
            linhas.Push("Hiperplasia linfoide")

        if (linhas.Length = 0)
            return "Apêndice não neoplásico: [nenhum achado selecionado]"

        for l in linhas
            txt .= "" l "`n"

        return RTrim(txt, "`n")
    }
}
