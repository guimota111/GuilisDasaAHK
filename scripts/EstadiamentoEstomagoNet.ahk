; ==============================================================================
; ESTADIAMENTO — NET ESTÔMAGO (AJCC v9 / CAP 5.0.0.0)
; ==============================================================================

Mask_EstadiamentoStomachNET() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Estadiamento — NET Estômago (AJCC v9)")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14

    g.SetFont("s12 Bold", "Segoe UI")
    g.Add("Text", "xm w420 Center", "Estadiamento — NET Estômago (AJCC v9)")
    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "xm y+8 w420 0x10")

    ; --- pT ---
    g.Add("Text", "xm y+12", "Categoria pT:")
    DropPT := g.Add("DropDownList", "xm y+4 w420 vPTCategory", [
        "pTX (Não determinado)",
        "pT0 (Sem evidência de tumor primário)",
        "pT1 (Invade mucosa/submucosa E ≤ 1 cm)",
        "pT2 (Invade muscularis propria OU > 1 cm)",
        "pT3 (Invade subserosa)",
        "pT4 (Penetra serosa ou órgãos adjacentes)"
    ])

    ; --- pN ---
    g.Add("Text", "xm y+12", "Categoria pN:")
    DropPN := g.Add("DropDownList", "xm y+4 w420 vPNCategory", [
        "pN0 (Sem metástases regionais)",
        "pN1 (Metástase em linfonodo(s) regional(ais))",
        "pN N/A (Linfonodos não submetidos)"
    ])

    ; --- pM ---
    g.Add("Text", "xm y+12", "Categoria pM:")
    DropPM := g.Add("DropDownList", "xm y+4 w420 vPMCategory", [
        "pM N/A",
        "pM1a (Metástase apenas hepática)",
        "pM1b (Metástase apenas extra-hepática)",
        "pM1c (Metástases hepáticas e extra-hepáticas)"
    ])

    ; --- Modificadores ---
    g.Add("Text", "xm y+12", "Modificadores:")
    cbNeoadj := g.Add("CheckBox", "xm y+4 vNeoadj", "Pós-neoadjuvância (prefixo y)")
    cbMult   := g.Add("CheckBox", "xm y+6 vMult",   "Múltiplos tumores (sufixo m)")

    ; --- Prévia ---
    g.Add("Text", "xm y+12", "Prévia")
    edtPrev := g.Add("Edit", "xm y+4 w420 r2 ReadOnly -Wrap")

    ; --- CORREÇÃO DOS EVENTOS ---
    ; DropDowns usam "Change"
    for ctrl in [DropPT, DropPN, DropPM]
        ctrl.OnEvent("Change", (*) => UpdatePreview())
    
    ; CheckBoxes usam "Click"
    for ctrl in [cbNeoadj, cbMult]
        ctrl.OnEvent("Click", (*) => UpdatePreview())

    ; --- Botões ---
    g.Add("Button", "xm y+14 w130 Default", "Inserir").OnEvent("Click", (*) => (
        txt := Build(), g.Destroy(), PasteInto(prevWin, txt)
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
        pT := (Saved.PTCategory != "") ? RegExReplace(Saved.PTCategory, " .*$", "") : "pT"
        pN := (Saved.PNCategory != "") ? RegExReplace(Saved.PNCategory, " .*$", "") : "pN"
        pM := (Saved.PMCategory != "" && Saved.PMCategory != "pM N/A") ? RegExReplace(Saved.PMCategory, " .*$", "") : ""

        ; Lógica de prefixos
        if Saved.Neoadj {
            pT := "y" pT
            if (pN != "pN")
                pN := "y" pN
        }
        
        ; Lógica de multiplicidade
        if Saved.Mult
            pT := pT "(m)"

        res := "Estadiamento patológico (pTNM AJCC Versão 9): " pT " " pN
        return (pM != "") ? res " " pM : res
    }
}