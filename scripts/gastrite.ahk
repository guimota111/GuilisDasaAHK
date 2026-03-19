; =========================================================
; MÁSCARA — GASTRITE CRÔNICA (AutoHotkey v2)
; Arquivo para ser usado via #Include
; =========================================================

; Função "pública" para o menu chamar
Gastrite_Run() {
    Mask_GastriteCronica()
}

Mask_GastriteCronica() {
    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Gastrite crônica")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 16, g.MarginY := 14
    AplicarIcone(g, "Logo.ico")

    ; ---------- Linha 1: Gastrite crônica + mucosa ----------
    g.AddText("w120", "Gastrite crônica")
    ddlGrau := g.AddDropDownList("x+8 w170 Choose1 vGrau", ["leve", "moderada", "intensa"])

    g.AddText("x+12 w70", "em mucosa")
    ddlMucosa := g.AddDropDownList("x+8 w190 Choose1 vMucosa", ["de padrão fúndico", "de padrão antral", "juncional", "de cárdia"])

    ; ---------- Atividade / Atrofia ----------
    g.AddText("xm y+12 w120", "Atividade")
    ddlAtividade := g.AddDropDownList("x+8 w170 Choose1 vAtividade", ["ausente", "leve", "moderada", "intensa"])

    g.AddText("x+12 w120", "Atrofia")
    ddlAtrofia := g.AddDropDownList("x+8 w170 Choose1 vAtrofia", ["ausente", "leve", "moderada", "intensa"])

    ; ---------- Metaplasia intestinal ----------
    g.AddText("xm y+12 w120", "Metaplasia intestinal")
    ddlMI := g.AddDropDownList("x+8 w530 Choose1 vMI", [
        "ausente",
        "incompleta, focal e sem displasia",
        "incompleta, focal e com displasia de baixo grau",
        "incompleta, focal e com displasia de alto grau",
        "incompleta, difusa e sem displasia",
        "incompleta, difusa e com displasia de baixo grau",
        "incompleta, difusa e com displasia de alto grau",
        "completa, focal e sem displasia",
        "completa, focal e com displasia de baixo grau",
        "completa, focal e com displasia de alto grau",
        "completa, difusa e sem displasia",
        "completa, difusa e com displasia de baixo grau",
        "completa, difusa e com displasia de alto grau"
    ])

    ; ---------- H. pylori ----------
    g.AddText("xm y+12 w280", "Pesquisa de H. pylori (coloração especial Giemsa)")
    ddlHP := g.AddDropDownList("x+8 w170 Choose1 vHP", ["negativa", "positiva"])

    ; ---------- Outros achados (checkboxes) ----------
    g.AddText("xm y+12 w120", "Outros achados")
    cbAgg := g.AddCheckBox("xm y+6 vOA_Agregado", "agregado linfoide")
    cbFol := g.AddCheckBox("x+18 yp vOA_Foliculo", "folículo linfoide")
    cbEro := g.AddCheckBox("x+18 yp vOA_Erosao", "erosão")
    cbHf  := g.AddCheckBox("x+18 yp vOA_HFoveolar", "hiperplasia foveolar")

    ; ---------- Área de preview ----------
    g.AddText("xm y+12", "Prévia")
    edtPrev := g.AddEdit("xm w720 r6 ReadOnly -Wrap vPreview")


    for ctrl in [ddlGrau, ddlMucosa, ddlAtividade, ddlAtrofia, ddlMI, ddlHP, cbAgg, cbFol, cbEro, cbHf] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview(g))
        try ctrl.OnEvent("Click",  (*) => UpdatePreview(g))
    }

    ; ---------- Botões ----------
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        g.Submit(),
        txt := Build_GastriteCronica(g),
        InsertText(txt),
        g.Destroy()
    ))
    btnCopy.OnEvent("Click", (*) => (
        g.Submit(),
        txt := Build_GastriteCronica(g),
        A_Clipboard := txt
    ))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview(g)
}

UpdatePreview(g) {
    g.Submit(false)
    try g["Preview"].Value := Build_GastriteCronica(g)
}

Build_GastriteCronica(g) {
    grau      := g["Grau"].Text
    mucosa    := g["Mucosa"].Text
    atividade := g["Atividade"].Text
    atrofia   := g["Atrofia"].Text
    mi        := g["MI"].Text
    hp        := g["HP"].Text

    txt := "Gastrite crônica " grau " em mucosa " mucosa ".`n"
    txt .= ". Atividade " atividade "`n"
    txt .= ". Atrofia " atrofia "`n"
    txt .= ". Metaplasia intestinal " mi "`n"
    txt .= ". Pesquisa de H. pylori (coloração especial Giemsa): " hp

    oa := []
    if (g["OA_Agregado"].Value)
        oa.Push("agregados linfoides")
    if (g["OA_Foliculo"].Value)
        oa.Push("folículos linfoides")
    if (g["OA_Erosao"].Value)
        oa.Push("erosão")
    if (g["OA_HFoveolar"].Value)
        oa.Push("hiperplasia foveolar")

    if (oa.Length)
        txt .= "`n. Outros achados: " JoinList(oa, ", ")

    return txt
}

JoinList(arr, sep := ", ") {
    out := ""
    for i, v in arr
        out .= (i = 1 ? v : sep v)
    return out
}

