; scripts\utils.ahk

PasteInto(hwnd, txt) {
    try WinActivate("ahk_id " hwnd)
    try WinWaitActive("ahk_id " hwnd, , 1)
    SendText txt
}

InsertText(txt) {
    SendText txt
}

; Envia a linha do H. pylori com o nome em itálico
SendLinhaHP(resultado) {
    SendText "`n. A pesquisa de "
    Send "^i"
    SendText "Helicobacter pylori"
    Send "^i"
    SendText " (Giemsa) resultou " resultado "."
}

AplicarIcone(guiObj, nomeDoIcone := "IconeMascaras.ico") {
    iconPath := A_ScriptDir "\Icones\" nomeDoIcone

    if FileExist(iconPath) {
        hIcon := LoadPicture(iconPath, "Icon1", &type)
        SendMessage(0x80, 0, hIcon, guiObj.Hwnd) ; Ícone pequeno
        SendMessage(0x80, 1, hIcon, guiObj.Hwnd) ; Ícone grande
    }
}
