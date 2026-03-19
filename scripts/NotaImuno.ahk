; =========================================================
; Notas Padronizadas — Sugestão de Imuno-histoquímica (V2)
; Arquivo: scripts\NotaImuno.ahk
; =========================================================

Mask_NotaImuno() {
    prevWin := WinGetID("A")
    g := Gui("+AlwaysOnTop", "Nota — Sugestão de Imuno-histoquímica")
    g.SetFont("s9", "Segoe UI")
    g.MarginX := 20, g.MarginY := 20

    ; --- 1. CONTROLE DE HIPÓTESE ---
    chkHip := g.AddCheckbox("w600 Checked +Tabstop", "Incluir hipótese diagnóstica morfológica")
    edtHip := g.AddEdit("y+5 w570 +Tabstop", "[hipótese]")

    ; --- 2. STATUS E FINALIDADE ---
    g.AddGroupBox("xm y+20 w600 h110", "Status e Objetivo do Estudo")

    g.AddText("xp+15 yp+30 w100", "Status:")
    ddlStatus := g.AddDropDownList("x130 yp-3 w180 Choose2 +Tabstop", ["Em andamento", "É necessária a realização de"])

    g.AddText("x35 y+35 w100", "Finalidade:")
    ddlFinalidade := g.AddDropDownList("x130 yp-3 w440 Choose1 +Tabstop", [
        "definição diagnóstica",
        "subclassificação e/ou pesquisa do sítio primário da neoplasia",
        "pesquisa do sítio primário da neoplasia",
        "pesquisa de fatores prognósticos e preditivos da neoplasia",
        "pesquisa da expressão de proteínas dos genes de reparo do DNA",
        "exclusão definitiva de malignidade",
        "confirmação diagnóstica e/ou subclassificação da neoplasia",
        "exclusão definitiva de lesão invasiva",
        "pesquisa de associação com infecção por HPV"])

    ; --- PRÉVIA E BOTÕES ---
    g.AddText("xm y+35", "Texto da Nota (Negrito simulado na inserção):")
    edtPrev := g.AddEdit("xm w600 r6 ReadOnly -Wrap")

    btnIns := g.AddButton("xm y+20 w120 Default +Tabstop", "Inserir")
    btnCopy := g.AddButton("x+10 yp w120 +Tabstop", "Copiar")
    g.AddButton("x+10 yp w120", "Cancelar").OnEvent("Click", (*) => g.Destroy())

    ; --- LÓGICA ---
    AtualizarInterface(*) {
        edtHip.Enabled := chkHip.Value
        UpdatePreview()
    }

    UpdatePreview(*) => edtPrev.Value := Build(false) ; Preview sem os códigos de negrito

    chkHip.OnEvent("Click", AtualizarInterface)
    edtHip.OnEvent("Change", UpdatePreview)
    ddlStatus.OnEvent("Change", UpdatePreview)
    ddlFinalidade.OnEvent("Change", UpdatePreview)

    ; AQUI ESTÁ O SEGREDO: Na hora de inserir, chamamos uma função especial
    btnIns.OnEvent("Click", (*) => InserirComNegrito(prevWin))
    btnCopy.OnEvent("Click", (*) => A_Clipboard := Build(false))

    g.Show()
    edtHip.Focus()
    UpdatePreview()

    ; Função interna para montar o texto
    Build(comFormatacao := false) {
        ; Se o sistema usar Ctrl+B, usamos um marcador temporário para tratar depois
        prefixo := comFormatacao ? "{B_ON}Nota:{B_OFF} " : "Nota: "
        res := prefixo

        if (chkHip.Value) {
            hip := edtHip.Value || "[hipótese]"
            res .= "Os achados morfológicos podem corresponder ao diagnóstico de " hip ". "
        }
        res .= ddlStatus.Text " estudo imuno-histoquímico para " ddlFinalidade.Text "."
        return res
    }

    ; Função para processar o negrito e colar no sistema
    InserirComNegrito(idJanela) {
        WinActivate("ahk_id " idJanela)
        if !WinWaitActive("ahk_id " idJanela, , 2)
            return

        ; Envia o prefixo com comandos de negrito
        Send("^b") ; Ativa Negrito
        Send("Nota:")
        Send("^b") ; Desativa Negrito
        Send("{Space}")

        ; Envia o restante do texto (que não é negrito)
        ; Pegamos apenas a parte do texto sem o "Nota: " inicial
        textoRestante := Build(false)
        textoRestante := StrReplace(textoRestante, "Nota: ", "")

        A_Clipboard := textoRestante
        Send("^v") ; Cola o resto
        g.Destroy()
    }
}