; scripts\utils.ahk

PasteInto(hwnd, txt) {
    try WinActivate("ahk_id " hwnd)
    try WinWaitActive("ahk_id " hwnd, , 1)

    old := A_Clipboard
    A_Clipboard := txt
    ClipWait 0.5
    Send "^v"
    Sleep 50
    A_Clipboard := old
}

InsertText(txt) {
    old := A_Clipboard
    A_Clipboard := txt
    ClipWait 1
    Send "^v"
    Sleep 300
    A_Clipboard := old
}

AplicarIcone(guiObj, nomeDoIcone := "IconeMascaras.ico") {
    iconPath := A_ScriptDir "\Icones\" nomeDoIcone

    if FileExist(iconPath) {
        hIcon := LoadPicture(iconPath, "Icon1", &type)
        SendMessage(0x80, 0, hIcon, guiObj.Hwnd) ; Ícone pequeno
        SendMessage(0x80, 1, hIcon, guiObj.Hwnd) ; Ícone grande
    }
}