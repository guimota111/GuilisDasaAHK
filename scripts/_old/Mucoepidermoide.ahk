; =========================================================
; Cabeça e Pescoço — Carcinoma Mucoepidermoide (AFIP)
; Arquivo: scripts\Mucoepidermoide.ahk
; =========================================================

Mask_Mucoepidermoide() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Carcinoma Mucoepidermoide")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CLASSIFICAÇÃO E ESCORE AFIP ---
    g.AddGroupBox("w760 h110", "Classificação e Escore (AFIP)")
    g.AddText("xp+15 yp+30 w110", "Grau Histológico:")
    ddlGrau := g.AddDropDownList("x140 yp-3 w160 Choose1 +Tabstop", ["baixo", "intermediário", "alto"])

    g.AddText("x320 yp+3 w110", "Escore Final:")
    edtEscore := g.AddEdit("x410 yp-3 w40 +Tabstop")

    g.AddText("x465 yp+3 w280", "(0-4: Baixo | 5-6: Interm. | 7+: Alto)")

    ; --- 2. CRITÉRIOS DE PONTUAÇÃO ---
    g.AddGroupBox("xm y+25 w760 h180", "Critérios de Pontuação")

    ; Linha 1: Componente Cístico e Perineural
    g.AddText("xp+15 yp+35 w110", "Comp. Cístico:")
    edtCist := g.AddEdit("x140 yp-3 w40 +Tabstop"), g.AddText("x185 yp+3", "%")
    ddlCistPts := g.AddDropDownList("x220 yp-3 w160 Choose1 +Tabstop", ["0 pts (>20%)", "2 pts (<20%)"])

    g.AddText("x400 yp+3 w110", "Inv. Perineural:")
    ddlPeri := g.AddDropDownList("x520 yp-3 w225 Choose2 +Tabstop", ["presente (2 pts)", "não detectada (0 pts)"])

    ; Linha 2: Mitoses e Necrose
    g.AddText("x35 y+15 w110", "Índice Mitótico:")
    edtMit := g.AddEdit("x140 yp-3 w40 +Tabstop")
    ddlMitPts := g.AddDropDownList("x220 yp-3 w160 Choose1 +Tabstop", ["0 pts (<4/10CGA)", "3 pts (>=4/10CGA)"])

    g.AddText("x400 yp+3 w110", "Necrose:")
    ddlNec := g.AddDropDownList("x520 yp-3 w225 Choose2 +Tabstop", ["presente (3 pts)", "não detectada (0 pts)"])

    ; Linha 3: Anaplasia
    g.AddText("x35 y+15 w110", "Anaplasia:")
    ddlAna := g.AddDropDownList("x140 yp-3 w240 Choose2 +Tabstop", ["presente (4 pts)", "não detectada (0 pts)"])

    ; --- 3. DIMENSÕES E EXTENSÃO ---
    g.AddGroupBox("xm y+25 w760 h150", "Dimensões e Invasão")
    g.AddText("xp+15 yp+35 w110", "Dimensões (cm):")
    edtDim1 := g.AddEdit("x140 yp-3 w50 +Tabstop"), g.AddText("x195 yp+3", "x"), edtDim2 := g.AddEdit("x210 yp-3 w50 +Tabstop")

    g.AddText("x400 yp+0 w110", "Multifocalidade:")
    ddlMulti := g.AddDropDownList("x520 yp-3 w225 Choose2 +Tabstop", ["presente", "não detectada"])

    g.AddText("x35 y+15 w110", "Extensão Tumor:")
    ddlExt := g.AddDropDownList("x140 yp-3 w605 Choose1 +Tabstop", ["restrito à glândula salivar", "com extensão extraparenquimatosa apenas à microscopia", "com extensão extraparenquimatosa à macroscopia", "invade a pele", "invade o conduto auditivo externo", "invade a mandíbula", "invade o nervo facial", "invade a base do crânio", "invade a placa pterigoide", "envolve a artéria carótida"])

    ; --- 4. OUTRAS INVASÕES E ASSOCIADAS ---
    g.AddGroupBox("xm y+30 w760 h110", "Invasões e Lesões Associadas")
    g.AddText("xp+15 yp+35 w110", "Vasc (L/S):")
    ddlVascL := g.AddDropDownList("x140 yp-3 w100 Choose2 +Tabstop", ["L: sim", "L: não"])
    ddlVascS := g.AddDropDownList("x+5 w100 Choose2 +Tabstop", ["S: sim", "S: não"])
    g.AddText("x370 yp+3 w80", "Inv. Óssea:")
    ddlOssea := g.AddDropDownList("x450 yp-3 w100 Choose2 +Tabstop", ["presente", "não detectada"])

    g.AddText("x570 yp+3 w40", "TALP:")
    ddlTalp := g.AddDropDownList("x615 yp-3 w130 Choose2 +Tabstop", ["presente", "não detectada"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w760 r8 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()
    controles := [ddlGrau, edtEscore, edtCist, ddlCistPts, ddlPeri, edtMit, ddlMitPts, ddlNec, ddlAna, edtDim1, edtDim2, ddlMulti, ddlExt, ddlVascL, ddlVascS, ddlOssea, ddlTalp]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlGrau.Focus()
    UpdatePreview()

    Build() {
        res := "Carcinoma mucoepidermoide de " ddlGrau.Text " grau histológico.`n"
        res .= ". Escore final (AFIP point system): " (edtEscore.Value || "[]") "`n"
        res .= "- Proporção do componente intracístico: " (edtCist.Value || "[]") "% do total da neoplasia (" ddlCistPts.Text ")`n"
        res .= "- Invasão perineural: " ddlPeri.Text "`n"
        res .= "- Necrose: " ddlNec.Text "`n"
        res .= "- Índice mitótico: " (edtMit.Value || "[]") " mitoses em 10 campos de grande aumento (" ddlMitPts.Text ")`n"
        res .= "- Anaplasia: " ddlAna.Text "`n"
        res .= ". Dimensão da neoplasia: " (edtDim1.Value || "[]") " x " (edtDim2.Value || "[]") " cm.`n"
        res .= ". Multifocalidade: " ddlMulti.Text ".`n"
        res .= ". Invasão microscópica da neoplasia: tumor " ddlExt.Text ".`n"

        vL := (ddlVascL.Text == "L: sim") ? "presente" : "não detectada"
        res .= ". Invasão vascular linfática: " vL ".`n"
        vS := (ddlVascS.Text == "S: sim") ? "presente" : "não detectada"
        res .= ". Invasão vascular sanguínea: " vS ".`n"

        res .= ". Invasão óssea: " ddlOssea.Text ".`n"
        res .= "Lesões associadas:`n- Proliferação de tecido linfoide associado ao tumor (TALP): " ddlTalp.Text "."
        return res
    }
}