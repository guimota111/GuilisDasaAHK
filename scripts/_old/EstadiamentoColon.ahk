; ==============================================================================
; ESTADIAMENTO — CÓLON E RETO (AJCC 8ª Ed / CAP 4.4.0.1)
; ==============================================================================

Mask_EstadiamentoColon() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Estadiamento — Cólon e Reto (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    g.SetFont("s12 Bold", "Segoe UI")
    g.Add("Text", "xm w400 Center", "Estadiamento — Cólon e Reto (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "xm y+8 w400 0x10")

    ; --- pT ---
    g.Add("Text", "xm y+12", "Categoria pT:")
    DropPT := g.Add("DropDownList", "xm y+4 w400 vPTCategory", [
        "pTX (Não determinado)",
        "pT0 (Sem evidência de tumor)",
        "pTis (Carcinoma in situ / Intramucosal)",
        "pT1 (Invade submucosa)",
        "pT2 (Invade muscular própria)",
        "pT3 (Invade através da muscular própria no pericolorectal)",
        "pT4a (Penetra a superfície do peritônio visceral)",
        "pT4b (Invade diretamente outros órgãos ou estruturas)"
    ])

    ; --- pN ---
    g.Add("Text", "xm y+12", "Categoria pN:")
    DropPN := g.Add("DropDownList", "xm y+4 w400 vPNCategory", [
        "pNX (Não determinado)",
        "pN0 (Sem metástases regionais)",
        "pN1a (1 linfonodo regional positivo)",
        "pN1b (2-3 linfonodos regionais positivos)",
        "pN1c (Depósitos tumorais sem linfonodos positivos)",
        "pN2a (4-6 linfonodos regionais positivos)",
        "pN2b (7 ou mais linfonodos regionais positivos)"
    ])

    ; --- Modificadores ---
    g.Add("Text", "xm y+12", "Modificadores:")
    cbMult   := g.Add("CheckBox", "xm y+4 vMult",   "Tumores múltiplos (sufixo m → pT(m))")
    cbNeoadj := g.Add("CheckBox", "xm y+6 vNeoadj", "Pós-neoadjuvância (prefixo y → ypT, ypN)")

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

        ; Aplicar prefixo y (neoadjuvância)
        if Saved.Neoadj
            pT := "y" pT, pN := "y" pN
        
        ; Aplicar sufixo (m) para multiplicidade
        if Saved.Mult
            pT := RegExReplace(pT, "^(y?pT[is1-4][a-b]?)", "$1(m)")

        return "Estadiamento patológico (pTNM AJCC 8ª edição): " pT " " pN
    }
}