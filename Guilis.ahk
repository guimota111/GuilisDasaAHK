#Requires AutoHotkey v2.0
#SingleInstance Force

TraySetIcon(A_ScriptDir "\Icones\Logo.ico")

; =========================================================
; INCLUDES
; =========================================================
#Include scripts\utils.ahk
#Include scripts\atalhos.ahk
#Include scripts\carimbos.ahk
#Include scripts\MenuGUI.ahk
#Include scripts\GastroGUI.ahk
#Include scripts\Gestor.ahk

; --- Estômago ---
#Include scripts\EstomagoNormalBiopsia.ahk

; --- Cólon ---
#Include scripts\ColonNormal.ahk

; =========================================================
; MENU
; =========================================================
Estomago := Menu()
Estomago.Add("&1 Mucosa Normal", (*) => Mask_EstomagoNormalBiopsia())

Colon := Menu()
Colon.Add("&1 Cólon Normal", (*) => Mask_ColonNormal())

Gastro := Menu()
Gastro.Add("&1 Estômago", Estomago)
Gastro.Add("&2 Cólon",    Colon)

Residentes := Menu()
Staffs     := Menu()
Carimbos   := Menu()
Carimbos.Add("&1 Adicionar carimbo",  (*) => GuiNovoCarimbo())
Carimbos.Add("&2 Gerenciar carimbos", (*) => GuiVerCarimbos())
Carimbos.Add()
Carimbos.Add("&3 Residentes", Residentes)
Carimbos.Add("&4 Staffs",     Staffs)
InicializarCarimbos(Residentes, Staffs)

Guilis := Menu()
Guilis.Add("SISTEMA GUILIS", (*) => "")
Guilis.Disable("SISTEMA GUILIS")
Guilis.Add()
Guilis.Add("&1 Gastro",    Gastro)
Guilis.Add()
Guilis.Add("&0 Carimbos",  Carimbos)
Guilis.Add("&X Recarregar", (*) => Reload())
Guilis.Add()
Guilis.Add("&Q Sair", (*) => ExitApp())

; =========================================================
; HOTKEYS
; =========================================================
^k:: Guilis.Show()
^l:: MenuGUI_Show()
F5:: Reload()
