; =========================================================
; Pele — Normal
; Arquivo: scripts\PeleNormal.ahk
; Função chamada no menu: Mask_PeleNormal()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_PeleNormal() {
    prevWin := WinGetID("A")

    g := Gui("+AlwaysOnTop +MinSize", "Máscara — Pele — Normal")
    g.MarginX := 12
    g.MarginY := 12

    ; =========================
    ; OPÇÃO: HIPODERME
    ; =========================
    g.AddText("w170", "Hipoderme")
    ddlHip := g.AddDropDownList("x+8 w520 Choose1", [
        "dentro dos limites histológicos da normalidade.",
        "não representada na amostra."
    ])

    ; =========================
    ; PRÉVIA
    ; =========================
    g.AddText("xm y+16", "Prévia")
    edtPrev := g.AddEdit("xm w820 r14 ReadOnly -Wrap")

    ; =========================
    ; BOTÕES
    ; =========================
    btnInsert := g.AddButton("xm y+12 w120 Default", "Inserir")
    btnCopy   := g.AddButton("x+10 w120", "Copiar")
    btnCancel := g.AddButton("x+10 w120", "Cancelar")

    ; =========================================================
    ; STATIC refs (evita #Warn + resolve escopo)
    ; =========================================================
    static s_prevWin := 0, s_g := 0, s_edtPrev := 0, s_ddlHip := 0
    s_prevWin := prevWin
    s_g := g
    s_edtPrev := edtPrev
    s_ddlHip := ddlHip

    ; =========================
    ; FUNÇÕES INTERNAS
    ; =========================
    Build() {
        return (
            "DESCRIÇÃO MICROSCÓPICA:`n"
            ". Epiderme exibindo ortoqueratose, camada granulosa preservada, sem acantose, nem espongiose ou exocitose de células inflamatórias. Não há degeneração hidrópica de camada basal (alteração vacuolar de interface) e a pigmentação dos queratinócitos basais encontra-se preservada, sem alteração da quantidade e do aspecto dos melanócitos.`n"
            ". Derme papilar e reticular superficial sem infiltrado inflamatório, dentro dos limites histológicos da normalidade.`n"
            ". Derme reticular profunda dentro dos limites histológicos da normalidade.`n"
            ". Hipoderme " s_ddlHip.Text "`n"
            ". Ausência de neoplasia no espécime.`n"
            "DIAGNÓSTICO MORFOLÓGICO:`n"
            "Pele dentro dos limites histológicos da normalidade."
        )
    }

    UpdatePreview(*) => (s_edtPrev.Value := Build())

    ; =========================
    ; EVENTOS
    ; =========================
    ddlHip.OnEvent("Change", UpdatePreview)

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
