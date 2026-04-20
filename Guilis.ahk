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
#Include scripts\MucosaGastricaNormal.ahk
; IHQ Estômago
#Include scripts\IHQEstomago_pMMR_HER2neg.ahk
#Include scripts\IHQEstomago_pMMR_HER2neg_Peca.ahk
#Include scripts\GastriteInativa.ahk

#Include scripts\GastriteAtiva.ahk
#Include scripts\BordaUlceraHpPositivo.ahk
#Include scripts\BordaUlceraHpNegativo.ahk
#Include scripts\GastropReativa.ahk
#Include scripts\AltReativaDisc.ahk

; --- Duodeno ---
#Include scripts\DuodenoNormal.ahk
#Include scripts\DuodenoLeve.ahk
#Include scripts\DuodenoHeterotopia.ahk
#Include scripts\DuodenoHiperplasiaBrunner.ahk

; --- Vesícula Biliar ---
#Include scripts\VesiculaBiliarColecistite.ahk
#Include scripts\VesiculaBiliarAgudizada.ahk

; --- Cólon ---
#Include scripts\ColonNormal.ahk
#Include scripts\AdenocarcinomaColonPeca.ahk
#Include scripts\ColonColiteAtivaFocal.ahk
#Include scripts\ColonPolipoHiperplasicoInflamatorio.ahk

; =========================================================
; MENU
; =========================================================
IHQEstomago := Menu()
IHQEstomago.Add("&1 pMMR + HER2 neg (Biópsia)",      (*) => Mask_IHQEstomago_pMMR_HER2neg())
IHQEstomago.Add("&2 pMMR + HER2 neg (Peça Radical)", (*) => Mask_IHQEstomago_pMMR_HER2neg_Peca())

Estomago := Menu()
Estomago.Add("&1 Mucosa Normal",             (*) => Mask_MucosaGastricaNormal())
Estomago.Add("&2 Gastrite Inativa",          (*) => Mask_GastriteInativa())
Estomago.Add("&3 Gastrite Ativa",            (*) => Mask_GastriteAtiva())
Estomago.Add("&4 Borda de Úlcera Hp+",      (*) => Mask_BordaUlceraHpPositivo())
Estomago.Add("&5 Borda de Úlcera Hp-",      (*) => Mask_BordaUlceraHpNegativo())
Estomago.Add("&6 Gastropatia Reativa",       (*) => Mask_GastropReativa())
Estomago.Add("&7 Alt. Reativas Discretas",   (*) => Mask_AltReativaDisc())

Duodeno := Menu()
Duodeno.Add("&1 Duodeno Normal",  (*) => Mask_DuodenoNormal())
Duodeno.Add("&2 Duodenite Leve",  (*) => Mask_DuodenoLeve())
Duodeno.Add("&3 Heterotopia",              (*) => Mask_DuodenoHeterotopia())
Duodeno.Add("&4 Hiperplasia de Brunner",   (*) => Mask_DuodenoHiperplasiaBrunner())

VesiculaBiliar := Menu()
VesiculaBiliar.Add("&1 Colecistite Crônica", (*) => Mask_VesiculaBiliarColecistite())
VesiculaBiliar.Add("&2 Agudizada",           (*) => Mask_VesiculaBiliarAgudizada())

Colon := Menu()
Colon.Add("&1 Cólon Normal",             (*) => Mask_ColonNormal())
Colon.Add("&2 Adenocarcinoma (Peça)",    (*) => Mask_AdenocarcinomaColonPeca())
Colon.Add("&3 Colite Ativa Focal",                (*) => Mask_ColonColiteAtivaFocal())
Colon.Add("&4 Pólipo Hiperplásico/Inflamatório",  (*) => Mask_ColonPolipoHiperplasicoInflamatorio())

Gastro := Menu()
Gastro.Add("&1 Estômago",        Estomago)
Gastro.Add("&2 Duodeno",         Duodeno)
Gastro.Add("&3 Vesícula Biliar", VesiculaBiliar)
Gastro.Add("&4 Cólon",           Colon)
Gastro.Add()
Gastro.Add("&I IHQ",                IHQEstomago)

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
