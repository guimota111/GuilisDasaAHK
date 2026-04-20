; =========================================================
; Patologia Geral — Neoplasia de Células Fusiformes
; Arquivo: scripts\CelsFusiformes.ahk
; =========================================================

Mask_CelsFusiformes() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Células Fusiformes")
    AplicarIcone(g)
    g.BackColor := "F3F3F3"
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. MORFOLOGIA ---
    g.AddGroupBox("w760 h150", "Achados Morfológicos")

    g.AddText("xp+15 yp+30 w110", "Breve Descrição:")
    edtDesc := g.AddEdit("x140 yp-3 w605 +Tabstop", "")

    g.AddText("x35 y+35 w110", "Atipia Celular:")
    ddlAtipia := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["não detectada", "discreta", "moderada", "acentuada"])

    g.AddText("x400 yp+3 w110", "Índice Mitótico:")
    edtMitose := g.AddEdit("x520 yp-3 w225 +Tabstop", "mitoses não detectadas")

    g.AddText("x35 y+35 w110", "Necrose:")
    ddlNecrose := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["não detectada", "presente, focal", "presente, extensa"])

    g.AddText("x400 yp+3 w110", "Margens:")
    ddlMargem := g.AddDropDownList("x520 yp-3 w225 Choose1 +Tabstop", ["Margens cirúrgicas livres de lesão", "Margens cirúrgicas comprometidas pela neoplasia"])

    ; --- 2. INVASÕES ---
    g.AddGroupBox("xm y+25 w760 h70", "Invasões")
    g.AddText("xp+15 yp+30 w110", "Perineural:")
    ddlNeural := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["não detectada", "presente"])

    g.AddText("x400 yp+3 w110", "Angiolinfática:")
    ddlVasc := g.AddDropDownList("x520 yp-3 w225 Choose1 +Tabstop", ["não detectada", "presente"])

    ; --- 3. NOTA E IMUNO ---
    g.AddGroupBox("xm y+25 w760 h110", "Nota e Complementação")
    g.AddText("xp+15 yp+30 w110", "Hipótese (Opcional):")
    edtHipots := g.AddEdit("x140 yp-3 w605 +Tabstop", "")

    g.AddText("x35 y+35 w110", "Necessidade:")
    ddlNec := g.AddDropDownList("x140 yp-3 w240 Choose1 +Tabstop", ["Em andamento", "É necessária a realização de"])

    ddlEstudo := g.AddDropDownList("x+10 yp w355 Choose1 +Tabstop", [
        "estudo imuno-histoquímico para complementação diagnóstica",
        "estudo imuno-histoquímico para complementação diagnóstica e/ou pesquisa do sítio primário",
        "estudo imuno-histoquímico para pesquisa do sítio primário da neoplasia",
        "estudo imuno-histoquímico para pesquisa de fatores prognósticos e preditivos",
        "estudo imuno-histoquímico para pesquisa da expressão de proteínas dos genes de reparo do DNA",
        "estudo imuno-histoquímico para confirmação ou exclusão da presença de malignidade",
        "estudo imuno-histoquímico para subclassificação da neoplasia",
        "estudo imuno-histoquímico para exclusão de lesão invasiva",
        "pesquisa de associação com infecção por HPV"
    ])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Laudo:")
    edtPrev := g.AddEdit("r10 w760 +ReadOnly Background333333", "")
    edtPrev.SetFont("cwhite s10", "Consolas")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- EVENTOS ---
    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [edtDesc, ddlAtipia, edtMitose, ddlNecrose, ddlMargem, ddlNeural, ddlVasc, edtHipots, ddlNec, ddlEstudo]
    for c in controles
        c.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    UpdatePreview()

    Build() {
        desc := (edtDesc.Value != "") ? " " edtDesc.Value : ""
        res := "Neoplasia de células fusiformes" desc "`r`n"
        res .= ". Atipia celular: " ddlAtipia.Text ".`r`n"

        mit := edtMitose.Value
        if (IsNumber(mit))
            mit .= " mitoses/ 10 campos de grande aumento"
        res .= ". Índice mitótico: " mit ".`r`n"

        res .= ". Necrose: " ddlNecrose.Text ".`r`n"
        res .= ". Invasão perineural: " ddlNeural.Text ".`r`n"
        res .= ". Invasão angiolinfática: " ddlVasc.Text ".`r`n"
        res .= ". " ddlMargem.Text ".`r`n`r`n"

        res .= "Nota: "
        if (edtHipots.Value != "")
            res .= "Os achados morfológicos podem corresponder ao diagnóstico de " edtHipots.Value ". "

        res .= ddlNec.Text " " ddlEstudo.Text "."
        return res
    }
}