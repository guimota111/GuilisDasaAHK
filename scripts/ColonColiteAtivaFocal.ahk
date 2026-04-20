; =========================================================
; Máscara — Colite Ativa Focal
; =========================================================

Mask_ColonColiteAtivaFocal() {
    prevWin := WinGetID("A")
    try WinActivate("ahk_id " prevWin)
    try WinWaitActive("ahk_id " prevWin, , 1)

    nota := "Nota: estes achados podem ser vistos em colites infecciosas, reação a medicamentos ou em doença inflamatória intestinal. Necessária correlação com dados clínicos e endoscópicos."

    Send "^b"
    SendText "- Colite ativa focal."
    Send "^b"
    SendText "`n. Os cortes histológicos demonstram mucosa colônica com arquitetura de criptas preservada.`n. Epitélio de revestimento com alterações regenerativas.`n. Lâmina própria exibindo infiltrado linfomononuclear com neutrófilos agredindo focalmente as criptas.`n. Não foram detectados granulomas, parasitos, sinais de cronicidade ou malignidade nesta amostra.`n`n" nota
}
