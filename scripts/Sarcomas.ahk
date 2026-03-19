; =========================================================
; Partes moles — Sarcomas (GUI + Calculadora FNCLCC automática)
; Arquivo: scripts\Sarcomas.ahk
; Função chamada no menu: Mask_Sarcomas()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_Sarcomas() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Partes moles — Sarcomas (FNCLCC)")
    g.MarginX := 12, g.MarginY := 12

    ; =========================
    ; CAMPOS DO LAUDO
    ; =========================
    g.AddText("xm w170", "Tipo histológico (digitar)")
    edtTipo := g.AddEdit("x+8 w540")

    g.AddText("xm y+12 w170", "Localização (digitar)")
    edtLoc := g.AddEdit("x+8 w540")

    g.AddText("xm y+12 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w100")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+8 yp-3 w100")
    g.AddText("x+8 yp+3", "cm")

    g.AddText("xm y+12 w170", "Mitoses / 10 CGA (digitar)")
    edtMitoses := g.AddEdit("x+8 w120") ; aceita 12, 18 etc.

    g.AddText("x+16 yp w170", "Necrose")
    ddlNecrose := g.AddDropDownList("x+8 w250 Choose1", [
        "não detectada",
        "presente, correspondendo a menos de 50% da lesão",
        "presente, correspondendo a mais de 50% da lesão"
    ])

    g.AddText("xm y+12 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    g.AddText("xm y+12 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w220 Choose2", ["presente", "não detectada"])

    ; =========================
    ; FNCLCC — CALCULADORA
    ; =========================
    g.AddText("xm y+18 w720", "FNCLCC (calculadora automática — não muda o texto do laudo além do grau)")

    cbAuto := g.AddCheckBox("xm y+6", "Calcular grau automaticamente")
    cbAuto.Value := 1

    g.AddText("xm y+10 w170", "Score diferenciação")
    ddlDiffScore := g.AddDropDownList("x+8 w120 Choose1", ["1", "2", "3"])

    g.AddText("x+16 yp w170", "Score mitótico (auto)")
    txtMitScore := g.AddText("x+8 w60", "1")

    g.AddText("x+16 yp w170", "Score necrose (auto)")
    txtNecScore := g.AddText("x+8 w60", "0")

    g.AddText("xm y+10 w170", "Soma (D+M+N)")
    txtSum := g.AddText("x+8 w60", "2")

    g.AddText("x+16 yp w170", "Grau FNCLCC (auto)")
    txtGrade := g.AddText("x+8 w60", "1")

    g.AddText("xm y+10 w170", "Grau FNCLCC (manual)")
    ddlGradeManual := g.AddDropDownList("x+8 w120 Choose1", ["1", "2", "3"])
    ddlGradeManual.Enabled := false

    g.AddText("xm y+8 w720 cGray", "Regras: mitoses 0–9=1; 10–19=2; ≥20=3. Necrose 0/1/2. Soma 2–3=G1; 4–5=G2; 6–8=G3.")

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r10 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================
    ; EVENTOS
    ; =========================
    for ctrl in [edtTipo, edtLoc, edtDimA, edtDimB, edtMitoses, ddlNecrose, ddlIVS, ddlIVL, ddlIPN
               , cbAuto, ddlDiffScore, ddlGradeManual] {
        try ctrl.OnEvent("Change", (*) => (ApplyCalc(), UpdatePreview()))
        try ctrl.OnEvent("Click",  (*) => (ApplyCalc(), UpdatePreview()))
    }

    ddlNecrose.OnEvent("Change", (*) => (ApplyCalc(), UpdatePreview()))
    cbAuto.OnEvent("Click", (*) => (ApplyCalc(), UpdatePreview()))

    btnInsert.OnEvent("Click", (*) => (
        txt := BuildText(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := BuildText()))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    ApplyCalc()
    UpdatePreview()

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    UpdatePreview() => edtPrev.Value := BuildText()

    ApplyCalc() {
        ; habilita manual vs auto
        auto := (cbAuto.Value != 0)
        ddlGradeManual.Enabled := !auto

        ; --- Mitotic score (auto) ---
        m := ParseIntSafe(edtMitoses.Value)
        if (m = "")
            mitScore := 1
        else if (m <= 9)
            mitScore := 1
        else if (m <= 19)
            mitScore := 2
        else
            mitScore := 3

        ; --- Necrosis score (auto) ---
        ; ddlNecrose: 1=none, 2=<50, 3=>50
        necScore := (ddlNecrose.Value = 1) ? 0 : (ddlNecrose.Value = 2 ? 1 : 2)

        ; --- Diff score (manual selection) ---
        diffScore := Integer(ddlDiffScore.Text)

        sum := diffScore + mitScore + necScore

        if (sum <= 3)
            gradeAuto := 1
        else if (sum <= 5)
            gradeAuto := 2
        else
            gradeAuto := 3

        txtMitScore.Text := mitScore
        txtNecScore.Text := necScore
        txtSum.Text := sum
        txtGrade.Text := gradeAuto

        if (auto)
            ddlGradeManual.Choose(gradeAuto)
    }

    BuildText() {
        linhas := []

        tipo := Trim(edtTipo.Value)
        if (tipo = "")
            tipo := "[Tipo histológico]"

        loc := Trim(edtLoc.Value)
        if (loc = "")
            loc := "[local]"

        ; Dimensão (aceita 2,3 ou 2.3; mantém o que digitou, só normaliza vírgula->ponto)
        dimA := NormalizeNum(edtDimA.Value)
        dimB := NormalizeNum(edtDimB.Value)

        if (dimA != "" && dimB != "")
            dimTxt := dimA " x " dimB " cm"
        else if (dimA != "" && dimB = "")
            dimTxt := dimA " cm"
        else if (dimA = "" && dimB != "")
            dimTxt := dimB " cm"
        else
            dimTxt := "[cm] x [cm] cm"

        mit := Trim(edtMitoses.Value)
        mitTxt := (mit = "") ? "[mitoses]" : mit

        ; Grau: auto ou manual
        grade := (cbAuto.Value != 0) ? txtGrade.Text : ddlGradeManual.Text
        if (grade = "")
            grade := "1"

        linhas.Push(tipo)
        linhas.Push(". Grau histológico (French Federation of Cancer Centers Sarcoma Group - FNCLCC): grau " grade)
        linhas.Push(". Localização: " loc)
        linhas.Push(". Dimensão da lesão: " dimTxt)
        linhas.Push(". Índice mitótico: " mitTxt " / 10 campos de grande aumento")
        linhas.Push(". Necrose: " ddlNecrose.Text)
        linhas.Push(". Invasão vascular sanguínea: " ddlIVS.Text)
        linhas.Push(". Invasão vascular linfática: " ddlIVL.Text)
        linhas.Push(". Invasão perineural: " ddlIPN.Text)

        txt := ""
        for l in linhas
            txt .= l "`n"
        return RTrim(txt, "`n")
    }

    NormalizeNum(v) {
        s := Trim(v)
        if (s = "")
            return ""
        s := StrReplace(s, ",", ".")
        ; remove caracteres estranhos, mantém dígitos e ponto
        s := RegExReplace(s, "[^0-9.]", "")
        ; evita múltiplos pontos: mantém o primeiro
        if (InStr(s, ".") && RegExMatch(s, "\..*\.", &m)) {
            ; remove pontos extras
            first := InStr(s, ".")
            s := SubStr(s, 1, first) RegExReplace(SubStr(s, first+1), "\.", "")
        }
        return s
    }

    ParseIntSafe(v) {
        s := Trim(v)
        if (s = "")
            return ""
        ; pega primeiro número inteiro encontrado
        s := RegExReplace(s, "[^0-9]", "")
        if (s = "")
            return ""
        return Integer(s)
    }
}
