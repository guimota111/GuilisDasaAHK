; =========================================================
; Colo uterino — Biópsia (seleção por checkboxes)
; Arquivo: scripts\ColoUtBiopsia.ahk
; Função chamada no menu: Mask_ColoUtBiopsia()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_ColoUtBiopsia() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Colo uterino — Biópsia")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("xm w720", "Selecione os achados que entrarão no laudo:")

    ; =========================
    ; 1) LIE
    ; =========================
    cbLIE := g.AddCheckBox("xm y+10", "Lesão intraepitelial cervical (LIE)")

    g.AddText("xm y+8 w60", "Grau")
    ddlGrau := g.AddDropDownList("x+8 w140 Choose1", ["baixo", "alto"])

    g.AddText("x+16 w40", "NIC")
    ddlNIC := g.AddDropDownList("x+8 w80 Choose1", ["1", "2", "3"])

    cbLIEExt := g.AddCheckBox("x+18 yp+3", "extensiva às glândulas")

    ; =========================
    ; 2) Viral
    ; =========================
    cbViral := g.AddCheckBox("xm y+14", "Efeito citopático sugestivo de infecção viral")

    ; =========================
    ; 3) Cervicite (padrão marcado)
    ; =========================
    cbCerv := g.AddCheckBox("xm y+14", "Cervicite crônica")
    cbCerv.Value := 1

    cbAgud := g.AddCheckBox("xm y+8", "agudizada")
    cbCervExt := g.AddCheckBox("x+18 yp", "metaplasia escamosa extensiva às glândulas")

    ; =========================
    ; 4) Naboth
    ; =========================
    cbNaboth := g.AddCheckBox("xm y+14", "Cistos de Naboth")

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r7 ReadOnly -Wrap")

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

    ; =========================
    ; EVENTOS
    ; =========================
    cbLIE.OnEvent("Click", (*) => (ApplyRules(), UpdatePreview()))
    cbCerv.OnEvent("Click", (*) => (ApplyRules(), UpdatePreview()))

    for ctrl in [ddlGrau, ddlNIC, cbLIEExt, cbViral, cbAgud, cbCervExt, cbNaboth] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    g.Show()
    ApplyRules()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ApplyRules() {
        onLIE := cbLIE.Value
        ddlGrau.Enabled := onLIE
        ddlNIC.Enabled  := onLIE
        cbLIEExt.Enabled := onLIE
        if (!onLIE)
            cbLIEExt.Value := 0

        onCerv := cbCerv.Value
        cbAgud.Enabled := onCerv
        cbCervExt.Enabled := onCerv
        if (!onCerv) {
            cbAgud.Value := 0
            cbCervExt.Value := 0
        }
    }

    UpdatePreview() => edtPrev.Value := BuildText()

    BuildText() {
        linhas := []

        if (cbLIE.Value) {
            l := "Lesão intraepitelial cervical de " ddlGrau.Text " grau (NIC " ddlNIC.Text ")"
            if (cbLIEExt.Value)
                l .= " extensiva às glândulas"
            linhas.Push(l)
        }

        if (cbViral.Value)
            linhas.Push("Efeito citopático sugestivo de infecção viral")

        if (cbCerv.Value) {
            l := "Cervicite crônica"
            if (cbAgud.Value)
                l .= " agudizada"
            l .= " com metaplasia escamosa"
            if (cbCervExt.Value)
                l .= " extensiva às glândulas"
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
