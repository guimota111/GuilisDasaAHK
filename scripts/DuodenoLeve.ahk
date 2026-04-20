; =========================================================
; Máscara — Duodenite Leve
; =========================================================

Mask_DuodenoLeve() {
    prevWin := WinGetID("A")
    try WinActivate("ahk_id " prevWin)
    try WinWaitActive("ahk_id " prevWin, , 1)

    Send "^b"
    SendText "- Duodenite leve com focos de metaplasia foveolar."
    Send "^b"
    SendText "`n. Mucosa apresentando leve edema, congestão vascular e infiltrado inflamatório misto leve.`n. Linfócitos intraepiteliais em contagem não significante.`n. Revestimento epitelial aparece ligeiramente reativo, mantendo organização regular, sem atrofia de vilos.`n. Ausência de granulomas, eosinofilia ou parasitas.`n. Não foram observados sinais de malignidade nesta amostra."
}
