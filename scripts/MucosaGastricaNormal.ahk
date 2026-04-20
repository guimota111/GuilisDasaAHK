; =========================================================
; Máscara — Mucosa Gástrica Normal
; =========================================================

Mask_MucosaGastricaNormal() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Mucosa Gástrica Normal")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm w180", "Localização da mucosa")
    ddlLocal := g.AddDropDownList("x+8 w200 Choose1", ["corpo", "antro", "corpo e antro", "antro e incisura", "corpo, antro e incisura"])

    g.AddText("xm y+12 w100", "H. pylori")
    chkGiemsa := g.AddCheckbox("x+6 w110 Checked", "(Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w200 Choose1", ["negativa", "positiva (+/3+)", "positiva (2+/3+)", "positiva (3+/3+)"])

    g.AddButton("xm y+18 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    OnOK(*) {
        loc      := ddlLocal.Text
        hp       := ddlHP.Text
        hpSufixo := chkGiemsa.Value ? " (Giemsa)" : ""

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
        SendText hpSufixo " resultou " hp ".`n. Ausência de evidências de malignidade nesta amostra."
    }
}
