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

; --- Próstata ---
#Include scripts\ProstataBenigna.ahk
#Include scripts\ProstataBiopsiaTumor.ahk
#Include scripts\RTUmaligno.ahk
#Include scripts\ProstataTumorPeca.ahk

; --- Mama ---
#Include scripts\MamaBenigna.ahk
#Include scripts\MamaBiopsiaTumor.ahk
#Include scripts\MamaFiloide.ahk
#Include scripts\MamaMastectomia.ahk
#Include scripts\MamaProtocoloQT.ahk
#Include scripts\MamaQuadrante.ahk
#Include scripts\MamaTumorQT.ahk
#Include scripts\EstadiamentoMama.ahk
#Include scripts\EstadiamentoRim.ahk
#Include scripts\PAAFmama.ahk
#Include scripts\ihqmama.ahk

; --- Gastrointestinal ---
#Include scripts\gastrite.ahk
#Include scripts\gastritenovo.ahk
#Include scripts\ApendiceNormal.ahk
#Include scripts\ApendiceTumor.ahk
#Include scripts\ApendiceNet.ahk
#Include scripts\ColonBiopsiaColiteCronica.ahk
#Include scripts\ColonBiopsiaTumor.ahk
#Include scripts\ColonNetPeca.ahk
#Include scripts\ColonTumorPeca.ahk
#Include scripts\ColonTumorPediculado.ahk
#Include scripts\ColonTumorSessil.ahk
#Include scripts\DuodenoBiopsiaCeliaca.ahk
#Include scripts\DuodenoBiopsiaDuodenite.ahk
#Include scripts\DuodenoNormalBiopsia.ahk
#Include scripts\EstomagoBiopsiaTumor.ahk
#Include scripts\EstomagoNetPeca.ahk
#Include scripts\EstomagoNormal.ahk
#Include scripts\EstomagoTumorPeca.ahk
#Include scripts\EsofagoBiopsiaEsofagite.ahk
#Include scripts\EsofagoBiopsiaTumor.ahk
#Include scripts\TumorEsofagoPeca.ahk
#Include scripts\EstadiamentoEstomago.ahk
#Include scripts\EstadiamentoEstomagoNet.ahk
#Include scripts\EstadiamentoColon.ahk

; --- Pele e Dermatopatologia ---
#Include scripts\PeleNormal.ahk
#Include scripts\PeleCbc.ahk
#Include scripts\PeleCec.ahk
#Include scripts\PeleMelanoma.ahk
#Include scripts\PeleNevo.ahk
#Include scripts\PeleQueratose.ahk
#Include scripts\PeleLupus.ahk
#Include scripts\DermatiteEstase.ahk
#Include scripts\DermHiperplasiaEpidermica.ahk
#Include scripts\DermPerivascularSuperficial.ahk
#Include scripts\Alopecia.ahk
#Include scripts\hanseniase.ahk

; --- Gineco / Trato Urinário ---
#Include scripts\ColoUtBenigno.ahk
#Include scripts\ColoUtBiopsia.ahk
#Include scripts\ColoUtTumorPeca.ahk
#Include scripts\CorpoBenigno.ahk
#Include scripts\EndometrioBiopsiaBenigno.ahk
#Include scripts\UteroBiopsiaTumor.ahk
#Include scripts\UteroConeNic.ahk
#Include scripts\UteroTumorEndometrio.ahk
#Include scripts\OvarioBenigno.ahk
#Include scripts\OvarioTumor.ahk
#Include scripts\TubaUterina.ahk
#Include scripts\BexigaBiopsiaTumor.ahk
#Include scripts\BexigaTumorPeca.ahk
#Include scripts\CitologiaUrina.ahk

; --- Cabeça, Pescoço e Glândulas ---
#Include scripts\TireoideBenigna.ahk
#Include scripts\TireoideTumorPeca.ahk
#Include scripts\PAAFtireoide.ahk
#Include scripts\SalivaresOutrosMalignas.ahk
#Include scripts\AdenocaPleomorfico.ahk
#Include scripts\AdenoideCistico.ahk
#Include scripts\Mucoepidermoide.ahk
#Include scripts\CarcinomaBoca.ahk
#Include scripts\CarcinomaExAdenoma.ahk
#Include scripts\AdrenalMaligna.ahk
#Include scripts\EstadiamentoTireoide.ahk

; --- Outros / Notas ---
#Include scripts\Linfonodos.ahk
#Include scripts\LinfomaHodgkin.ahk
#Include scripts\LinfomaNaoHodgkin.ahk
#Include scripts\BMOHE.ahk
#Include scripts\GliomaDifusoHE.ahk
#Include scripts\Meningioma.ahk
#Include scripts\Neuroblastoma.ahk
#Include scripts\RimNefrectomiaTotal.ahk
#Include scripts\RimWilms.ahk
#Include scripts\Sarcomas.ahk
#Include scripts\NotaImuno.ahk
#Include scripts\NotaColoracao.ahk
#Include scripts\NotaBichos.ahk
#Include scripts\NotaAprofundamento.ahk
#Include scripts\CitologiaGeral.ahk
#Include scripts\CervicoVaginal.ahk
#Include scripts\AmostraInadequada.ahk
#Include scripts\IHQ.ahk
#include scripts\ConeCecMicroinvasor.ahk
#include scripts\GDPtumorEmPapila.ahk
#include scripts\GDPnet.ahk
#include scripts\IntestinoNormalBiopsia.ahk
#include scripts\ColonNetPeca.ahk
#include scripts\PulmaoTumorBiopsia.ahk
#include scripts\PulmaoTumorPeca.ahk
#include scripts\CelsFusiformes.ahk
#include scripts\RimNefrectomiaParcial.ahk
#include scripts\RimExclusao.ahk
#include scripts\RimWilmsQT.ahk
#Include scripts\TesticuloGerminativas.ahk
#Include scripts\PenisCec.ahk
#Include scripts\SNCMetastase.ahk
#include scripts\TireoideTumorPecam.ahk
#Include scripts\milao.ahk
#Include scripts\ihqmama.ahk
#include scripts\SitioPrimario.ahk
#include scripts\ihqestomago.ahk
#include scripts\ihqpulmao.ahk
#Include scripts\BuscarLaudo.ahk

; (Mantenha seus Includes de scripts aqui...)

; =========================================================
; 1. DEFINIÇÃO DOS SUB-SUBMENUS (Crie estes primeiro)
; =========================================================
Estomago := Menu()
Esofago  := Menu()
Duodeno  := Menu()
Apendice := Menu()
Colon    := Menu()
ColoUterino := Menu()
CorpoUterino := Menu()
Tuba := Menu()
Ovario := Menu()
PeleInflamatoria := Menu()
Rim := Menu()
Bexiga := Menu()
Prostata := Menu()
Adrenal := Menu()
Testiculo := Menu()
Penis := Menu()
Tireoide := Menu()
Salivares := Menu()
Boca := Menu()
Nasofaringe := Menu()
Laringe := Menu()
ColonNormal := Menu()
Residentes := Menu()
Staffs := Menu()


; =========================================================
; 2. DEFINIÇÃO DOS SUBMENUS PRINCIPAIS
; =========================================================
Gastro   := Menu()
Gineco   := Menu()
Dermato  := Menu()
Toracica := Menu()
Mama     := Menu()
Uro      := Menu()
Neuro    := Menu()
Hemato   := Menu()
Cabeca   := Menu()
Atalhos  := Menu()
Notas    := Menu()
Cito     := Menu()
Imuno        := Menu()
Carimbos     := Menu()
Estadiamento := Menu()



; ==============================================================================
; 1. GASTROINTESTINAL
; ==============================================================================
Gastro.Add("&1 Estômago", Estomago)
Gastro.Add("&2 Esôfago", Esofago)
Gastro.Add("&3 Duodeno", Duodeno)
Gastro.Add("&4 Apêndice", Apendice)
Gastro.Add("&5 Cólon", Colon)

Estomago.Add("&1 Gastrite", (*) => Gastrite_Run())
Estomago.Add("&2 Estômago Normal", (*) => Mask_EstomagoNormal())
Estomago.Add("&3 Biopsia de Tumor", (*) => Mask_EstomagoBiopsiaTumor())
Estomago.Add("&4 Tumor em Peça", (*) => Mask_EstomagoTumorPeca())
Estomago.Add("&5 Net em Peça", (*) => Mask_EstomagoNetPeca())

Esofago.Add("&1 Esofagite", (*) => Mask_EsofagoBiopsiaEsofagite())
Esofago.Add("&2 Biopsia de Tumor", (*) => EstomagoBiopsiaTumor_Run())
Esofago.Add("&3 Tumor em Peça", (*) => Mask_TumorEsofagoPeca())

Duodeno.Add("&1 Duodeno normal", (*) => Mask_DuodenoNormalBiopsia())
Duodeno.Add("&2 Biopsia de Duodenite", (*) => Mask_DuodenoBiopsiaDuodenite())
Duodeno.Add("&3 Biopsia de Doença Celíaca", (*) => Mask_DuodenoBiopsiaCeliaca())
Duodeno.Add("&4 Tumor em papila", (*) => Mask_GDPtumorEmPapila())
Duodeno.Add("&5 NET (papila/duodeno)", (*) => Mask_GDPnet())

Apendice.Add("&1 Apêndice Normal", (*) => Mask_ApendiceNormal())
Apendice.Add("&2 Tumor", (*) => Mask_ApendiceTumor())
Apendice.Add("&3 NET", (*) => Mask_ApendiceNet())

Colon.Add("&1 Colon normal", ColonNormal)
Colon.Add("&2 Biopsia Colite Crônica", (*) => Mask_ColonBiopsiaColiteCronica())
Colon.Add("&3 Biopsia de Tumor", (*) => Mask_ColonBiopsiaTumor())
Colon.Add("&4 Tumor em Peça", (*) => Mask_ColonTumorPeca())
Colon.Add("&5 NET em peça", (*) => Mask_ColonNetPeca())
Colon.Add("&6 Tumor Pediculado", (*) => Mask_ColonTumorPediculado())
Colon.Add("&7 Tumor Sessil", (*) => Mask_ColonTumorSessil())

ColonNormal.Add("&1 Ileo", (*) => Mask_IleoBiopsiaNormal())
ColonNormal.Add("&2 Colon", (*) => Mask_ColonBiopsiaNormal())
ColonNormal.Add("&3 Reto", (*) => Mask_RetoBiopsiaNormal())


; ==============================================================================
; 2. GINECO
; ==============================================================================
Gineco.Add("&1 Colo uterino", ColoUterino)
Gineco.Add("&2 Corpo uterino", CorpoUterino)
Gineco.Add("&3 Tuba uterina", Tuba)
Gineco.Add("&4 Ovário", Ovario)

Ovario.Add("&1 Tumor benigno", (*) => Mask_OvarioBenigno())
Ovario.Add("&2 Tumor maligno", (*) => Mask_OvarioTumor())

ColoUterino.Add("&1 Biopsia de Tumor", (*) => Mask_ColoUtBiopsia())
ColoUterino.Add("&2 Colo benigno (peça)", (*) => Mask_ColoUterinoBenigno())
ColoUterino.Add("&3 Cone Nic", (*) => Mask_UteroConeNic())
ColoUterino.Add("&4 Cone Cec Microinvasor", (*) => Mask_ConeCecMicroinvasor())
ColoUterino.Add("&5 Tumor peça", (*) => Mask_ColoUtTumorPeca())

CorpoUterino.Add("&1 Biopsia Benigno", (*) => Mask_EndometrioBiopsiaBenigno())
CorpoUterino.Add("&2 Biopsia Tumor", (*) => Mask_UteroBiopsiaTumor())
CorpoUterino.Add("&3 Peça normal", (*) => Mask_CorpoBenigno())
CorpoUterino.Add("&4 Tumor peça", (*) => Mask_UteroTumorEndometrio())

Tuba.Add("&1 Tuba normal", (*) => Tuba_Normal())
Tuba.Add("&2 Hidátide", (*) => Tuba_Hidatide_Singular())
Tuba.Add("&3 Hidátides", (*) => Tuba_Hidatide_Plural())
Tuba.Add("&4 Cistoadenoma seroso", (*) => Tuba_Cistoadenoma_Seroso())
Tuba.Add("&5 Hematossalpinge", (*) => Tuba_Hematossalpinge())
Tuba.Add("&6 Hidrossalpinge", (*) => Tuba_Hidrossalpinge())
Tuba.Add("&7 Salpingite aguda", (*) => Tuba_salpingite_Aguda())

; ==============================================================================
; 3. DERMATO
; ==============================================================================
Dermato.Add("&1 CEC", (*) => Mask_PeleCec())
Dermato.Add("&2 CBC", (*) => Mask_PeleCbc())
Dermato.Add("&3 Queratose", (*) => Mask_PeleQueratose())
Dermato.Add("&4 Nevo", (*) => Mask_PeleNevo())
Dermato.Add("&5 Melanoma", (*) => Mask_PeleMelanoma())
Dermato.Add("&6 Pele inflamatória", PeleInflamatoria)

PeleInflamatoria.Add("&1 Pele normal", (*) => Mask_PeleNormal())
PeleInflamatoria.Add("&2 Hiperplasia Epidérmica", (*) => Mask_DermHiperplasiaEpidermica())
PeleInflamatoria.Add("&3 Perivascular superficial", (*) => Mask_DermPerivascularSuperficial())
PeleInflamatoria.Add("&4 Alopecia", (*) => Mask_Alopecia())
PeleInflamatoria.Add("&5 Hanseníase", (*) => Mask_hanseniase())
PeleInflamatoria.Add("&6 Lupus", (*) => Mask_PeleLupus())
PeleInflamatoria.Add("&7 Dermatite de estase", (*) => Mask_DermatiteEstase())

; ==============================================================================
; 4. TORÁCICA E PARTES MOLES
; ==============================================================================
Toracica.Add("&1 Pulmao Biopsia", (*) => Mask_PulmaoTumorBiopsia())
Toracica.Add("&2 Pulmao Peça", (*) => Mask_PulmaoTumorPeca())
Toracica.Add()
Toracica.Add("&3 Lesão fusiformes descrever", (*) => Mask_CelsFusiformes())
Toracica.Add("&4 Sarcomas", (*) => Mask_Sarcomas())

; ==============================================================================
; 5. MAMA
; ==============================================================================
Mama.Add("&1 Benigna", (*) => Mask_MamaBenigna())
Mama.Add("&2 Biopsia de Tumor", (*) => Mask_MamaBiopsiaTumor())
Mama.Add("&3 Filoide", (*) => Mask_MamaFiloide())
Mama.Add("&4 Mastectomia", (*) => Mask_MamaMastectomia())
Mama.Add("&5 Quadrante", (*) => Mask_MamaQuadrante())
Mama.Add("&6 Tumor QT", (*) => Mask_MamaTumorQT())
Mama.Add("&7 Protocolo QT", (*) => Mask_MamaProtocoloQT())

; ==============================================================================
; 6. URO
; ==============================================================================
Uro.Add("&1 Rim", Rim)
Uro.Add("&2 Bexiga", Bexiga)
Uro.Add("&3 Prostata", Prostata)
Uro.Add("&4 Testículo", Testiculo)
Uro.Add("&5 Pênis", Penis)
Uro.Add("&6 Adrenal", Adrenal)

Rim.Add("&1 Nefrectomia Total", (*) => Mask_RimNefrectomiaTotal())
Rim.Add("&2 Nefrectomia Parcial", (*) => Mask_RimNefrectomiaParcial())
Rim.Add("&3 Rim de esclusão", (*) => Mask_RimExclusao())
Rim.Add("&4 Tumor de Wilms", (*) => Mask_RimWilms())
Rim.Add("&5 Protocolo Wilms", (*) => Mask_RimWilmsQT())

Bexiga.Add("&1 Tumor biopsia", (*) => Mask_BexigaBiopsiaTumor())
Bexiga.Add("&2 Tumor peça", (*) => Mask_BexigaTumorPeca())

Prostata.Add("&1 HPB", (*) => Mask_ProstataBenigna())
Prostata.Add("&2 Tumor biopsia", (*) => Mask_ProstataBiopsiaTumor())
Prostata.Add("&3 Tumor RTU",(*) => Mask_RTUmaligno())
Prostata.Add("&4 Tumor peça", (*) => Mask_ProstataTumorPeca())

Adrenal.Add("&1 Maligna", (*) => Mask_AdrenalMaligna())

Testiculo.Add("&1 Tu de células germinativas", (*) => Mask_TesticuloGerminativas())

Penis.Add("&1 Tumor", (*) => Mask_PenisCEC())


; ==============================================================================
; 7. NEURO
; ==============================================================================

Neuro.Add("&1 Meningioma", (*) => Mask_Meningioma())
Neuro.Add("&2 Glioma Difuso", (*) => Mask_GliomaDifusoHE())
Neuro.Add("&3 Neuroblastoma", (*) => Mask_Neuroblastoma())
Neuro.Add("&4 Metástase cerebral", (*) => Mask_SNCMetastase())

; ==============================================================================
; 8. HEMATO
; ==============================================================================

Hemato.Add("&1 Linfonodos", (*) => Mask_Linfonodos())
Hemato.Add("&2 BMO", (*) => Mask_BMOHE())

; ==============================================================================
; 9. CABEÇA E PESCOÇO
; ==============================================================================
Cabeca.Add("&1 Tireoide", Tireoide)
Cabeca.Add("&2 Glândulas Salivares", Salivares)
Cabeca.Add("&3 Boca", Boca)
Cabeca.Add("&4 Nasofaringe", Nasofaringe)
Cabeca.Add("&5 Laringe", Laringe)

Nasofaringe.Add("&1 Tumor de nasofaringe", (*) => MsgBox("Função não implementada"))

Laringe.Add("&1 Tumor de laringe", (*) => MsgBox("Função não implementada"))

Tireoide.Add("&1 Benigna", (*) => Mask_TireoideBenigna())
Tireoide.Add("&2 Tumor em peça", (*) => Mask_TireoideTumor())
Tireoide.Add("&3 Tumor multiplos focos", (*) => Mask_TireoideTumorPecam())

Salivares.Add("&1 Adenocarcinoma Pleomorfico", (*) => Mask_AdenocaPolimorfico())
Salivares.Add("&2 Adenoide Cístico", (*) => Mask_AdenoideCistico())
Salivares.Add("&3 Mucoepidermoide", (*) => Mask_Mucoepidermoide())
Salivares.Add("&4 Carcinoma ex adenoma", (*) => Mask_CarcinomaExAdenoma())
Salivares.Add("&5 Outras malignas", (*) => Mask_SalivaresOutrasMalignas())


Boca.Add("&1 Carcinoma de boca", (*) => Mask_CarcinomaBoca())


; ==============================================================================
; A. ATALHOS / N. NOTAS / C. CITO / I. IMUNO / 0. CARIMBOS
; ==============================================================================
Atalhos := Menu()

Atalhos.Add("&1 Adicionar novo atalho", (*) => GuiNovoAtalho())
Atalhos.Add("&2 Gerenciar atalhos", (*) => GuiVerAtalhos())

Notas.Add("&1 Imuno", (*) => Mask_NotaImuno())
Notas.Add("&2 Coloracao", (*) => Mask_NotaColoracao())
Notas.Add("&3 Bichos", (*) => Mask_NotaBichos())
Notas.Add("&4 Aprofundamento", (*) => Mask_NotaAprofundamento())
Notas.Add("&5 Amostra inadequada", (*) => Mask_NotasInadequada() )


Cito.Add("&1 PAAF mama", (*) => Mask_PAAFmama())
Cito.Add("&2 PAAF tireoide", (*) => Mask_PAAFtireoide())
Cito.Add("&3 PAAF glândulas salivares", (*) => Mask_Milan())
Cito.Add("&4 Citologia de urina", (*) => Mask_CitologiaUrina())
Cito.Add("&5 Citologia geral", (*) => Mask_CitologiaGeral())
Cito.Add("&6 Cervicovaginal (Papanicolau)", (*) => Mask_CervicoVaginal())

Imuno.Add("&1 IHQ mama", (*) => Mask_IhqMama())
Imuno.Add("&2 Sitio primario", (*) => Mask_SitioPrimario())
Imuno.Add("&3 IHQ linfoma de Hodgkin", (*) => Mask_LinfomaHodgkin())
Imuno.Add("&4 IHQ Linfoma não Hodgkin", (*) => Mask_LinfomaNaoHodgkin())
Imuno.Add("&5 estomago (HER2)" , (*) => Mask_IhqEstomago())
Imuno.Add("&6 Pulmao (HER2)", (*) => Mask_IhqPulmao())


Estadiamento.Add("&1 Mama (AJCC 8ª Ed)", (*) => Mask_EstadiamentoMama())
Estadiamento.Add("&2 Rim (AJCC 8ª Ed)",  (*) => Mask_EstadiamentoRim())
Estadiamento.Add("&3 Estômago Carcinoma (AJCC 8ª Ed)", (*) => Mask_EstadiamentoEstomagoCarcinoma())
Estadiamento.Add("&4 Estômago NET (JNCCN 2023)", (*) => Mask_EstadiamentoStomachNET())
Estadiamento.Add("&5 Tireoide (AJCC 8ª Ed)", (*) => Mask_EstadiamentoTireoide())
Estadiamento.Add("&6 Cólon (AJCC 8ª Ed)", (*) => Mask_EstadiamentoColon())

Carimbos.Add("&1 Adicionar carimbo",  (*) => GuiNovoCarimbo())
Carimbos.Add("&2 Gerenciar carimbos", (*) => GuiVerCarimbos())
Carimbos.Add()
Carimbos.Add("&3 Residentes", Residentes)
Carimbos.Add("&4 Staffs", Staffs)

InicializarCarimbos(Residentes, Staffs)
; =========================================================
; 4. MONTAR O MENU PRINCIPAL (Guilis)
; =========================================================
Guilis := Menu()

; Título (Não acionável)
Guilis.Add("SISTEMA GUILIS", (*) => "")
Guilis.Disable("SISTEMA GUILIS")
Guilis.Add()

; Itens do Menu (Agora o Gastro já tem conteúdo)
Guilis.Add("&1 Gastro", Gastro)
Guilis.Add("&2 Gineco", Gineco)
Guilis.Add("&3 Dermato", Dermato)
Guilis.Add("&4 Torácica e partes moles", Toracica)
Guilis.Add("&5 Mama", Mama)
Guilis.Add("&6 Uro", Uro)
Guilis.Add("&7 Neuro", Neuro)
Guilis.Add("&8 Hemato", Hemato)
Guilis.Add("&9 Cabeça e pescoço", Cabeca)
Guilis.Add()

Guilis.Add("&N Notas", Notas)
Guilis.Add("&C Cito", Cito)
Guilis.Add("&I Imuno-histoquímica", Imuno)
Guilis.Add("&A Atalhos", Atalhos)
Guilis.Add("&E Estadiamento", Estadiamento)
Guilis.Add("&0 Carimbos", Carimbos)
Guilis.Add("&B Buscar Laudo", (*) => BuscarLaudo())
Guilis.Add("&G Gestor de Laudos", (*) => CriarInterfaceCasos())
Guilis.Add("&X Recarregar programa", (*) => Reload())
Guilis.Add()

Guilis.Add("&H Help", (*) => MsgBox("SISTEMA GUILIS - Máscaras Histopatológicas`n`n" 
    . "=== COMO USAR ===`n"
    . "• Use o menu ou atalhos (números/letras sublinhadas)`n"
    . "• Menu: Ctrl+K para abrir`n"
    . "• Reload: F5 para recarregar o programa`n`n"
    . "=== CATEGORIAS ===`n"
    . "1. Gastro | 2. Gineco | 3. Dermato | 4. Torácica`n"
    . "5. Mama | 6. Uro | 7. Neuro | 8. Hemato`n"
    . "9. Cabeça e Pescoço`n`n"
    . "N. Notas | C. Cito | I. Imuno-histoquímica`n"
    . "0. Carimbos | Q. Sair`n`n"
    . "Versão: AutoHotkey v2.0", "Ajuda - GUILIS"))
Guilis.Add("&Q Sair do Programa", (*) => ExitApp())


GuiNovoAtalho() {
    global GuiAtalhos
    GuiAtalhos := Gui(, "Adicionar Novo Atalho")
    GuiAtalhos.MarginX := 16
    GuiAtalhos.MarginY := 14
    GuiAtalhos.SetFont("s11", "Segoe UI")

    GuiAtalhos.SetFont("s13 Bold", "Segoe UI")
    GuiAtalhos.Add("Text", "w320", "Novo Atalho de Expansão")

    GuiAtalhos.SetFont("s10", "Segoe UI")
    GuiAtalhos.Add("Text", "w320 y+10", "Palavra-gatilho  (só letras, números e _)")
    GuiAtalhos.Add("Edit", "w320 vAtalho")

    GuiAtalhos.Add("Text", "w320 y+10", "Texto expandido")
    GuiAtalhos.Add("Edit", "w320 h110 vTexto Multi")

    GuiAtalhos.SetFont("s10 Bold", "Segoe UI")
    GuiAtalhos.Add("Button", "w320 y+12 Default", "Salvar Atalho").OnEvent("Click", (*) => SalvarNovoAtalho())

    GuiAtalhos.Show("w354 h320")
}

SalvarNovoAtalho() {
    ; Obtém os valores dos campos usando o objeto
    global GuiAtalhos
    GuiValores := GuiAtalhos.Submit(false)

    Atalho := GuiValores.Atalho
    Texto := GuiValores.Texto
    
    ; Valida se os campos não estão vazios
    if (Atalho = "") {
        MsgBox("Por favor, digite um atalho!")
        return
    }
    
    if (Texto = "") {
        MsgBox("Por favor, digite o texto!")
        return
    }
    
    ; Validação: atalho deve ser apenas letras e números (sem espaços)
    if !RegExMatch(Atalho, "^[a-zA-Z0-9_]+$") {
        MsgBox("O atalho deve conter apenas letras, números e underscore (_)")
        return
    }
    
    ; Caminho do arquivo de atalhos
    arquivoAtalhos := A_ScriptDir . "\scripts\atalhos.ahk"
    
    ; Verifica se o arquivo existe
    if !FileExist(arquivoAtalhos) {
        MsgBox("Arquivo scripts\atalhos.ahk não encontrado!")
        return
    }
    
    ; Prepara o novo atalho no formato correto
    ; Substitui quebras de linha por `n
    TextoFormatado := StrReplace(Texto, "`r`n", "`n")
    TextoFormatado := StrReplace(TextoFormatado, "`n", "``n")
    
    ; Cria o código do atalho em formato correto usando Chr(34) para aspas
    aspas := Chr(34)
    novoAtalho := "`n`n:*:" . Atalho . ":: {`n"
    novoAtalho .= "    InserirTextoRapido(" . aspas . TextoFormatado . aspas . ")`n"
    novoAtalho .= "}`n"
    
    ; Adiciona o novo atalho ao fim do arquivo (antes da última linha de comentário se houver)
    try {
        conteudo := FileRead(arquivoAtalhos, "UTF-8")

        ; Adiciona o novo atalho ao arquivo
        FileDelete(arquivoAtalhos)
        FileAppend(conteudo . "`n" . novoAtalho, arquivoAtalhos, "UTF-8")
        
        ; Mensagem de sucesso
        MsgBox("Atalho '" . Atalho . "' criado com sucesso!`n`n"
            . "Pressione F5 para recarregar os atalhos ou use o menu Atalhos → Recarregar programa", "Sucesso!")
        
        ; Fecha a GUI
        GuiAtalhos.Destroy()
    } catch Error as err {
        MsgBox("Erro ao salvar atalho: " . err.What)
    }
}

GuiVerAtalhos() {
    global GuiVer
    GuiVer := Gui(, "Gerenciar Atalhos")
    GuiVer.MarginX := 16
    GuiVer.MarginY := 14
    GuiVer.SetFont("s11", "Segoe UI")

    GuiVer.SetFont("s13 Bold", "Segoe UI")
    GuiVer.Add("Text", "w560", "Gerenciar Atalhos")

    GuiVer.SetFont("s10", "Segoe UI")
    GuiVer.Add("Text", "w560 y+6", "Selecione um atalho na lista e clique em Deletar.")
    LV := GuiVer.Add("ListView", "w560 h300 y+8 -Multi", ["Atalho", "Texto (prévia)"])
    LV.ModifyCol(1, 130)
    LV.ModifyCol(2, 410)
    CarregarAtalhos(LV)

    GuiVer.SetFont("s10 Bold", "Segoe UI")
    GuiVer.Add("Button", "w200 y+12", "Deletar Selecionado").OnEvent("Click", (*) => DeletarAtalheSelecionado(LV))
    GuiVer.SetFont("s10", "Segoe UI")
    GuiVer.Add("Button", "x+10 w100", "Fechar").OnEvent("Click", (*) => GuiVer.Destroy())
    GuiVer.Add("Button", "x+10 w100", "Adicionar").OnEvent("Click", (*) => GuiNovoAtalho())

    GuiVer.Show("w592 h420")
}

CarregarAtalhos(LV) {
    arquivoAtalhos := A_ScriptDir . "\scripts\atalhos.ahk"
    if !FileExist(arquivoAtalhos) {
        MsgBox("Arquivo scripts\atalhos.ahk não encontrado!")
        return
    }
    conteudo := FileRead(arquivoAtalhos, "UTF-8")
    startPos := 1
    while RegExMatch(conteudo, ":\*:([^:]+):: \{\R\s+InserirTextoRapido\(`"([^`"]*)`"\)", &m, startPos) {
        nome := m[1]
        previa := StrReplace(m[2], "``n", " / ")
        if StrLen(previa) > 60
            previa := SubStr(previa, 1, 60) . "..."
        LV.Add(, nome, previa)
        startPos := m.Pos + m.Len
    }
}

DeletarAtalheSelecionado(LV) {
    row := LV.GetNext(0)
    if !row {
        MsgBox("Selecione um atalho na lista antes de deletar.")
        return
    }
    nome := LV.GetText(row, 1)
    if MsgBox("Tem certeza que deseja deletar o atalho '" . nome . "'?", "Confirmar exclusão", "YesNo Icon?") != "Yes"
        return
    arquivoAtalhos := A_ScriptDir . "\scripts\atalhos.ahk"
    conteudo := FileRead(arquivoAtalhos, "UTF-8")
    novoConteudo := RegExReplace(conteudo, "\R\R:\*:" . nome . ":: \{[^}]*\}")
    FileDelete(arquivoAtalhos)
    FileAppend(novoConteudo, arquivoAtalhos, "UTF-8")
    LV.Delete()
    CarregarAtalhos(LV)
    MsgBox("Atalho '" . nome . "' deletado com sucesso!`n`nPressione F5 para recarregar o programa.", "Sucesso!")
}

; =========================================================
; ATALHOS
; =========================================================
^k:: Guilis.Show()
^l:: CriarInterfaceCasos()
F5:: Reload()