; =========================================================
; Máscara — IHQ Estômago: pMMR + HER2 negativo (Biópsia)
; =========================================================

Mask_IHQEstomago_pMMR_HER2neg() {
    prevWin := WinGetID("A")
    try WinActivate("ahk_id " prevWin)
    try WinWaitActive("ahk_id " prevWin, , 1)

    nota1 := "Nota 1: Este resultado indica proficiência do sistema de reparo de mal pareamento do DNA (pMMR), o que indica que o tumor tem baixíssima probabilidade de ter instabilidade de microssatélites. A probabilidade deste paciente ser portador de síndrome de Lynch é pequena, entretanto não é possível excluir a possibilidade de o paciente apresentar neoplasia decorrente da alteração em outros genes não envolvidos no sistema de reparo dos erros do pareamento do DNA. Pacientes com história pessoal e/ou familiar de câncer podem se beneficiar de aconselhamento genético para melhor interpretação do resultado."

    nota2 := "Nota 2: Expressão imuno-histoquímica da proteína HER2 (C-erb-B2) pelo Colégio Americano de Patologistas (CAP) é considerada:`n. Positiva (escore 3 +): marcação de forte intensidade, circunferencial completa, basolateral ou lateral de membrana em qualquer percentual de células neoplásicas.`n. Duvidosa (escore 2 +): marcação de fraca a moderada intensidade, circunferencial completa, basolateral ou lateral de membrana em qualquer percentual de células neoplásicas.`n. Negativa (escore 1+): marcação de intensidade tênue / vagamente perceptível, em qualquer percentual de células neoplásicas.`n. Negativa (escore 0): ausência de marcação ou ausência de marcação na membrana em qualquer célula neoplásica."

    refs := "Referências Bibliográficas: 1) Boland, RC. and Goel A. (2010). Microsatellite instability in colorectal cancer. Gastroenterology. 138(6): 2073-2087. 2) WHO Classification of Tumours Editorial Board. Digestive system tumours. Lyon (France): International Agency for Research on Cancer; 2019. (WHO classification of tumours series, 5th ed.; vol. 1)."

    Send "^b"
    SendText "- Adenocarcinoma com expressão mantida das enzimas que compõem o sistema de correção de erros de mal pareamento do DNA.`n- HER2 negativo."
    Send "^b"
    SendText "`n`n" nota1 "`n`n" nota2 "`n`n" refs
}
