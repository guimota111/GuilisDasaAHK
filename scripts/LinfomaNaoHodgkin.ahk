; =========================================================
; Hematopatologia — Linfoma Não-Hodgkin
; Arquivo: scripts\LinfomaNaoHodgkin.ahk
; =========================================================

Mask_LinfomaNaoHodgkin() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Linfoma Não-Hodgkin")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. IMUNOFENÓTIPO E TIPO ---
    g.AddGroupBox("w760 h150", "Classificação do Linfoma")

    g.AddText("xp+15 yp+30 w110", "Imunofenótipo:")
    ddlFeno := g.AddDropDownList("x140 yp-3 w120 Choose1 +Tabstop", ["B", "T"])

    g.AddText("x35 y+40 w110", "Tipo de Linfoma:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", [
        "Folicular grau 1/2",
        "Folicular grau 3A",
        "Folicular grau 3B",
        "Difuso de grandes células, com perfil semelhante às células do centro germinativo",
        "Difuso de Grandes Células, com perfil semelhante às células pós centro germinativo",
        "Células no Manto clássico",
        "Células do Manto variante blastoide",
        "Células do Manto variante pleomórfico",
        "Linfoma Linfocítico Pequeno/Leucemia Linfocítica Crônica",
        "Zona Marginal",
        "Linfoblástico",
        "Linfoma Primário de Tecido Linfoide Associado à Mucosa (MALT)",
        "Rico em Células T e Histiócitos",
        "Células T Periféricas, sem outras especificações (SOE)",
        "Células T/NK Nasal",
        "Células T do Adulto",
        "Linfoma de Grandes Células Anaplásicas",
        "Angioimunoblástico"
    ])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+60", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r8 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlFeno, ddlTipo]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlFeno.Focus()
    UpdatePreview()

    Build() {
        res := "O perfil imuno-histoquímico, associado aos achados morfológicos, corrobora o diagnóstico de Linfoma Não-Hodgkin, imunofenótipo "
        res .= ddlFeno.Text ", tipo " ddlTipo.Text "."
        return res
    }
}