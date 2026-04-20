; =========================================================
; Citopatologia — PAAF de Mama
; Arquivo: scripts\PAAFMama.ahk
; =========================================================

Mask_PAAFmama() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Máscara — PAAF de Mama")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CATEGORIA DIAGNÓSTICA ---
    g.AddGroupBox("w600 h80", "Categoria")
    ddlCat := g.AddDropDownList("xp+15 yp+30 w570 Choose1 +Tabstop", [
        "NORMAL / NEGATIVA",
        "LESÃO PAPILÍFERA (Indeterminada)",
        "LEPCA (Suspeita)",
        "RARAS CÉLULAS / ADIPOSO"])

    ; --- 2. SUB-OPÇÕES (DINÂMICAS) ---
    g.AddGroupBox("xm y+25 w600 h120", "Especificações")

    ; Opções para Normal/Negativa
    ddlNormal := g.AddDropDownList("xp+15 yp+30 w570 Choose1 +Tabstop", [
        "Consistente com Fibroadenoma",
        "Consistente com Lesão epitelial benigna proliferativa sem atipia",
        "Consistente com Alterações fibrocísticas mamárias",
        "Consistente com conteúdo de lesão cística benigna",
        "Consistente com Necrose gordurosa"])

    ; Opções para Raras Células
    ddlRaras := g.AddDropDownList("xp yp w570 Choose1 Hidden +Tabstop", [
        "Raros agrupamentos de células ductais típicas",
        "Ausência de células ductais"])
    cbAdiposo := g.AddCheckbox("xp y+15 Hidden +Tabstop", "Presença de tecido adiposo maduro")

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Prévia do Diagnóstico:")
    edtPrev := g.AddEdit("xm w600 r8 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA DE INTERFACE ---
    AtualizarLayout(*) {
        ; Controlar visibilidade conforme categoria
        ddlNormal.Visible := (ddlCat.Value == 1)
        ddlRaras.Visible  := (ddlCat.Value == 4)
        cbAdiposo.Visible := (ddlCat.Value == 4)

        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build()

    ; CORREÇÃO: Checkbox não aceita "Change", apenas "Click"
    ddlCat.OnEvent("Change", AtualizarLayout)
    ddlNormal.OnEvent("Change", AtualizarLayout)
    ddlRaras.OnEvent("Change", AtualizarLayout)
    cbAdiposo.OnEvent("Click", AtualizarLayout)

    btnIns.OnEvent("Click", (*) => (PasteInto(prevWin, Build()), g.Destroy()))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build())

    g.Show()
    ddlCat.Focus()
    AtualizarLayout()

    Build() {
        res := ""
        cat := ddlCat.Value

        if (cat == 1) { ; NORMAL
            res := "Citologia negativa para malignidade.`n"
            res .= ddlNormal.Text "."
        }
        else if (cat == 2) { ; PAPILIFERA
            res := "Citologia indeterminada para malignidade.`n"
            res .= "Consistente com Lesão papilífera.`n"
            res .= "Nota: Sugere-se, a critério clínico, exérese da lesão para avaliação histológica e melhor definição diagnóstica."
        }
        else if (cat == 3) { ; LEPCA
            res := "Citologia suspeita para malignidade.`n"
            res .= "Consistente com Lesão epitelial proliferativa com atipia nuclear (LEPCA).`n"
            res .= "Nota: Sugere-se, a critério clínico, obtenção de amostra para avaliação histológica e melhor definição diagnóstica."
        }
        else if (cat == 4) { ; RARAS CÉLULAS
            res := ddlRaras.Text "."
            if cbAdiposo.Value
                res .= "`nTecido adiposo maduro presente na amostra."
        }
        return res
    }
}