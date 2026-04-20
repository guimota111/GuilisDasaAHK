; =========================================================
; Mastopatologia — Tumor Filoide
; Arquivo: scripts\MamaFiloide.ahk
; =========================================================

Mask_MamaFiloide() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Mama: Tumor Filoide")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CLASSIFICAÇÃO E DIMENSÃO ---
    g.AddGroupBox("w760 h80", "Classificação Geral")
    g.AddText("xp+15 yp+30 w110", "Grau Histológico:")
    ddlGrau := g.AddDropDownList("x140 yp-3 w150 Choose1", ["benigno", "borderline", "maligno"])

    g.AddText("x310 yp+3", "Dimensão (cm):")
    edtDim1 := g.AddEdit("x410 yp-3 w50", ""), g.AddText("x465 yp+3", "x"), edtDim2 := g.AddEdit("x480 yp-3 w50", ""), g.AddText("x535 yp+3", "cm")

    ; --- 2. ANÁLISE ESTROMAL ---
    g.AddGroupBox("xm y+25 w760 h150", "Parâmetros Estromais")

    g.AddText("xp+15 yp+30 w110", "Mitoses (Escore):")
    ddlMitEscore := g.AddDropDownList("x140 yp-3 w150 Choose1", ["menos de 10 mitoses", "mais de 10 mitoses"])
    g.AddText("x310 yp+3", "Contagem real:")
    edtMitReal := g.AddEdit("x410 yp-3 w50", ""), g.AddText("x465 yp+3", "mit / 10 CGA")

    g.AddText("x35 y+35 w110", "Celularidade:")
    ddlCel := g.AddDropDownList("x140 yp-3 w150 Choose1", ["leve", "moderada", "acentuada"])
    g.AddText("x310 yp+3", "Atipia Estromal:")
    ddlAtipia := g.AddDropDownList("x410 yp-3 w150 Choose1", ["ausente", "leve", "moderada", "acentuada"])

    g.AddText("x35 y+35 w110", "Supercrescimento:")
    ddlSuper := g.AddDropDownList("x140 yp-3 w150 Choose1", ["ausente", "presente", "não pode ser determinada"])
    g.AddText("x310 yp+3", "Borda/Periferia:")
    ddlBorda := g.AddDropDownList("x410 yp-3 w150 Choose1", ["circunscrita", "infiltrativa, focal", "infiltrativa, extensa"])

    ; --- 3. ELEMENTOS HETERÓLOGOS ---
    g.AddGroupBox("xm y+25 w760 h80", "Elementos Heterólogos Malignos")
    ddlHetero := g.AddDropDownList("xp+15 yp+30 w350 Choose1", [
        "não detectados",
        "presentes, tipo lipossarcoma",
        "presentes, tipo osteossarcoma",
        "presentes, tipo condrossarcoma",
        "presentes, tipo {outros-citar}"
    ])
    edtOutros := g.AddEdit("x+10 yp w355 +Disabled", "especificar outro tipo")

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r8 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) {
        edtOutros.Enabled := (ddlHetero.Value = 5)
        edtPrev.Value := Build()
    }

    controles := [ddlGrau, edtDim1, edtDim2, ddlMitEscore, edtMitReal, ddlCel, ddlAtipia, ddlSuper, ddlBorda, ddlHetero, edtOutros]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        res := "Tumor Filoide histologicamente " ddlGrau.Text "`r`n"
        res .= ". Dimensão: " (edtDim1.Value || "[]") " x " (edtDim2.Value || "[]") " cm`r`n"
        res .= ". Índice mitótico: " ddlMitEscore.Text " - " (edtMitReal.Value || "[]") " mitoses por 10 campos de grande aumento – área de 1,96mm²`r`n"
        res .= ". Celularidade estromal: " ddlCel.Text "`r`n"
        res .= ". Atipia estromal: " ddlAtipia.Text "`r`n"
        res .= ". Supercrescimento estromal: " ddlSuper.Text "`r`n"
        res .= ". Delimitação da borda/periferia do tumor: " ddlBorda.Text "`r`n"

        heteroTxt := ddlHetero.Text
        if (ddlHetero.Value = 5)
            heteroTxt := StrReplace(heteroTxt, "{outros-citar}", edtOutros.Value)

        res .= ". Elementos heterólogos malignos: " heteroTxt "."
        return res
    }
}