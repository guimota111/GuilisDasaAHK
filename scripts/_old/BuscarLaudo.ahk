; =========================================================
; Buscar Laudo — Abre laudo no SharePoint pelo número do caso
; Arquivo: scripts\BuscarLaudo.ahk
; Formato de URL: /:w:/r/sites/.../LAUDOS - DIGITAÇÃO/{ano}/{residente}/{caso}.docx
; =========================================================

BuscarLaudo() {
    g := Gui("+AlwaysOnTop", "Buscar Laudo — SharePoint")
    g.MarginX := 16
    g.MarginY := 14
    g.SetFont("s10", "Segoe UI")

    g.AddText("xm w380", "Preencha os campos para abrir o laudo no SharePoint:")

    ; Ano
    g.AddText("xm y+14 w90 +0x200 h23", "Ano:")
    edtAno := g.AddEdit("x+8 yp w70", A_Year)

    ; Residente
    g.AddText("xm y+10 w90 +0x200 h23", "Residente:")
    edtRes := g.AddEdit("x+8 yp w280", "")

    ; Caso (sem extensão — .docx é adicionado automaticamente)
    g.AddText("xm y+10 w90 +0x200 h23", "Caso:")
    edtCaso := g.AddEdit("x+8 yp w280", "")

    g.AddText("xm y+6 w380 cGray", "Ex.: 26 - 225   (extensão .docx será adicionada automaticamente)")

    ; Botões
    btnAbrir    := g.AddButton("xm y+14 w120 Default", "Abrir")
    btnCancelar := g.AddButton("x+10 yp w120", "Cancelar")

    btnCancelar.OnEvent("Click", (*) => g.Destroy())
    btnAbrir.OnEvent("Click",    (*) => Abrir())

    g.Show("w408")
    edtRes.Focus()

    ; ---------------------------------------------------------
    Abrir() {
        ano  := Trim(edtAno.Value)
        res  := Trim(edtRes.Value)
        caso := Trim(edtCaso.Value)

        if (ano = "" || res = "" || caso = "") {
            MsgBox("Preencha todos os campos antes de abrir.", "Atenção", "Icon! T3")
            return
        }

        ; Garante extensão .docx
        if !RegExMatch(caso, "i)\.docx$")
            caso .= ".docx"

        ; Codifica espaços e caracteres comuns nas partes variáveis
        resEnc  := _UrlEncodeSimples(res)
        casoEnc := _UrlEncodeSimples(caso)

        ; Formato /:w:/r/ — SharePoint abre o arquivo Word pelo caminho completo
        url := "https://ebserhnet.sharepoint.com/:w:/r/sites/ULAPHUOLEBSERH"
             . "/Documentos%20Partilhados/LAUDOS/LAUDOS%20-%20DIGITA%C3%87%C3%83O"
             . "/" ano "/" resEnc "/" casoEnc "?web=1"

        g.Destroy()
        Run url
    }
}

; Codifica espaços e caracteres acentuados comuns em nomes de pasta/arquivo
_UrlEncodeSimples(str) {
    str := StrReplace(str, " ",  "%20")
    str := StrReplace(str, "á",  "%C3%A1")
    str := StrReplace(str, "Á",  "%C3%81")
    str := StrReplace(str, "â",  "%C3%A2")
    str := StrReplace(str, "Â",  "%C3%82")
    str := StrReplace(str, "ã",  "%C3%A3")
    str := StrReplace(str, "Ã",  "%C3%83")
    str := StrReplace(str, "à",  "%C3%A0")
    str := StrReplace(str, "À",  "%C3%80")
    str := StrReplace(str, "é",  "%C3%A9")
    str := StrReplace(str, "É",  "%C3%89")
    str := StrReplace(str, "ê",  "%C3%AA")
    str := StrReplace(str, "Ê",  "%C3%8A")
    str := StrReplace(str, "í",  "%C3%AD")
    str := StrReplace(str, "Í",  "%C3%8D")
    str := StrReplace(str, "ó",  "%C3%B3")
    str := StrReplace(str, "Ó",  "%C3%93")
    str := StrReplace(str, "ô",  "%C3%B4")
    str := StrReplace(str, "Ô",  "%C3%94")
    str := StrReplace(str, "õ",  "%C3%B5")
    str := StrReplace(str, "Õ",  "%C3%95")
    str := StrReplace(str, "ú",  "%C3%BA")
    str := StrReplace(str, "Ú",  "%C3%9A")
    str := StrReplace(str, "ü",  "%C3%BC")
    str := StrReplace(str, "ç",  "%C3%A7")
    str := StrReplace(str, "Ç",  "%C3%87")
    return str
}
