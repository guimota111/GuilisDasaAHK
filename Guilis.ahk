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

; --- Máscaras Gástricas ---
#Include scripts\MucosaGastricaNormal.ahk
#Include scripts\GastriteInativa.ahk
#Include scripts\GastriteAtiva.ahk

; --- Vesícula Biliar ---
#Include scripts\VesiculaBiliarColecistite.ahk
#Include scripts\VesiculaBiliarAgudizada.ahk

; =========================================================
; MENU
; =========================================================
Estomago := Menu()
Estomago.Add("&1 Mucosa Normal",    (*) => Mask_MucosaGastricaNormal())
Estomago.Add("&2 Gastrite Inativa", (*) => Mask_GastriteInativa())
Estomago.Add("&3 Gastrite Ativa",   (*) => Mask_GastriteAtiva())

VesiculaBiliar := Menu()
VesiculaBiliar.Add("&1 Colecistite Crônica", (*) => Mask_VesiculaBiliarColecistite())
VesiculaBiliar.Add("&2 Agudizada",           (*) => Mask_VesiculaBiliarAgudizada())

Gastro := Menu()
Gastro.Add("&1 Estômago",       Estomago)
Gastro.Add("&2 Vesícula Biliar", VesiculaBiliar)

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
