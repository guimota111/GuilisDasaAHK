; =========================================================
; Tuba uterina — Achados simples (sem GUI)
; Arquivo: scripts\TubaUterina.ahk
; Funções chamadas no menu
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Tuba_Normal() {
    PasteSimple("Fragmentos de tuba uterina dentro dos limites histológicos da normalidade")
}

Tuba_Hidatide_Singular() {
    PasteSimple("Hidátide de Morgagni")
}

Tuba_Hidatide_Plural() {
    PasteSimple("Hidátides de Morgagni")
}

Tuba_Cistoadenoma_Seroso() {
    PasteSimple("Cistoadenoma seroso")
}

Tuba_Hematossalpinge() {
    PasteSimple("Hematossalpinge")
}

Tuba_Hidrossalpinge() {
    PasteSimple("Hidrossalpinge")
}

Tuba_salpingite_Aguda() {
    PasteSimple("Salpingite aguda")
}

; ---------------------------------------------------------
; Helper padrão do GUILIS (sem GUI)
; ---------------------------------------------------------
PasteSimple(txt) {
    prevWin := WinGetID("A")
    PasteInto(prevWin, txt)
}
