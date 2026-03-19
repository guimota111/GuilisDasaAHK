; =========================================================
; Máscara — Esôfago (biópsia) — Esofagite
; Arquivo: scripts\EsofagoBiopsiaEsofagite.ahk
; Requer: PasteInto(hwnd, txt) no _lib\gui_utils.ahk (via #Include no principal)
; Chamada no menu: (*) => Mask_EsofagoBiopsiaEsofagite()
; =========================================================

Mask_EsofagoBiopsiaEsofagite() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Esôfago (biópsia) — Esofagite")
    g.MarginX := 12, g.MarginY := 12

    ; =========================
    ; ESOFAGITE
    ; =========================
    g.AddText("w170", "Esofagite crônica")
    ddlGrau := g.AddDropDownList("x+8 w220 Choose1", ["leve", "moderada", "intensa"])

    g.AddText("x+12 w120", "Atividade")
    ddlAtiv := g.AddDropDownList("x+8 w220 Choose1", ["sem atividade", "em atividade"])

    ; =========================
    ; EOSINÓFILOS
    ; =========================
    g.AddText("xm y+12 w170", "Eosinófilos intraepiteliais")
    ddlEos := g.AddDropDownList("x+8 w220 Choose1", ["ausentes", "presentes"])

    g.AddText("x+12 w130", "Qtde (10 CGA)")
    edtEos10 := g.AddEdit("x+8 w80")       ; ex: 25

    g.AddText("x+12 w120", "por campo")
    edtEosCampo := g.AddEdit("x+8 w80")    ; ex: 2-3

    ; =========================
    ; BARRETT
    ; =========================
    g.AddText("xm y+12 w170", "Epitélio metaplásico (Barrett)")
    ddlBarrett := g.AddDropDownList("x+8 w520 Choose1", [
        "ausente",
        "presente, focal, sem displasia",
        "presente, focal, com displasia de baixo grau",
        "presente, focal, com displasia de alto grau",
        "presente, difuso, sem displasia",
        "presente, difuso, com displasia de baixo grau",
        "presente, difuso, com displasia de alto grau"
    ])

    ; =========================
    ; PRÉVIA + BOTÕES
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r7 ReadOnly -Wrap")

    for ctrl in [ddlGrau, ddlAtiv, ddlEos, edtEos10, edtEosCampo, ddlBarrett] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ; habilita/desabilita campos conforme eos
    ddlEos.OnEvent("Change", (*) => (
        ToggleEosFields(),
        UpdatePreview()
    ))

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (
        txt := Build(),
        A_Clipboard := txt
    ))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()

    ToggleEosFields()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ToggleEosFields() {
        isPresente := (ddlEos.Value = 2)
        edtEos10.Enabled := isPresente
        edtEosCampo.Enabled := isPresente
        if (!isPresente) {
            edtEos10.Value := ""
            edtEosCampo.Value := ""
        } else {
            edtEos10.Focus()
        }
    }

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        txt := "Esofagite crônica " ddlGrau.Text " " ddlAtiv.Text "`n"

        if (ddlEos.Value = 1) {
            txt .= ". Eosinófilos intraepiteliais: ausentes`n"
        } else {
            v10 := Trim(edtEos10.Value)
            vCampo := Trim(edtEosCampo.Value)

            ; Mantém placeholders se não preencher
            if (v10 = "")
                v10 := "{}"
            if (vCampo = "")
                vCampo := "{}"

            txt .= ". Eosinófilos intraepiteliais: " v10 " em 10 campos de grande aumento (" vCampo "/campo)`n"
        }

        txt .= ". Epitélio metaplásico (esôfago de Barrett): " ddlBarrett.Text
        return txt
    }
}
