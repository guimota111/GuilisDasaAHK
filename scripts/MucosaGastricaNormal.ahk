; =========================================================
; Máscara — Mucosa Gástrica Normal
; =========================================================

Mask_MucosaGastricaNormal() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Mucosa Gástrica Normal")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm w180", "Localização da mucosa")
    ddlLocal := g.AddDropDownList("x+8 w200 Choose1", ["corpo", "antro", "corpo e antro"])

    g.AddText("xm y+12 w180", "H. pylori (Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w200 Choose1", ["negativa", "positiva"])

    g.AddButton("xm y+18 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    OnOK(*) {
        loc := ddlLocal.Text
        hp  := ddlHP.Text

        g.Destroy()
        try WinActivate("ahk_id " prevWin)
        try WinWaitActive("ahk_id " prevWin, , 1)
        Send "^b"
        SendText "- Mucosa sem particularidades histológicas."
        Send "^b"
        SendText "`n. Mucosa de " loc " com revestimento habitual, mantendo organização regular e maturação preservada.`n. Atrofia: ausente.`n. Metaplasia intestinal: ausente.`n. A pesquisa de "
        Send "^i"
        SendText "Helicobacter pylori"
        Send "^i"
        SendText " (Giemsa) resultou " hp ".`n. Ausência de evidências de malignidade nesta amostra."
    }
}
