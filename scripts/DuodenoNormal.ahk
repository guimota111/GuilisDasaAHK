; =========================================================
; Máscara — Duodeno Normal (laudo completo)
; =========================================================

Mask_DuodenoNormal() {
    prevWin := WinGetID("A")
    try WinActivate("ahk_id " prevWin)
    try WinWaitActive("ahk_id " prevWin, , 1)
    Send "^b"
    SendText "- Mucosa duodenal de aspecto histológico habitual."
    Send "^b"
    SendText "`n. Mucosa duodenal com vilosidades preservadas sem sinais de hiperplasia das criptas.`n. Ausência de linfocitose intraepitelial significativa.`n. Proporção vilo / cripta preservada.`n. Lâmina própria com discreto infiltrado inflamatório linfoplasmocitário.`n. Ausência de granulomas, eosinofilia ou parasitas.`n. Não foram observados sinais de malignidade nesta amostra."
}
