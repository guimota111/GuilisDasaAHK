; =========================================================
; Corpo uterino — Endométrio — Biópsia (benigno)
; Arquivo: scripts\EndometrioBiopsiaBenigno.ahk
; Função chamada no menu: Mask_EndometrioBiopsiaBenigno()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_EndometrioBiopsiaBenigno() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Endométrio — Biópsia (benigno)")
    g.MarginX := 12
    g.MarginY := 12

    g.AddText("w160", "Diagnóstico")
    ddlDx := g.AddDropDownList("x+8 w560 Choose1", [
        "Fragmentos de endométrio de padrão atrófico",
        "Fragmentos de endométrio de padrão atrófico cístico",
        "Fragmentos de endométrio de padrão secretor",
        "Fragmentos de endométrio de padrão proliferativo",
        "Restos ovulares",
        "Fragmentos de endométrio exibindo dissociação estroma-glândula (estroma decidual e glândulas atróficas), compatível com efeito hormonal exógeno",
        "Endométrio exibindo hiperplasia simples sem atipia (OMS 2014: Hiperplasia benigna)",
        "Endométrio exibindo hiperplasia complexa sem atipia (OMS 2014: Hiperplasia benigna)",
        "Endométrio exibindo hiperplasia complexa com atipia (OMS 2014: Hiperplasia atípica)",
        "Endométrio proliferativo desordenado",
        "Pólipo endometrial"
    ])

    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w720 r4 ReadOnly -Wrap")

    UpdatePreview(*) => edtPrev.Value := ddlDx.Text
    ddlDx.OnEvent("Change", UpdatePreview)

    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    btnInsert.OnEvent("Click", (*) => (
        txt := ddlDx.Text,
        g.Destroy(),
        PasteInto(prevWin, txt)
    ))
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := ddlDx.Text))
    btnCancel.OnEvent("Click", (*) => g.Destroy())

    g.Show()
    UpdatePreview()
}
