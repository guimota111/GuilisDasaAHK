; =========================================================
; Máscara — Gastropatia Reativa
; =========================================================

Mask_GastropReativa() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Gastropatia Reativa")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm w340", "Localização")
    g.SetFont("s10", "Segoe UI")
    ddlLocal := g.AddDropDownList("xm y+8 w340 Choose1", ["corpo e antro", "corpo", "antro", "antro e incisura"])

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w340", "Atrofia")
    g.SetFont("s10", "Segoe UI")
    ddlAtrofia := g.AddDropDownList("xm y+8 w340 Choose1", ["ausente", "leve", "moderada", "acentuada"])

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w340", "Metaplasia intestinal")
    g.SetFont("s10", "Segoe UI")
    ddlMeta := g.AddDropDownList("xm y+8 w340 Choose1", ["ausente", "leve", "moderada", "acentuada"])

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w340", "Helicobacter pylori (Giemsa)")
    g.SetFont("s10", "Segoe UI")
    ddlHP := g.AddDropDownList("xm y+8 w340 Choose1", ["negativa", "positiva", "não realizada"])

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w340", "Nota: sugestivo de lesão química")
    g.SetFont("s10", "Segoe UI")
    ddlNota := g.AddDropDownList("xm y+8 w340 Choose1", ["incluir", "não incluir"])

    g.AddButton("xm y+16 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    OnOK(*) {
        locais  := ["corpo e antro", "corpo", "antro", "antro e incisura"]
        localiz := locais[ddlLocal.Value]
        atrofia := ddlAtrofia.Text
        meta    := ddlMeta.Text
        hpIdx   := ddlHP.Value
        notaIdx := ddlNota.Value

        g.Destroy()
        try WinActivate("ahk_id " prevWin)
        try WinWaitActive("ahk_id " prevWin, , 1)

        Send "^b"
        SendText "- Gastropatia reativa."
        Send "^b"
        SendText "`n. Mucosa de " localiz " exibindo alterações reativas evidenciadas pela hiperplasia foveolar com transformação viliforme, depleção de mucina e basofilia citoplásmica."
        SendText "`n. Atrofia: " atrofia "."
        SendText "`n. Metaplasia intestinal: " meta "."

        if (hpIdx = 3) {
            SendText "`n. A pesquisa de "
            Send "^i"
            SendText "Helicobacter pylori"
            Send "^i"
            SendText " (Giemsa) não foi realizada."
        } else {
            hpResult := (hpIdx = 1) ? "negativa" : "positiva"
            SendText "`n. A pesquisa de "
            Send "^i"
            SendText "Helicobacter pylori"
            Send "^i"
            SendText " (Giemsa) resultou " hpResult "."
        }

        SendText "`n. Ausência de evidências de malignidade nesta amostra."

        if (notaIdx = 1)
            SendText "`nNota: os achados morfológicos são sugestivos de lesão química. Recomenda-se correlação com demais dados clínicos."
    }
}
