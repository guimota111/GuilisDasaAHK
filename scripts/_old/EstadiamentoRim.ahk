; ==============================================================================
; ESTADIAMENTO — RIM (AJCC 8ª Ed / CAP 4.2.1.0)
; ==============================================================================

Mask_EstadiamentoRim() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Estadiamento — Rim (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    g.SetFont("s12 Bold", "Segoe UI")
    g.Add("Text", "xm w400 Center", "Estadiamento — Rim (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "xm y+8 w400 0x10")

    ; --- pT --- [cite: 1753-1769]
    g.Add("Text", "xm y+12", "Categoria pT:")
    DropPT := g.Add("DropDownList", "xm y+4 w400 vPTCategory", [
        "pTX (Não determinado)",
        "pT0 (Sem evidência de tumor)",
        "pT1a (≤4 cm, limitado ao rim)",
        "pT1b (>4 cm a ≤7 cm, limitado ao rim)",
        "pT2a (>7 cm a ≤10 cm, limitado ao rim)",
        "pT2b (>10 cm, limitado ao rim)",
        "pT3a (Veia renal/segmentares, pelvicalicial ou gordura hilar/perirenal)",
        "pT3b (Vena cava abaixo do diafragma)",
        "pT3c (Vena cava acima do diafragma ou parede da cava)",
        "pT4 (Além da fáscia de Gerota ou adrenal ipsilateral contígua)"
    ])

    ; --- pN --- [cite: 1776-1781]
    g.Add("Text", "xm y+12", "Categoria pN:")
    DropPN := g.Add("DropDownList", "xm y+4 w400 vPNCategory", [
        "pN0 (Sem metástases regionais)",
        "pN1 (Metástase em linfonodo(s) regional(ais))",
        "pN N/A (Linfonodos não submetidos)"
    ])

    ; --- Modificadores --- [cite: 2109-2115]
    g.Add("Text", "xm y+12", "Modificadores:")
    cbNeoadj := g.Add("CheckBox", "xm y+4 vNeoadj", "Pós-neoadjuvância  (prefixo y → ypT, ypN)")
    cbMult   := g.Add("CheckBox", "xm y+6 vMult",   "Tumores múltiplos  (sufixo m → pT(m))")

    ; --- Prévia ---
    g.Add("Text", "xm y+12", "Prévia")
    edtPrev := g.Add("Edit", "xm y+4 w400 r2 ReadOnly -Wrap")

    DropPT.OnEvent("Change", (*) => UpdatePreview())
    DropPN.OnEvent("Change", (*) => UpdatePreview())
    cbNeoadj.OnEvent("Click", (*) => UpdatePreview())
    cbMult.OnEvent("Click",   (*) => UpdatePreview())

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

        ; Tratamento para pN N/A
        if (pN = "pN") 
            pN := "pN não atribuído"

        ; Aplicar Modificador de Neoadjuvância [cite: 2112]
        if Saved.Neoadj {
            pT := "y" pT
            if (pN != "pN não atribuído")
                pN := "y" pN
        }
        
        ; Aplicar Modificador de Multiplicidade 
        if Saved.Mult
            pT := RegExReplace(pT, "^(y?pT)", "$1(m)")

        return "Estadiamento patológico (pTNM AJCC 8ª edição): " pT " " pN
    }
}