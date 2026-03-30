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
    g.Add("Button", "xm y+6 w" bw, "Mucosa Normal"  ).OnEvent("Click", (*) => (g.Destroy(), Mask_MucosaGastricaNormal()))
    g.Add("Button", "x+8 w"   bw, "Gastrite Inativa" ).OnEvent("Click", (*) => (g.Destroy(), Mask_GastriteInativa()))
    g.Add("Button", "xm y+6 w" bw, "Gastrite Ativa"  ).OnEvent("Click", (*) => (g.Destroy(), Mask_GastriteAtiva()))

    ; ------- VESÍCULA BILIAR -------
    AddSection("Vesícula Biliar")
    g.SetFont("s10", "Segoe UI")
    g.Add("Button", "xm y+6 w" bw, "Colecistite Crônica" ).OnEvent("Click", (*) => (g.Destroy(), Mask_VesiculaBiliarColecistite()))
    g.Add("Button", "x+8 w"   bw, "Agudizada"            ).OnEvent("Click", (*) => (g.Destroy(), Mask_VesiculaBiliarAgudizada()))

    ; ------- CÓLON -------
    AddSection("Cólon")
    g.SetFont("s10", "Segoe UI")
    g.Add("Button", "xm y+6 w" bw, "Adenocarcinoma (Peça)").OnEvent("Click", (*) => (g.Destroy(), Mask_AdenocarcinomaColonPeca()))

    g.Show("w" sw + 28)
}
