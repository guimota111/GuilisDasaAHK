; =========================================================
; MÁSCARA — ESTÔMAGO NORMAL (AutoHotkey v2)
; Arquivo para ser usado via #Include
; =========================================================

; Função "pública" para o menu chamar

Mask_EstomagoNormal() {
    prevWin := WinGetID("A")   ; guarda a janela ativa antes do GUI

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Estômago normal")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    g.AddText("w120", "Mucosa")
    ddlMucosa := g.AddDropDownList("x+8 w420 Choose1", [
        "gástrica de padrão fúndico",
        "gástrica de padrão antral",
        "gástrica juncional",
        "de cárdia"
    ])

    g.AddText("xm y+12 w280", "Pesquisa de H. pylori (Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w170 Choose1", ["negativa", "positiva"])

    g.AddText("xm y+12", "Prévia")
    edtPrev := g.AddEdit("xm w720 r4 ReadOnly -Wrap")

    ddlMucosa.OnEvent("Change", (*) => UpdatePreview())
    ddlHP.OnEvent("Change", (*) => UpdatePreview())

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := Build_EstomagoNormal(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))

    btnCopy.OnEvent("Click", (*) => (
        txt := Build_EstomagoNormal(),
        A_Clipboard := txt
    ))

    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    UpdatePreview() {
        edtPrev.Value := Build_EstomagoNormal()
    }

    Build_EstomagoNormal() {
        return (
            "Fragmentos de mucosa " ddlMucosa.Text " dentro dos limites histológicos da normalidade`n"
            ". Pesquisa de H. pylori (coloração especial Giemsa): " ddlHP.Text
        )
    }
}
