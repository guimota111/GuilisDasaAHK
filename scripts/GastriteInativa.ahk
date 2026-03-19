; =========================================================
; Máscara — Gastrite Crônica Inativa
; =========================================================

Mask_GastriteInativa() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Gastrite Inativa")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm w180", "Intensidade")
    ddlInt := g.AddDropDownList("x+8 w200 Choose1", ["leve", "moderada", "intensa"])

    g.AddText("xm y+10 w180", "Localização")
    ddlLocal := g.AddDropDownList("x+8 w200 Choose1", ["corpo", "antro", "corpo e antro"])

    g.AddText("xm y+10 w180", "Infiltrado mononuclear")
    ddlInfil := g.AddDropDownList("x+8 w200 Choose1", ["leve", "moderado", "acentuado"])

    g.AddText("xm y+10 w180", "Atrofia")
    ddlAtrofia := g.AddDropDownList("x+8 w200 Choose1", ["ausente", "leve", "moderada", "acentuada"])

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w400", "Metaplasia intestinal")
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm y+6 w180", "Presente/Ausente")
    ddlMI := g.AddDropDownList("x+8 w260 Choose1", ["ausente", "presente em corpo", "presente em antro", "presente em corpo e antro"])

    g.AddText("xm y+8 w180", "    Tipo")
    ddlMITipo := g.AddDropDownList("x+8 w200 Choose1", ["completa", "incompleta"])

    g.AddText("xm y+8 w180", "    Grau")
    ddlMIGrau := g.AddDropDownList("x+8 w200 Choose1", ["leve", "moderada", "intensa"])

    g.AddText("xm y+8 w180", "    Displasia")
    ddlMIDisp := g.AddDropDownList("x+8 w200 Choose1", ["sem", "com"])

    g.AddText("xm y+14 w180", "H. pylori (Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w200 Choose1", ["negativa", "positiva"])

    g.AddButton("xm y+18 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    OnOK(*) {
        int     := ddlInt.Text
        loc     := ddlLocal.Text
        infil   := ddlInfil.Text
        atrofia := ddlAtrofia.Text
        mi      := ddlMI.Text
        hp      := ddlHP.Text

        if mi = "ausente"
            linhaMI := "ausente"
        else
            linhaMI := mi ", tipo " ddlMITipo.Text ", " ddlMIGrau.Text ", " ddlMIDisp.Text " displasia"

        g.Destroy()
        try WinActivate("ahk_id " prevWin)
        try WinWaitActive("ahk_id " prevWin, , 1)
        Send "^b"
        SendText "- Gastrite crônica " int " e inativa."
        Send "^b"
        SendText "`n. Mucosa de " loc " com revestimento habitual, mantendo organização regular e maturação preservada.`n. Lâmina própria exibindo " infil " infiltrado mononuclear, sem atividade neutrofílica.`n. Atrofia: " atrofia ".`n. Metaplasia intestinal: " linhaMI ".`n. A pesquisa de "
        Send "^i"
        SendText "Helicobacter pylori"
        Send "^i"
        SendText " (Giemsa) resultou " hp ".`n. Ausência de evidências de malignidade nesta amostra."
    }
}
