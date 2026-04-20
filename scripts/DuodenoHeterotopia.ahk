; =========================================================
; Máscara — Heterotopia de Mucosa Gástrica em Delgado
; =========================================================

Mask_DuodenoHeterotopia() {
    prevWin := WinGetID("A")
    try WinActivate("ahk_id " prevWin)
    try WinWaitActive("ahk_id " prevWin, , 1)

    Send "^b"
    SendText "- Heterotopia de mucosa gástrica em delgado."
    Send "^b"
    SendText "`n. Tecido gástrico composto por glândulas fúndicas, recobertas por epitélio foveolar, sem atipia.`n. Na lâmina própria, leve edema e infiltrado mononuclear moderado com agregado linfoide.`n. Ausência de evidências de malignidade na presente amostra."
}
