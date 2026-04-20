; =========================================================
; Útero — Cone — NIC (checkboxes + quadrantes, lábio automático no TEXTO)
; Arquivo: scripts\UteroConeNic.ahk
; Função chamada no menu: Mask_UteroConeNic()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_UteroConeNic() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Útero — Cone — NIC")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("xm w720", "Selecione os achados que entrarão no laudo:")

    ; =========================
    ; LIE/NIC (com quadrantes)
    ; =========================
    cbLIE := g.AddCheckBox("xm y+10", "Lesão intraepitelial cervical (LIE)")

    g.AddText("xm y+8 w60", "Grau")
    ddlGrau := g.AddDropDownList("x+8 w140 Choose1", ["baixo", "alto"])

    g.AddText("x+16 w40", "NIC")
    ddlNIC := g.AddDropDownList("x+8 w80 Choose1", ["1", "2", "3"])

    cbExtGland := g.AddCheckBox("x+18 yp+3", "extensiva às glândulas")

    g.AddText("xm y+12 w110", "Quadrantes")
    cbQ1 := g.AddCheckBox("x+8", "12-3h")
    cbQ2 := g.AddCheckBox("x+10", "3-6h")
    cbQ3 := g.AddCheckBox("x+10", "6-9h")
    cbQ4 := g.AddCheckBox("x+10", "9-12h")


    ; =========================
    ; OUTROS ACHADOS (checkboxes)
    ; =========================
    cbViral := g.AddCheckBox("xm y+14", "Efeito citopático sugestivo de infecção viral")

    cbCerv := g.AddCheckBox("xm y+10", "Cervicite crônica com metaplasia escamosa")
    cbCerv.Value := 1  ; padrão

    cbNaboth := g.AddCheckBox("xm y+10", "Cistos de Naboth")

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

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
    for ctrl in [ddlGrau, ddlNIC, cbExtGland, cbQ1, cbQ2, cbQ3, cbQ4, cbViral, cbCerv, cbNaboth] {
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
        on := cbLIE.Value

        ddlGrau.Enabled := on
        ddlNIC.Enabled := on
        cbExtGland.Enabled := on

        cbQ1.Enabled := on
        cbQ2.Enabled := on
        cbQ3.Enabled := on
        cbQ4.Enabled := on

        if (!on) {
            cbExtGland.Value := 0
            cbQ1.Value := 0, cbQ2.Value := 0, cbQ3.Value := 0, cbQ4.Value := 0
        }
    }

    UpdatePreview() => edtPrev.Value := BuildText()

    BuildText() {
        linhas := []

        if (cbLIE.Value) {
            l := "Lesão intraepitelial cervical de " ddlGrau.Text " grau (NIC " ddlNIC.Text ")"
            if (cbExtGland.Value)
                l .= " extensiva às glândulas"
            linhas.Push(l)

                       ; Quadrantes selecionados (robusto)
            q1 := (cbQ1.Value != 0)
            q2 := (cbQ2.Value != 0)
            q3 := (cbQ3.Value != 0)
            q4 := (cbQ4.Value != 0)

            n := (q1?1:0) + (q2?1:0) + (q3?1:0) + (q4?1:0)

            if (n > 0) {
                if (n = 4) {
                    qTxt := "todos os quadrantes"
                } else {
                    qTxt := ""
                    if (q1) qTxt .= (qTxt="" ? "" : ", ") "12-3h"
                    if (q2) qTxt .= (qTxt="" ? "" : ", ") "3-6h"
                    if (q3) qTxt .= (qTxt="" ? "" : ", ") "6-9h"
                    if (q4) qTxt .= (qTxt="" ? "" : ", ") "9-12h"

                    ; transforma última vírgula em " e " quando tiver 2+ itens
                    if (n >= 2) {
                        pos := InStr(qTxt, ", ",, -1) ; última ocorrência
                        if (pos)
                            qTxt := SubStr(qTxt, 1, pos-1) " e " SubStr(qTxt, pos+2)
                    }
                }

                ; Lábio automático (sem GUI)
                hasAnt := (q1 || q4) ; 12-3 e/ou 9-12
                hasPos := (q2 || q3) ; 3-6 e/ou 6-9

                if (hasAnt && hasPos)
                    lab := "anterior e posterior"
                else if (hasAnt)
                    lab := "anterior"
                else
                    lab := "posterior"

                linhas.Push(". Localização: lábio " lab ", quadrantes " qTxt)
            }

        }

        if (cbViral.Value)
            linhas.Push("Efeito citopático sugestivo de infecção viral")

        if (cbCerv.Value)
            linhas.Push("Cervicite crônica com metaplasia escamosa")

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
