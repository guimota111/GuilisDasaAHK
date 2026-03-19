; =========================================================
; Pele — Lúpus (texto fixo, sem GUI)
; Arquivo: scripts\PeleLupus.ahk
; Função chamada no menu: Mask_PeleLupus()
; Requer: PasteInto(hwnd, txt) em scripts\utils.ahk
; =========================================================

Mask_PeleLupus() {
    prevWin := WinGetID("A")

    txt :=
    (
    "Pele exibindo epiderme com áreas de atrofia, hipergranulose, hiperqueratose com presença de plugs de queratina ocluindo óstios foliculares, extensa área de vacuolização da camada basal, epidermotropismo de linfócitos com necrose de queratinócitos isolados. Há espessamento da membrana basal evidenciado pelas colorações especiais de PAS e Alcian Blue.`n"
    "Na derme, observa-se intensa elastose solar, melanófagos na derme papilar superficial, ectasia de pequenos capilares, infiltrado inflamatório leve perivascular e perianexial constituído por pequenos linfócitos.`n"
    "NOTA:`n"
    "Os aspectos histológicos observados na amostra, podem ser encontrados em quadros de Lupus Eritematoso. Correlacionar com aspectos clínicos e exames laboratoriais para diagnóstico definitivo."
    )

    PasteInto(prevWin, txt)
}
