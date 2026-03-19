; =========================================================
; CARIMBOS — Sistema Dinâmico
; Dados armazenados em scripts\carimbos_data.ini (UTF-8)
; =========================================================

; ---------------------------------------------------------------------------
; Funções INI com suporte a UTF-8
; (IniRead/IniWrite nativo usa API Windows que não suporta UTF-8 sem BOM,
;  corrompendo caracteres acentuados como ã, é, ç, etc.)
; ---------------------------------------------------------------------------

_IniSectionsUTF8(file) {
    if !FileExist(file)
        return ""
    content := FileRead(file, "UTF-8")
    out := ""
    pos := 1
    while RegExMatch(content, "m)^\[([^\]]+)\]", &m, pos) {
        out .= (out = "" ? "" : "`n") m[1]
        pos := m.Pos + m.Len
    }
    return out
}

_IniReadUTF8(file, section, key, default := "") {
    if !FileExist(file)
        return default
    content := FileRead(file, "UTF-8")
    if !RegExMatch(content, "m)^\[" section "\]", &sec)
        return default
    nextSecPos := RegExMatch(content, "m)^\[", &dummy, sec.Pos + sec.Len)
        ? dummy.Pos
        : StrLen(content) + 1
    block := SubStr(content, sec.Pos + sec.Len, nextSecPos - sec.Pos - sec.Len)
    if !RegExMatch(block, "m)^" key "=(.*)$", &kv)
        return default
    return kv[1]
}

_IniWriteUTF8(value, file, section, key) {
    content := FileExist(file) ? FileRead(file, "UTF-8") : ""
    if RegExMatch(content, "m)^\[" section "\]", &sec) {
        nextSecPos := RegExMatch(content, "m)^\[", &dummy, sec.Pos + sec.Len)
            ? dummy.Pos
            : StrLen(content) + 1
        block := SubStr(content, sec.Pos + sec.Len, nextSecPos - sec.Pos - sec.Len)
        if RegExMatch(block, "m)^" key "=.*", &kv) {
            ; Substitui a linha da chave existente
            block := SubStr(block, 1, kv.Pos - 1) . key "=" value . SubStr(block, kv.Pos + kv.Len)
        } else {
            ; Adiciona a chave ao fim do bloco da seção
            block := RTrim(block, "`r`n") . "`n" . key "=" value . "`n"
        }
        beforeBlock := SubStr(content, 1, sec.Pos + sec.Len - 1)
        afterBlock  := SubStr(content, nextSecPos)
        content := beforeBlock . block . afterBlock
    } else {
        ; Seção não existe — adiciona ao final do arquivo
        if (content != "" && SubStr(content, -1) != "`n")
            content .= "`n"
        content .= "[" section "]`n" . key "=" value . "`n"
    }
    if FileExist(file)
        FileDelete(file)
    FileAppend(content, file, "UTF-8")
}

_IniDeleteUTF8(file, section) {
    if !FileExist(file)
        return
    content := FileRead(file, "UTF-8")
    if !RegExMatch(content, "m)^\[" section "\]", &sec)
        return
    nextSecPos := RegExMatch(content, "m)^\[", &dummy, sec.Pos + sec.Len)
        ? dummy.Pos
        : StrLen(content) + 1
    content := SubStr(content, 1, sec.Pos - 1) . SubStr(content, nextSecPos)
    content := LTrim(content, "`r`n")
    if FileExist(file)
        FileDelete(file)
    if (Trim(content, "`r`n") != "")
        FileAppend(content, file, "UTF-8")
}

; ---------------------------------------------------------------------------
; Chamado no início do programa para popular menus e registrar hotstrings
; ---------------------------------------------------------------------------
InicializarCarimbos(menuRes, menuStaff) {
    arquivo := A_ScriptDir "\scripts\carimbos_data.ini"
    if !FileExist(arquivo)
        return

    secoes := _IniSectionsUTF8(arquivo)
    nRes := 1, nStaff := 1

    for hotstr in StrSplit(secoes, "`n") {
        hotstr := Trim(hotstr)
        if (hotstr == "")
            continue

        nome  := _IniReadUTF8(arquivo, hotstr, "nome",  "?")
        cat   := _IniReadUTF8(arquivo, hotstr, "cat",   "Staff")
        texto := StrReplace(_IniReadUTF8(arquivo, hotstr, "texto", ""), "|", "`n")

        fn := _CarimboMakeFn(texto)

        if (cat == "Residente") {
            menuRes.Add("&" nRes " " nome, fn)
            nRes++
        } else {
            menuStaff.Add("&" nStaff " " nome, fn)
            nStaff++
        }

        Hotstring(":*:" hotstr, fn)
    }
}

; Fábrica de closure — evita problema de captura de variável em loop
_CarimboMakeFn(texto) {
    return (*) => InserirCarimboTexto(texto)
}

InserirCarimboTexto(texto) {
    oldClip := A_Clipboard
    A_Clipboard := texto
    ClipWait(1)
    Send("^v")
    SetTimer(() => (A_Clipboard := oldClip), -1000)
}

; =========================================================
; GUI — Adicionar Novo Carimbo
; =========================================================
GuiNovoCarimbo() {
    global _GuiNovoCarimbo
    _GuiNovoCarimbo := Gui(, "Adicionar Novo Carimbo")
    g := _GuiNovoCarimbo
    g.MarginX := 16, g.MarginY := 14
    g.SetFont("s11", "Segoe UI")

    g.SetFont("s13 Bold", "Segoe UI")
    g.Add("Text", "w400", "Novo Carimbo")

    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "w400 y+12", "Nome de exibição no menu  (ex: João):")
    edtNome := g.Add("Edit", "w400 vNome")

    g.Add("Text", "w400 y+10", "Hotstring — gatilho de texto  (ex: cjoao):")
    edtHot  := g.Add("Edit", "w400 vHotstring")

    g.Add("Text", "w400 y+10", "Categoria:")
    ddlCat  := g.Add("DropDownList", "w200 Choose1", ["Residente", "Staff"])

    g.Add("Text", "w400 y+12", "Nome completo  (ex: Dr. João da Silva):")
    edtL1   := g.Add("Edit", "w400")

    g.Add("Text", "w400 y+10", "Cargo  (ex: Residente de Patologia):")
    edtL2   := g.Add("Edit", "w400")

    g.Add("Text", "w400 y+10", "CRM  (ex: CRM-RN 99999 / RQE 1234)")
    edtL3   := g.Add("Edit", "w400")

    g.SetFont("s10 Bold", "Segoe UI")
    g.Add("Button", "w400 y+14 Default", "Salvar Carimbo").OnEvent("Click",
        (*) => _CarimboSalvar(g, edtNome, edtHot, ddlCat, edtL1, edtL2, edtL3))

    g.Show("w432 h500")
}

_CarimboSalvar(g, edtNome, edtHot, ddlCat, edtL1, edtL2, edtL3) {
    nome   := Trim(edtNome.Value)
    hotstr := Trim(edtHot.Value)
    cat    := ddlCat.Text
    l1     := Trim(edtL1.Value)
    l2     := Trim(edtL2.Value)
    l3     := Trim(edtL3.Value)

    if (nome == "" || hotstr == "" || l1 == "" || l2 == "") {
        MsgBox("Preencha ao menos: nome de exibição, hotstring, nome completo e cargo.")
        return
    }
    if !RegExMatch(hotstr, "^[a-zA-Z0-9_]+$") {
        MsgBox("O hotstring deve conter apenas letras, números e underscore (_).")
        return
    }

    arquivo := A_ScriptDir "\scripts\carimbos_data.ini"

    ; Verifica duplicata
    if (_IniReadUTF8(arquivo, hotstr, "nome", "") != "") {
        MsgBox("Já existe um carimbo com o hotstring '" hotstr "'. Escolha outro.")
        return
    }

    ; Monta texto com separador |
    texto := l1 "|" l2
    if (l3 != "")
        texto .= "|" l3

    _IniWriteUTF8(nome,  arquivo, hotstr, "nome")
    _IniWriteUTF8(cat,   arquivo, hotstr, "cat")
    _IniWriteUTF8(texto, arquivo, hotstr, "texto")

    MsgBox("Carimbo '" nome "' salvo com sucesso!`n`nPressione F5 para recarregar.", "Sucesso!")
    g.Destroy()
}

; =========================================================
; GUI — Gerenciar Carimbos (ver / deletar)
; =========================================================
GuiVerCarimbos() {
    global _GuiVerCarimbos
    _GuiVerCarimbos := Gui(, "Gerenciar Carimbos")
    g := _GuiVerCarimbos
    g.MarginX := 16, g.MarginY := 14
    g.SetFont("s11", "Segoe UI")

    g.SetFont("s13 Bold", "Segoe UI")
    g.Add("Text", "w600", "Gerenciar Carimbos")

    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "w600 y+6", "Selecione um carimbo na lista e clique em Deletar.")

    LV := g.Add("ListView", "w600 h300 y+8 -Multi", ["Nome", "Hotstring", "Categoria", "Texto"])
    LV.ModifyCol(1, 90)
    LV.ModifyCol(2, 90)
    LV.ModifyCol(3, 90)
    LV.ModifyCol(4, 310)

    arquivo := A_ScriptDir "\scripts\carimbos_data.ini"
    _CarimboCarregarLV(LV, arquivo)

    g.SetFont("s10 Bold", "Segoe UI")
    g.Add("Button", "w200 y+12", "Deletar Selecionado").OnEvent("Click",
        (*) => _CarimboDeletar(LV, arquivo))
    g.SetFont("s10", "Segoe UI")
    g.Add("Button", "x+10 w130", "Adicionar Novo").OnEvent("Click", (*) => GuiNovoCarimbo())
    g.Add("Button", "x+10 w100", "Fechar").OnEvent("Click", (*) => g.Destroy())

    g.Show("w632 h430")
}

_CarimboCarregarLV(LV, arquivo) {
    LV.Delete()
    if !FileExist(arquivo)
        return
    secoes := _IniSectionsUTF8(arquivo)
    for hotstr in StrSplit(secoes, "`n") {
        hotstr := Trim(hotstr)
        if (hotstr == "")
            continue
        nome  := _IniReadUTF8(arquivo, hotstr, "nome",  "?")
        cat   := _IniReadUTF8(arquivo, hotstr, "cat",   "?")
        texto := StrReplace(_IniReadUTF8(arquivo, hotstr, "texto", ""), "|", " / ")
        LV.Add(, nome, hotstr, cat, texto)
    }
}

_CarimboDeletar(LV, arquivo) {
    row := LV.GetNext(0)
    if !row {
        MsgBox("Selecione um carimbo na lista antes de deletar.")
        return
    }
    nome   := LV.GetText(row, 1)
    hotstr := LV.GetText(row, 2)
    if MsgBox("Deletar o carimbo '" nome "' (hotstring: " hotstr ")?",
              "Confirmar exclusão", "YesNo Icon?") != "Yes"
        return

    _IniDeleteUTF8(arquivo, hotstr)
    _CarimboCarregarLV(LV, arquivo)
    MsgBox("Carimbo '" nome "' deletado.`n`nPressione F5 para recarregar.", "Sucesso!")
}
