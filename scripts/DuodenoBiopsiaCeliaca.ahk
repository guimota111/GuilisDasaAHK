; =========================================================
; Duodeno — Biópsia — Doença celíaca (Marsh / Corazza / Ensari)
; Arquivo: scripts\DuodenoBiopsiaCeliaca.ahk
; Requer: PasteInto(hwnd, txt) em _lib\gui_utils.ahk (via #Include no principal)
; Chamada no menu: (*) => Mask_DuodenoBiopsiaCeliaca()
; =========================================================

Mask_DuodenoBiopsiaCeliaca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Duodeno — Doença celíaca")
    g.MarginX := 12, g.MarginY := 12

    ; =========================
    ; MORFOLOGIA
    ; =========================
    g.AddText("w220", "Linfócitos intraepiteliais")
    ddlLIE := g.AddDropDownList("x+8 w520 Choose1", [
        "proporção linfócitos intraepiteliais/enterócitos preservada (menos de 30 linfócitos/100 enterócitos)",
        "proporção linfócitos intraepiteliais/enterócitos aumentada (mais de 30 linfócitos/100 enterócitos), com concentração dos linfócitos no topo das vilosidades"
    ])

    g.AddText("xm y+10 w220", "Vilosidades")
    ddlVilos := g.AddDropDownList("x+8 w520 Choose1", [
        "preservadas, com relação vilosidade cripta ≥ 3:1",
        "parcialmente atróficas, com relação vilosidade cripta < 3:1",
        "atrofia completa, com relação vilosidade cripta < 1"
    ])

    g.AddText("xm y+10 w220", "Criptas")
    ddlCriptas := g.AddDropDownList("x+8 w520 Choose1", [
        "preservadas",
        "hiperplásicas"
    ])

    ; =========================
    ; CLASSIFICAÇÕES
    ; =========================
    g.AddText("xm y+16 w720", "Categoria diagnóstica dos achados histológicos")

    g.AddText("xm y+6 w220", "Marsh-Oberhuber (1999)")
    ddlMarsh := g.AddDropDownList("x+8 w520 Choose1", [
        "0 (achados histológicos normais)",
        "1 (aumento de linfócitos intraepiteliais, sem hiperplasia de criptas e/ou atrofia de vilosidades)",
        "2 (aumento de linfócitos intraepiteliais e hiperplasia de criptas, sem atrofia de vilosidades)",
        "3a (aumento de linfócitos intraepiteliais, hiperplasia de criptas e atrofia leve de vilosidades)",
        "3b (aumento de linfócitos intraepiteliais, hiperplasia de criptas e atrofia parcial de vilosidades)",
        "3c (aumento de linfócitos intraepiteliais, hiperplasia de criptas e atrofia total de vilosidades)"
    ])

    g.AddText("xm y+10 w220", "Corazza & Villanacci (2005)")
    ddlCorazza := g.AddDropDownList("x+8 w520 Choose1", [
        "A (aumento de linfócitos intraepiteliais, sem hiperplasia de criptas e/ou atrofia de vilosidades)",
        "B1 (aumento de linfócitos intraepiteliais, hiperplasia de criptas e atrofia parcial de vilosidades)",
        "B2 (aumento de linfócitos intraepiteliais, hiperplasia de criptas e atrofia total de vilosidades)"
    ])

    g.AddText("xm y+10 w220", "Ensari (2010)")
    ddlEnsari := g.AddDropDownList("x+8 w520 Choose1", [
        "1 (aumento de linfócitos intraepiteliais, sem hiperplasia de criptas e/ou aplanamento de vilosidades)",
        "2 (aumento de linfócitos intraepiteliais, hiperplasia de criptas e aplanamento parcial de vilosidades)",
        "3 (aumento de linfócitos intraepiteliais, hiperplasia de criptas e aplanamento total de vilosidades)"
    ])

    ; Nota final (checkbox pra ligar/desligar)
    chkNota := g.AddCheckBox("xm y+14 Checked", "Incluir nota de correlação clínico-laboratorial")

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+12", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    for ctrl in [ddlLIE, ddlVilos, ddlCriptas, ddlMarsh, ddlCorazza, ddlEnsari, chkNota] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := Build()))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        txt := (
            "Fragmentos de mucosa duodenal exibindo:`n"
            ". Linfócitos intraepiteliais: " ddlLIE.Text "`n"
            ". Vilosidades: " ddlVilos.Text "`n"
            ". Criptas " ddlCriptas.Text "`n"
            "CATEGORIA DIAGNÓSTICA DOS ACHADOS HISTOLÓGICOS`n"
            "Marsh-Oberhuber modificada (1999):`n"
            ". Tipo " ddlMarsh.Text "`n"
            "Corazza & Villanacci (2005):`n"
            ". Grau " ddlCorazza.Text "`n"
            "Ensari (2010):`n"
            ". Tipo " ddlEnsari.Text
        )

        if (chkNota.Value) {
            txt .= "`nNota: Os achados morfológicos favorecem o diagnóstico de doença celíaca. É necessária a correlação com dados clínicos e laboratoriais para confirmação diagnóstica"
        }

        return txt
    }
}
