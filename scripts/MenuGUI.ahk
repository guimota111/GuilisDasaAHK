; =========================================================
; MENU GUI — SISTEMA GUILIS (Ctrl+L)
; =========================================================

MenuGUI_Show() {
    global Gastro, Gineco, Dermato, Toracica, Mama, Uro, Neuro, Hemato, Cabeca
    global Notas, Cito, Imuno, Atalhos, Carimbos
    global gMenuGUI

    if IsSet(gMenuGUI) && IsObject(gMenuGUI)
        try gMenuGUI.Destroy()

    gMenuGUI := Gui("+AlwaysOnTop", "Sistema GUILIS")
    gMenuGUI.SetFont("s10", "Segoe UI")
    gMenuGUI.MarginX := 14
    gMenuGUI.MarginY := 12
    AplicarIcone(gMenuGUI, "Logo.ico")
    gMenuGUI.OnEvent("Escape", (*) => gMenuGUI.Destroy())

    ; ---- Título ----
    gMenuGUI.SetFont("s13 Bold", "Segoe UI")
    gMenuGUI.Add("Text", "xm w406 Center", "SISTEMA GUILIS")
    gMenuGUI.Add("Text", "xm y+8 w406 0x10")

    ; ---- Especialidades principais ----
    gMenuGUI.SetFont("s10", "Segoe UI")
    gMenuGUI.Add("Button", "xm y+10 w130", "&1 Gastro").OnEvent("Click", (*) => (gMenuGUI.Destroy(), GastroGUI_Show()))
    gMenuGUI.Add("Button", "x+8 w130", "&2 Gineco").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Gineco.Show()))
    gMenuGUI.Add("Button", "x+8 w130", "&3 Dermato").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Dermato.Show()))

    gMenuGUI.Add("Button", "xm y+6 w130", "&4 Torácica").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Toracica.Show()))
    gMenuGUI.Add("Button", "x+8 w130", "&5 Mama").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Mama.Show()))
    gMenuGUI.Add("Button", "x+8 w130", "&6 Uro").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Uro.Show()))

    gMenuGUI.Add("Button", "xm y+6 w130", "&7 Neuro").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Neuro.Show()))
    gMenuGUI.Add("Button", "x+8 w130", "&8 Hemato").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Hemato.Show()))
    gMenuGUI.Add("Button", "x+8 w130", "&9 Cabeça e pescoço").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Cabeca.Show()))

    ; ---- Separador ----
    gMenuGUI.Add("Text", "xm y+12 w406 0x10")

    ; ---- Seção secundária ----
    gMenuGUI.Add("Button", "xm y+10 w130", "&N Notas").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Notas.Show()))
    gMenuGUI.Add("Button", "x+8 w130", "&C Cito").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Cito.Show()))
    gMenuGUI.Add("Button", "x+8 w130", "&I Imuno-hist.").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Imuno.Show()))

    gMenuGUI.Add("Button", "xm y+6 w199", "&A Atalhos").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Atalhos.Show()))
    gMenuGUI.Add("Button", "x+8 w199", "&0 Carimbos").OnEvent("Click", (*) => (gMenuGUI.Destroy(), Carimbos.Show()))

    ; ---- Separador ----
    gMenuGUI.Add("Text", "xm y+12 w406 0x10")

    ; ---- Utilitários ----
    gMenuGUI.Add("Button", "xm y+10 w199", "&H Ajuda").OnEvent("Click", (*) => MsgBox(
        "SISTEMA GUILIS`n`nCtrl+K  = Menu original`nCtrl+L  = Este menu`nF5         = Recarregar programa", "Ajuda"))
    gMenuGUI.Add("Button", "x+8 w199", "&Q Sair do programa").OnEvent("Click", (*) => ExitApp())

    gMenuGUI.Show("w434")
}
