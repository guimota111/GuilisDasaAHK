; =========================================================
; Máscara — Vesícula Biliar — Colecistite Crônica Agudizada
; =========================================================

Mask_VesiculaBiliarAgudizada() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Vesícula Biliar — Agudizada")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm w380", "Linha opcional")
    g.SetFont("s10", "Segoe UI")
    cbSeios := g.AddCheckBox("xm y+8", "Seios de Rokitanski-Aschoff dilatados")

    g.AddButton("xm y+18 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    OnOK(*) {
        linhasReg := "`n. Mucosa revestida por epitélio colunar simples, sem atipias, com focos de exulceração, área de necrose e infiltrado neutrofílico."
                  . "`n. Lâmina própria e parede muscular com fibrose, focos de hemorragia e infiltrado inflamatório linfohistioplasmocitário."

        if cbSeios.Value
            linhasReg .= "`n. Seios de Rokitanski-Aschoff dilatados."

        linhasReg .= "`n. Ausência de neoplasia."

        g.Destroy()
        try WinActivate("ahk_id " prevWin)
        try WinWaitActive("ahk_id " prevWin, , 1)

        Send "^b"
        SendText "- Colecistite crônica agudizada."
        Send "^b"
        SendText linhasReg
        SendText "`n"
        Send "^b"
        SendText "- Colelitíase."
        Send "^b"
    }
}
