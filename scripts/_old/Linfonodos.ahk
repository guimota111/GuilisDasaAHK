; =========================================================
; Geral — Linfonodos (Versão Final Completa)
; Arquivo: scripts\Linfonodos.ahk
; =========================================================

Mask_Linfonodos() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Linfonodos")
    g.MarginX := 12, g.MarginY := 12

    ; --- SELEÇÃO DE PROTOCOLO ---
    g.SetFont("s9 Bold")
    g.AddText("xm y10", "Protocolo (Setas alternar opções) e TAB para ir pra próxima opção:")
    g.SetFont("s9 Norm")
    ddlProtocolo := g.AddDropDownList("xm y+5 w740 Choose1", ["Geral", "CCP", "Gineco", "Mama", "Melanoma", "Sentinela", "Testículo", "Tireoide"])

    g.AddGroupBox("xm y+15 w740 h160", "Dados do Protocolo")

    ; --- CAMPOS FIXOS ---
    bx := 30, by := 75, yL2 := by + 45, yL3 := by + 80
    g.AddText("x" bx " y" by+5, "Acometidos:")
    edtAcom := g.AddEdit("x+5 w50 Number", "0")
    g.AddText("x+20 yp+3", "Total avaliados:")
    edtTot := g.AddEdit("x+5 yp-3 w50 Number", "0")

    ctrls := Map()

    ; --- 1. GERAL ---
    tG1 := g.AddText("x" bx " y" yL2+3 " Hidden", "Tipo de Tumor:"), dG1 := g.AddDropDownList("x+5 w250 Choose1 Hidden", ["Adenocarcinoma", "Carcinoma de células escamosas", "Tumor neuroendócrino de alto grau"])
    tG2 := g.AddText("x" bx " y" yL3+3 " Hidden", "Extravasamento:"), dG2 := g.AddDropDownList("x+5 w100 Choose2 Hidden", ["com", "sem"])
    tG3 := g.AddText("x+20 yp+3 Hidden", "Maior foco (mm):"), eG3 := g.AddEdit("x+5 yp-3 w60 Hidden")
    ctrls["Geral"] := [tG1, dG1, tG2, dG2, tG3, eG3]

    ; --- 2. CCP ---
    tC1 := g.AddText("x" bx " y" yL2+3 " Hidden", "Extravasamento:"), dC1 := g.AddDropDownList("x+5 w100 Choose1 Hidden", ["com", "sem"])
    tC2 := g.AddText("x" bx " y" yL3+3 " Hidden", "Foco (mm):"), eC2 := g.AddEdit("x+5 w60 Hidden")
    tC3 := g.AddText("x+20 yp+3 Hidden", "Extravas. (mm):"), eC3 := g.AddEdit("x+5 yp-3 w60 Hidden")
    ctrls["CCP"] := [tC1, dC1, tC2, eC2, tC3, eC3]

    ; --- 3. GINECO ---
    tGi1 := g.AddText("x" bx " y" yL2+3 " Hidden", "Extravasamento:"), dGi1 := g.AddDropDownList("x+5 w100 Choose2 Hidden", ["com", "sem"])
    tGi2 := g.AddText("x" bx " y" yL3+3 " Hidden", "Maior Linf. (cm):"), eGi2 := g.AddEdit("x+5 w60 Hidden")
    tGi3 := g.AddText("x+20 yp+3 Hidden", "Maior Foco (mm):"), eGi3 := g.AddEdit("x+5 yp-3 w60 Hidden")
    ctrls["Gineco"] := [tGi1, dGi1, tGi2, eGi2, tGi3, eGi3]

    ; --- 4. MAMA ---
    tMa1 := g.AddText("x" bx " y" yL2+3 " Hidden", "Extravasamento:"), dMa1 := g.AddDropDownList("x+5 w480 Choose3 Hidden", ["com extravasamento capsular > 2,0 mm", "com extravasamento capsular < 2,0 mm", "sem extravasamento capsular"])
    tMa2 := g.AddText("x" bx " y" yL3+3 " Hidden", "Maior Foco (mm):"), eMa2 := g.AddEdit("x+5 w80 Hidden")
    tMa3 := g.AddText("x+20 yp+3 Hidden", "Resposta prévia:"), dMa3 := g.AddDropDownList("x+5 yp-3 w120 Choose1 Hidden", ["Ausência", "Presença"])
    ctrls["Mama"] := [tMa1, dMa1, tMa2, eMa2, tMa3, dMa3]

    ; --- 5. MELANOMA ---
    tMe1 := g.AddText("x" bx " y" yL2+3 " Hidden", "Extravasamento:"), dMe1 := g.AddDropDownList("x+5 w100 Choose2 Hidden", ["com", "sem"])
    tMe2 := g.AddText("x" bx " y" yL3+3 " Hidden", "Maior Foco (mm):"), eMe2 := g.AddEdit("x+5 w80 Hidden")
    tMe3 := g.AddText("x+20 yp+3 Hidden", "Localização:"), dMe3 := g.AddDropDownList("x+5 yp-3 w220 Choose1 Hidden", ["subcapsular", "intraparenquimatosa", "em todo o linfonodo"])
    ctrls["Melanoma"] := [tMe1, dMe1, tMe2, eMe2, tMe3, dMe3]

    ; --- 6. SENTINELA ---
    tS1 := g.AddText("x" bx " y" yL2+3 " Hidden", "Tipo:"), dS1 := g.AddDropDownList("x+5 w120 Choose1 Hidden", ["Carcinoma", "Melanoma"])
    tS2 := g.AddText("x" bx " y" yL3+3 " Hidden", "Extravasamento:"), dS2 := g.AddDropDownList("x+5 w400 Choose3 Hidden", ["com extravasamento capsular > 2,0 mm", "com extravasamento capsular < 2,0 mm", "sem extravasamento capsular"])
    tS3 := g.AddText("x+10 yp+3 Hidden", "Foco(mm):"), eS3 := g.AddEdit("x+5 yp-3 w50 Hidden")
    ctrls["Sentinela"] := [tS1, dS1, tS2, dS2, tS3, eS3]

    ; --- 7. TESTÍCULO ---
    tT1 := g.AddText("x" bx " y" yL2+3 " Hidden", "Tipo:"), dT1 := g.AddDropDownList("x+5 w250 Choose1 Hidden", ["Seminoma", "Tumor do seio endodérmico", "Carcinoma embrionário", "Coriocarcinoma", "Teratoma imaturo"])
    tT2 := g.AddText("x" bx " y" yL3+3 " Hidden", "Extravasamento:"), dT2 := g.AddDropDownList("x+5 w100 Choose2 Hidden", ["com", "sem"])
    tT3 := g.AddText("x+20 yp+3 Hidden", "Maior Linf.(cm):"), eT3 := g.AddEdit("x+5 yp-3 w60 Hidden")
    ctrls["Testículo"] := [tT1, dT1, tT2, dT2, tT3, eT3]

    ; --- 8. TIREOIDE ---
    tTi1 := g.AddText("x" bx " y" yL2+3 " Hidden", "Extravasamento:"), dTi1 := g.AddDropDownList("x+5 w100 Choose2 Hidden", ["com", "sem"])
    tTi2 := g.AddText("x" bx " y" yL3+3 " Hidden", "Dimensão foco(s) (mm):"), eTi2 := g.AddEdit("x+5 w80 Hidden")
    ctrls["Tireoide"] := [tTi1, dTi1, tTi2, eTi2]

    ; --- PRÉVIA E BOTÕES ---
    g.SetFont("Bold")
    g.AddText("xm y260", "Prévia do Laudo:")
    g.SetFont("Norm")
    edtPrev := g.AddEdit("xm y+5 w740 r6 ReadOnly -Wrap")
    btnIns := g.AddButton("xm y+10 w120 Default", "Inserir")
    g.AddButton("x+10 yp w120", "Copiar").OnEvent("Click", (*) => A_Clipboard := Build())
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE VISIBILIDADE ---
    AtualizarLayout(*) {
        for nome, lista in ctrls {
            for c in lista
                c.Visible := false
        }
        proto := ddlProtocolo.Text
        if ctrls.Has(proto) {
            for c in ctrls[proto]
                c.Visible := true

            ; Condicionais de Extravasamento para CCP, Geral e Tireoide
            if (proto == "CCP") {
                tem := (dC1.Text == "com"), tC3.Visible := tem, eC3.Visible := tem
            }
            if (proto == "Geral") {
                tem := (dG2.Text == "com"), tG3.Visible := tem, eG3.Visible := tem
            }
            if (proto == "Tireoide") {
                tem := (dTi1.Text == "com"), tTi2.Visible := tem, eTi2.Visible := tem
            }
        }
        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    ; --- EVENTOS ---
    ddlProtocolo.OnEvent("Change", AtualizarLayout)
    ; Dropdowns que alteram layout
    for d in [dC1, dG2, dTi1]
        d.OnEvent("Change", AtualizarLayout)

    ; Controles que apenas atualizam texto
    todosTxt := [edtAcom, edtTot, eG3, eC2, eC3, eGi2, eGi3, eMa2, eMe2, eS3, eT3, eTi2, dG1, dGi1, dMa1, dMa3, dMe1, dMe3, dS1, dS2, dT1, dT2]
    for ct in todosTxt
        try ct.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))

    ; --- CONSTRUÇÃO DO LAUDO ---
    Build() {
        ac_val := (edtAcom.Value == "") ? 0 : Number(edtAcom.Value)
        tot_val := (edtTot.Value == "") ? 0 : Number(edtTot.Value)
        ac_fmt := Format("{:02}", ac_val), tot_fmt := Format("{:02}", tot_val)

        wL := (tot_val == 1) ? "linfonodo avaliado" : "linfonodos avaliados"
        wA := (ac_val == 1) ? "linfonodo" : "linfonodos"

        if (ac_val == 0)
            return "Ausência de neoplasia em " tot_fmt " de " tot_fmt " " wL " (00/" tot_fmt ")"

        p := ddlProtocolo.Text
        if (p == "Geral") {
            ext := (dG2.Text == "com") ? (", com extravasamento capsular.`n. Dimensão do maior foco: " (eG3.Value || "[]") " mm") : ", sem extravasamento capsular."
            return "Metástase de " dG1.Text " em " ac_fmt "/" tot_fmt " " wA ext
        }
        if (p == "CCP") {
            ext := (dC1.Text == "com") ? (", com extravasamento capsular.`n. Foco: " (eC2.Value || "[]") " mm`n. Extravasamento: " (eC3.Value || "[]") " mm") : (", sem extravasamento capsular.`n. Foco: " (eC2.Value || "[]") " mm")
            return "Metástase de carcinoma em " ac_fmt "/" tot_fmt " " wA ext
        }
        if (p == "Gineco") {
            ext := (dGi1.Text == "com") ? (", com extravasamento capsular.`n. Maior linfonodo acometido: " (eGi2.Value || "[]") " cm`n. Maior foco: " (eGi3.Value || "[]") " mm") : ", sem extravasamento capsular."
            return "Metástase de carcinoma em " ac_fmt "/" tot_fmt " " wA ext
        }
        if (p == "Mama") {
            return "Metástase de carcinoma em " ac_fmt "/" tot_fmt " " wA ", " dMa1.Text ".`n. Maior foco: " (eMa2.Value || "[]") " mm`n. " dMa3.Text " de alterações morfológicas compatíveis com resposta patológica.`nNota: Realizados cortes seriados em 03 níveis."
        }
        if (p == "Melanoma") {
            return "Metástase de melanoma em " ac_fmt "/" tot_fmt " " wA ", " dMe1.Text " extravasamento capsular.`n. Maior foco: " (eMe2.Value || "[]") " mm`n. Localização: " dMe3.Text
        }
        if (p == "Sentinela") {
            return "Metástase de " dS1.Text " em " ac_fmt "/" tot_fmt " " wA ", " dS2.Text ".`n. Maior foco: " (eS3.Value || "[]") " mm`nNota: Realizados cortes aprofundados em 03 níveis para pesquisa de micrometástases."
        }
        if (p == "Testículo") {
            return "Metástase de " dT1.Text " em " ac_fmt "/" tot_fmt " " wA ", " dT2.Text " extravasamento capsular.`n. Maior linfonodo acometido: " (eT3.Value || "[]") " cm"
        }
        if (p == "Tireoide") {
            ext := (dTi1.Text == "com") ? (", com extravasamento capsular.`n. Dimensão do(s) foco(s): " (eTi2.Value || "[]") " mm") : ", sem extravasamento capsular."
            return "Metástase de carcinoma em " ac_fmt "/" tot_fmt " " wA ext
        }
        return "Erro no protocolo."
    }

    g.Show()
    AtualizarLayout()
}