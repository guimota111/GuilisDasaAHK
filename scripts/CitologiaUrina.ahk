; =========================================================
; Citopatologia — Urina (Sistema de Paris)
; Arquivo: scripts\CitologiaUrina.ahk
; =========================================================

Mask_CitologiaUrina() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — Citologia de Urina")
    g.SetFont("s10", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CATEGORIA DIAGNÓSTICA ---
    g.AddGroupBox("w600 h120", "Classificação de Paris (2016)")

    g.AddText("xp+15 yp+30 w120", "Categoria:")
    ddlCat := g.AddDropDownList("x150 yp-3 w420 Choose2 +Tabstop", [
        "Insatisfatório / Não diagnóstico",
        "Negativo para Carcinoma urotelial de alto grau",
        "Células uroteliais atípicas",
        "Suspeito para Carcinoma urotelial de alto grau",
        "Carcinoma urotelial de alto grau",
        "Neoplasia urotelial de baixo grau",
        "Outras malignidades primárias e secundárias ou lesões mistas"])

    ; Campo para citar outras malignidades (oculto por padrão)
    tOutras := g.AddText("x35 y+15 w110 Hidden", "Especificar:")
    edtOutras := g.AddEdit("x150 yp-3 w420 Hidden +Tabstop")

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+25", "Prévia do Diagnóstico:")
    edtPrev := g.AddEdit("xm w600 r6 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE INTERFACE ---
    AtualizarLayout(*) {
        ; Mostra o campo de especificação apenas na opção 7
        isOutras := (ddlCat.Value == 7)
        tOutras.Visible := isOutras
        edtOutras.Visible := isOutras

        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    ddlCat.OnEvent("Change", AtualizarLayout)
    edtOutras.OnEvent("Change", UpdatePreview)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlCat.Focus()
    AtualizarLayout()

    Build() {
        cat := ddlCat.Text
        res := "Categoria diagnóstica (Classificação de Paris, 2016):`n"

        if (ddlCat.Value == 7) {
            res .= cat ": " (edtOutras.Value || "[especificar]") "."
        } else {
            res .= cat "."
        }

        return res
    }
}