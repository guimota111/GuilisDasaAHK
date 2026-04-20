; =========================================================
; Dermato — Hiperplasia Epidérmica (GUI)
; Arquivo: scripts\DermHiperplasiaEpidermica.ahk
; Função chamada no menu: Mask_DermHiperplasiaEpidermica()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_DermHiperplasiaEpidermica() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Dermato — Hiperplasia epidérmica")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; EPIDERME
    ; =========================
    g.AddText("xm w820", "DESCRIÇÃO MICROSCÓPICA — Epiderme")

    g.AddText("xm y+10 w140", "Queratinização")
    ddlKera := g.AddDropDownList("x+8 w660 Choose1", [
        "hiperqueratose compacta",
        "hiperortoqueratose",
        "hiperqueratose compacta com áreas focais de paraqueratose",
        "hiperortoqueratose com áreas focais de paraqueratose",
        "hiperqueratose com alternância de áreas hiperortoqueratóticas"
    ])

    g.AddText("xm y+10 w140", "Lesão crostosa")
    ddlEroUlc := g.AddDropDownList("x+8 w420 Choose1", ["erosão", "ulceração"])

    g.AddText("x+12 w140", "Acantose")
    ddlAcant := g.AddDropDownList("x+8 w220 Choose1", ["irregular", "regular", "nodulariforme"])

    g.AddText("xm y+10 w140", "Espongiose")
    ddlEsp := g.AddDropDownList("x+8 w420 Choose1", ["sem espongiose", "com espongiose mínima"])

    ; =========================
    ; DERME SUPERFICIAL
    ; =========================
    g.AddText("xm y+16 w820", "Derme papilar/reticular superficial")

    g.AddText("xm y+10 w140", "Infiltrado")
    ddlInf := g.AddDropDownList("x+8 w420 Choose1", [
        "linfocitário",
        "linfo-histiocitário não granulomatoso"
    ])

    g.AddText("x+12 w140", "Distribuição")
    ddlDist := g.AddDropDownList("x+8 w220 Choose1", [
        "perivascular",
        "perivascular e perifolicular"
    ])

    g.AddText("xm y+10 w140", "Eosinófilos")
    ddlEos := g.AddDropDownList("x+8 w220 Choose1", ["com", "sem"])

    g.AddText("x+12 w200", "Capilares/extravasamento")
    ddlCap := g.AddDropDownList("x+8 w420 Choose1", [
        "com proeminência de capilares papilares dérmicos e extravasamento de hemácias",
        "sem proeminência de capilares papilares dérmicos, porém com extravasamento de hemácias",
        "com proeminência de capilares papilares dérmicos, sem extravasamento de hemácias",
        "sem proeminência de capilares papilares dérmicos, nem extravasamento de hemácias"
    ])

    g.AddText("xm y+10 w200", "Filetes nervosos")
    ddlNervo := g.AddDropDownList("x+8 w420 Choose2", [
        "Observa-se ainda hiperplasia de filetes nervosos",
        "Não se observa hiperplasia de filetes nervosos"
    ])

    ; =========================
    ; DIAGNÓSTICO MORFOLÓGICO
    ; =========================
    g.AddText("xm y+16 w820", "DIAGNÓSTICO MORFOLÓGICO")

    g.AddText("xm y+10 w140", "Padrão")
    ddlPadrao := g.AddDropDownList("x+8 w420 Choose1", [
        "linear",
        "linear pseudoepiteliomatosa",
        "nodulariforme",
        "nodulariforme pseudoepiteliomatosa"
    ])

    ; =========================
    ; INTERPRETAÇÃO
    ; =========================
    g.AddText("xm y+16 w820", "Interpretação diagnóstica")

    g.AddText("xm y+10 w140", "Frase")
    ddlInterp := g.AddDropDownList("x+8 w660 Choose1", [
        ", associado aos dados clínicos, corrobora o",
        "favorece o",
        "pode corresponder ao"
    ])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w820 r12 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ; STATIC refs
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0
    static s_ddlKera := 0, s_ddlEroUlc := 0, s_ddlAcant := 0, s_ddlEsp := 0
    static s_ddlInf := 0, s_ddlDist := 0, s_ddlEos := 0, s_ddlCap := 0, s_ddlNervo := 0
    static s_ddlPadrao := 0, s_ddlInterp := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev
    s_ddlKera := ddlKera
    s_ddlEroUlc := ddlEroUlc
    s_ddlAcant := ddlAcant
    s_ddlEsp := ddlEsp
    s_ddlInf := ddlInf
    s_ddlDist := ddlDist
    s_ddlEos := ddlEos
    s_ddlCap := ddlCap
    s_ddlNervo := ddlNervo
    s_ddlPadrao := ddlPadrao
    s_ddlInterp := ddlInterp

    Build() {
        ; use aspas simples no texto para evitar escape
        return (
            "DESCRIÇÃO MICROSCÓPICA:`n"
            ". Epiderme exibindo " s_ddlKera.Text ", " s_ddlEroUlc.Text " crostosa piogênica e sero-hemática, hipergranulose, acantose " s_ddlAcant.Text ", exocitose de linfócitos típicos, " s_ddlEsp.Text ". Não há degeneração hidrópica de camada basal.`n"
            ". Derme papilar e reticular superficial apresentando infiltrado " s_ddlInf.Text " " s_ddlDist.Text ", " s_ddlEos.Text " eosinófilos e fibroblasia subepidérmica, " s_ddlCap.Text ". " s_ddlNervo.Text ".`n"
            ". Derme reticular profunda e hipoderme dentro dos limites histológicos da normalidade.`n"
            ". Ausência de neoplasia no espécime.`n"
            "DIAGNÓSTICO MORFOLÓGICO:`n"
            "Hiperplasia epidérmica " s_ddlPadrao.Text " com eosinófilos`n"
            "Interpretação diagnóstica:`n"
            "O quadro histológico " s_ddlInterp.Text " diagnóstico de Líquen Simples crônico/ Prurigo nodular/ Nódulo isolado de prurigo nodular (Nódulo de Prurigo, 'picker nodule' ou 'nódulo do coçador')."
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    for ctrl in [ddlKera, ddlEroUlc, ddlAcant, ddlEsp, ddlInf, ddlDist, ddlEos, ddlCap, ddlNervo, ddlPadrao, ddlInterp] {
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
