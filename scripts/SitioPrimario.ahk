; =========================================================
; Imuno-histoquímica — Sugestão de Sítio Primário
; Arquivo: scripts\SitioPrimario.ahk
; =========================================================

Mask_SitioPrimario() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Perfil Imuno-histoquímico")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. SELEÇÃO DO PERFIL ---
    g.AddGroupBox("w760 h110", "Diagnóstico e Origem")

    g.AddText("xp+15 yp+30 w110", "Tipo de Neoplasia:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", [
        "Adenocarcinoma",
        "Carcinoma de células escamosas",
        "Carcinoma"
    ])

    g.AddText("x35 y+40 w110", "Provável Origem:")
    ddlOrigem := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", [
        "colônica", "pulmonar", "em colo uterino", "em trato digestivo superior",
        "em trato pancreático-biliar", "endometrial", "hepática", "mamária",
        "ovariana", "urotelial", "renal", "prostática", "em glândulas salivares", "tireoidiana"
    ])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r6 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlTipo, ddlOrigem]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlTipo.Focus()
    UpdatePreview()

    Build() {
        res := "O perfil imuno-histoquímico, associado aos achados morfológicos, corrobora o diagnóstico de metástase de "
        res .= ddlTipo.Text " de provável origem " ddlOrigem.Text "."
        return res
    }
}