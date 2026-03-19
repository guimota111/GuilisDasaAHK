; =========================================================
; Rim — Exclusão (sem GUI)
; Arquivo: scripts\RimExclusao.ahk
; Função chamada no menu: Mask_RimExclusao()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_RimExclusao() {
    prevWin := WinGetID("A")

    txt :=
    (
    "Rim exibindo:`n"
    ". Esclerose glomerular`n"
    ". Atrofia tubular`n"
    ". Processo inflamatório crônico"
    )

    PasteInto(prevWin, txt)
}
