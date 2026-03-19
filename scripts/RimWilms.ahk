; =========================================================
; Rim — Wilms (Nefroblastoma residual)
; Arquivo: scripts\RimWilms.ahk
; Função chamada no menu: Mask_RimWilms()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_RimWilms() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Rim — Wilms (residual)")
    g.MarginX := 12, g.MarginY := 12

    ; =========================
    ; Localização / multifocalidade / dimensões
    ; =========================
    locList := ["polo superior", "polo inferior", "região mesorrenal", "todo parênquima renal"]

    g.AddText("w220", "Localização (1)")
    ddlLoc1 := g.AddDropDownList("x+8 w240 Choose1", locList)

    g.AddText("x+12 w120", "Localização (2)")
    ddlLoc2 := g.AddDropDownList("x+8 w240 Choose1", locList)

    g.AddText("xm y+12 w220", "Multifocalidade")
    ddlMulti := g.AddDropDownList("x+8 w240 Choose2", ["presente", "não detectada"])

    g.AddText("xm y+12 w220", "Dimensões (cm)")
    edtA := g.AddEdit("x+8 w70")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtB := g.AddEdit("x+8 yp-3 w70")
    g.AddText("x+8 yp+3 w12 Center", "x")
    edtC := g.AddEdit("x+8 yp-3 w70")
    g.AddText("x+8 yp+3", "cm")

    ; =========================
    ; Resposta ao tratamento
    ; =========================
    g.AddText("xm y+14 w260", "Resposta ao tratamento neoadjuvante")
    ddlResp := g.AddDropDownList("x+8 w240 Choose2", [
        "presentes, correspondendo a % do total da lesão (com proporções abaixo)",
        "não detectadas"
    ])
    g.AddText("x+12 w40", "%")
    edtRespTotal := g.AddEdit("x+6 w70") ; aceita , ou .

    g.AddText("xm y+10 w220", "Necrose (%)")
    edtRespNec := g.AddEdit("x+8 w90")

    g.AddText("x+12 w260", "Macrófagos espumosos (%)")
    edtRespMac := g.AddEdit("x+8 w90")

    g.AddText("xm y+10 w220", "Fibrose (%)")
    edtRespFib := g.AddEdit("x+8 w90")

    ; =========================
    ; Neoplasia viável
    ; =========================
    g.AddText("xm y+14 w260", "Neoplasia viável")
    ddlViavel := g.AddDropDownList("x+8 w240 Choose1", [
        "presente, correspondendo a % do total da lesão (com proporções abaixo)",
        "não detectada"
    ])
    g.AddText("x+12 w40", "%")
    edtViavelTotal := g.AddEdit("x+6 w70")

    g.AddText("xm y+10 w220", "Blastemal (%)")
    edtBlast := g.AddEdit("x+8 w90")

    g.AddText("x+12 w260", "Epitelial (%)")
    edtEpit := g.AddEdit("x+8 w90")

    g.AddText("xm y+10 w220", "Mesenquimal (%)")
    edtMes := g.AddEdit("x+8 w90")

    ; =========================
    ; Outros
    ; =========================
    g.AddText("xm y+14 w220", "Anaplasia")
    ddlAnap := g.AddDropDownList("x+8 w240 Choose1", [
        "não detectada",
        "presente, focal",
        "presente, difusa"
    ])

    g.AddText("x+12 w280", "Restos nefrogênicos (peri/intralobares)")
    ddlRestos := g.AddDropDownList("x+8 w240 Choose2", ["presentes", "não detectados"])

    ; =========================
    ; Infiltração
    ; =========================
    yn := ["presente", "não detectada"]

    g.AddText("xm y+14 w720", "Infiltração de:")
    g.AddText("xm y+8 w170", "Cápsula renal")
    ddlCaps := g.AddDropDownList("x+8 w220 Choose2", yn)

    g.AddText("x+12 w170", "Gordura perirrenal")
    ddlGord := g.AddDropDownList("x+8 w220 Choose2", yn)

    g.AddText("xm y+10 w170", "Pelve renal")
    ddlPelve := g.AddDropDownList("x+8 w220 Choose2", yn)

    g.AddText("x+12 w170", "Seio renal")
    ddlSeio := g.AddDropDownList("x+8 w220 Choose2", yn)

    g.AddText("xm y+10 w170", "Artéria renal")
    ddlArt := g.AddDropDownList("x+8 w220 Choose2", yn)

    g.AddText("x+12 w170", "Veia renal")
    ddlVeia := g.AddDropDownList("x+8 w220 Choose2", yn)

    ; =========================
    ; Invasões
    ; =========================
    g.AddText("xm y+14 w220", "Invasão vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w240 Choose2", yn)

    g.AddText("x+12 w220", "Invasão vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w240 Choose2", yn)

    g.AddText("xm y+10 w220", "Invasão perineural")
    ddlIPN := g.AddDropDownList("x+8 w240 Choose2", yn)

    ; =========================
    ; Prévia + botões
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r12 ReadOnly -Wrap")

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := Build()))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    ; =========================
    ; Eventos / regras
    ; =========================
    for ctrl in [
        ddlLoc1, ddlLoc2, ddlMulti, edtA, edtB, edtC,
        ddlResp, edtRespTotal, edtRespNec, edtRespMac, edtRespFib,
        ddlViavel, edtViavelTotal, edtBlast, edtEpit, edtMes,
        ddlAnap, ddlRestos,
        ddlCaps, ddlGord, ddlPelve, ddlSeio, ddlArt, ddlVeia,
        ddlIVS, ddlIVL, ddlIPN
    ] {
        try ctrl.OnEvent("Change", (*) => UpdatePreview())
        try ctrl.OnEvent("Click",  (*) => UpdatePreview())
    }

    ddlResp.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))
    ddlViavel.OnEvent("Change", (*) => (ApplyRules(), UpdatePreview()))

    g.Show()
    ApplyRules()
    UpdatePreview()

    ; =========================
    ; Funções internas
    ; =========================
    ApplyRules() {
        respOn := (ddlResp.Value = 1)
        edtRespTotal.Enabled := respOn
        edtRespNec.Enabled := respOn
        edtRespMac.Enabled := respOn
        edtRespFib.Enabled := respOn
        if (!respOn) {
            edtRespTotal.Value := ""
            edtRespNec.Value := ""
            edtRespMac.Value := ""
            edtRespFib.Value := ""
        }

        viaOn := (ddlViavel.Value = 1)
        edtViavelTotal.Enabled := viaOn
        edtBlast.Enabled := viaOn
        edtEpit.Enabled := viaOn
        edtMes.Enabled := viaOn
        if (!viaOn) {
            edtViavelTotal.Value := ""
            edtBlast.Value := ""
            edtEpit.Value := ""
            edtMes.Value := ""
        }
    }

    UpdatePreview() => edtPrev.Value := Build()

    NormPct(v) {
        v := StrReplace(Trim(v), ",", ".")
        return (v = "" ? "[]%" : v "%")
    }

    NormNum(v) {
        v := StrReplace(Trim(v), ",", ".")
        return v
    }

    Build() {
        linhas := []

        linhas.Push("Nefroblastoma (Tumor de Wilms) residual")

        linhas.Push(". Localização no tecido renal: " ddlLoc1.Text " e " ddlLoc2.Text)
        linhas.Push(". Multifocalidade: " ddlMulti.Text)

        a := NormNum(edtA.Value), b := NormNum(edtB.Value), c := NormNum(edtC.Value)
        if (a != "" && b != "" && c != "")
            dimTxt := a " x " b " x " c " cm"
        else if (a != "" || b != "" || c != "")
            dimTxt := (a!=""?a:"[]") " x " (b!=""?b:"[]") " x " (c!=""?c:"[]") " cm"
        else
            dimTxt := "[] x [] x [] cm"
        linhas.Push(". Dimensões da neoplasia: " dimTxt)

        ; Resposta ao tratamento
        if (ddlResp.Value = 1) {
            total := StrReplace(Trim(edtRespTotal.Value), ",", ".")
            if (total = "")
                total := "{}"
            linhas.Push(". Áreas de resposta ao tratamento neoadjuvante: presentes, correspondendo a " total "% do total da lesão, nas seguintes proporções:")
            linhas.Push("- Necrose: " NormPct(edtRespNec.Value))
            linhas.Push("- Acúmulos de macrófagos espumosos: " NormPct(edtRespMac.Value))
            linhas.Push("- Fibrose: " NormPct(edtRespFib.Value))
        } else {
            linhas.Push(". Áreas de resposta ao tratamento neoadjuvante: não detectadas")
        }

        ; Neoplasia viável
        if (ddlViavel.Value = 1) {
            total2 := StrReplace(Trim(edtViavelTotal.Value), ",", ".")
            if (total2 = "")
                total2 := "{}"
            linhas.Push(". Neoplasia viável: presente, correspondendo a " total2 "% do total da lesão, nas seguintes proporções:")
            linhas.Push("- Componente blastemal: " NormPct(edtBlast.Value))
            linhas.Push("- Componente epitelial: " NormPct(edtEpit.Value))
            linhas.Push("- Componente mesenquimal: " NormPct(edtMes.Value))
        } else {
            linhas.Push(". Neoplasia viável: não detectada")
        }

        linhas.Push(". Anaplasia: " ddlAnap.Text)
        linhas.Push(". Restos nefrogênicos perilobares e intralobares: " ddlRestos.Text)

        linhas.Push(". Infiltração de:")
        linhas.Push("- Cápsula renal: " ddlCaps.Text)
        linhas.Push("- Gordura perirrenal: " ddlGord.Text)
        linhas.Push("- Pelve renal: " ddlPelve.Text)
        linhas.Push("- Seio renal: " ddlSeio.Text)
        linhas.Push("- Artéria renal: " ddlArt.Text)
        linhas.Push("- Veia renal: " ddlVeia.Text)

        linhas.Push(". Invasão vascular sanguinea: " ddlIVS.Text)
        linhas.Push(". Invasão vascular linfática: " ddlIVL.Text)
        linhas.Push(". Invasão perineural: " ddlIPN.Text)

        linhas.Push("Parênquima renal não neoplásico:")
        linhas.Push(". Compartimento glomerular: dentro dos limites histológicos da normalidade")
        linhas.Push(". Compartimento túbulo-intersticial: dentro dos limites histológicos da normalidade")
        linhas.Push(". Compartimento vascular: dentro dos limites histológicos da normalidade")

        txt := ""
        for l in linhas
            txt .= l "`n"
        return RTrim(txt, "`n")
    }
}
