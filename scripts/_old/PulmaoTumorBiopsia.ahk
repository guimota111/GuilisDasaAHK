; =========================================================
; Pulmão — Tumor (biópsia) + representatividade + notas
; Arquivo: scripts\PulmaoTumorBiopsia.ahk
; Função chamada no menu: Mask_PulmaoTumorBiopsia()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_PulmaoTumorBiopsia() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pulmão — Tumor (biópsia)")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; DIAGNÓSTICO
    ; =========================
    g.AddText("xm w170", "Diagnóstico")
    ddlDx := g.AddDropDownList("x+8 w740 Choose1", [
        "Carcinoma não pequenas células, favorecendo o diagnóstico de carcinoma de células escamosas",
        "Carcinoma não pequenas células, favorecendo o diagnóstico de adenocarcinoma",
        "Tumor carcinoide típico",
        "Tumor carcinoide atípico",
        "Carcinoma neuroendócrino de pequenas células",
        "Carcinoma de células escamosas",
        "Infiltração por adenocarcinoma",
        "Carcinoma pouco diferenciado",
        "Adenocarcinoma de padrão lepídico"
    ])

    ; =========================
    ; REPRESENTATIVIDADE
    ; =========================
    g.AddText("xm y+16 w910", "Representatividade da amostra e respectivas proporções (%)")
    g.AddText("xm y+8 w260", "Células neoplásicas")
    edtNeo := g.AddEdit("x+8 w80")
    g.AddText("x+6 yp+3", "%")

    g.AddText("xm y+10 w260", "Tecido pulmonar normal")
    edtNorm := g.AddEdit("x+8 w80")
    g.AddText("x+6 yp+3", "%")

    g.AddText("xm y+10 w260", "Células inflamatórias")
    edtInf := g.AddEdit("x+8 w80")
    g.AddText("x+6 yp+3", "%")

    g.AddText("xm y+10 w260", "Necrose")
    edtNec := g.AddEdit("x+8 w80")
    g.AddText("x+6 yp+3", "%")

    g.AddText("xm y+10 w260", "Fibrose")
    edtFib := g.AddEdit("x+8 w80")
    g.AddText("x+6 yp+3", "%")

    g.AddText("xm y+10 w260", "Material mucinoso")
    edtMuc := g.AddEdit("x+8 w80")
    g.AddText("x+6 yp+3", "%")

    g.AddText("xm y+10 w260", "Material hemático")
    edtHem := g.AddEdit("x+8 w80")
    g.AddText("x+6 yp+3", "%")

    ; =========================
    ; NOTAS
    ; =========================
    g.AddText("xm y+16 w910", "Notas (opcionais)")

    cbNota1 := g.AddCheckBox("xm y+8", "Incluir Nota 1 (imuno-histoquímica)")
    cbNota1.Value := 1

    g.AddText("x+10 yp+3 w120", "Status")
    ddlNota1a := g.AddDropDownList("x+8 w160 Choose1", ["Em andamento", "É necessária a realização de"])

    g.AddText("x+10 yp w120", "Objetivo")
    ddlNota1b := g.AddDropDownList("x+8 w430 Choose2", [
        "pesquisa do sítio primário da neoplasia",
        "complementação diagnóstica e/ou pesquisa do sítio primário da neoplasia"
    ])

    cbNota2 := g.AddCheckBox("xm y+10", "Incluir Nota 2 (apenas se lepídico exclusivo)")
    cbNota2.Value := 0

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w910 r12 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ; STATIC refs (evita #Warn)
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0
    static s_ddlDx := 0
    static s_edtNeo := 0, s_edtNorm := 0, s_edtInf := 0, s_edtNec := 0, s_edtFib := 0, s_edtMuc := 0, s_edtHem := 0
    static s_cbNota1 := 0, s_ddlNota1a := 0, s_ddlNota1b := 0
    static s_cbNota2 := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev
    s_ddlDx := ddlDx

    s_edtNeo := edtNeo
    s_edtNorm := edtNorm
    s_edtInf := edtInf
    s_edtNec := edtNec
    s_edtFib := edtFib
    s_edtMuc := edtMuc
    s_edtHem := edtHem

    s_cbNota1 := cbNota1
    s_ddlNota1a := ddlNota1a
    s_ddlNota1b := ddlNota1b
    s_cbNota2 := cbNota2

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    NormPct(v) {
        v := Trim(v)
        if (v = "")
            return ""
        ; aceita "2,5" ou "2.5"
        v := StrReplace(v, ",", ".")
        return v
    }

    ApplyRules() {
        ; Nota 2 só faz sentido no "Adenocarcinoma de padrão lepídico"
        isLepidico := (s_ddlDx.Value = 9)
        s_cbNota2.Enabled := isLepidico
        if (!isLepidico)
            s_cbNota2.Value := 0

        ; Nota 1 habilita/desabilita dropdowns
        on := (s_cbNota1.Value = 1)
        s_ddlNota1a.Enabled := on
        s_ddlNota1b.Enabled := on
    }

    Build() {
        ApplyRules()

        nNeo  := NormPct(s_edtNeo.Value)
        nNorm := NormPct(s_edtNorm.Value)
        nInf  := NormPct(s_edtInf.Value)
        nNec  := NormPct(s_edtNec.Value)
        nFib  := NormPct(s_edtFib.Value)
        nMuc  := NormPct(s_edtMuc.Value)
        nHem  := NormPct(s_edtHem.Value)

        txt := s_ddlDx.Text "`n"
        txt .= ". Representatividade da amostra e respectivas proporções:`n"
        txt .= "- Células neoplásicas: " (nNeo  = "" ? "[quantidade]%" : nNeo "%") "`n"
        txt .= "- Tecido pulmonar normal: " (nNorm = "" ? "[quantidade]%" : nNorm "%") "`n"
        txt .= "- Células inflamatórias: " (nInf  = "" ? "[quantidade]%" : nInf "%") "`n"
        txt .= "- Necrose: " (nNec  = "" ? "[quantidade]%" : nNec "%") "`n"
        txt .= "- Fibrose: " (nFib  = "" ? "[quantidade]%" : nFib "%") "`n"
        txt .= "- Material mucinoso: " (nMuc  = "" ? "[quantidade]%" : nMuc "%") "`n"
        txt .= "- Material hemático: " (nHem  = "" ? "[quantidade]%" : nHem "%")

        notas := []

        if (s_cbNota1.Value = 1) {
            notas.Push("1. " s_ddlNota1a.Text " estudo imuno-histoquímico para " s_ddlNota1b.Text ".")
        }

        if (s_cbNota2.Value = 1) {
            notas.Push("2. Não é possível excluir presença de lesão invasiva residual em decorrência da pequena amostragem da neoplasia em material obtido por biópsia.")
        }

        if (notas.Length) {
            txt .= "`n`nNotas:`n"
            for i, l in notas
                txt .= l "`n"
            txt := RTrim(txt, "`n")
        }

        return txt
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    ; =========================
    ; EVENTOS
    ; =========================
    for ctrl in [ddlDx, edtNeo, edtNorm, edtInf, edtNec, edtFib, edtMuc, edtHem, cbNota1, ddlNota1a, ddlNota1b, cbNota2] {
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
