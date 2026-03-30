; =========================================================
; Máscara — Biopsia de Estômago Normal
; =========================================================

Mask_EstomagoNormalBiopsia() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Biopsia de Estômago Normal")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm w180", "Localização da mucosa")
    ddlLocal := g.AddDropDownList("x+8 w200 Choose1", ["de corpo", "de antro", "de incisura", "de corpo e antro", "oxíntica", "de cárdia"])

    g.AddText("xm y+12 w180", "H. pylori (Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w220 Choose1", ["negativa.", "positiva (1+/3+).", "positiva (2+/3+).", "positiva (3+/3+)."])

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
        SendText "`n. Mucosa " loc " com revestimento habitual, mantendo organização regular e maturação preservada.`n. Atrofia: ausente.`n. Metaplasia intestinal: ausente.`n. A pesquisa de "
        Send "^i"
        SendText "Helicobacter pylori"
        Send "^i"
        SendText " (Giemsa) resultou " hp "`n. Ausência de evidências de malignidade."
    }
}
