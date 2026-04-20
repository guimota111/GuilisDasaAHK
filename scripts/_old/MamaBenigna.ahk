; =========================================================
; Mastopatologia — Lesões Benignas e Atipias
; Arquivo: scripts\MamaBenigna.ahk
; =========================================================

Mask_MamaBenigna() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Mama Benigna")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. ATIPIAS ---
    g.AddGroupBox("w760 h130", "Lesões de Risco / Atipias")

    chkHDA := g.Add("Checkbox", "xp+15 yp+30 vHDA", "Hiperplasia ductal atípica")
    ddlHDA_Tipo := g.Add("DropDownList", "x+10 yp-3 w100 Choose1", ["focal", "multifocal"])
    g.AddText("x+10 yp+3", "Dim:")
    edtHDA_Dim := g.Add("Edit", "x+5 yp-3 w40", "")
    g.AddText("x+5 yp+3", "mm | Margem:")
    ddlHDA_Marg := g.Add("DropDownList", "x+5 yp-3 w120 Choose1", ["livre de", "comprometida pela"])

    chkAEP := g.Add("Checkbox", "x35 y+15 vAEP", "Atipia epitelial plana (AEP)")
    ddlAEP_Tipo := g.Add("DropDownList", "x195 yp-3 w100 Choose1", ["focal", "multifocal"])
    g.AddText("x+10 yp+3", "Dim:")
    edtAEP_Dim := g.Add("Edit", "x+5 yp-3 w40", "")
    g.AddText("x+5 yp+3", "mm | Margem:")
    ddlAEP_Marg := g.Add("DropDownList", "x+5 yp-3 w120 Choose1", ["livre de", "comprometida pela"])

    chkHLA := g.Add("Checkbox", "x35 y+15 vHLA", "Hiperplasia lobular atípica")

    ; --- 2. LESÕES BENIGNAS ---
    g.AddGroupBox("xm y+25 w760 h220", "Alterações Benignas")

    chkHDU := g.Add("Checkbox", "xp+15 yp+30 vHDU", "Hiperplasia ductal usual")
    chkCol := g.Add("Checkbox", "y+10 vCol", "Alt. células colunares sem atipias")
    chkFib := g.Add("Checkbox", "y+10 vFib", "Fibroadenoma")
    chkPap := g.Add("Checkbox", "y+10 vPap", "Papiloma intraductal sem atipias")
    chkAde := g.Add("Checkbox", "y+10 vAde", "Adenose simples e esclerosante")
    chkApo := g.Add("Checkbox", "y+10 vApo", "Alt. papilar apócrina / Metaplasia")
    chkEct := g.Add("Checkbox", "y+10 vEct", "Ectasia ductal / Cistificação")

    chkPSEA := g.Add("Checkbox", "x400 yp-150 vPSEA", "Hiperplasia pseudoangiomatosa (PSEA)")
    chkCalcL := g.Add("Checkbox", "y+10 vCalcL", "Microcalcificações intraluminais")
    chkCalcE := g.Add("Checkbox", "y+10 vCalcE", "Microcalcificações estromais")
    chkFibE := g.Add("Checkbox", "y+10 vFibE", "Fibrose estromal")
    chkLip := g.Add("Checkbox", "y+10 vLip", "Lipossubstituição")
    chkInf := g.Add("Checkbox", "y+10 vInf", "Processo inflamatório (corpo estranho)")

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+30", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r8 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    ; Em vez de loop, vamos usar um evento global simples para atualizar
    UpdatePreview(*) {
        edtPrev.Value := Build()
    }

    ; Registrando apenas os principais por segurança
    for c in [chkHDA, chkAEP, chkHLA, chkHDU, chkCol, chkFib, chkPap, chkAde, chkApo, chkEct, chkPSEA, chkCalcL, chkCalcE, chkFibE, chkLip, chkInf]
        c.OnEvent("Click", UpdatePreview)

    for c in [ddlHDA_Tipo, ddlHDA_Marg, ddlAEP_Tipo, ddlAEP_Marg, edtHDA_Dim, edtAEP_Dim]
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        itens := []

        if chkHDA.Value
            itens.Push("Hiperplasia ductal atípica " ddlHDA_Tipo.Text " (maior foco: " (edtHDA_Dim.Value || "[]") " mm), margem " ddlHDA_Marg.Text " lesão atípica")

        if chkAEP.Value
            itens.Push("Alteração de células colunares com atipias / atipia epitelial plana " ddlAEP_Tipo.Text " (maior foco: " (edtAEP_Dim.Value || "[]") " mm), margem " ddlAEP_Marg.Text " lesão atípica")

        if chkHLA.Value
            itens.Push("Hiperplasia lobular atípica, focal ou multifocal")
        if chkHDU.Value
            itens.Push("Hiperplasia ductal usual")
        if chkCol.Value
            itens.Push("Alteração de células colunares sem atipias")
        if chkFib.Value
            itens.Push("Fibroadenoma")
        if chkPap.Value
            itens.Push("Papiloma intraductal sem atipias")
        if chkAde.Value
            itens.Push("Adenose simples e esclerosante")
        if chkApo.Value
            itens.Push("Alteração papilar apócrina e metaplasia apócrina")
        if chkEct.Value
            itens.Push("Ectasia ductal e cistificação de ductos")
        if chkPSEA.Value
            itens.Push("Hiperplasia pseudoangiomatosa do estroma (PSEA)")
        if chkCalcL.Value
            itens.Push("Microcalcificações intraluminais")
        if chkCalcE.Value
            itens.Push("Microcalcificações estromais")
        if chkFibE.Value
            itens.Push("Fibrose estromal")
        if chkLip.Value
            itens.Push("Lipossubstituição do parênquima mamário")
        if chkInf.Value
            itens.Push("Processo inflamatório crônico com reação gigantocelular tipo corpo estranho e áreas de hemorragia antiga, compatível com resposta a procedimento prévio")

        if (itens.Length = 0)
            return "Tecido mamário dentro dos limites histológicos da normalidade."

        if (itens.Length = 1)
            return "Tecido mamário exibindo " itens[1] "."

        res := "Tecido mamário exibindo:`r`n"
        for index, texto in itens
            res .= ". " texto (index = itens.Length ? "." : "`r`n")

        return res
    }
}
