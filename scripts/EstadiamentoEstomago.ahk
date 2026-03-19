; ==============================================================================
; ESTADIAMENTO — CARCINOMA DO ESTÔMAGO (AJCC 8ª Ed / CAP 4.4.0.0)
; ==============================================================================

Mask_EstadiamentoEstomagoCarcinoma() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Estadiamento — Estômago Carcinoma (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    ; AplicarIcone(g, "Logo.ico")

    g.SetFont("s12 Bold", "Segoe UI")
    g.Add("Text", "xm w420 Center", "Estadiamento — Estômago Carcinoma (AJCC 8ª Ed)")
    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "xm y+8 w420 0x10")

    ; --- pT --- [cite: 6211-6229, 6457-6498]
    g.Add("Text", "xm y+12", "Categoria pT:")
    DropPT := g.Add("DropDownList", "xm y+4 w420 vPTCategory", [
        "pTX (Não determinado)",
        "pT0 (Sem evidência de tumor)",
        "pTis (Carcinoma in situ / Displasia de alto grau)",
        "pT1a (Lâmina própria ou muscular da mucosa)",
        "pT1b (Submucosa)",
        "pT2 (Muscular própria)",
        "pT3 (Subserosa)",
        "pT4a (Serosa / Peritônio visceral)",
        "pT4b (Estruturas ou órgãos adjacentes)"
    ])

    ; --- pN --- [cite: 6233-6241, 6502-6508]
    g.Add("Text", "xm y+12", "Categoria pN:")
    DropPN := g.Add("DropDownList", "xm y+4 w420 vPNCategory", [
        "pN0 (Sem metástase regional ou ITC ≤0.2 mm)",
        "pN1 (1 a 2 linfonodos regionais)",
        "pN2 (3 a 6 linfonodos regionais)",
        "pN3a (7 a 15 linfonodos regionais)",
        "pN3b (16 ou mais linfonodos regionais)"
    ])

    ; --- Modificadores --- [cite: 6203-6208, 6441-6453]
    g.Add("Text", "xm y+12", "Modificadores:")
    cbNeoadj := g.Add("CheckBox", "xm y+4 vNeoadj", "Pós-neoadjuvância (prefixo y → ypT, ypN)")
    cbMult   := g.Add("CheckBox", "xm y+6 vMult",   "Tumores múltiplos (sufixo m → pT(m))")

    ; --- Prévia ---
    g.Add("Text", "xm y+12", "Prévia")
    edtPrev := g.Add("Edit", "xm y+4 w420 r2 ReadOnly -Wrap")

    ; Eventos para atualização dinâmica
    DropPT.OnEvent("Change", (*) => UpdatePreview())
    DropPN.OnEvent("Change", (*) => UpdatePreview())
    cbNeoadj.OnEvent("Click", (*) => UpdatePreview())
    cbMult.OnEvent("Click", (*) => UpdatePreview())

    ; --- Botões ---
    g.Add("Button", "xm y+14 w130 Default", "Inserir").OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    g.Add("Button", "x+10 w130", "Copiar").OnEvent("Click", (*) => (
        A_Clipboard := Build()
    ))
    g.Add("Button", "x+10 w130", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    g.Show("w452")
    UpdatePreview()

    UpdatePreview() {
        edtPrev.Value := Build()
    }

    Build() {
        Saved := g.Submit(false)
        pT := RegExReplace(Saved.PTCategory, " .*$", "")
        pN := RegExReplace(Saved.PNCategory, " .*$", "")

        ; Aplicação de prefixos e sufixos [cite: 6441-6453]
        if Saved.Neoadj
            pT := "y" pT, pN := "y" pN
        
        if Saved.Mult
            pT := RegExReplace(pT, "^(y?pT)", "$1(m)")

        return "Estadiamento patológico (pTNM AJCC 8ª edição): " pT " " pN
    }
}