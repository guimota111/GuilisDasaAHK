; =========================================================
; Sistema de Ajuda — Guilis
; Arquivo: scripts\help.ahk
; =========================================================

Mask_Help(opcao) {
    titulo := ""
    conteudo := ""

    switch opcao {
        case 1:
            titulo := "Como usar o Guilis"
            conteudo := "
            (
            GUILIS - GUIA DE LAUDOS

            0. Aperte Control K - Se você está aqui é porque já fez essa parte.
            1. Navegue pelas abas (Pode ser com mouse, com setas ou digitando o número da aba).
            2. Selecione o menu desejado para abrir a máscara.
            3. Preencha os campos e dropdowns.
            4. O botão 'Inserir' cola o texto diretamente no seu arquivo.
            5. O botão 'Copiar' apenas envia o texto para a memória (Clipboard).

            Dica: Use a tecla TAB para navegar rapidamente entre os campos e as setas para trocar entre as opções.
            Dica: Usar só as setas é bem mais rápido... Pegou um papilífero de múltiplos focos? Aperta aí bem rápido CONTROL+K 913.
            )"

        case 2:
            titulo := "Atalhos"
            conteudo := "
            (
            ATALHOS SAPECAS

            O Guilis possui atalhos escondidos...
            Para digitar um carimbo escreva a letra 'c' e depois o nome da pessoa ou do residente...
            Exemplo: cluana

			Por enquanto é só... mas se eu tiver de bom humor amanhã vai você não estará lendo essa linha e sim uma listinha de atalhos
            )"

        case 3:
            titulo := "Adicionar Carimbos"
            conteudo := "
            (
            ADICIONANDO CARIMBOS PARA NOVOS RESIDENTES OU STAFFS
            Essa é mais difícil, chame o residente que for mais desenrolado com computador.

            1. Dentro da pasta onde está o Guilis, procure a pasta Script e então pelo arquivo carimbos.ahk.
            2. Vá até o final do arquivo.
            3. Para adicionar na fórmula escreva:
               case [NUMERO]: texto := '[NOME]`n[CARGO]`n[CRM/RQE]'
            4. Qualquer erro de escrita pode fazer o programa inteiro parar de funcionar, então sem pressão.
            5. O Carimbo agora faz parte da função, mas você não vai conseguir inserir no menu já que o arquivo foi compilado.
            6. Agora que o carimbo foi feito, vamos fazer o atalho.
            7. Vá para parte delimitada para adicionar novos atalhos e digite:
               :*:cNOME:: {InserirCarimbo([NUMERO])}
            )"

        case 4:
            titulo := "Instalação"
            conteudo := "
            (
            INSTALAÇÃO EM OUTRA ESTAÇÃO

            1. Baixe o arquivo zip e extraia a pasta em qualquer lugar.
            2. Certifique-se de que dentro da pasta foi copiada a pasta script.
            3. Execute o arquivo principal Guilis.exe.
			4. Se quiser fechar o programa (ele fica rodando no fundo) aperta control+k Q   OU   Vai na bandeja de ícones, clique com o botão direito no ícone do GUILIS e clique sair ou exit

            DICA: Você sabe que o programa está aberto se ver o ícone dele na bandeja de ícones perto do relógio (canto inferior direito).
            )"

        case 5:
            titulo := "Sobre o Autor"
            conteudo := "
            (
            GUILIS v2.0

            O Guilis foi feito para ajudar os residentes do HUOL a digitar seus laudos.
            Agradeçam a Dr. Fábio pelas máscaras e a mim pela programação.

            Ele foi feito em uma semana então eu acho que vai ter muitos Bugs...
            Mas paguem pelas próximas versões que vai estar tudo certo.

            A programação dele continua, mas também não vou ser otário de dar tudo de graça pra vocês...
            Novas ferramentas também virão.

            Erros, dúvidas, reclamações ou se quiserem comprar outros produtos: guimota1@gmail.com

            Autor: Guilherme Mota - Patologista Ex-residente do HUOL
            Linguagem: AutoHotkey v2.0
            Se quiser me ajudar com um pix: 10207442436
            )"
    }

    ; Criando a janela de ajuda ampliada
    gHelp := Gui("+AlwaysOnTop", titulo)
    AplicarIcone(gHelp)
    gHelp.BackColor := "F3F3F3"
    gHelp.SetFont("s10", "Segoe UI")

    ; Campo de texto largo (w650) e com altura suficiente (r18)
    gHelp.Add("Edit", "w650 r18 ReadOnly -Border -Tabstop", conteudo)

    btnFechar := gHelp.Add("Button", "Default w100 h30 x275 y+20", "Entendido")
    btnFechar.OnEvent("Click", (*) => gHelp.Destroy())

    gHelp.Show()
}