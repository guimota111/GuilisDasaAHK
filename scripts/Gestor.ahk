#Requires AutoHotkey v2.0
#SingleInstance Force

; --- Configurações Globais ---
global ARQUIVO_DADOS := A_ScriptDir "\casos_patologia.json"
global LISTA_CASOS := [] 
global lv, edtCaso, selStatus, edtObs, dtVenc, g, edtBusca, selResidente
global btnAbrir, btnRemover 

global LISTA_RESIDENTES := ["ALANNE LINO", "DAVID", "GUILHERME", "HENRIQUE", "IHQ", "JULIANA", "LIANA BARROS", "LUANA QUEIROGA", "LUCAS R2", "LUCAS R3", "RAFAEL", "RENATO"]


CriarInterfaceCasos() {
    global lv, edtCaso, selStatus, edtObs, dtVenc, g, edtBusca, selResidente, btnAbrir, btnRemover
    
    g := Gui("+AlwaysOnTop +Resize", "Central de Casos Patologia - Gui")
    g.SetFont("s10", "Segoe UI")
    
    ; --- Área de Entrada (Fixa) ---
    g.AddGroupBox("xm w650 h150", "Novo Laudo")
    g.AddText("xp+15 yp+30", "Residente Responsável:")
    selResidente := g.AddDropDownList("x+5 w200 Choose1", LISTA_RESIDENTES)
    g.AddText("x+20", "Nº Caso:")
    edtCaso := g.AddEdit("x+5 w100", "")
    g.AddText("xm+15 y+15", "Vencimento:")
    dtVenc := g.AddDateTime("x+5 w110", "ShortDate")
    g.AddText("x+15", "Status:")
    selStatus := g.AddDropDownList("x+5 w140 Choose1", ["Laudar", "Checar", "Coloração Especial", "Recorte", "Second Look", "Digitar", "Aguarda IHQ", "Liberado"])
    g.AddText("xm+15 y+15", "Obs:")
    edtObs := g.AddEdit("x+5 w350", "")
    g.AddButton("x+20 w100 h30 Default", "Adicionar").OnEvent("Click", AdicionarCaso)

    g.AddText("xm y+25", "🔍 Filtrar casos:")
    edtBusca := g.AddEdit("x+10 w300", "")
    edtBusca.OnEvent("Change", (*) => FiltrarTabela())

    ; --- Tabela ---
    lv := g.AddListView("xm y+10 r20 w1200 +Grid -Multi", ["Residente", "Nº Caso", "Status", "Vencimento", "Observações"])
    lv.ModifyCol(1, 150), lv.ModifyCol(2, 120), lv.ModifyCol(3, 150), lv.ModifyCol(4, 120), lv.ModifyCol(5, 500)
    
    lv.OnEvent("DoubleClick", AbrirSelecionado)
    lv.OnEvent("ContextMenu", MostrarMenuStatus)

    ; --- Botões de Ação ---
    btnAbrir := g.AddButton("xm y+10 w180 h40", "🌐 Abrir no SharePoint")
    btnAbrir.SetFont("bold")
    btnAbrir.OnEvent("Click", AbrirSelecionado)
    
    btnRemover := g.AddButton("x+10 yp w120 h40", "Excluir Registro")
    btnRemover.OnEvent("Click", RemoverCaso)

    g.OnEvent("Size", AjustarElementos)

    CarregarDados()
    g.Show("Maximize")
}

; --- Função de Ajuste Dinâmico ---
AjustarElementos(guiObj, windowMinMax, width, height) {
    if (windowMinMax = -1) {
        return
    }
    
    lvHeight := height - 320
    lv.Move(,, width - 40, lvHeight)
    
    lv.GetPos(&lvX, &lvY, &lvW, &lvH)
    btnY := lvY + lvH + 10
    
    btnAbrir.Move(, btnY)
    btnRemover.Move(, btnY)
}

; --- Funções de Lógica ---

AdicionarCaso(*) {
    if (edtCaso.Value = "") {
        return
    }
    dataStr := FormatTime(dtVenc.Value, "dd/MM/yyyy")
    LISTA_CASOS.Push({res: selResidente.Text, caso: edtCaso.Value, status: selStatus.Text, obs: edtObs.Value, venc: dataStr})
    SalvarDados()
    FiltrarTabela()
    edtCaso.Value := "", edtObs.Value := "", edtCaso.Focus()
}

FiltrarTabela(*) {
    termo := StrLower(edtBusca.Value)
    lv.Delete()
    for item in LISTA_CASOS {
        if (termo = "" || InStr(StrLower(item.res), termo) || InStr(StrLower(item.caso), termo) || InStr(StrLower(item.status), termo)) {
            lv.Add(, item.res, item.caso, item.status, item.venc, item.obs)
        }
    }
}

RemoverCaso(*) {
    linha := lv.GetNext()
    if (linha = 0) {
        return
    }
    textoCaso := lv.GetText(linha, 2)
    for i, item in LISTA_CASOS {
        if (item.caso = textoCaso) {
            LISTA_CASOS.RemoveAt(i)
            break
        }
    }
    SalvarDados()
    FiltrarTabela()
}

MostrarMenuStatus(lv, itemIndex, *) {
    if (itemIndex = 0) {
        return
    }
    m := Menu()
    opcoes := ["Laudar", "Checar", "Coloração Especial", "Recorte", "Second Look", "Digitar", "Aguarda IHQ", "Liberado"]
    for status in opcoes {
        m.Add(status, (statusEscolhido, *) => AlterarStatus(statusEscolhido, itemIndex))
    }
    m.Show()
}

AlterarStatus(novoStatus, linha) {
    numCaso := lv.GetText(linha, 2)
    for item in LISTA_CASOS {
        if (item.caso = numCaso) {
            item.status := novoStatus
            break
        }
    }
    lv.Modify(linha, "Col3", novoStatus)
    SalvarDados()
}

SalvarDados() {
    textoJson := "["
    for item in LISTA_CASOS {
        textoJson .= "`n  {`n    `"residente`": `"" item.res "`",`n    `"caso`": `"" item.caso "`",`n    `"status`": `"" item.status "`",`n    `"obs`": `"" item.obs "`",`n    `"venc`": `"" item.venc "`"`n  },"
    }
    textoJson := RTrim(textoJson, ",") 
    if (LISTA_CASOS.Length > 0) {
        textoJson .= "`n]"
    } else {
        textoJson := "[]"
    }
    
    try {
        f := FileOpen(ARQUIVO_DADOS, "w", "UTF-8")
        f.Write(textoJson)
        f.Close()
    }
}

CarregarDados() {
    if !FileExist(ARQUIVO_DADOS) {
        return
    }
    conteudo := FileRead(ARQUIVO_DADOS, "UTF-8")
    global LISTA_CASOS := []
    pos := 1
    while RegExMatch(conteudo, 's)\{(.*?)\}', &objeto, pos) {
        LISTA_CASOS.Push({res: ExtrairCampo(objeto[1], "residente"), caso: ExtrairCampo(objeto[1], "caso"), status: ExtrairCampo(objeto[1], "status"), obs: ExtrairCampo(objeto[1], "obs"), venc: ExtrairCampo(objeto[1], "venc")})
        pos := objeto.Pos + objeto.Len
    }
    FiltrarTabela()
}

ExtrairCampo(bloco, campo) {
    if RegExMatch(bloco, '"' . campo . '":\s*"(.*?)"', &match) {
        return match[1]
    }
    return ""
}

AbrirSelecionado(*) {
    linha := lv.GetNext()
    if (linha != 0) {
        AbrirNoSharePoint(A_Year, lv.GetText(linha, 1), lv.GetText(linha, 2))
    }
}

AbrirNoSharePoint(ano, res, caso) {
    if !RegExMatch(caso, "i)\.docx$") {
        caso .= ".docx"
    }
    Run "https://ebserhnet.sharepoint.com/:w:/r/sites/ULAPHUOLEBSERH/Documentos%20Partilhados/LAUDOS/LAUDOS%20-%20DIGITA%C3%87%C3%83O/" ano "/" _UrlEncode(res) "/" _UrlEncode(caso) "?web=1"
}

_UrlEncode(str) {
    str := StrReplace(str, " ", "%20")
    str := StrReplace(str, "á", "%C3%A1"), str := StrReplace(str, "é", "%C3%A9"), str := StrReplace(str, "í", "%C3%AD"), str := StrReplace(str, "ó", "%C3%B3"), str := StrReplace(str, "ú", "%C3%BA"), str := StrReplace(str, "ç", "%C3%A7")
    return str
}