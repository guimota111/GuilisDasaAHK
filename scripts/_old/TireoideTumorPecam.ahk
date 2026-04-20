; =========================================================
; Cabeça e Pescoço — Tireoide (Carcinoma Papilífero Multifocal)
; Arquivo: scripts\TireoideMultifocal.ahk
; =========================================================

Mask_TireoideTumorPecam() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Tireoide (Multifocal)")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CLASSIFICAÇÃO E FOCOS ---
    g.AddGroupBox("w760 h110", "Classificação Histológica")
    g.AddText("xp+15 yp+30 w110", "Variante:")
    ddlVar := g.AddDropDownList("x140 yp-3 w400 Choose1 +Tabstop", ["clássico encapsulado", "clássico, não encapsulado", "variante folicular", "variante esclerosante difuso", "variante células altas", "variante cribriforme/morular", "variante células colunares"])

    g.AddText("x560 yp+3 w60", "Nº Focos:")
    edtFocos := g.AddEdit("x625 yp-3 w100 +Tabstop")

    ; --- 2. DIMENSÕES E LOCALIZAÇÃO ---
    g.AddGroupBox("xm y+25 w760 h130", "Dimensões e Localização")

    ; Lesão Maior
    g.AddText("xp+15 yp+30 w110", "Lesão Maior (cm):")
    edtMa1 := g.AddEdit("x140 yp-3 w60 +Tabstop"), g.AddText("x205 yp+3", "x"), edtMa2 := g.AddEdit("x220 yp-3 w60 +Tabstop")

    ; Lesão Menor
    g.AddText("x400 yp+3 w110", "Lesão Menor (cm):")
    edtMe1 := g.AddEdit("x520 yp-3 w60 +Tabstop"), g.AddText("x585 yp+3", "x"), edtMe2 := g.AddEdit("x600 yp-3 w60 +Tabstop")

    ; Localização
    g.AddText("x35 y+15 w110", "Localiz. (Terço):")
    ddlLoc := g.AddDropDownList("x140 yp-3 w620 Choose1 +Tabstop", ["superior", "médio", "inferior", "superior e médio", "médio e inferior", "superior e inferior", "superior, médio e inferior"])

    ; --- 3. EXTENSÃO E INVASÕES ---
    g.AddGroupBox("xm y+25 w760 h150", "Extensão e Invasões")

    g.AddText("xp+15 yp+35 w110", "Ext. Muscular:")
    ddlMusc := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["não detectada", "presente, focal", "presente, extensa"])

    g.AddText("x400 yp+3 w110", "Índice Mitótico:")
    edtMit := g.AddEdit("x520 yp-3 w60 +Tabstop", "0")
    g.AddText("x585 yp+3", "mitoses / 2,0 mm²")

    ; Invasões Sanguínea e Linfática
    g.AddText("x35 y+15 w110", "Invasão Sang.:")
    ddlVascS := g.AddDropDownList("x140 yp-3 w140 Choose1 +Tabstop", ["não detectada", "presente"])
    eFocS := g.AddEdit("x285 yp w40 Hidden +Tabstop")

    g.AddText("x400 yp w110", "Invasão Linf.:")
    ddlVascL := g.AddDropDownList("x520 yp-3 w140 Choose1 +Tabstop", ["não detectada", "presente"])
    eFocL := g.AddEdit("x665 yp w40 Hidden +Tabstop")

    ; --- 4. PARÊNQUIMA E ADJACENTES ---
    g.AddGroupBox("xm y+30 w760 h130", "Adjacentes e Perineural")

    g.AddText("xp+15 yp+30 w110", "Inv. Perineural:")
    ddlPeri := g.AddDropDownList("x140 yp-3 w140 Choose1 +Tabstop", ["não detectada", "presente"])

    g.AddText("x35 y+15 w110", "Parênquima:")
    ddlParenq := g.AddDropDownList("x140 yp-3 w620 Choose1 +Tabstop", ["dentro dos limites histológicos da normalidade", "doença nodular folicular da tireoide (bócio multinodular)", "tireoidite linfocítica", "hiperplasia de células foliculares", "doença nodular folicular da tireoide (bócio multinodular), tireoidite linfocítica", "doença nodular folicular da tireoide (bócio multinodular), hiperplasia de células foliculares", "doença nodular folicular da tireoide (bócio multinodular), tireoidite linfocítica e hiperplasia de células foliculares"])

    g.AddText("x35 y+15 w600", "Glândula paratireóide adjacente dentro dos limites histológicos da normalidade.")

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w760 r10 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE INTERFACE ---
    AtualizarLayout(*) {
        eFocS.Visible := (ddlVascS.Text == "presente")
        eFocL.Visible := (ddlVascL.Text == "presente")
        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlVar, edtFocos, edtMa1, edtMa2, edtMe1, edtMe2, ddlLoc, ddlMusc, edtMit, ddlVascS, eFocS, ddlVascL, eFocL, ddlPeri, ddlParenq]
    for c in controles
        c.OnEvent("Change", AtualizarLayout)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlVar.Focus()
    AtualizarLayout()

    Build() {
        res := "Carcinoma papilífero da tireoide " ddlVar.Text ", presente em " (edtFocos.Value || "[]") " focos.`n"
        res .= ". Dimensão da neoplasia:`n"
        res .= "  - Lesão maior: " (edtMa1.Value || "[]") " x " (edtMa2.Value || "[]") " cm.`n"
        res .= "  - Lesão menor: " (edtMe1.Value || "[]") " x " (edtMe2.Value || "[]") " cm.`n"
        res .= ". Localização: terço " ddlLoc.Text ".`n"
        res .= ". Extensão extratireoidiana muscular microscópica: " ddlMusc.Text ".`n"
        res .= ". Índice mitótico: " (edtMit.Value || "0") " mitoses em 10 campos de grande aumento (área de 2,0 mm²).`n"

        vS := (ddlVascS.Text == "não detectada") ? "não detectada" : "presente em " (eFocS.Value || "[]") " focos"
        res .= ". Invasão vascular sanguínea: " vS ".`n"

        vL := (ddlVascL.Text == "não detectada") ? "não detectada" : "presente em " (eFocL.Value || "[]") " focos"
        res .= ". Invasão vascular linfática: " vL ".`n"

        res .= ". Invasão perineural: " ddlPeri.Text ".`n"
        res .= "Parênquima tireoidiano não neoplásico: " ddlParenq.Text ".`n"
        res .= "Glândula paratireóide adjacente dentro dos limites histológicos da normalidade."
        return res
    }
}