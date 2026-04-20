; =========================================================
; Máscara — Borda de Úlcera Hp+
; =========================================================

Mask_BordaUlceraHpPositivo() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Borda de Úlcera Hp+")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm w180", "Mucosa")
    ddlMucosa := g.AddDropDownList("x+8 w200 Choose1", ["antral", "fúndica", "de corpo", "de transição corpo-antro"])

    g.AddText("xm y+10 w180", "Intensidade")
    ddlInt := g.AddDropDownList("x+8 w200 Choose1", ["leve", "moderada", "intensa"])

    g.AddText("xm y+10 w180", "Atrofia")
    ddlAtrofia := g.AddDropDownList("x+8 w200 Choose1", ["ausente", "leve", "moderada", "acentuada"])

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w400", "Metaplasia intestinal")
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm y+6 w180", "Presente/Ausente")
    ddlMI := g.AddDropDownList("x+8 w260 Choose1", ["ausente", "presente", "presente em corpo", "presente em antro", "presente em corpo e antro"])

    g.AddText("xm y+8 w180", "    Tipo")
    ddlMITipo := g.AddDropDownList("x+8 w200 Choose1", ["completa", "incompleta", "completa e incompleta"])

    g.AddText("xm y+8 w180", "    Grau")
    ddlMIGrau := g.AddDropDownList("x+8 w200 Choose1", ["leve", "moderada", "intensa"])

    g.AddText("xm y+8 w180", "    Displasia")
    ddlMIDisp := g.AddDropDownList("x+8 w200 Choose1", ["sem", "com"])

    g.AddText("xm y+14 w100", "H. pylori")
    chkGiemsa := g.AddCheckbox("x+6 w110 Checked", "(Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w200 Choose2", ["negativa", "positiva (1+/3+)", "positiva (2+/3+)", "positiva (3+/3+)"])

    g.AddButton("xm y+18 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    OnOK(*) {
        mucosa   := ddlMucosa.Text
        int      := ddlInt.Text
        atrofia  := ddlAtrofia.Text
        mi       := ddlMI.Text
        hp       := ddlHP.Text
        hpSufixo := chkGiemsa.Value ? " (Giemsa)" : ""

        if mi = "ausente"
            linhaMI := "ausente"
        else
            linhaMI := mi ", tipo " ddlMITipo.Text ", " ddlMIGrau.Text ", " ddlMIDisp.Text " displasia"

        g.Destroy()
        try WinActivate("ahk_id " prevWin)
        try WinWaitActive("ahk_id " prevWin, , 1)
        Send "^b"
        SendText "- Gastrite crônica " int ", em atividade, em mucosa de padrão " mucosa ", compatível com borda de úlcera."
        Send "^b"
        SendText "`n. Atrofia: " atrofia ".`n. Metaplasia intestinal: " linhaMI ".`n. Pesquisa de "
        Send "^i"
        SendText "Helicobacter pylori"
        Send "^i"
        SendText hpSufixo " resultou " hp ".`n. Ausência de evidências de malignidade nesta amostra.`n`nNota: Mucosa com intensas alterações epiteliais de aspectos reativo e regenerativo. Recomenda-se, a critério clínico, nova amostragem após tratamento."
    }
}
