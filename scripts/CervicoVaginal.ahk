#Requires AutoHotkey v2.0
#SingleInstance Force

; Exemplo de como chamar a função (Pressione F12 para abrir)
F12::Mask_CervicoVaginal()

Mask_CervicoVaginal() {
    ; Salva o ID da janela que estava ativa antes de abrir a GUI
    JanelaAnterior := WinExist("A")
    
    MyGui := Gui("+AlwaysOnTop", "GUILIS — Citologia Cérvico-Vaginal")
    MyGui.SetFont("s10", "Segoe UI")

    ; --- 1. ADEQUABILIDADE ---
    MyGui.Add("GroupBox", "w450 h80", "1. Adequabilidade do Material")
    selAdeq := MyGui.Add("DropDownList", "xp+10 yp+25 w430 Choose1", [
        "Satisfatória", 
        "Insatisfatória: material acelular ou hipocelular", 
        "Insatisfatória: sangue em mais de 75%", 
        "Insatisfatória: piócitos em mais de 75%", 
        "Insatisfatória: artefatos de dessecamento", 
        "Insatisfatória: contaminantes externos", 
        "Insatisfatória: intensa superposição celular", 
        "Insatisfatória: outros"
    ])
    txtAdeqOutros := MyGui.Add("Edit", "xp yp+30 w430 Hidden", "")
    selAdeq.OnEvent("Change", (*) => txtAdeqOutros.Visible := (selAdeq.Value = 8))

    ; --- 2. EPITÉLIOS ---
    MyGui.Add("GroupBox", "xp-10 yp+45 w450 h50", "2. Epitélios Representados")
    cbEscam := MyGui.Add("Checkbox", "xp+10 yp+20 Checked", "Escamoso")
    cbGland := MyGui.Add("Checkbox", "x+20 yp Checked", "Glandular")
    cbMeta  := MyGui.Add("Checkbox", "x+20 yp Checked", "Metaplásico")

    ; --- 3. DIAGNÓSTICO DESCRITIVO ---
    MyGui.Add("GroupBox", "x10 yp+40 w450 h210", "3. Diagnóstico Descritivo")
    MyGui.SetFont("s8 Bold")
    MyGui.Add("Text", "xp+10 yp+20 cTeal", "ALTERAÇÕES BENIGNAS / REATIVAS")
    MyGui.SetFont("s10 Norm")
    cbInflam  := MyGui.Add("Checkbox", "xp yp+20", "Inflamação")
    cbMetaEsc := MyGui.Add("Checkbox", "x+20 yp", "Metaplasia imatura")
    cbRep     := MyGui.Add("Checkbox", "x+20 yp", "Reparação")
    cbAtrofia := MyGui.Add("Checkbox", "x10 yp+25", "Atrofia c/ inflamação")
    cbRad     := MyGui.Add("Checkbox", "x+20 yp", "Radiação")

    MyGui.SetFont("s8 Bold")
    MyGui.Add("Text", "x20 yp+35 cTeal", "MICROBIOLOGIA")
    MyGui.SetFont("s10 Norm")
    cbLacto   := MyGui.Add("Checkbox", "xp yp+20", "Lactobacillus")
    cbVagBact := MyGui.Add("Checkbox", "x+20 yp", "Vaginose")
    cbCocos   := MyGui.Add("Checkbox", "x+20 yp", "Cocos")
    cbTricho  := MyGui.Add("Checkbox", "x20 yp+25", "Trichomonas")
    cbHerpes  := MyGui.Add("Checkbox", "x+20 yp", "Herpes")
    cbChlam   := MyGui.Add("Checkbox", "x+20 yp", "Chlamydia")

    ; --- 4. CONCLUSÃO ---
    MyGui.Add("GroupBox", "x10 yp+45 w450 h60", "4. Conclusão")
    selConc := MyGui.Add("DropDownList", "xp+10 yp+25 w430 Choose1", [
        "Negativo para lesão intraepitelial ou malignidade",
        "ASCUS (Células escamosas atípicas - possivelmente não neoplásicas)",
        "ASC-H (Atipias escamosas, não se afasta alto grau)",
        "LSIL (Lesão de baixo grau: HPV / NIC I)",
        "HSIL (Lesão de alto grau: NIC II / NIC III)",
        "Carcinoma de células escamosas",
        "AGC - SOE (Atipias em células glandulares)",
        "Adenocarcinoma 'in situ'",
        "Adenocarcinoma invasivo"
    ])

    ; --- BOTÃO INSERIR ---
    btnInserir := MyGui.Add("Button", "x10 yp+60 w450 h40 Default", "INSERIR LAUDO")
    btnInserir.OnEvent("Click", (*) => ProcessarEEnviar())

    MyGui.Show()

    ProcessarEEnviar() {
        ; Coleta Adequabilidade
        adeq := selAdeq.Text
        if (selAdeq.Value = 8 && txtAdeqOutros.Value != "")
            adeq := "Insatisfatória: " txtAdeqOutros.Value

        ; Coleta Epitélios
        epitList := []
        if cbEscam.Value ? epitList.Push("Escamoso") : ""
        if cbGland.Value ? epitList.Push("Glandular") : ""
        if cbMeta.Value  ? epitList.Push("Metaplásico") : ""
        
        epitStr := ""
        for i, v in epitList
            epitStr .= (i=1 ? "" : i=epitList.Length ? " e " : ", ") v

        ; Coleta Diagnósticos
        diagnosticos := ""
        
        ; Benignos
        benList := []
        for cb in [cbInflam, cbMetaEsc, cbRep, cbAtrofia, cbRad]
            if cb.Value
                benList.Push(cb.Text)
        
        if benList.Length {
            diagnosticos .= "`nAlterações Celulares Benignas Reativas ou Reparativas:`n"
            for item in benList
                diagnosticos .= "- " item "`n"
        }

        ; Microbiologia
        microList := []
        for cb in [cbLacto, cbVagBact, cbCocos, cbTricho, cbHerpes, cbChlam]
            if cb.Value
                microList.Push(cb.Text)

        if microList.Length {
            diagnosticos .= "`nMicrobiologia:`n"
            for item in microList
                diagnosticos .= "- " item "`n"
        }

        ; Montagem Final
        TextoFinal := "ADEQUABILIDADE DO MATERIAL`n" adeq "`n"
        if (epitStr != "")
            TextoFinal .= "`nEpitélios representados na amostra:`n" epitStr ".`n"
        
        TextoFinal .= "`nDIAGNÓSTICO DESCRITIVO`n" diagnosticos
        TextoFinal .= "`nConclusão:`n" selConc.Text "."

        ; Fecha a GUI antes de digitar
        MyGui.Destroy()
        
        ; Reativa a janela anterior e digita o texto
        if WinExist(JanelaAnterior) {
            WinActivate(JanelaAnterior)
            Sleep(100) ; Pequena pausa para garantir o foco
            
            ; Usa o Clipboard temporariamente para uma "digitação" instantânea e fiel à formatação
            BackupClip := A_Clipboard
            A_Clipboard := TextoFinal
            Send("^v") 
            Sleep(200)
            A_Clipboard := BackupClip
        }
    }
}