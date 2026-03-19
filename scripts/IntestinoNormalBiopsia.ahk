; =========================================================
; Intestino — Biópsia — Normal (sem GUI)
; Arquivo: scripts\IntestinoNormalBiopsia.ahk
; Funções: Mask_IleoBiopsiaNormal(), Mask_ColonBiopsiaNormal(), Mask_RetoBiopsiaNormal()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_IleoBiopsiaNormal() {
    prevWin := WinGetID("A")
    PasteInto(prevWin, "Fragmentos de mucosa ileal dentro dos limites histológicos da normalidade")
}

Mask_ColonBiopsiaNormal() {
    prevWin := WinGetID("A")
    PasteInto(prevWin, "Fragmentos de mucosa colônica dentro dos limites histológicos da normalidade")
}

Mask_RetoBiopsiaNormal() {
    prevWin := WinGetID("A")
    PasteInto(prevWin, "Fragmentos de mucosa retal dentro dos limites histológicos da normalidade")
}
