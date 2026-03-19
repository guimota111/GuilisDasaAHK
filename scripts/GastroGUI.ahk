; =========================================================
; GUI — GASTRO
; =========================================================

GastroGUI_Show() {
    global gGastroGUI
    if IsSet(gGastroGUI) && IsObject(gGastroGUI)
        try gGastroGUI.Destroy()

    g := Gui("+AlwaysOnTop", "GUILIS — Gastro")
    gGastroGUI := g
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 14
    g.MarginY := 12
    AplicarIcone(g, "Logo.ico")
    g.OnEvent("Escape", (*) => g.Destroy())

    bw := 140   ; largura de cada botão
    sw := 436   ; largura da seção (3×140 + 2×8)

    g.SetFont("s13 Bold", "Segoe UI")
    g.Add("Text", "xm w" sw " Center", "Gastro")
    g.Add("Text", "xm y+8 w" sw " 0x10")

    AddSection(label) {
        g.SetFont("s10 Bold", "Segoe UI")
        g.Add("Text", "xm y+12", label)
        g.SetFont("s10", "Segoe UI")
        g.Add("Text", "xm y+4 w" sw " 0x10")
    }

    ; ------- ESTÔMAGO -------
    AddSection("Estômago")
    g.Add("Button", "xm y+6 w" bw, "Gastrite"        ).OnEvent("Click", (*) => (g.Destroy(), Gastrite_Run()))
    g.Add("Button", "x+8 w"   bw, "Estômago Normal"  ).OnEvent("Click", (*) => (g.Destroy(), Mask_EstomagoNormal()))
    g.Add("Button", "x+8 w"   bw, "Biopsia de Tumor" ).OnEvent("Click", (*) => (g.Destroy(), Mask_EstomagoBiopsiaTumor()))
    g.Add("Button", "xm y+6 w" bw, "Tumor em Peça"   ).OnEvent("Click", (*) => (g.Destroy(), Mask_EstomagoTumorPeca()))
    g.Add("Button", "x+8 w"   bw, "NET em Peça"      ).OnEvent("Click", (*) => (g.Destroy(), Mask_EstomagoNetPeca()))

    ; ------- ESÔFAGO -------
    AddSection("Esôfago")
    g.Add("Button", "xm y+6 w" bw, "Esofagite"       ).OnEvent("Click", (*) => (g.Destroy(), Mask_EsofagoBiopsiaEsofagite()))
    g.Add("Button", "x+8 w"   bw, "Biopsia de Tumor" ).OnEvent("Click", (*) => (g.Destroy(), EstomagoBiopsiaTumor_Run()))
    g.Add("Button", "x+8 w"   bw, "Tumor em Peça"    ).OnEvent("Click", (*) => (g.Destroy(), Mask_TumorEsofagoPeca()))

    ; ------- DUODENO -------
    AddSection("Duodeno")
    g.Add("Button", "xm y+6 w" bw, "Duodeno Normal"  ).OnEvent("Click", (*) => (g.Destroy(), Mask_DuodenoNormalBiopsia()))
    g.Add("Button", "x+8 w"   bw, "Biopsia Duodenite").OnEvent("Click", (*) => (g.Destroy(), Mask_DuodenoBiopsiaDuodenite()))
    g.Add("Button", "x+8 w"   bw, "Doença Celíaca"   ).OnEvent("Click", (*) => (g.Destroy(), Mask_DuodenoBiopsiaCeliaca()))
    g.Add("Button", "xm y+6 w" bw, "Tumor em Papila" ).OnEvent("Click", (*) => (g.Destroy(), Mask_GDPtumorEmPapila()))
    g.Add("Button", "x+8 w"   bw, "NET (papila/duo)" ).OnEvent("Click", (*) => (g.Destroy(), Mask_GDPnet()))

    ; ------- APÊNDICE -------
    AddSection("Apêndice")
    g.Add("Button", "xm y+6 w" bw, "Apêndice Normal" ).OnEvent("Click", (*) => (g.Destroy(), Mask_ApendiceNormal()))
    g.Add("Button", "x+8 w"   bw, "Tumor"            ).OnEvent("Click", (*) => (g.Destroy(), Mask_ApendiceTumor()))
    g.Add("Button", "x+8 w"   bw, "NET"              ).OnEvent("Click", (*) => (g.Destroy(), Mask_ApendiceNet()))

    ; ------- CÓLON -------
    AddSection("Cólon")
    g.Add("Button", "xm y+6 w" bw, "Normal: Íleo"    ).OnEvent("Click", (*) => (g.Destroy(), Mask_IleoBiopsiaNormal()))
    g.Add("Button", "x+8 w"   bw, "Normal: Cólon"    ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonBiopsiaNormal()))
    g.Add("Button", "x+8 w"   bw, "Normal: Reto"     ).OnEvent("Click", (*) => (g.Destroy(), Mask_RetoBiopsiaNormal()))
    g.Add("Button", "xm y+6 w" bw, "Colite Crônica"  ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonBiopsiaColiteCronica()))
    g.Add("Button", "x+8 w"   bw, "Biopsia de Tumor" ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonBiopsiaTumor()))
    g.Add("Button", "x+8 w"   bw, "Tumor em Peça"    ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonTumorPeca()))
    g.Add("Button", "xm y+6 w" bw, "NET em Peça"     ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonNetPeca()))
    g.Add("Button", "x+8 w"   bw, "Tumor Pediculado" ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonTumorPediculado()))
    g.Add("Button", "x+8 w"   bw, "Tumor Sessil"     ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonTumorSessil()))

    g.Show("w464")
}
