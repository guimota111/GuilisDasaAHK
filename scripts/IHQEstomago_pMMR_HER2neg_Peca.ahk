; =========================================================
; Máscara — IHQ Estômago: pMMR + HER2 negativo (Peça Radical)
; =========================================================

Mask_IHQEstomago_pMMR_HER2neg_Peca() {
    prevWin := WinGetID("A")
    try WinActivate("ahk_id " prevWin)
    try WinWaitActive("ahk_id " prevWin, , 1)

    interpretacao := "Interpretação: Este resultado indica proficiência do sistema de reparo de mal pareamento do DNA (pMMR), o que indica que o tumor tem baixíssima probabilidade de ter instabilidade de microssatélites. A probabilidade deste paciente ser portador de síndrome de Lynch é pequena, entretanto não é possível excluir a possibilidade de o paciente apresentar neoplasia decorrente da alteração em outros genes não envolvidos no sistema de reparo dos erros do pareamento do DNA."

    nota := "Nota: Pacientes com história pessoal e/ou familiar de câncer podem se beneficiar de aconselhamento genético para melhor interpretação do resultado."

    refs := "Referências Bibliográficas: 1) Boland, RC. and Goel A. (2010). Microsatellite instability in colorectal cancer. Gastroenterology. 138(6): 2073-2087. 2) WHO Classification of Tumours Editorial Board. Digestive system tumours. Lyon (France): International Agency for Research on Cancer; 2019. (WHO classification of tumours series, 5th ed.; vol. 1)."

    Send "^b"
    SendText "- Adenocarcinoma com expressão mantida das enzimas que compõem o sistema de correção de erros de mal pareamento do DNA."
    Send "^b"
    SendText "`n`n"
    Send "^b"
    SendText "- HER2 negativo."
    Send "^b"
    SendText "`n`n" interpretacao "`n`n" nota "`n`n" refs
}
