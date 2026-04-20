; =========================================================
; Colo uterino — Benigno (seleção por checkboxes)
; Arquivo: scripts\ColoUterinoBenigno.ahk
; Função chamada no menu: Mask_ColoUterinoBenigno()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ColoUterinoBenigno() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Colo uterino — Benigno")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("xm w720", "Selecione os achados que entrarão no laudo:")

    cbPolipo := g.AddCheckBox("xm y+10", "Pólipo endocervical")
    cbHiper  := g.AddCheckBox("xm y+10", "Hiperplasia, queratinização e paraqueratose do epitélio escamoso")

    ; Cervicite (padrão marcado)
    cbCerv := g.AddCheckBox("xm y+10", "Cervicite crônica com metaplasia escamosa")
    cbCerv.Value := 1

    cbExt := g.AddCheckBox("x+20 yp", "extensiva às glândulas")

    cbNaboth := g.AddCheckBox("xm y+10", "Cistos de Naboth")

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r6 ReadOnly -Wrap")

    UpdatePreview(*) => edtPrev.Value := BuildText()

    for ctrl in [cbPolipo, cbHiper, cbCerv, cbExt, cbNaboth] {
        try ctrl.OnEvent("Click",  UpdatePreview)
        try ctrl.OnEvent("Change", UpdatePreview)
    }

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
    ; TEXTO FINAL (1 linha por achado)
    ; =========================
    BuildText() {
        linhas := []

        if (cbPolipo.Value)
            linhas.Push("Pólipo endocervical")

        if (cbHiper.Value)
            linhas.Push("Hiperplasia, queratinização e paraqueratose do epitélio escamoso")

        if (cbCerv.Value) {
            l := "Cervicite crônica com metaplasia escamosa"
            if (cbExt.Value)
                l .= ", extensiva às glândulas"
            linhas.Push(l)
        }

        if (cbNaboth.Value)
            linhas.Push("Cistos de Naboth")

        if (linhas.Length = 0)
            return "[nenhum achado selecionado]"

        txt := ""
        for l in linhas
            txt .= l "`n"
        return RTrim(txt, "`n")
    }
}
