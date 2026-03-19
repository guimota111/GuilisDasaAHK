; =========================================================
; Hematopatologia — Linfoma de Hodgkin
; Arquivo: scripts\LinfomaHodgkin.ahk
; =========================================================

Mask_LinfomaHodgkin() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Linfoma de Hodgkin")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CLASSIFICAÇÃO ---
    g.AddGroupBox("w760 h120", "Classificação Histológica")

    g.AddText("xp+15 yp+30 w110", "Tipo de Linfoma:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", [
        "Clássico, tipo Esclerose Nodular",
        "Clássico, tipo Rico em Linfócitos",
        "Clássico, tipo Celularidade Mista",
        "Clássico, tipo Depleção Linfocitária",
        "Predominância Linfocitário Nodular"
    ])

    g.AddText("x35 y+40 w110", "Padrão (se PLN):")
    edtPadrao := g.AddEdit("x140 yp-3 w605 +Disabled +Tabstop", "")
    g.AddText("x140 y+5 cGray", "Especifique o padrão para o tipo Predominância Linfocitário Nodular.")

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r6 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) {
        ; Habilita/Desabilita campo de padrão baseado na escolha
        if (ddlTipo.Text = "Predominância Linfocitário Nodular")
            edtPadrao.Enabled := true
        else
            edtPadrao.Enabled := false

        edtPrev.Value := Build()
    }

    controles := [ddlTipo, edtPadrao]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlTipo.Focus()
    UpdatePreview()

    Build() {
        res := "O perfil imuno-histoquímico, associado aos achados morfológicos, corrobora o diagnóstico de Linfoma de Hodgkin "

        if (ddlTipo.Text = "Predominância Linfocitário Nodular") {
            padrao := edtPadrao.Value || "[especificar padrão]"
            res .= "Predominância Linfocitário Nodular, padrão " padrao "."
        } else {
            res .= ddlTipo.Text "."
        }

        return res
    }
}