; =========================================================
; Corpo uterino — Benigno
; Arquivo: scripts\CorpoBenigno.ahk
; Função chamada no menu: Mask_CorpoBenigno()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_CorpoBenigno() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Corpo uterino — Benigno")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("xm w720", "Selecione os achados que entrarão no laudo:")

    ; =========================
    ; Leiomioma(s) — sempre incluído, plural padrão
    ; =========================
    cbLeio := g.AddCheckBox("xm y+10", "Leiomioma(s)")
    cbLeio.Value := 1

    g.AddText("x+12 yp+2 w90", "Número")
    ddlLeioNum := g.AddDropDownList("x+8 w140 Choose1", ["Leiomiomas", "Leiomioma"]) ; plural padrão

    ; =========================
    ; Pólipo endometrial — opcional
    ; =========================
    cbPolipo := g.AddCheckBox("xm y+12", "Pólipo endometrial")
    cbPolipo.Value := 0

    ; =========================
    ; Endométrio — sempre incluído (padrão proliferativo)
    ; =========================
    g.AddText("xm y+12 w100", "Endométrio")
    ddlEndo := g.AddDropDownList("x+8 w560 Choose1", [
        "de padrão proliferativo",
        "de padrão secretor",
        "de padrão atrófico",
        "de padrão atrófico cístico",
        "exibindo dissociação estroma-glândula (estroma secretor e glândulas atróficas), compatível com efeito hormonal exógeno",
        "de padrão basal"
        "autolisado"
    ])

    ; =========================
    ; Adenomiose — opcional
    ; =========================
    cbAdenom := g.AddCheckBox("xm y+12", "Adenomiose")
    cbAdenom.Value := 0

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r7 ReadOnly -Wrap")

    UpdatePreview(*) => edtPrev.Value := Build()

    for ctrl in [cbLeio, ddlLeioNum, cbPolipo, ddlEndo, cbAdenom] {
        try ctrl.OnEvent("Change", UpdatePreview)
        try ctrl.OnEvent("Click",  UpdatePreview)
    }

    ; Se desmarcar leiomioma, desabilita escolha singular/plural
    cbLeio.OnEvent("Click", (*) => (
        ddlLeioNum.Enabled := (cbLeio.Value = 1),
        UpdatePreview()
    ))

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
    ddlLeioNum.Enabled := (cbLeio.Value = 1)
    UpdatePreview()

    ; =========================
    ; TEXTO FINAL
    ; =========================
    Build() {
        linhas := []

        if (cbLeio.Value = 1)
            linhas.Push(ddlLeioNum.Text)

        ; Endométrio sempre entra
        linhas.Push("Endométrio " ddlEndo.Text)

        if (cbPolipo.Value = 1)
            linhas.Push("Pólipo endometrial")

        if (cbAdenom.Value = 1)
            linhas.Push("Adenomiose")

        txt := ""
        for l in linhas
            txt .= l "`n"
        return RTrim(txt, "`n")
    }
}
