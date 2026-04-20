; =========================================================
; Máscara — Vesícula Biliar — Colecistite Crônica
; =========================================================

Mask_VesiculaBiliarColecistite() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Vesícula Biliar — Colecistite Crônica")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm w380", "Colecistite crônica")
    g.SetFont("s10", "Segoe UI")
    cbCalculosa   := g.AddCheckBox("xm y+8",  "Calculosa")
    cbCalculosa.Value := 1

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w380", "Linhas opcionais (corpo do laudo)")
    g.SetFont("s10", "Segoe UI")
    cbColesterolose := g.AddCheckBox("xm y+8",  "Colesterolose")
    cbMetInt        := g.AddCheckBox("xm y+6",  "Metaplasia intestinal")
    cbMetPseudo     := g.AddCheckBox("xm y+6",  "Metaplasia pseudopilórica")
    cbSeios         := g.AddCheckBox("xm y+6",  "Seios de Rokitanski-Aschoff dilatados")
    cbAdenomio      := g.AddCheckBox("xm y+6",  "Adenomiomatose")

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w380", "Linhas adicionais em negrito (opcionais)")
    g.SetFont("s10", "Segoe UI")
    cbLinfonodo := g.AddCheckBox("xm y+8", "Linfonodo peri-cístico com hiperplasia linfoide reacional")
    cbHepatico  := g.AddCheckBox("xm y+6", "Rima de tecido hepático aderido")

    g.AddButton("xm y+18 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    OnOK(*) {
        titulo      := cbCalculosa.Value   ? "- Colecistite crônica calculosa." : "- Colecistite crônica."
        vColest     := cbColesterolose.Value
        vMetInt     := cbMetInt.Value
        vMetPseudo  := cbMetPseudo.Value
        vSeios      := cbSeios.Value
        vAdenomio   := cbAdenomio.Value
        vLinfonodo  := cbLinfonodo.Value
        vHepatico   := cbHepatico.Value

        linhasReg := ""
        if vColest
            linhasReg .= "`n. Colesterolose."

        if (vMetInt && vMetPseudo)
            linhasReg .= "`n. Presença de focos de metaplasia intestinal e pseudopilórica."
        else if vMetInt
            linhasReg .= "`n. Presença de focos de metaplasia intestinal."
        else if vMetPseudo
            linhasReg .= "`n. Presença de focos de metaplasia pseudopilórica."

        if vSeios
            linhasReg .= "`n. Seios de Rokitanski-Aschoff dilatados."

        linhasReg .= "`n. Ausência de neoplasia."

        if vAdenomio
            linhasReg .= "`n. Presença de adenomiomatose."

        g.Destroy()
        try WinActivate("ahk_id " prevWin)
        try WinWaitActive("ahk_id " prevWin, , 1)

        ; Título em negrito
        Send "^b"
        SendText titulo
        Send "^b"
        SendText linhasReg

        ; Linha do linfonodo (negrito)
        if vLinfonodo {
            SendText "`n"
            Send "^b"
            SendText "- Linfonodo peri-cístico com hiperplasia linfoide reacional."
            Send "^b"
        }

        ; Linha do tecido hepático (negrito)
        if vHepatico {
            SendText "`n"
            Send "^b"
            SendText "- Rima de tecido hepático aderido com artefatos pré-analíticos de fulguração, discreto infiltrado inflamatório linfocitário periportal e esteatose discreta."
            Send "^b"
        }
    }
}
