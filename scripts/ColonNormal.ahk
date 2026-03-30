; =========================================================
; Máscara — Cólon Normal
; =========================================================

Mask_ColonNormal() {
    Send "^b"
    SendText "- Mucosa colônica de aspecto histológico habitual."
    Send "^b"
    SendText "`n. Mucosa com arquitetura de criptas preservada e número habitual de células caliciformes.`n. Ausência de criptite.`n. Não foram detectados granulomas, parasitas, espessamento colágeno subepitelial e/ou linfocitose intraepitelial.`n. Não foram observados sinais de malignidade nesta amostra."
}

:*:colonnormal:: {
    Mask_ColonNormal()
}
