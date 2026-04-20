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

    bw := 180
    sw := bw * 2 + 8

    AddSection(label) {
        g.SetFont("s10 Bold", "Segoe UI")
        g.Add("Text", "xm y+12", label)
        g.SetFont("s10", "Segoe UI")
        g.Add("Text", "xm y+4 w" sw " 0x10")
    }

    g.SetFont("s13 Bold", "Segoe UI")
    g.Add("Text", "xm w" sw " Center", "Gastro")
    g.Add("Text", "xm y+8 w" sw " 0x10")

    ; ------- ESTÔMAGO -------
    AddSection("Estômago")
    g.SetFont("s10", "Segoe UI")
    g.Add("Button", "xm y+6 w" bw, "Mucosa Normal"         ).OnEvent("Click", (*) => (g.Destroy(), Mask_MucosaGastricaNormal()))
    g.Add("Button", "x+8 w"   bw, "Gastrite Inativa"        ).OnEvent("Click", (*) => (g.Destroy(), Mask_GastriteInativa()))
    g.Add("Button", "xm y+6 w" bw, "Gastrite Ativa"         ).OnEvent("Click", (*) => (g.Destroy(), Mask_GastriteAtiva()))
    g.Add("Button", "x+8 w"   bw, "Borda de Úlcera Hp+"    ).OnEvent("Click", (*) => (g.Destroy(), Mask_BordaUlceraHpPositivo()))
    g.Add("Button", "xm y+6 w" bw, "Borda de Úlcera Hp-"   ).OnEvent("Click", (*) => (g.Destroy(), Mask_BordaUlceraHpNegativo()))
    g.Add("Button", "xm y+6 w" bw, "Gastropatia Reativa"    ).OnEvent("Click", (*) => (g.Destroy(), Mask_GastropReativa()))
    g.Add("Button", "xm y+6 w" bw, "Alt. Reativas Discretas").OnEvent("Click", (*) => (g.Destroy(), Mask_AltReativaDisc()))

    ; ------- DUODENO -------
    AddSection("Duodeno")
    g.SetFont("s10", "Segoe UI")
    g.Add("Button", "xm y+6 w" bw, "Duodeno Normal" ).OnEvent("Click", (*) => (g.Destroy(), Mask_DuodenoNormal()))
    g.Add("Button", "x+8 w"   bw, "Duodenite Leve" ).OnEvent("Click", (*) => (g.Destroy(), Mask_DuodenoLeve()))
    g.Add("Button", "xm y+6 w" bw, "Heterotopia"         ).OnEvent("Click", (*) => (g.Destroy(), Mask_DuodenoHeterotopia()))
    g.Add("Button", "x+8 w"   bw, "Hiperplasia Brunner" ).OnEvent("Click", (*) => (g.Destroy(), Mask_DuodenoHiperplasiaBrunner()))

    ; ------- VESÍCULA BILIAR -------
    AddSection("Vesícula Biliar")
    g.SetFont("s10", "Segoe UI")
    g.Add("Button", "xm y+6 w" bw, "Colecistite Crônica" ).OnEvent("Click", (*) => (g.Destroy(), Mask_VesiculaBiliarColecistite()))
    g.Add("Button", "x+8 w"   bw, "Agudizada"            ).OnEvent("Click", (*) => (g.Destroy(), Mask_VesiculaBiliarAgudizada()))

    ; ------- CÓLON -------
    AddSection("Cólon")
    g.SetFont("s10", "Segoe UI")
    g.Add("Button", "xm y+6 w" bw, "Adenocarcinoma (Peça)").OnEvent("Click", (*) => (g.Destroy(), Mask_AdenocarcinomaColonPeca()))
    g.Add("Button", "x+8 w"   bw, "Colite Ativa Focal"        ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonColiteAtivaFocal()))
    g.Add("Button", "xm y+6 w" bw, "Pólipo Hiperpl./Inflam." ).OnEvent("Click", (*) => (g.Destroy(), Mask_ColonPolipoHiperplasicoInflamatorio()))

    ; ------- IHQ -------
    AddSection("IHQ")
    g.SetFont("s10", "Segoe UI")
    g.Add("Button", "xm y+6 w" bw, "pMMR + HER2 neg (Biópsia)").OnEvent("Click", (*) => (g.Destroy(), Mask_IHQEstomago_pMMR_HER2neg()))
    g.Add("Button", "x+8 w"   bw, "pMMR + HER2 neg (Peça)"   ).OnEvent("Click", (*) => (g.Destroy(), Mask_IHQEstomago_pMMR_HER2neg_Peca()))

    g.Show("w" sw + 28)
}
