; scripts\atalhos.ahk

; Função para inserir texto digitando (sem área de transferência)
InserirTextoRapido(texto) {
    SendText texto
}


; Insere uma linha em negrito seguida de texto normal
InserirBoldResto(bold, resto) {
    Send "^b"
    SendText bold
    Send "^b"
    SendText resto
}

; =========================================================
; ATALHOS GERAIS
; =========================================================
:*:notacortes:: {
    Send "^b"
    SendText "Nota:"
    Send "^b"
    SendText " foram avaliados cortes histológicos aprofundados."
}


; =========================================================
; ESTÔMAGO — PÓLIPOS E ADENOMAS
; =========================================================
:*:pgf:: {
    Send "^b"
    SendText "- Pólipo de glândulas fúndicas."
    Send "^b"
    SendText "`n. Mucosa gástrica oxíntica sem atipias, exibindo glândulas cisticamente dilatadas, revestidas por células parietais e principais.`n. Lâmina própria com infiltrado mononuclear.`n. A pesquisa de "
    Send "^i"
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou negativa.`n. Ausência de evidências de malignidade nesta amostra."
}

:*:estomagohiperplasico:: {
    Send "^b"
    SendText "- Pólipo hiperplásico."
    Send "^b"
    SendText "`n. Mucosa glandular de tipo gástrico, constituída por glândulas dilatadas junto à superfície, sem atipias celulares.`n. Lâmina própria com infiltrado mononuclear.`n. A pesquisa de "
    Send "^i"
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou negativa.`n. Ausência de evidências de malignidade nesta amostra."
}

:*:phip:: {
    Send "^b"
    SendText "- Pólipo hiperplásico."
    Send "^b"
    SendText "`n"
    Send "^b"
    SendText "- Não foram observados sinais de malignidade nesta amostra."
    Send "^b"
}

:*:atbdbg:: {
    Send "^b"
    SendText "- Adenoma tubular com displasia de baixo grau."
    Send "^b"
    SendText "`n"
    SendText "- Categoria III do Consenso de Viena."
    SendText "`n"
    SendText "- Não foram observados sinais de invasão do córion ou malignidade nesta amostra."
    SendText "`n"

}

:*:atbdag:: {
    Send "^b"
    SendText "- Adenoma tubular com displasia de alto grau."
    Send "^b"
    SendText "`n"
    SendText "- Categoria IV do Consenso de Viena."
    SendText "`n"
    SendText "- Não foram observados sinais de invasão do córion ou malignidade nesta amostra."
    SendText "`n"

}

:*:corponormal:: {
    Send "^b"
    SendText "- Mucosa sem particularidades histológicas."
    Send "^b"
    SendText "`n"
    SendText ". Mucosa de corpo com revestimento habitual, mantendo organização regular e maturação preservada."
    SendText "`n"
    SendText ". Atrofia: ausente."
    SendText "`n"
    SendText ". Metaplasia intestinal: ausente."
    SendText "`n"
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou negativa."
    SendText "`n"
    SendText ". Ausência de evidências de malignidade nesta amostra."
    SendText "`n"
    
}

:*:antronormal:: {
    Send "^b"
    SendText "- Mucosa sem particularidades histológicas."
    Send "^b"
    SendText "`n"
    SendText ". Mucosa de antro com revestimento habitual, mantendo organização regular e maturação preservada."
    SendText "`n"
    SendText ". Atrofia: ausente."
    SendText "`n"
    SendText ". Metaplasia intestinal: ausente."
    SendText "`n"
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou negativa."
    SendText "`n"
    SendText ". Ausência de evidências de malignidade nesta amostra."
    SendText "`n"
    
}

:*:cpannormal:: {
    Send "^b"
    SendText "- Mucosa sem particularidades histológicas."
    Send "^b"
    SendText "`n"
    SendText ". Mucosa de corpo e antro com revestimento habitual, mantendo organização regular e maturação preservada."
    SendText "`n"
    SendText ". Atrofia: ausente."
    SendText "`n"
    SendText ". Metaplasia intestinal: ausente."
    SendText "`n"
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou negativa."
    SendText "`n"
    SendText ". Ausência de evidências de malignidade nesta amostra."
    SendText "`n"
    
}

:*:gclsemnadaa:: {
    Send "^b"
    SendText "- Gastrite crônica leve e inativa."
    Send "^b"
    SendText "`n"
    SendText ". Mucosa de antro com revestimento habitual, mantendo organização regular e maturação preservada."
    SendText "`n"
    SendText ". Lâmina própria exibindo leve infiltrado mononuclear, sem atividade neutrofílica."
    SendText "`n"
    SendText ". Atrofia: ausente."
    SendText "`n"
    SendText ". Metaplasia intestinal: ausente."
    SendText "`n"
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou negativa."
    SendText "`n"
    SendText ". Ausência de evidências de malignidade nesta amostra."
    SendText "`n"
    
}

:*:gclsemnadac:: {
    Send "^b"
    SendText "- Gastrite crônica leve e inativa."
    Send "^b"
    SendText "`n"
    SendText ". Mucosa de antro com revestimento habitual, mantendo organização regular e maturação preservada."
    SendText "`n"
    SendText ". Lâmina própria exibindo leve infiltrado mononuclear, sem atividade neutrofílica."
    SendText "`n"
    SendText ". Atrofia: ausente."
    SendText "`n"
    SendText ". Metaplasia intestinal: ausente."
    SendText "`n"
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou negativa."
    SendText "`n"
    SendText ". Ausência de evidências de malignidade nesta amostra."
    SendText "`n"
    
}

:*:bpcorpoeantro:: {
    SendText "Biópsia gástrica (corpo e antro):"

}

:*:bpcp:: {
    SendText "Biópsia gástrica (corpo):"

}
:*:bpan:: {
    SendText "Biópsia gástrica (antro):"

}
:*:bpai:: {
    SendText "Biópsia gástrica (antro e incisura):"

}
:*:@smal:: {
    SendText ". Ausência de evidências de malignidade nesta amostra."

}
:*:@hp0::{
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou negativa."
    SendText "`n"
}

:*:@hp1::{
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou positiva (1+/3+)."
    SendText "`n"
}

:*:@hp2::{
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou positiva (2+/3+)."
    SendText "`n"
}

:*:@hp3::{
    SendText ". A pesquisa de "
    Send "^i" 
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou positiva (3+/3+)."
    SendText "`n"
}
:*:@apendicite:: {
    Send "^b"
    SendText "Apêndice cecal:`n- Apendicite aguda úlcero-flegmonosa.`n- Periapendicite aguda fibrinoleucocitária.`n"
    Send "^b"
    SendText "- Não se observam elementos de malignidade.`n"
}

:*:notahpihq::{
    SendText "Nota: Sugere-se  pesquisar H. pylori através do estudo imuno-histoquímico (método mais sensível e mais específico) devido a atividade inflamatória com pesquisa negativa pela coloração especial (Giemsa)."
}
; =========================================================
; DUODENO
; =========================================================
:*:duodn:: {
    Mask_DuodenoNormal()
}
:*:duodeniteleve:: {
Send "^b"
SendText "- Duodenite leve com focos de metaplasia foveolar."
Send "^b"
SendText ". Mucosa apresentando leve edema, congestão vascular e infiltrado inflamatório misto leve."
SendText ". Linfócitos intraepiteliais em contagem não significante."
SendText ". Revestimento epitelial aparece ligeiramente reativo, mantendo organização regular, sem atrofia de vilos."
SendText ". Ausência de granulomas, eosinofilia ou parasitas."
SendText ". Não foram observados sinais de malignidade nesta amostra."

}

; =========================================================
; ALTERAÇÕES REATIVAS DISCRETAS
; =========================================================
:*:estomagoreativo:: {
    Mask_AltReativaDisc()
}

; =========================================================
; GASTROPATIA REATIVA
; =========================================================
:*:gastropatiareativa:: {
    Mask_GastropReativa()
}

; =========================================================
; OLGA / OLGIM
; =========================================================
:*:@olga:: {
    OlgaOlgim_Show()
}

OlgaOlgim_Show() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "OLGA / OLGIM")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm w340", "Atrofia")
    g.SetFont("s10", "Segoe UI")
    g.AddText("xm y+8 w140", "Corpo")
    ddlAtCorpo := g.AddDropDownList("x+8 w180 Choose1", ["ausente", "leve", "moderada", "acentuada"])
    g.AddText("xm y+8 w140", "Antro")
    ddlAtAntro := g.AddDropDownList("x+8 w180 Choose1", ["ausente", "leve", "moderada", "acentuada"])

    g.SetFont("s10 Bold", "Segoe UI")
    g.AddText("xm y+14 w340", "Metaplasia intestinal")
    g.SetFont("s10", "Segoe UI")
    g.AddText("xm y+8 w140", "Corpo")
    ddlMICorpo := g.AddDropDownList("x+8 w180 Choose1", ["ausente", "leve", "moderada", "acentuada"])
    g.AddText("xm y+8 w140", "Antro")
    ddlMIAntro := g.AddDropDownList("x+8 w180 Choose1", ["ausente", "leve", "moderada", "acentuada"])

    g.AddButton("xm y+16 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    OnOK(*) {
        atCorpo := ddlAtCorpo.Value - 1
        atAntro := ddlAtAntro.Value - 1
        miCorpo := ddlMICorpo.Value - 1
        miAntro := ddlMIAntro.Value - 1

        olga  := OlgaToRoman(OlgaCalcStage(atCorpo, atAntro))
        olgim := OlgaToRoman(OlgaCalcStage(miCorpo, miAntro))
        exp   := OlgaBuildExplicacao(atCorpo, atAntro, miCorpo, miAntro)

        output := "Nota: OLGA " olga " e OLGIM " olgim " (" exp ")"

        g.Destroy()
        try WinActivate("ahk_id " prevWin)
        try WinWaitActive("ahk_id " prevWin, , 1)
        SendText output
    }
}

OlgaCalcStage(corpus, antrum) {
    static tbl := [[0,1,2,2],[1,1,2,3],[2,2,3,4],[3,3,4,4]]
    return tbl[antrum+1][corpus+1]
}

OlgaToRoman(n) {
    static r := ["0", "I", "II", "III", "IV"]
    return r[n+1]
}

OlgaBuildExplicacao(atCorpo, atAntro, miCorpo, miAntro) {
    grades := ["ausente", "leve", "moderada", "acentuada"]

    if (atCorpo = 0 && atAntro = 0 && miCorpo = 0 && miAntro = 0)
        return "atrofia e metaplasia intestinal ausentes em corpo e antro"

    if (atCorpo = atAntro)
        atDesc := "atrofia " grades[atCorpo+1] " em corpo e antro"
    else
        atDesc := "atrofia " grades[atCorpo+1] " em corpo e " grades[atAntro+1] " em antro"

    if (miCorpo = miAntro)
        miDesc := "metaplasia intestinal " grades[miCorpo+1] " em corpo e antro"
    else
        miDesc := "metaplasia intestinal " grades[miCorpo+1] " em corpo e " grades[miAntro+1] " em antro"

    return atDesc ", " miDesc
}

