; =========================================================
; Cabeça e Pescoço — Tireoide (Neoplasia em Peça)
; Arquivo: scripts\TireoideTumor.ahk
; =========================================================

Mask_TireoideTumor() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Tireoide (Tumor)")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. TIPO HISTOLÓGICO E VARIANTE ---
    g.AddGroupBox("w760 h110", "Classificação Histológica")
    g.AddText("xp+15 yp+30 w110", "Tipo:")
    ddlTipo := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["papilífero", "folicular", "medular", "de células de Hürthle (oncocítico)", "pouco diferenciado (anaplásico)"])

    g.AddText("x400 yp+3 w110", "Variante:")
    ddlVar := g.AddDropDownList("x520 yp-3 w240 Choose1 +Tabstop", ["clássico encapsulado", "clássico, não encapsulado", "variante folicular", "variante esclerosante difuso", "variante células altas", "variante cribriforme/morular", "variante células colunares", "minimamente invasivo", "angioinvasivo encapsulado", "francamente invasivo"])

    ; --- 2. LOCALIZAÇÃO E DIMENSÕES ---
    g.AddGroupBox("xm y+25 w760 h110", "Localização e Dimensões")
    g.AddText("xp+15 yp+30 w110", "Terço:")
    ddlLoc := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["superior", "médio", "inferior", "superior e médio", "médio e inferior", "superior e inferior", "superior, médio e inferior"])

    g.AddText("x400 yp+3 w110", "Dimensões (cm):")
    edtDim1 := g.AddEdit("x520 yp-3 w50 +Tabstop")
    g.AddText("x575 yp+3", "x")
    edtDim2 := g.AddEdit("x590 yp-3 w50 +Tabstop")

    ; --- 3. EXTENSÃO E INVASÕES ---
    g.AddGroupBox("xm y+25 w760 h180", "Extensão e Invasões")

    g.AddText("xp+15 yp+35 w110", "Ext. Tec. Muscular:")
    ddlMusc := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["não detectada", "presente, focal", "presente, extensa"])

    g.AddText("x400 yp+3 w110", "Necrose:")
    ddlNec := g.AddDropDownList("x520 yp-3 w120 Choose2 +Tabstop", ["presente", "não detectada"])

    ; Invasão Vascular Sanguínea
    g.AddText("x35 y+15 w110", "Invasão Sanguínea:")
    ddlVascS := g.AddDropDownList("x140 yp-3 w140 Choose1 +Tabstop", ["não detectada", "presente"])
    tFocS := g.AddText("x290 yp+3 Hidden", "focos:")
    eFocS := g.AddEdit("x330 yp-3 w40 Hidden +Tabstop")

    ; Invasão Vascular Linfática
    g.AddText("x400 yp+3 w110", "Invasão Linfática:")
    ddlVascL := g.AddDropDownList("x520 yp-3 w140 Choose1 +Tabstop", ["não detectada", "presente"])
    tFocL := g.AddText("x670 yp+3 Hidden", "focos:")
    eFocL := g.AddEdit("x710 yp-3 w40 Hidden +Tabstop")

    ; --- 4. ÍNDICE MITÓTICO E PERINEURAL ---
    g.AddText("x35 y+15 w110", "Índice Mitótico:")
    edtMit := g.AddEdit("x140 yp-3 w60 +Tabstop", "0")
    g.AddText("x205 yp+3", "mitoses / 2,0 mm²")

    g.AddText("x400 yp+0 w110", "Inv. Perineural:")
    ddlPeri := g.AddDropDownList("x520 yp-3 w120 Choose1 +Tabstop", ["não detectada", "presente"])

    ; --- 5. PARÊNQUIMA E PARATIREOIDE ---
    g.AddGroupBox("xm y+30 w760 h100", "Adjacentes")
    g.AddText("xp+15 yp+30 w110", "Parênquima:")
    ddlParenq := g.AddDropDownList("x140 yp-3 w620 Choose1 +Tabstop", ["dentro dos limites histológicos da normalidade", "doença nodular folicular da tireoide (bócio multinodular)", "tireoidite linfocítica", "hiperplasia de células foliculares", "doença nodular folicular da tireoide (bócio multinodular), tireoidite linfocítica", "doença nodular folicular da tireoide (bócio multinodular), hiperplasia de células foliculares", "doença nodular folicular da tireoide (bócio multinodular), tireoidite linfocítica e hiperplasia de células foliculares"])

    g.AddText("x35 y+15 w600", "Glândula paratireoide adjacente dentro dos limites histológicos da normalidade.")

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w760 r10 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    AtualizarLayout(*) {
        ; Lógica de visibilidade para focos vasculares
        showS := (ddlVascS.Text == "presente")
        tFocS.Visible := showS, eFocS.Visible := showS

        showL := (ddlVascL.Text == "presente")
        tFocL.Visible := showL, eFocL.Visible := showL

        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlTipo, ddlVar, ddlLoc, edtDim1, edtDim2, ddlMusc, edtMit, ddlNec, ddlVascS, eFocS, ddlVascL, eFocL, ddlPeri, ddlParenq]
    for c in controles
        c.OnEvent("Change", AtualizarLayout)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlTipo.Focus()
    AtualizarLayout()

    Build() {
        res := "Carcinoma " ddlTipo.Text " da tireoide, " ddlVar.Text ".`n"
        res .= ". Localização: terço " ddlLoc.Text ".`n"
        res .= ". Dimensão da neoplasia: " (edtDim1.Value || "[]") " x " (edtDim2.Value || "[]") " cm.`n"
        res .= ". Extensão extratireoidiana para tecido muscular estriado: " ddlMusc.Text ".`n"
        res .= ". Índice mitótico: " (edtMit.Value || "0") " mitoses em 10 campos de grande aumento (área de 2,0 mm²).`n"
        res .= ". Necrose: " ddlNec.Text ".`n"

        vS := (ddlVascS.Text == "não detectada") ? "não detectada" : "presente em " (eFocS.Value || "[]") " focos"
        res .= ". Invasão vascular sanguínea: " vS ".`n"

        vL := (ddlVascL.Text == "não detectada") ? "não detectada" : "presente em " (eFocL.Value || "[]") " focos"
        res .= ". Invasão vascular linfática: " vL ".`n"

        res .= ". Invasão perineural: " ddlPeri.Text ".`n"
        res .= "Parênquima tireoidiano não neoplásico: " ddlParenq.Text ".`n"
        res .= "Glândula paratireoide adjacente dentro dos limites histológicos da normalidade."

        return res
    }
}