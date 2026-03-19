; =========================================================
; Cabeça e Pescoço — Outras Neoplasias Malignas de Salivar
; Arquivo: scripts\SalivaresOutrasMalignas.ahk
; =========================================================

Mask_SalivaresOutrasMalignas() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Outras Malignas Salivares")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. TIPO HISTOLÓGICO ---
    g.AddGroupBox("w760 h80", "Classificação Histológica")
    g.AddText("xp+15 yp+30 w110", "Tipo de Tumor:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", [
        "Carcinoma de células acinares",
        "Carcinoma mioepitelial",
        "Carcinoma epitelial-mioepitelial",
        "Carcinoma do ducto salivar",
        "Carcinoma de células claras (hialinizante)",
        "Adenocarcinoma de células basais",
        "Carcinoma intraductal de alto grau",
        "Carcinoma intraductal de baixo grau",
        "Carcinoma linfo-epitelial",
        "Carcinoma de células escamosas",
        "Adenocarcinoma sebáceo",
        "Carcinossarcoma"])

    ; --- 2. DIMENSÕES E FOCO ---
    g.AddGroupBox("xm y+25 w760 h110", "Dimensões e Foco")
    g.AddText("xp+15 yp+30 w110", "Dimensões (cm):")
    edtDim1 := g.AddEdit("x140 yp-3 w60 +Tabstop"), g.AddText("x205 yp+3", "x"), edtDim2 := g.AddEdit("x220 yp-3 w60 +Tabstop")

    g.AddText("x400 yp+0 w110", "Multifocalidade:")
    ddlMulti := g.AddDropDownList("x520 yp-3 w225 Choose2 +Tabstop", ["presente", "não detectada"])

    ; --- 3. EXTENSÃO E INVASÕES ---
    g.AddGroupBox("xm y+25 w760 h180", "Invasão e Extensão")

    g.AddText("xp+15 yp+35 w110", "Extensão Tumor:")
    ddlExt := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", [
        "restrito à glândula salivar",
        "com extensão extraparenquimatosa apenas à microscopia",
        "com extensão extraparenquimatosa à macroscopia",
        "invade a pele",
        "invade o conduto auditivo externo",
        "invade a mandíbula",
        "invade o nervo facial",
        "invade a base do crânio",
        "invade a placa pterigoide",
        "envolve a artéria carótida"])

    ; Linhas de Invasão
    g.AddText("x35 y+15 w110", "Invasão Linf.:")
    ddlVascL := g.AddDropDownList("x140 yp-3 w140 Choose2 +Tabstop", ["presente", "não detectada"])
    g.AddText("x400 yp+3 w110", "Invasão Sang.:")
    ddlVascS := g.AddDropDownList("x520 yp-3 w140 Choose2 +Tabstop", ["presente", "não detectada"])

    g.AddText("x35 y+15 w110", "Inv. Perineural:")
    ddlPeri := g.AddDropDownList("x140 yp-3 w140 Choose2 +Tabstop", ["presente", "não detectada"])
    g.AddText("x400 yp+3 w110", "Invasão Óssea:")
    ddlOssea := g.AddDropDownList("x520 yp-3 w140 Choose2 +Tabstop", ["presente", "não detectada"])

    ; --- 4. LESÕES ASSOCIADAS ---
    g.AddGroupBox("xm y+30 w760 h100", "Lesões Associadas")
    g.AddText("xp+15 yp+35 w110", "Sialoadenite:")
    ddlSialo := g.AddDropDownList("x140 yp-3 w140 Choose2 +Tabstop", ["presente", "não detectada"])
    g.AddText("x400 yp+3 w110", "TALP:")
    ddlTalp := g.AddDropDownList("x520 yp-3 w140 Choose2 +Tabstop", ["presente", "não detectada"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w760 r10 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()
    controles := [ddlTipo, edtDim1, edtDim2, ddlMulti, ddlExt, ddlVascL, ddlVascS, ddlPeri, ddlOssea, ddlSialo, ddlTalp]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlTipo.Focus()
    UpdatePreview()

    Build() {
        res := ddlTipo.Text ".`n"
        res .= ". Multifocalidade: " ddlMulti.Text ".`n"
        res .= ". Dimensão da neoplasia: " (edtDim1.Value || "[]") " x " (edtDim2.Value || "[]") " cm.`n"
        res .= ". Invasão microscópica da neoplasia: tumor " ddlExt.Text ".`n"
        res .= ". Invasão vascular linfática: " ddlVascL.Text ".`n"
        res .= ". Invasão vascular sanguínea: " ddlVascS.Text ".`n"
        res .= ". Invasão perineural: " ddlPeri.Text ".`n"
        res .= ". Invasão óssea: " ddlOssea.Text ".`n"
        res .= "Lesões associadas:`n"
        res .= "- Sialoadenite: " ddlSialo.Text ".`n"
        res .= "- Proliferação de tecido linfoide associado ao tumor (TALP): " ddlTalp.Text "."
        return res
    }
}