; =========================================================
; Patologia — Próstata Benigna
; Arquivo: scripts\ProstataBenigna.ahk
; =========================================================

Mask_ProstataBenigna() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Próstata Benigna")
    if IsSet(AplicarIcone) ; Verifica se a função de ícone existe para evitar erros
        AplicarIcone(g)

    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. ALTERAÇÕES ---
    g.AddGroupBox("w400 h130", "Alterações Histopatológicas")

    chkHiperplasia := g.Add("Checkbox", "xp+15 yp+30", "Hiperplasia prostática benigna")
    chkInflamacao  := g.Add("Checkbox", "y+10", "Processo inflamatório crônico")
    chkAtrofia     := g.Add("Checkbox", "y+10", "Atrofia acinar")

    ; Marcados por definição
    chkHiperplasia.Value := 1
    chkInflamacao.Value := 1
    chkAtrofia.Value := 1

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+30", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r6 w400 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) {
        edtPrev.Value := Build()
    }

    for c in [chkHiperplasia, chkInflamacao, chkAtrofia]
        c.OnEvent("Click", UpdatePreview)

    ; Nota: PasteInto deve estar definida no seu script principal
    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    ; --- LÓGICA DE CONSTRUÇÃO DO TEXTO ---
   Build() {
        itens := []

        if chkHiperplasia.Value
            itens.Push("hiperplasia prostática benigna")
        if chkInflamacao.Value
            itens.Push("processo inflamatório crônico")
        if chkAtrofia.Value
            itens.Push("atrofia acinar")

        if (itens.Length = 0)
            return "Tecido prostático dentro dos limites histológicos da normalidade."

        if (itens.Length = 1)
            return "Tecido prostático exibindo " itens[1] "."

        res := "Tecido prostático exibindo:`r`n"
        for index, texto in itens {
            ; Transforma apenas a primeira letra em Maiúscula
            primeiraLetra := StrUpper(SubStr(texto, 1, 1))
            restoTexto := SubStr(texto, 2)
            itemFormatado := primeiraLetra . restoTexto

            ; Monta a linha com o ponto final apenas no último item
            res .= ". " itemFormatado (index = itens.Length ? "." : "`r`n")
        }

        return res
    }
}