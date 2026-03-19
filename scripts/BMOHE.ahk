; =========================================================
; Hematopatologia — Medula Óssea (Biópsia)
; Versão Final: Alinhamento Simétrico e Sem Erros de Sintaxe
; =========================================================

Mask_BMOHE() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Medula Óssea")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. QUALIDADE E ARQUITETURA ---
    g.AddGroupBox("w760 h110", "Qualidade e Arquitetura")
    g.AddText("xp+15 yp+30 w110", "Amostra:")
    ddl1 := g.AddDropDownList("x140 yp-3 w160 Choose1 +Tabstop", ["adequada", "inadequada"])
    g.AddText("x315 yp+3 w140", "N° Esp. Intertrab.:")
    edtEsp := g.AddEdit("x460 yp-3 w80 Number +Tabstop")

    g.AddText("x35 y+15 w110", "Arq. Geral:")
    ddl2 := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["preservada", "destruída"])
    g.AddText("x400 yp+3 w110", "Trabéculas:")
    ddl3 := g.AddDropDownList("x520 yp-3 w240 Choose1 +Tabstop", ["preservada", "destruídas por infiltração neoplásica", "Espessadas", "Adelgaçadas"])

    ; --- 2. CELULARIDADE GLOBAL ---
    g.AddGroupBox("xm y+25 w760 h120", "Celularidade Global")
    g.AddText("xp+15 yp+30 w50", "Tipo:")
    ddlCelType := g.AddDropDownList("x90 yp-3 w155 Choose1 +Tabstop", ["normocelular", "hipercelular", "hipocelular"])
    g.AddText("x260 yp+3 w75", "% Celulard.:")
    edtCel := g.AddEdit("x340 yp-3 w60 Number +Tabstop")
    g.AddText("x405 yp+3 w90", "Faixa Etária:")
    ddl4 := g.AddDropDownList("x500 yp-3 w195 Choose1 +Tabstop", ["acima", "abaixo", "compatível"])

    g.AddText("x35 y+15 w110", "Relação M:E:")
    edtM := g.AddEdit("x140 yp-3 w50 Number +Tabstop", "3")
    g.AddText("x195 yp+3", ":")
    edtE := g.AddEdit("x205 yp-3 w50 Number +Tabstop", "1")

    ; --- 3. SÉRIES HEMATOPOÉTICAS ---
    g.AddGroupBox("xm y+25 w760 h200", "Séries Hematopoéticas")

    ; Eritroide
    g.AddText("x35 yp+35 w110", "Eritróide:")
    ddl5 := g.AddDropDownList("x140 yp-3 w120 Choose1 +Tabstop", ["preservada", "aumentada", "reduzida"])
    g.AddText("x280 yp+3", "Localização:")
    ddl6 := g.AddDropDownList("x365 yp-3 w130 Choose1 +Tabstop", ["Intersticial", "Peritrabecular"])
    g.AddText("x510 yp+3", "Maturação:")
    ddl7 := g.AddDropDownList("x590 yp-3 w160 Choose1 +Tabstop", ["preservada", "alterada pela presença de elementos blásticos e/ou displásicos"])

    ; Mieloide
    g.AddText("x35 y+18 w110", "Mieloide:")
    ddl8 := g.AddDropDownList("x140 yp-3 w120 Choose1 +Tabstop", ["preservada", "aumentada", "reduzida"])
    g.AddText("x280 yp+3", "Blastos:")
    ddl9 := g.AddDropDownList("x365 yp-3 w130 Choose1 +Tabstop", ["peritrabecular", "intersticial"])
    g.AddText("x510 yp+3", "F. Maduras:")
    ddl10 := g.AddDropDownList("x590 yp-3 w160 Choose1 +Tabstop", ["intersticial", "peritrabecular"])

    g.AddText("x35 y+15 w110", "Maturação Mielo:")
    ddl11 := g.AddDropDownList("x140 yp-3 w610 Choose1 +Tabstop", ["preservada", "alterada pela presença de elementos displásicos"])

    ; Megacariocítica
    g.AddText("x35 y+18 w110", "Megacariocítica:")
    ddl12 := g.AddDropDownList("x140 yp-3 w120 Choose1 +Tabstop", ["preservada", "aumentada", "reduzida"])
    g.AddText("x280 yp+3", "Maturação:")
    ddl13 := g.AddDropDownList("x365 yp-3 w130 Choose1 +Tabstop", ["preservada", "alterada pela presença de elementos blásticos e/ou displásicos"])
    g.AddText("x510 yp+3", "Localização:")
    ddl14 := g.AddDropDownList("x590 yp-3 w160 Choose1 +Tabstop", ["perisinusal", "intersticial"])

    ; --- 4. FIBROSE ---
    g.AddGroupBox("xm y+30 w760 h80", "Fibrose (Reticulina)")
    g.AddText("xp+15 yp+35 w110", "Fibrose:")
    ddl15 := g.AddDropDownList("x140 yp-3 w620 Choose1 +Tabstop", ["grau 0 (MF 0-3)", "grau 1 (MF 0-3)", "grau 2 (MF 0-3)", "grau 3 (MF 0-3)"])

    ; --- 5. ELEMENTOS ESTRANHOS ---
    g.AddGroupBox("xm y+25 w760 h100", "Elementos Estranhos")
    g.AddText("xp+15 yp+30 w65", "Corp. Estr.:")
    ddl_ce := g.AddDropDownList("x105 yp-3 w80 Choose2 +Tabstop", ["presença", "ausência"])
    g.AddText("x195 yp+3 w75", "Granulomas:")
    ddl_gran := g.AddDropDownList("x275 yp-3 w80 Choose2 +Tabstop", ["presença", "ausência"])
    g.AddText("x365 yp+3 w70", "Abscessos:")
    ddl_abs := g.AddDropDownList("x440 yp-3 w80 Choose2 +Tabstop", ["presença", "ausência"])
    g.AddText("x530 yp+3 w65", "Microorg.:")
    ddl_micro := g.AddDropDownList("x600 yp-3 w80 Choose2 +Tabstop", ["presença", "ausência"])

    g.AddText("x35 y+15 w120", "Elem. Cel. Estr.:")
    ddl_ece := g.AddDropDownList("x160 yp-3 w80 Choose2 +Tabstop", ["presença", "ausência"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w760 r10 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS E LÓGICA ---
    UpdatePreview(*) => edtPrev.Value := Build()
    controles := [ddl1, edtEsp, ddl2, ddl3, ddlCelType, edtCel, ddl4, edtM, edtE, ddl5, ddl6, ddl7, ddl8, ddl9, ddl10, ddl11, ddl12, ddl13, ddl14, ddl15, ddl_ce, ddl_gran, ddl_abs, ddl_micro, ddl_ece]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddl1.Focus()
    UpdatePreview()

    Build() {
        espStr := (edtEsp.Value == "") ? "XX" : edtEsp.Value
        celStr := (edtCel.Value == "") ? "XX" : edtCel.Value
        vCel   := (edtCel.Value == "") ? 0 : Number(edtCel.Value)
        rAdip  := 100 - vCel
        mVal   := (edtM.Value || "X"), eVal := (edtE.Value || "X")

        res := "DESCRIÇÃO MICROSCÓPICA:`n"
        res .= ". Amostra de medula óssea " ddl1.Text " para avaliação, constituída por " espStr " espaços intertrabeculares, com arquitetura geral " ddl2.Text ".`n"
        res .= ". Trabéculas ósseas " ddl3.Text ".`n"
        res .= ". Celularidade global: " ddlCelType.Text ", com relação celularidade : tecido adiposo de " celStr "%, " ddl4.Text " dos valores esperados para faixa etária.`n"
        res .= ". Relação série mieloide:eritroide de " mVal ":" eVal ".`n"
        res .= ". A série eritróide apresenta celularidade " ddl5.Text ", organizada em colônias, de localização " ddl6.Text " e com maturação " ddl7.Text ".`n"
        res .= ". A série mieloide apresenta celularidade " ddl8.Text ", com blastos de localização " ddl9.Text " e formas maduras de localização " ddl10.Text ", com maturação " ddl11.Text ".`n"
        res .= ". A série megacariocítica apresenta celularidade " ddl12.Text ", maturação " ddl13.Text ", de localização " ddl14.Text ".`n"
        res .= ". Fibrose: " ddl15.Text ".`n"
        res .= ". Observa-se, ainda, " ddl_ce.Text " de corpos estranhos ao parênquima medular, " ddl_gran.Text " de granulomas, " ddl_abs.Text " de abscessos, " ddl_micro.Text " de microorganismos e " ddl_ece.Text " de elementos celulares estranhos (excesso de plasmócitos, linfócitos e eosinófilos) e de acúmulo anormal de ferro.`n`n"
        res .= "Notas:`n1.Em andamento estudo imuno-histoquímico para contagem diferencial de células hematopoéticas`n2. Foram realizadas as colorações especiais pelos métodos tricrômico de Masson, Giemsa e Reticulina."
        return res
    }
}
