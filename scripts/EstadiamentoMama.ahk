; ==============================================================================
; ESTADIAMENTO — MAMA (AJCC 8ª Ed / CAP 4.10.0.0)
; ==============================================================================

Mask_EstadiamentoMama() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Estadiamento — Mama (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    g.SetFont("s12 Bold", "Segoe UI")
    g.Add("Text", "xm w400 Center", "Estadiamento — Mama (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "xm y+8 w400 0x10")

    ; --- pT ---
    g.Add("Text", "xm y+12", "Categoria pT:")
    DropPT := g.Add("DropDownList", "xm y+4 w400 vPTCategory", [
        "pTX (Não determinado)",
        "pT0 (Sem evidência)",
        "pTis (DCIS)",
        "pTis (Paget)",
        "pT1mi (≤1 mm)",
        "pT1a (>1 mm a ≤5 mm)",
        "pT1b (>5 mm a ≤10 mm)",
        "pT1c (>10 mm a ≤20 mm)",
        "pT2 (>20 mm a ≤50 mm)",
        "pT3 (>50 mm)",
        "pT4a (Parede Torácica)",
        "pT4b (Pele: Ulcerada/Nódulos Satélites)",
        "pT4c (T4a + T4b)",
        "pT4d (Carcinoma Inflamatório)"
    ])

    ; --- pN ---
    g.Add("Text", "xm y+12", "Categoria pN:")
    DropPN := g.Add("DropDownList", "xm y+4 w400 vPNCategory", [
        "pN0 (Sem metástases)",
        "pN0(i+) (Células isoladas ≤0.2 mm)",
        "pN1mi (Micrometástases >0.2 a 2 mm)",
        "pN1a (1-3 linfonodos axilares)",
        "pN1b (Linfonodo mamária interna)",
        "pN2a (4-9 linfonodos axilares)",
        "pN3a (10+ linfonodos axilares)"
    ])

    ; --- Modificadores ---
    g.Add("Text", "xm y+12", "Modificadores:")
    cbNeoadj := g.Add("CheckBox", "xm y+4 vNeoadj", "Pós-neoadjuvância  (prefixo y → ypT, ypN)")
    cbSN     := g.Add("CheckBox", "xm y+6 vSN",     "Linfonodo sentinela  (sufixo sn → pN(sn))")

    ; --- Prévia ---
    g.Add("Text", "xm y+12", "Prévia")
    edtPrev := g.Add("Edit", "xm y+4 w400 r2 ReadOnly -Wrap")

    DropPT.OnEvent("Change", (*) => UpdatePreview())
    DropPN.OnEvent("Change", (*) => UpdatePreview())
    cbNeoadj.OnEvent("Click", (*) => UpdatePreview())
    cbSN.OnEvent("Click",     (*) => UpdatePreview())

    ; --- Botões ---
    g.Add("Button", "xm y+14 w120 Default", "Inserir").OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    g.Add("Button", "x+10 w120", "Copiar").OnEvent("Click", (*) => (
        A_Clipboard := Build()
    ))
    g.Add("Button", "x+10 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    g.Show("w432")
    UpdatePreview()

    UpdatePreview() {
        edtPrev.Value := Build()
    }

    Build() {
        Saved := g.Submit(false)
        pT := RegExReplace(Saved.PTCategory, " .*$", "")
        pN := RegExReplace(Saved.PNCategory, " .*$", "")

        if Saved.Neoadj
            pT := "y" pT, pN := "y" pN
        if Saved.SN
            pN := RegExReplace(pN, "^(y?pN[^(]*)", "$1(sn)")

        return "Estadiamento patológico (pTNM AJCC 8ª edição): " pT " " pN
    }
}
