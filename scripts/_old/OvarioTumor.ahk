; =========================================================
; Ovário — Tumor (OMS 2020)
; Arquivo: scripts\OvarioTumor.ahk
; Função chamada no menu: Mask_OvarioTumor()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; Obs: Graduação (FIGO + arq/nuclear) só para ENDOMETRIOIDE ou MUCINOSO (invasivo)
; =========================================================

Mask_OvarioTumor() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Ovário — Tumor")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; TIPO
    ; =========================
    g.AddText("w170", "Tipo (OMS 2020)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Tumor seroso borderline",
        "Tumor seroso borderline, variante micropapilar e cribriforme",
        "Tumor seroso borderline com microinvasão",
        "Carcinoma seroso de baixo grau microinvasivo",
        "Carcinoma seroso de baixo grau",
        "Carcinoma seroso de alto grau",
        "Tumor mucinoso borderline",
        "Tumor mucinoso borderline com carcinoma intraepitelial",
        "Tumor mucinoso borderline com microinvasão",
        "Adenocarcinoma mucinoso",
        "Carcinoma endometrioide",
        "Carcinoma de células claras",
        "Carcinossarcoma",
        "Disgerminoma",
        "Tumor de células da granulosa tipo adulto",
        "Tumor do seio endodérmico",
        "Teratoma imaturo de baixo grau",
        "Teratoma imaturo de alto grau"
    ])

    ; =========================
    ; GRADUAÇÃO (condicional)
    ; =========================
    g.AddText("xm y+12 w220", "Grau histológico (FIGO)")
    ddlFIGO := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    g.AddText("xm y+10 w220", "Grau arquitetural")
    ddlArq := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    g.AddText("x+24 yp w220", "Grau nuclear")
    ddlNuclear := g.AddDropDownList("x+8 w140 Choose1", ["1", "2", "3"])

    ; =========================
    ; DIMENSÃO
    ; =========================
    g.AddText("xm y+12 w220", "Dimensão da neoplasia (cm)")
    edtDimA := g.AddEdit("x+8 w90")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w90")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; OUTROS PARÂMETROS
    ; =========================
    g.AddText("xm y+12 w220", "Integridade do espécime")
    ddlInt := g.AddDropDownList("x+8 w220 Choose1", ["cápsula íntegra", "cápsula rota", "fragmentado"])

    g.AddText("x+24 w260", "Superfície ovariana")
    ddlSup := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectado"])

    g.AddText("xm y+12 w220", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("x+24 w260", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("xm y+12 w220", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r11 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ;  STATIC refs (evita #Warn + garante escopo)
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0
    static s_ddlTipo := 0, s_ddlFIGO := 0, s_ddlArq := 0, s_ddlNuclear := 0
    static s_edtDimA := 0, s_edtDimB := 0
    static s_ddlInt := 0, s_ddlSup := 0, s_ddlIVS := 0, s_ddlIVL := 0, s_ddlIPN := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev

    s_ddlTipo := ddlTipo
    s_ddlFIGO := ddlFIGO
    s_ddlArq := ddlArq
    s_ddlNuclear := ddlNuclear

    s_edtDimA := edtDimA
    s_edtDimB := edtDimB

    s_ddlInt := ddlInt
    s_ddlSup := ddlSup
    s_ddlIVS := ddlIVS
    s_ddlIVL := ddlIVL
    s_ddlIPN := ddlIPN

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    ApplyRules() {
        ; Gradua apenas:
        ; - Adenocarcinoma mucinoso (10)
        ; - Carcinoma endometrioide (11)
        on := (s_ddlTipo.Value = 10) || (s_ddlTipo.Value = 11)
        s_ddlFIGO.Enabled := on
        s_ddlArq.Enabled := on
        s_ddlNuclear.Enabled := on
    }

    Build() {
        FixNum(x, placeholder := "[cm]") {
            v := StrReplace(Trim(x), ",", ".")
            return (v = "" ? placeholder : v)
        }

        dimA := FixNum(s_edtDimA.Value, "[cm]")
        dimB := FixNum(s_edtDimB.Value, "[cm]")

        txt := s_ddlTipo.Text " - OMS 2020`n"

        if (s_ddlFIGO.Enabled) {
            txt .= ". Grau histológico (FIGO): " s_ddlFIGO.Text "`n"
            txt .= "- Grau arquitetural: " s_ddlArq.Text "`n"
            txt .= "- Grau nuclear: " s_ddlNuclear.Text "`n"
        }

        txt .= ". Dimensão da neoplasia: " dimA " x " dimB " cm`n"
        txt .= ". Integridade do espécime: " s_ddlInt.Text "`n"
        txt .= ". Comprometimento da superfície ovariana: " s_ddlSup.Text "`n"
        txt .= ". Invasão vascular sanguínea: " s_ddlIVS.Text "`n"
        txt .= ". Invasão vascular linfática: " s_ddlIVL.Text "`n"
        txt .= ". Invasão perineural: " s_ddlIPN.Text

        return txt
    }

    UpdatePreview(*) {
        ApplyRules()
        s_edtPrev.Value := Build()
    }

    ; =========================
    ; EVENTOS
    ; =========================
    ddlTipo.OnEvent("Change", UpdatePreview)

    for ctrl in [ddlFIGO, ddlArq, ddlNuclear, edtDimA, edtDimB, ddlInt, ddlSup, ddlIVS, ddlIVL, ddlIPN] {
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
    UpdatePreview()
}
