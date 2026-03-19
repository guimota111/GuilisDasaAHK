; =========================================================
; MENU GUI — SISTEMA GUILIS (Ctrl+L)
; =========================================================

MenuGUI_Show() {
    global gMenuGUI

    if IsSet(gMenuGUI) && IsObject(gMenuGUI)
        try gMenuGUI.Destroy()

    gMenuGUI := Gui("+AlwaysOnTop", "Sistema GUILIS")
    gMenuGUI.SetFont("s10", "Segoe UI")
    gMenuGUI.MarginX := 14
    gMenuGUI.MarginY := 12
    AplicarIcone(gMenuGUI, "Logo.ico")
    gMenuGUI.OnEvent("Escape", (*) => gMenuGUI.Destroy())

    gMenuGUI.SetFont("s13 Bold", "Segoe UI")
    gMenuGUI.Add("Text", "xm w370 Center", "SISTEMA GUILIS")
    gMenuGUI.Add("Text", "xm y+8 w370 0x10")

    gMenuGUI.SetFont("s10", "Segoe UI")
    gMenuGUI.Add("Button", "xm y+10 w370", "&1 Gastro").OnEvent("Click", (*) => (gMenuGUI.Destroy(), GastroGUI_Show()))

    gMenuGUI.Add("Text", "xm y+12 w370 0x10")

    gMenuGUI.Add("Button", "xm y+10 w370", "&0 Carimbos").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Carimbos.Show()))

    gMenuGUI.Add("Text", "xm y+12 w370 0x10")

    gMenuGUI.Add("Button", "xm y+10 w178", "&H Ajuda").OnEvent("Click", (*) => MsgBox(
        "SISTEMA GUILIS`n`n"
        . "Ctrl+K  = Menu`n"
        . "Ctrl+L  = Este menu`n"
        . "F5         = Recarregar`n`n"
        . "=== ATALHOS ===`n"
        . "@olga           = Calcular OLGA/OLGIM`n"
        . "pgf               = Pólipo de glândulas fúndicas`n"
        . "estomagohiperplasico = Pólipo hiperplásico (completo)`n"
        . "phip              = Pólipo hiperplásico (curto)`n"
        . "atbdbg         = Adenoma tubular baixo grau`n"
        . "atbdag         = Adenoma tubular alto grau`n"
        . "hpn / hpp      = H. pylori negativa/positiva`n"
        . "dlhn              = dentro dos limites histológicos...", "Ajuda"))
    gMenuGUI.Add("Button", "x+8 w178", "&Q Sair").OnEvent("Click", (*) => ExitApp())

    gMenuGUI.Show("w398")
}
