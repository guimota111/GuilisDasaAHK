; =========================================================
; Útero — Tumor de endométrio (peça) — OMS 2020
; Arquivo: scripts\UteroTumorEndometrio.ahk
; Função chamada no menu: Mask_UteroTumorEndometrio()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_UteroTumorEndometrio() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Útero — Tumor de endométrio (peça)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO + GRADUAÇÃO (condicional)
    ; =========================
    g.AddText("w170", "Tipo (OMS 2020)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Carcinoma endometrioide, SOE",
        "Adenocarcinoma de células claras",
        "Carcinoma seroso",
        "Carcinoma mucinoso tipo intestinal",
        "Carcinossarcoma",
        "Carcinoma neuroendócrino de grandes células",
        "Carcinoma neuroendócrino de pequenas células"
    ])

    g.AddText("xm y+12 w220", "Grau histológico (FIGO)")
    ddlFIGO := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    g.AddText("xm y+10 w220", "Grau nuclear")
    ddlNuclear := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    g.AddText("x+24 yp w220", "Grau arquitetural")
    ddlArq := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    ; =========================
    ; DIMENSÃO
    ; =========================
    g.AddText("xm y+12 w220", "Dimensão da neoplasia (cm)")
    edtDimA := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w90")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; INVASÃO MIOMETRIAL
    ; =========================
    g.AddText("xm y+12 w220", "Profundidade de invasão (mm)")
    edtInvProf := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3", "mm")

    g.AddText("x+24 yp-3 w220", "Espessura do miométrio (mm)")
    edtMioEsp := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3", "mm")

    g.AddText("xm y+10 w220", "Percentual de invasão")
    ddlPerc := g.AddDropDownList("x+8 w320 Choose1", [
        "infiltra menos da metade do miométrio",
        "infiltra mais da metade do miométrio"
    ])

    ; =========================
    ; OUTROS PARÂMETROS
    ; =========================
    g.AddText("xm y+12 w220", "Comprometimento da serosa uterina")
    ddlSerosa := g.AddDropDownList("x+8 w220 Choose1", ["não detectada", "presente"])

    g.AddText("x+24 w260", "Segmento uterino inferior")
    ddlSUI := g.AddDropDownList("x+8 w300 Choose1", [
        "não detectado",
        "presente, superficial (não mioinvasivo)",
        "presente, mioinvasivo"
    ])

    g.AddText("xm y+12 w220", "Comprometimento do estroma cervical")
    ddlCervEst := g.AddDropDownList("x+8 w220 Choose1", ["não detectado", "presente"])

    g.AddText("x+24 w260", "Invasão linfática/vascular (LVSI)")
    ddlLVSI := g.AddDropDownList("x+8 w300 Choose1", [
        "não detectada",
        "presente, focal (menos de 5 vasos comprometidos)",
        "presente, extensa/substancial (5 ou mais vasos comprometidos)"
    ])

    ; =========================
    ; TECIDOS ADJACENTES
    ; =========================
    g.AddText("xm y+12 w220", "Endométrio adjacente")
    ddlAdjEndo := g.AddDropDownList("x+8 w220 Choose1", ["atrófico", "atrófico-cístico", "proliferativo", "secretor"])

    g.AddText("x+24 w220", "Miométrio")
    ddlMio := g.AddDropDownList("x+8 w300 Choose1", [
        "dentro dos limites histológicos da normalidade",
        "leiomioma(s)",
        "adenomiose",
        "leiomioma(s) e adenomiose"
    ])

    ; =========================
    ; NOTA
    ; =========================
    g.AddText("xm y+12 w220", "Nota")
    ddlNota := g.AddDropDownList("x+8 w220 Choose1", ["Em andamento", "É necessário"])
    cbNota := g.AddCheckBox("x+12 yp+3", "Incluir nota")
    cbNota.Value := 1

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r12 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ;  REF: “STATIC CONTROLS” (evita #Warn + resolve escopo)
    ; =========================================================
    static s_prevWin := 0
    static s_g := 0

    static s_ddlTipo := 0, s_ddlFIGO := 0, s_ddlNuclear := 0, s_ddlArq := 0
    static s_edtDimA := 0, s_edtDimB := 0, s_edtInvProf := 0, s_edtMioEsp := 0
    static s_ddlPerc := 0, s_ddlSerosa := 0, s_ddlSUI := 0, s_ddlCervEst := 0, s_ddlLVSI := 0
    static s_ddlAdjEndo := 0, s_ddlMio := 0, s_ddlNota := 0, s_cbNota := 0
    static s_edtPrev := 0

    ; atribui refs estáveis
    s_prevWin := prevWin
    s_g := g
    s_ddlTipo := ddlTipo
    s_ddlFIGO := ddlFIGO
    s_ddlNuclear := ddlNuclear
    s_ddlArq := ddlArq
    s_edtDimA := edtDimA
    s_edtDimB := edtDimB
    s_edtInvProf := edtInvProf
    s_edtMioEsp := edtMioEsp
    s_ddlPerc := ddlPerc
    s_ddlSerosa := ddlSerosa
    s_ddlSUI := ddlSUI
    s_ddlCervEst := ddlCervEst
    s_ddlLVSI := ddlLVSI
    s_ddlAdjEndo := ddlAdjEndo
    s_ddlMio := ddlMio
    s_ddlNota := ddlNota
    s_cbNota := cbNota
    s_edtPrev := edtPrev

    ; =========================
    ; FUNÇÕES INTERNAS (usam s_*)
    ; =========================
    ApplyRules() {
        on := (s_ddlTipo.Value = 1) || (s_ddlTipo.Value = 4) ; endometrioide ou mucinoso
        s_ddlFIGO.Enabled := on
        s_ddlNuclear.Enabled := on
        s_ddlArq.Enabled := on
    }

    Build() {
        ; helper local
        FixNum(x, placeholder := "[]") {
            v := StrReplace(Trim(x), ",", ".")
            return (v = "" ? placeholder : v)
        }

        dimA := FixNum(s_edtDimA.Value, "[]")
        dimB := FixNum(s_edtDimB.Value, "[]")

        invProf := FixNum(s_edtInvProf.Value, "[]")
        mioEsp  := FixNum(s_edtMioEsp.Value, "[]")

        txt := s_ddlTipo.Text " (OMS 2020) - ver Nota`n"

        if (s_ddlFIGO.Enabled) {
            txt .= ". Grau histológico (FIGO): grau " s_ddlFIGO.Text "`n"
            txt .= "- Grau nuclear: " s_ddlNuclear.Text "`n"
            txt .= "- Grau arquitetural: " s_ddlArq.Text "`n"
        }

        txt .= ". Dimensão da neoplasia: " dimA " x " dimB " cm`n"
        txt .= ". Invasão do miométrio:`n"
        txt .= "- Profundidade de invasão: " invProf " mm`n"
        txt .= "- Espessura do miométrio: " mioEsp " mm`n"
        txt .= "- Percentual de invasão miometrial: " s_ddlPerc.Text "`n"
        txt .= ". Comprometimento da serosa uterina: " s_ddlSerosa.Text "`n"
        txt .= ". Invasão do segmento uterino inferior: " s_ddlSUI.Text "`n"
        txt .= ". Comprometimento do estroma cervical: " s_ddlCervEst.Text "`n"
        txt .= ". Invasão linfática/vascular: " s_ddlLVSI.Text "`n"
        txt .= "Endométrio adjacente de padrão " s_ddlAdjEndo.Text "`n"
        txt .= "Miométrio: " s_ddlMio.Text

        if (s_cbNota.Value = 1) {
            txt .= "`nNota: " s_ddlNota.Text " estudo imuno-histoquímico para pesquisa de mutações do gene p53 e de expressão das proteínas dos genes de reparo do DNA"
        }

        return txt
    }

    UpdatePreview(*) {
        s_edtPrev.Value := Build()
    }

    ; =========================
    ; EVENTOS (chamam ApplyRules/UpdatePreview)
    ; =========================
    ddlTipo.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))

    for ctrl in [ddlFIGO, ddlNuclear, ddlArq
               , edtDimA, edtDimB, edtInvProf, edtMioEsp
               , ddlPerc, ddlSerosa, ddlSUI, ddlCervEst, ddlLVSI
               , ddlAdjEndo, ddlMio, ddlNota, cbNota] {
        try ctrl.OnEvent("Change", UpdatePreview)
        try ctrl.OnEvent("Click",  UpdatePreview)
    }

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        s_g.Destroy(),
        PasteInto(s_prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := Build()))
    btnCancel.OnEvent("Click", (*) => s_g.Destroy())

    g.Show()
    ApplyRules()
    UpdatePreview()
}
