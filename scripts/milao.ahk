; =========================================================
; Citopatologia — PAAF de Glândula Salivar (Sistema Milão)
; Arquivo: scripts\milan.ahk
; =========================================================

Mask_Milan() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — PAAF Salivar (Milão)")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CATEGORIA MILÃO ---
    g.AddGroupBox("w720 h80", "Categoria (Sistema Milão, 2018)")
    ddlCat := g.AddDropDownList("xp+15 yp+30 w690 Choose1 +Tabstop", [
        "Categoria I: Não diagnóstico",
        "Categoria II: Não neoplásico",
        "Categoria III: Atipia de Significado Indeterminado (AUS)",
        "Categoria IV: Neoplasia (Benigna ou SUMP)",
        "Categoria V: Suspeito para malignidade",
        "Categoria VI: Maligno"])

    ; --- 2. SUB-OPÇÕES DINÂMICAS ---
    g.AddGroupBox("xm y+25 w720 h150", "Especificações Diagnósticas")

    ; DDLs específicas (escondidas por padrão)
    ; Cat I
    tB1 := g.AddText("xp+15 yp+35 w680 Hidden", "Material celular insuficiente para diagnóstico citológico.")

    ; Cat II
    ddlB2 := g.AddDropDownList("xp yp w680 Choose1 Hidden +Tabstop", ["Sialoadenite crônica", "Sialoadenite granulomatosa", "Sialolitíase", "Processo inflamatório crônico granulomatoso", "Linfonodo de aspecto reacional", "Processo infeccioso"])

    ; Cat III
    ddlB3 := g.AddDropDownList("xp yp w680 Choose1 Hidden +Tabstop", ["Elementos celulares com atipia reativa ou neoplásica", "Alteração metaplásica escamosa indefinida para neoplasia", "Alteração metaplásica oncocítica indefinida para neoplasia", "Lesão mucinosa cística com elementos celulares ausentes ou escassos", "Lesão cística não mucinosa com elementos celulares atípicos", "Esfregaços paucicelulares sugestivos mas não diagnósticos para neoplasia", "Lesão linfoide indefinida para Neoplasia linfoproliferativa"])

    ; Cat IV (A e B)
    ddlB4_Tipo := g.AddDropDownList("xp yp w200 Choose1 Hidden +Tabstop", ["IV-A: Benigno", "IV-B: SUMP (Potencial Incerto)"])
    ddlB4_Diag := g.AddDropDownList("x+10 yp w470 Choose1 Hidden +Tabstop", [
        "Adenoma pleomórfico",
        "Tumor de Warthin",
        "Schwannoma",
        "Lipoma",
        "Neoplasia celular com características basaloides",
        "Neoplasia celular com características oncocíticas",
        "Neoplasia de células com citoplasma claro"])

    ; Cat V
    ddlB5 := g.AddDropDownList("x35 yp w680 Choose1 Hidden +Tabstop", ["Suspeito para Carcinoma adenoide cístico", "Suspeito para Carcinoma mucoepidermoide", "Suspeito para Carcinoma secretor", "Suspeito para Carcinoma ex-adenoma pleomórfico", "Infiltração por pequenos linfócitos (suspeito linfoma baixo grau)", "Linfócitos grandes e atípicos (suspeito linfoma alto grau)"])

    ; Cat VI
    ddlB6_Diag := g.AddDropDownList("xp yp w550 Choose1 Hidden +Tabstop", ["Carcinoma adenoide cístico", "Carcinoma mucoepidermoide", "Carcinoma secretor", "Carcinoma ex-adenoma pleomórfico", "Carcinoma de células acinares", "Carcinoma epitelial mioepitelial", "Adenocarcinoma polimórfico", "Linfoma", "Sarcoma"])
    ddlB6_Grau := g.AddDropDownList("x+10 yp w120 Choose1 Hidden +Tabstop", ["alto grau", "baixo grau"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Laudo:")
    edtPrev := g.AddEdit("xm w720 r8 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+15 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE INTERFACE ---
    AtualizarLayout(*) {
        v := ddlCat.Value
        tB1.Visible := (v == 1)
        ddlB2.Visible := (v == 2)
        ddlB3.Visible := (v == 3)
        ddlB4_Tipo.Visible := (v == 4), ddlB4_Diag.Visible := (v == 4)
        ddlB5.Visible := (v == 5)
        ddlB6_Diag.Visible := (v == 6), ddlB6_Grau.Visible := (v == 6)
        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    controles := [ddlCat, ddlB2, ddlB3, ddlB4_Tipo, ddlB4_Diag, ddlB5, ddlB6_Diag, ddlB6_Grau]
    for c in controles
        c.OnEvent("Change", AtualizarLayout)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlCat.Focus()
    AtualizarLayout()

    Build() {
        v := ddlCat.Value
        res := ddlCat.Text " (Milão, 2018):`n"

        if (v == 1) {
            res .= "Material celular insuficiente para diagnóstico citológico."
        } else if (v == 2) {
            res .= "Consistente com " ddlB2.Text "."
        } else if (v == 3) {
            res .= "Amostra indefinida para neoplasia.`n" ddlB3.Text "."
        } else if (v == 4) {
            res := "Categoria " ddlB4_Tipo.Text " (Milão, 2018):`nConsistente com " ddlB4_Diag.Text "."
        } else if (v == 5) {
            res .= ddlB5.Text "."
        } else if (v == 6) {
            res .= "Consistente com " ddlB6_Diag.Text " de " ddlB6_Grau.Text "."
        }
        return res
    }
}