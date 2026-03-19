; =========================================================
; Máscara — Esôfago (biópsia) — Tumor
; Arquivo: scripts\EsofagoBiopsiaTumor.ahk
; Requer: PasteInto(hwnd, txt) no _lib\gui_utils.ahk (via #Include no principal)
; Chamada no menu: (*) => Mask_EsofagoBiopsiaTumor()
; =========================================================

Mask_EsofagoBiopsiaTumor() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Esôfago (biópsia) — Tumor")
    g.MarginX := 12, g.MarginY := 12

    g.AddText("w170", "Tipo")
    ddlTipo := g.AddDropDownList("x+8 w520 Choose1", [
        "Adenocarcinoma tubular",
        "Carcinoma de células escamosas",
        "Carcinoma adenoescamoso",
        "Tumor neuroendócrino de alto grau"
    ])

    g.AddText("xm y+12 w170", "Diferenciação")
    ddlDiff := g.AddDropDownList("x+8 w220 Choose2", ["bem", "moderadamente", "pouco"])

    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r4 ReadOnly -Wrap")

    for ctrl in [ddlTipo, ddlDiff] {
        ctrl.OnEvent("Change", (*) => UpdatePreview())
    }

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := Build(),
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (
        txt := Build(),
        A_Clipboard := txt
    ))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()

    UpdatePreview() => edtPrev.Value := Build()

    Build() {
        return (ddlTipo.Text " " ddlDiff.Text " diferenciado")
    }
}
