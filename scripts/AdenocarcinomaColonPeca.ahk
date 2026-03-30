; =========================================================
; Máscara — Adenocarcinoma de Cólon — Peça Cirúrgica
; =========================================================

Mask_AdenocarcinomaColonPeca() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Adenocarcinoma de Cólon (Peça)")
    g.MarginX := 14, g.MarginY := 12
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm w170", "Tipo (OMS 2019)")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Adenocarcinoma, SOE",
        "Adenocarcinoma mucinoso",
        "Adenocarcinoma serrilhado",
        "Carcinoma de células em anel de sinete",
        "Carcinoma medular",
        "Carcinoma micropapilífero",
        "Carcinoma adenoescamoso",
        "Carcinoma indiferenciado"
    ])

    g.AddText("xm y+10 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w200 Choose2", ["bem", "moderadamente", "pouco"])

    g.AddText("x+12 w100", "Ulceração")
    ddlUlc := g.AddDropDownList("x+8 w200 Choose1", ["ulcerado", "não ulcerado"])

    g.AddText("xm y+10 w170", "Localização")
    ddlLoc := g.AddDropDownList("x+8 w520 Choose1", [
        "ceco",
        "cólon ascendente",
        "flexura hepática",
        "cólon transverso",
        "flexura esplênica",
        "cólon descendente",
        "sigmoide",
        "transição retossigmoide",
        "reto",
        "transição reto-canal anal"
    ])

    g.AddText("xm y+10 w170", "Dimensão (cm)")
    edtDimA := g.AddEdit("x+8 w80")
    g.AddText("x+6 yp+3 w12 Center", "x")
    edtDimB := g.AddEdit("x+6 yp-3 w80")
    g.AddText("x+6 yp+3", "cm")

    g.AddText("xm y+10 w170", "Profundidade")
    ddlProf := g.AddDropDownList("x+8 w520 Choose4", [
        "restrito à mucosa",
        "invade a submucosa",
        "invade a muscular própria",
        "atinge o tecido adiposo subseroso",
        "perfura a serosa",
        "invade víscera adjacente"
    ])

    g.AddText("xm y+6 w170", "    Víscera adjacente")
    edtAdj := g.AddEdit("x+8 w520")
    edtAdj.Enabled := false

    g.AddText("xm y+10 w170", "Serosa")
    ddlSerosa := g.AddDropDownList("x+8 w520 Choose1", [
        "livre de infiltração neoplásica",
        "infiltrada pela neoplasia"
    ])

    g.AddText("xm y+10 w170", "Fronte de invasão")
    ddlFronte := g.AddDropDownList("x+8 w200 Choose1", ["infiltrativa", "expansiva"])

    g.AddText("x+12 w150", "Budding (0,785 mm²)")
    ddlBuds := g.AddDropDownList("x+8 w200 Choose1", [
        "baixo escore (0 a 4)",
        "escore intermediário (5 a 9)",
        "alto escore (10 ou mais)"
    ])

    g.AddText("xm y+10 w170", "Inv. vascular sanguínea")
    ddlIVS := g.AddDropDownList("x+8 w200 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w170", "Inv. vascular linfática")
    ddlIVL := g.AddDropDownList("x+8 w200 Choose1", ["não detectada", "presente"])

    g.AddText("xm y+6 w170", "Inv. perineural")
    ddlIPN := g.AddDropDownList("x+8 w200 Choose1", ["não detectada", "presente"])

    g.AddText("x+12 w200", "Depósitos tumorais")
    ddlDep := g.AddDropDownList("x+8 w200 Choose1", ["não detectados", "presentes"])

    g.AddText("xm y+10 w170", "Cólon não neoplásico")
    ddlNonNeo := g.AddDropDownList("x+8 w520 Choose1", [
        "dentro dos limites histológicos da normalidade",
        "doença diverticular",
        "serosite aguda",
        "adenoma tubular com displasia de baixo grau",
        "pólipo hiperplásico"
    ])

    g.AddButton("xm y+18 w120 Default", "OK").OnEvent("Click", OnOK)
    g.AddButton("x+8 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())
    g.OnEvent("Escape", (*) => g.Destroy())
    g.Show()

    ddlProf.OnEvent("Change", (*) => ToggleAdj())

    ToggleAdj() {
        if (ddlProf.Value = 6) {
            edtAdj.Enabled := true
            edtAdj.Focus()
        } else {
            edtAdj.Enabled := false
            edtAdj.Value := ""
        }
    }

    OnOK(*) {
        tipo   := ddlTipo.Text
        diff   := ddlDiff.Text
        ulc    := ddlUlc.Text
        loc    := ddlLoc.Text
        dimA   := StrReplace(Trim(edtDimA.Value), ",", ".")
        dimB   := StrReplace(Trim(edtDimB.Value), ",", ".")
        adj    := Trim(edtAdj.Value)
        serosa := ddlSerosa.Text
        fronte := ddlFronte.Text
        buds   := ddlBuds.Text
        ivs    := ddlIVS.Text
        ivl    := ddlIVL.Text
        ipn    := ddlIPN.Text
        dep    := ddlDep.Text
        nonNeo := ddlNonNeo.Text

        if (dimA != "" && dimB != "")
            dimTxt := dimA " x " dimB " cm"
        else if (dimA != "")
            dimTxt := dimA " cm"
        else if (dimB != "")
            dimTxt := dimB " cm"
        else
            dimTxt := "[dimensão] cm"

        if (ddlProf.Value = 6)
            profTxt := "invade víscera adjacente" . (adj != "" ? " (" adj ")" : "")
        else
            profTxt := ddlProf.Text

        g.Destroy()
        try WinActivate("ahk_id " prevWin)
        try WinWaitActive("ahk_id " prevWin, , 1)

        Send "^b"
        SendText "- " tipo " (OMS 2019) " diff " diferenciado, " ulc "."
        Send "^b"
        SendText "`n. Localização da neoplasia: " loc "."
                . "`n. Dimensão da neoplasia: " dimTxt "."
                . "`n. Profundidade da infiltração: tumor " profTxt "."
                . "`n. Serosa: " serosa "."
                . "`n. Fronte de invasão: " fronte "."
                . "`n. Número de " Chr(8220) "buds" Chr(8221) " tumorais em " Chr(8220) "hotspot" Chr(8221) " na fronte de invasão (área de 0,785mm²): " buds "."
                . "`n. Invasão vascular sanguínea: " ivs "."
                . "`n. Invasão vascular linfática: " ivl "."
                . "`n. Invasão perineural: " ipn "."
                . "`n. Nódulos satélites tumorais em gordura pericólica (depósitos tumorais): " dep "."
                . "`n. Cólon não neoplásico: " nonNeo "."
    }
}
