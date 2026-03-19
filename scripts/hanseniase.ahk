; =========================================================
; Dermato — Hanseníase (GUI)
; Arquivo: scripts\Hanseniase.ahk
; Função chamada no menu: Mask_Hanseniase()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_Hanseniase() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Dermato — Hanseníase")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; EPIDERME
    ; =========================
    g.AddText("xm w860", "Epiderme")

    g.AddText("xm y+10 w160", "Queratinização")
    ddlKera := g.AddDropDownList("x+8 w660 Choose1", [
        "ortoqueratose",
        "hiperqueratose ortoqueratótica",
        "hiperqueratose compacta",
        "paraqueratose",
        "hiperparaqueratose"
    ])

    g.AddText("xm y+10 w160", "Padrão")
    ddlPadraoEpi := g.AddDropDownList("x+8 w420 Choose1", [
        "atrofia",
        "acantose irregular"
    ])

    g.AddText("x+12 w160", "Camada granulosa")
    ddlGran := g.AddDropDownList("x+8 w220 Choose1", [
        "camada granulosa preservada",
        "hipergranulose",
        "hipogranulose"
    ])

    ; =========================
    ; DERME PAPILAR
    ; =========================
    g.AddText("xm y+16 w860", "Derme papilar")

    g.AddText("xm y+10 w160", "Achado")
    ddlPap := g.AddDropDownList("x+8 w660 Choose1", [
        "infiltrado linfo-histiocitário perivascular",
        "Zona de Grenz"
    ])

    ; =========================
    ; DERME RETICULAR / PADRÃO GRANULOMATOSO
    ; =========================
    g.AddText("xm y+16 w860", "Derme reticular (superficial e profunda)")

    g.AddText("xm y+10 w160", "Padrão")
    ddlDermeRet := g.AddDropDownList("x+8 w660 Choose1", [
        "formando granulomas não caseosos epitelioides com coroa linfocitária",
        "formando predominantemente granulomas não caseosos epitelioides com coroa linfocitária e algumas células de Virchow associadas a alguns granulomas mal formados",
        "apresentando fibrose lamelar perineural concêntrica com granulomas ora epitelioides não caseosos e com coroa linfocitária, ora com células de Virchow associadas a granulomas mal formados",
        "apresentando predominante células de Virchow, sem granulomas bem formados, porém com algumas áreas de granulomas epitelioides não caseosos e bem delimitados",
        "apresentando células de Virchow, sem granulomas bem formados"
    ])

    g.AddText("xm y+10 w200", "Células gigantes")
    ddlGig := g.AddDropDownList("x+8 w620 Choose2", [
        "Observam-se ainda células gigantes multinucleadas",
        "Não se observam células gigantes multinucleadas"
    ])

    ; =========================
    ; HIPODERME
    ; =========================
    g.AddText("xm y+16 w860", "Hipoderme")
    ddlHip := g.AddDropDownList("xm w860 Choose1", [
        "dentro dos limites histológicos da normalidade",
        "não representada na amostra"
    ])

    ; =========================
    ; DIAGNÓSTICO MORFOLÓGICO
    ; =========================
    g.AddText("xm y+16 w860", "Diagnóstico morfológico")

    g.AddText("xm y+10 w160", "Padrão")
    ddlDx1 := g.AddDropDownList("x+8 w220 Choose1", ["difusa", "nodular", "difusa/nodular"])

    g.AddText("x+12 w160", "Granulomatosa")
    ddlDx2 := g.AddDropDownList("x+8 w420 Choose1", ["granulomatosa tuberculoide não caseosa", "não granulomatosa"])

    ; =========================
    ; BAAR / RIDLEY
    ; =========================
    g.AddText("xm y+16 w860", "Bacilos Álcool-Ácido Resistentes (Fite-Faraco)")

    g.AddText("xm y+10 w160", "BAAR")
    ddlBaar := g.AddDropDownList("x+8 w420 Choose1", [
        "não detectados",
        "presentes e íntegros",
        "presentes e fragmentados",
        "presentes, ora íntegros, ora fragmentados"
    ])

    g.AddText("x+12 w160", "Globias")
    ddlGlob := g.AddDropDownList("x+8 w220 Choose1", [
        "sem globias",
        "formando globias"
    ])

    g.AddText("xm y+10 w160", "Ridley (Escala)")
    edtRidA := g.AddEdit("x+8 w60")   ; numerador (ex: 2)
    g.AddText("x+6 yp+3", "+/")
    edtRidB := g.AddEdit("x+6 yp-3 w60") ; denominador (ex: 4)
    g.AddText("x+6 yp+3", "+")

    cbNotaFite := g.AddCheckBox("xm y+10", "Incluir Nota do Fite-Faraco")
    cbNotaFite.Value := 1
    ddlNotaFite := g.AddDropDownList("x+12 yp-2 w520 Choose1", [
        "resultou negativa",
        "revelou a presença de organismos morfologicamente consistentes com Mycobacterium leprae"
    ])

    ; =========================
    ; INTERPRETAÇÃO
    ; =========================
    g.AddText("xm y+16 w860", "Interpretação diagnóstica")

    g.AddText("xm y+10 w160", "Frase")
    ddlInterp := g.AddDropDownList("x+8 w660 Choose1", [
        ", associado aos dados clínicos, corrobora o",
        "favorece o",
        "pode corresponder ao"
    ])

    g.AddText("xm y+10 w160", "Carga bacilar")
    ddlCarga := g.AddDropDownList("x+8 w220 Choose1", ["paucibacilar", "multibacilar"])

    g.AddText("x+12 w160", "Forma clínica")
    ddlForma := g.AddDropDownList("x+8 w420 Choose1", [
        "Tuberculoide",
        "Tuberculoide-Borderline",
        "Borderline-Borderline",
        "Borderline-Virchowiana",
        "Virchowiana-Virchowiana"
    ])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w860 r14 ReadOnly -Wrap")

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
    static s_ddlKera := 0, s_ddlPadraoEpi := 0, s_ddlGran := 0
    static s_ddlPap := 0, s_ddlDermeRet := 0, s_ddlGig := 0
    static s_ddlHip := 0
    static s_ddlDx1 := 0, s_ddlDx2 := 0
    static s_ddlBaar := 0, s_ddlGlob := 0, s_edtRidA := 0, s_edtRidB := 0
    static s_cbNotaFite := 0, s_ddlNotaFite := 0
    static s_ddlInterp := 0, s_ddlCarga := 0, s_ddlForma := 0

    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev

    s_ddlKera := ddlKera
    s_ddlPadraoEpi := ddlPadraoEpi
    s_ddlGran := ddlGran

    s_ddlPap := ddlPap
    s_ddlDermeRet := ddlDermeRet
    s_ddlGig := ddlGig

    s_ddlHip := ddlHip

    s_ddlDx1 := ddlDx1
    s_ddlDx2 := ddlDx2

    s_ddlBaar := ddlBaar
    s_ddlGlob := ddlGlob
    s_edtRidA := edtRidA
    s_edtRidB := edtRidB

    s_cbNotaFite := cbNotaFite
    s_ddlNotaFite := ddlNotaFite

    s_ddlInterp := ddlInterp
    s_ddlCarga := ddlCarga
    s_ddlForma := ddlForma

    ApplyRules() {
        ; Nota do Fite habilita/desabilita o dropdown
        s_ddlNotaFite.Enabled := (s_cbNotaFite.Value = 1)

        ; Sugestão automática (não força): se escolheu forma tuberculoide, sugere paucibacilar;
        ; se virchowiana, sugere multibacilar.
        if (s_ddlForma.Value = 1 || s_ddlForma.Value = 2) {
            s_ddlCarga.Choose(1)
        } else if (s_ddlForma.Value = 4 || s_ddlForma.Value = 5) {
            s_ddlCarga.Choose(2)
        }
    }

    Build() {
        ApplyRules()

        ridA := Trim(s_edtRidA.Value)
        ridB := Trim(s_edtRidB.Value)
        ridTxt := ""
        if (ridA != "" || ridB != "")
            ridTxt := " (Escala de Ridley " (ridA=""?"[]":ridA) "+/" (ridB=""?"[]":ridB) "+)"

        notaFite := ""
        if (s_cbNotaFite.Value = 1) {
            notaFite := "`nNota: A pesquisa de micobactérias pelo método Fite-Faraco " s_ddlNotaFite.Text "."
        }

        return (
            "DESCRIÇÃO MICROSCÓPICA:`n"
            ". Epiderme exibindo " s_ddlKera.Text ", " s_ddlPadraoEpi.Text " " s_ddlGran.Text ", exocitose de linfócitos típicos, sem espongiose, nem degeneração hidrópica de camada basal.`n"
            ". Derme papilar exibindo " s_ddlPap.Text ".`n"
            ". Derme reticular (superficial e profunda) com infiltrado linfo-histiocitário perivascular, periécrino, perissebáceo, perifolicular e perineural, comprometendo o músculo eretor do pelo e " s_ddlDermeRet.Text ". " s_ddlGig.Text ".`n"
            ". Hipoderme " s_ddlHip.Text ".`n"
            ". Ausência de neoplasia no espécime.`n"
            "DIAGNÓSTICO MORFOLÓGICO:`n"
            "Dermatite " s_ddlDx1.Text " linfo-histiocitária " s_ddlDx2.Text ", perivascular e perianexial, com perineurite.`n"
            "Bacilos Álcool-Ácido Resistentes: " s_ddlBaar.Text ", " s_ddlGlob.Text ridTxt "`n"
            "Interpretação diagnóstica:`n"
            "O quadro histológico " s_ddlInterp.Text " diagnóstico de Hanseníase " s_ddlCarga.Text ", notadamente na forma clínica " s_ddlForma.Text "."
            . notaFite
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    for ctrl in [ddlKera, ddlPadraoEpi, ddlGran, ddlPap, ddlDermeRet, ddlGig, ddlHip
               , ddlDx1, ddlDx2, ddlBaar, ddlGlob, edtRidA, edtRidB, cbNotaFite, ddlNotaFite
               , ddlInterp, ddlCarga, ddlForma] {
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
