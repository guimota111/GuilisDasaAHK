; ==============================================================================
; ESTADIAMENTO — TIREOIDE (AJCC 8ª Ed / CAP 4.4.0.0)
; ==============================================================================

Mask_EstadiamentoTireoide() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Estadiamento — Tireoide (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    g.SetFont("s12 Bold", "Segoe UI")
    g.Add("Text", "xm w400 Center", "Estadiamento — Tireoide (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "xm y+8 w400 0x10")

    ; --- pT ---
    g.Add("Text", "xm y+12", "Categoria pT:")
    DropPT := g.Add("DropDownList", "xm y+4 w400 vPTCategory", [
        "pTX (Não determinado)",
        "pT0 (Sem evidência de tumor)",
        "pT1a (≤1 cm, limitado à tireoide)",
        "pT1b (>1 cm a ≤2 cm, limitado à tireoide)",
        "pT2 (>2 cm a ≤4 cm, limitado à tireoide)",
        "pT3a (>4 cm, limitado à tireoide)",
        "pT3b (Invasão macroscópica apenas de m. pré-tireoidianos)",
        "pT4a (Invasão de tec. subcutâneo, laringe, traqueia, esôfago ou n. laríngeo recorrente)",
        "pT4b (Invasão de fáscia pré-vertebral ou vasos mediastinais/carótida)"
    ])

    ; --- pN ---
    g.Add("Text", "xm y+12", "Categoria pN:")
    DropPN := g.Add("DropDownList", "xm y+4 w400 vPNCategory", [
        "pNX (Não determinado)",
        "pN0 (Sem metástases regionais)",
        "pN0a (Linfonodos benignos citologicamente/histologicamente)",
        "pN1a (Metástases no Nível VI ou VII - Pré-traqueais, para-traqueais, pré-laríngeos)",
        "pN1b (Metástases laterais: Níveis I, II, III, IV, V ou retrofaríngeos)"
    ])

    ; --- Modificadores ---
    g.Add("Text", "xm y+12", "Modificadores:")
    cbMult   := g.Add("CheckBox", "xm y+4 vMult",   "Tumores múltiplos (sufixo m → pT(m))")
    cbNeoadj := g.Add("CheckBox", "xm y+6 vNeoadj", "Pós-multimodalidade (prefixo y → ypT, ypN)")

    ; --- Prévia ---
    g.Add("Text", "xm y+12", "Prévia")
    edtPrev := g.Add("Edit", "xm y+4 w400 r2 ReadOnly -Wrap")

    DropPT.OnEvent("Change", (*) => UpdatePreview())
    DropPN.OnEvent("Change", (*) => UpdatePreview())
    cbMult.OnEvent("Click",   (*) => UpdatePreview())
    cbNeoadj.OnEvent("Click", (*) => UpdatePreview())

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

        ; Aplicar prefixo y
        if Saved.Neoadj
            pT := "y" pT, pN := "y" pN
        
        ; Aplicar sufixo (m) para multiplicidade
        if Saved.Mult
            pT := RegExReplace(pT, "^(y?pT[1-4][a-b]?)", "$1(m)")

        return "Estadiamento patológico (pTNM AJCC 8ª edição): " pT " " pN
    }
}