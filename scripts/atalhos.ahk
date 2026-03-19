; --- Atalhos de Gastrite (Com Quebra de Linha) ---
:*:gclsemnadaa:: {
    InserirTextoRapido("Gastrite crônica leve em mucosa de padrão antral.`n. Atividade ausente`n. Atrofia ausente`n. Metaplasia intestinal ausente`n. Pesquisa de H. pylori (coloração especial Giemsa): negativa")
}

:*:gclsemnadaf:: {
    InserirTextoRapido("Gastrite crônica leve em mucosa de padrão fúndico.`n. Atividade ausente`n. Atrofia ausente`n. Metaplasia intestinal ausente`n. Pesquisa de H. pylori (coloração especial Giemsa): negativa")
}

:*:pangcl:: {
    InserirTextoRapido("Pangastrite crônica leve.`n. Atividade ausente`n. Atrofia ausente`n. Metaplasia intestinal ausente`n. Pesquisa de H. pylori (coloração especial Giemsa): negativa")
}

:*:gclatvla:: {
    InserirTextoRapido("Gastrite crônica leve em mucosa de padrão antral.`n. Atividade leve`n. Atrofia ausente`n. Metaplasia intestinal ausente`n. Pesquisa de H. pylori (coloração especial Giemsa): negativa")
}

:*:gclatvlf:: {
    InserirTextoRapido("Gastrite crônica leve em mucosa de padrão fúndica.`n. Atividade leve`n. Atrofia ausente`n. Metaplasia intestinal ausente`n. Pesquisa de H. pylori (coloração especial Giemsa): negativa")
}
:*:dcil:: {
    InserirTextoRapido("Duodenite crônica inespecífica (duodenite péptica) leve`n. Ausência de atrofia, granulomas e parasitas`n. Relação vilosidade:cripta 3:1, dentro dos limites histológicos da normalidade")
}

:*:datahoje:: {
    DataAtual := FormatTime(, "dd/MM/yyyy")
    SendText(DataAtual)
}

; Função para inserir textos longos via Colagem (Ctrl+V) sem perder o Clipboard original
InserirTextoRapido(texto) {
    oldClip := A_Clipboard    ; Salva o que você já tinha copiado
    A_Clipboard := texto      ; Coloca o laudo no clipboard
    ClipWait(1)               ; Aguarda até 1s o Windows confirmar a atualização
    Send("^v")                ; Cola

    ; Devolve o seu conteúdo original pro Ctrl+V depois de 1 segundo
    SetTimer(() => (A_Clipboard := oldClip), -1000)
}






:*:dlhn:: {
    InserirTextoRapido("dentro dos limites histológicos da normalidade")
}







:*:pelemglivre:: {
    InserirTextoRapido("2. MARGENS PERIFÉRICAS:`nLivres de neoplasia`n`n3. MARGEM PROFUNDA: `nLivre de neoplasia")
}



:*:cccl:: {
    InserirTextoRapido("Colecistite crônica`nColelitíase")
}



:*:_separator:: {
    InserirTextoRapido("------------------------------------------------------")
}



:*:mg0:: {
    InserirTextoRapido("Livre de neoplasia")
}



:*:mgdlhn:: {
    InserirTextoRapido("Livre de neoplasia, dentro dos limites histológicos da normalidade")
}















:*:compneo:: {
    InserirTextoRapido("Comprometida pela neoplasia")
}



:*:hpn:: {
    InserirTextoRapido("`n. Pesquisa de H. pylori (coloração especial Giemsa): negativa")
}



:*:hpp:: {
    InserirTextoRapido("`n. Pesquisa de H. pylori (coloração especial Giemsa): positiva")
}
