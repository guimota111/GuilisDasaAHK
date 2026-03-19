; =========================================================
; Testículo — Neoplasia (Lógica de Tumor Misto Dinâmica)
; Arquivo: scripts\Testiculo.ahk
; =========================================================

Mask_TesticuloGerminativas() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Testículo")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 12, g.MarginY := 12

    ; --- COMPONENTES (As 4 caixas iniciais) ---
    g.AddGroupBox("w740 h150", "Componentes da Neoplasia")
    g.AddText("xp+10 yp+25", "Selecione os componentes e suas porcentagens (deixe '---' se não houver):")

    listaComp := [
        "---", "Seminoma", "Seminoma com células sinciciotrofoblásticas", "Carcinoma embrionário",
        "Tumor do seio endodérmico, tipo pós-puberal", "Coriocarcinoma", "Teratoma pós-puberal",
        "Teratoma com malignidade somática", "Tumor espermatocítico", "Tumor do sítio trofoblástico placentário",
        "Tumor trofoblástico epitelioide", "Tumor de células de Leydig", "Tumor de células de Sertoli",
        "Tumor de células da granulosa"
    ]

    ; Criando as 4 linhas de componentes dinamicamente
    comps := []
    Loop 4 {
        yPos := (A_Index = 1) ? "y+10" : "y+5"
        row := {}
        row.ddl := g.AddDropDownList("xm+15 " yPos " w300 Choose1", listaComp)
        g.AddText("x+10 yp+3", "Porcentagem:")
        row.edt := g.AddEdit("x+5 yp-3 w50 Number")
        g.AddText("x+5 yp+3", "%")
        comps.Push(row)
    }

    ; --- DIMENSÃO E EXTENSÃO ---
    g.AddGroupBox("xm y+25 w740 h110", "Extensão e Dimensões")
    g.AddText("xp+10 yp+25 w110", "Dimensão (cm):")
    edtDimA := g.AddEdit("x+5 w60"), g.AddText("x+2 yp+3", "x"), edtDimB := g.AddEdit("x+2 yp-3 w60"), g.AddText("x+5 yp+3", "cm")

    g.AddText("x+30 yp", "Multifocalidade:")
    ddlMulti := g.AddDropDownList("x+5 w150 Choose2", ["presente", "não detectada"])

    g.AddText("xm+10 y+15 w110", "Invasão/Extensão:")
    ddlExt := g.AddDropDownList("x+5 w580 Choose1", [
        "limitado ao testículo e epidídimo",
        "invade a rede testicular",
        "invade partes moles hilares",
        "invade através da túnica albugínea e perfura a túnica vaginal (mesotélio)",
        "invade o cordão espermático",
        "invade a bolsa escrotal"
    ])

    ; --- INVASÕES ---
    g.AddGroupBox("xm y+20 w740 h80", "Invasões")
    g.AddText("xp+10 yp+25 w110", "Vasc. Sanguínea:")
    ddlIVS := g.AddDropDownList("x+5 w120 Choose2", ["presente", "não detectada"])
    g.AddText("x+20 yp w110", "Vasc. Linfática:")
    ddlIVL := g.AddDropDownList("x+5 w120 Choose2", ["presente", "não detectada"])
    g.AddText("x+20 yp w110", "Perineural:")
    ddlPNI := g.AddDropDownList("x+5 w120 Choose2", ["presente", "não detectada"])

    ; --- PRÉVIA ---
    g.AddText("xm y+20", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w740 r10 ReadOnly -Wrap")

    ; =========================
    ; EVENTOS
    ; =========================
    UpdatePreview(*) => edtPrev.Value := Build()

    ; Registrar eventos para todos os componentes e campos
    for row in comps {
        row.ddl.OnEvent("Change", UpdatePreview)
        row.edt.OnEvent("Change", UpdatePreview)
    }

    controles := [edtDimA, edtDimB, ddlMulti, ddlExt, ddlIVS, ddlIVL, ddlPNI]
    for ctrl in controles
        ctrl.OnEvent("Change", UpdatePreview)

    ; Botões
    g.AddButton("xm y+15 w120 Default", "Inserir").OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    g.AddButton("x+10 w120", "Copiar").OnEvent("Click", (*) => A_Clipboard := Build())
    g.AddButton("x+10 w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    ; =========================
    ; CONSTRUÇÃO DO LAUDO
    ; =========================
    Build() {
        selecionados := []
        for row in comps {
            if (row.ddl.Text != "---") {
                porc := row.edt.Value == "" ? "[]" : row.edt.Value
                selecionados.Push({nome: row.ddl.Text, porc: porc})
            }
        }

        ; Decidir o título
        if (selecionados.Length = 0) {
            titulo := "[Selecione ao menos um componente]"
        } else if (selecionados.Length = 1) {
            titulo := selecionados[1].nome
        } else {
            titulo := "Tumor misto de células germinativas, com os seguintes componentes:"
        }

        ; Montar lista de componentes (se for misto)
        listaTxt := ""
        if (selecionados.Length > 1) {
            for item in selecionados {
                listaTxt .= ". " item.nome ": " item.porc "%`n"
            }
        }

        ; Dimensões e outros
        dA := edtDimA.Value == "" ? "[]" : StrReplace(edtDimA.Value, ",", ".")
        dB := edtDimB.Value == "" ? "[]" : StrReplace(edtDimB.Value, ",", ".")

        res := titulo "`n"
        res .= listaTxt
        res .= ". Multifocalidade: " ddlMulti.Text "`n"
        res .= ". Dimensão da neoplasia: " dA " x " dB " cm`n"
        res .= ". Extensão da invasão: tumor " ddlExt.Text "`n"
        res .= ". Invasão vascular sanguínea: " ddlIVS.Text "`n"
        res .= ". Invasão vascular linfática: " ddlIVL.Text "`n"
        res .= ". Invasão perineural: " ddlPNI.Text

        return res
    }
}