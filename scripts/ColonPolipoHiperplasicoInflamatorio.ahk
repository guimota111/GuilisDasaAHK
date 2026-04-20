; =========================================================
; Máscara — Pólipo Hiperplásico/Inflamatório
; =========================================================

Mask_ColonPolipoHiperplasicoInflamatorio() {
    prevWin := WinGetID("A")
    try WinActivate("ahk_id " prevWin)
    try WinWaitActive("ahk_id " prevWin, , 1)

    Send "^b"
    SendText "- Pólipo hiperplásico/inflamatório."
    Send "^b"
    SendText "`n. Mucosa retal apresentando criptas revestidas por epitélio cilíndrico do tipo intestinal sem atipias, algumas com dilatação cística.`n. Na lâmina própria, há acentuação do infiltrado inflamatório misto, edema e proliferação de vasos. Há focos de erosão com formação de tecido de granulação.`n. Ausência de evidências de malignidade."
}
