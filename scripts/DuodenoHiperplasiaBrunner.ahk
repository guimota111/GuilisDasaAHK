; =========================================================
; Máscara — Hiperplasia de Glândulas de Brunner
; =========================================================

Mask_DuodenoHiperplasiaBrunner() {
    prevWin := WinGetID("A")
    try WinActivate("ahk_id " prevWin)
    try WinWaitActive("ahk_id " prevWin, , 1)

    Send "^b"
    SendText "- Hiperplasia de glândulas de Brunner."
    Send "^b"
    SendText "`n. Mucosa exibe aumento do volume e densidade das glândulas de Brunner, exibindo focos de dilatação cística, mas mantendo organização lobular regular, sem atipia nuclear.`n. Mucosa recobrindo glândulas reativa.`n. Ausência de atrofia vilositária e linfocitose intraepitelial (MARSH-OBERHUBER 0).`n. Ausência de parasitas.`n. Ausência de evidências de malignidade."
}
