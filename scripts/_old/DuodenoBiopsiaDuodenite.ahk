; =========================================================
; Duodeno — Biópsia — Duodenite
; Arquivo: scripts\DuodenoBiopsiaDuodenite.ahk
; Função chamada no menu: Mask_DuodenoBiopsiaDuodenite()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_DuodenoBiopsiaDuodenite() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Duodeno — Duodenite")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("w200", "Duodenite crônica inespecífica")
    ddlGrau := g.AddDropDownList("x+8 w220 Choose1", ["leve", "moderada", "intensa"])

    g.AddText("xm y+12 w200", "Outros achados")
    ddlAchados := g.AddDropDownList("x+8 w420 Choose1", [
        "Ausência de atrofia, granulomas e parasitas",
        "Áreas de atrofia e metaplasia gástrica"
    ])

    g.AddText("xm y+12 w200", "Relação vilosidade:cripta")
    ddlVC := g.AddDropDownList("x+8 w420 Choose1", [
        "3:1, dentro dos limites histológicos da normalidade",
        "reduzida, com áreas de atrofia"
    ])

    ; Prévia curta (opcional, mas ajuda a ver se está montando certo)
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r4 ReadOnly -Wrap")

    UpdatePreview(*) {
        edtPrev.Value := BuildDuodeniteText(ddlGrau.Text, ddlAchados.Text, ddlVC.Text)
    }

    ddlGrau.OnEvent("Change", UpdatePreview)
    ddlAchados.OnEvent("Change", UpdatePreview)
    ddlVC.OnEvent("Change", UpdatePreview)

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := BuildDuodeniteText(ddlGrau.Text, ddlAchados.Text, ddlVC.Text),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))

    btnCopy.OnEvent("Click", (*) => (
        A_Clipboard := BuildDuodeniteText(ddlGrau.Text, ddlAchados.Text, ddlVC.Text)
    ))

    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()
}

BuildDuodeniteText(grau, achados, vc) {
    txt := "Duodenite crônica inespecífica (duodenite péptica) " grau "`n"
    txt .= ". " achados "`n"
    txt .= ". Relação vilosidade:cripta " vc
    return txt
}
