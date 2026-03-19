#Include WebView2.ahk

Gastrite_WebView_Run() {
    prevWin := WinActive("A")

    ; -Caption remove a barra superior; +Border adiciona contorno fino
    myGui := Gui("-Caption +Border +AlwaysOnTop", "Laudo Moderno — Gastrite Crônica")
    myGui.BackColor := "121212"

    ; --- FUNÇÃO PARA ARRASTAR A JANELA ---
    ; Captura o clique esquerdo no fundo da janela para permitir o movimento
    OnMessage(0x0201, WM_LBUTTONDOWN)
    WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
        if (hwnd = myGui.Hwnd)
            PostMessage(0xA1, 2,,, "ahk_id " myGui.Hwnd)
    }

    html := "
    (
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset='UTF-8'>
        <style>
            body { background: #181818; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; padding: 20px; margin: 0; user-select: none; }
            .card { background: #252525; border: 1px solid #333; border-radius: 12px; padding: 20px; box-shadow: 0 8px 16px rgba(0,0,0,0.4); position: relative; }

            .close-btn { position: absolute; top: 10px; right: 15px; color: #666; cursor: pointer; font-size: 20px; font-weight: bold; }
            .close-btn:hover { color: #ff4d4d; }

            h2 { color: #00d4ff; margin-top: 0; font-size: 1.2rem; border-bottom: 1px solid #333; padding-bottom: 10px; }
            .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 15px; }
            .full-width { grid-column: span 2; }
            label { font-weight: bold; color: #aaa; font-size: 0.8rem; display: block; margin-bottom: 5px; }
            select, button { background: #333; color: white; border: 1px solid #444; width: 100%; padding: 8px; border-radius: 6px; font-size: 0.9rem; outline: none; }

            .checkbox-group { display: flex; flex-wrap: wrap; gap: 15px; margin-top: 10px; background: #1e1e1e; padding: 10px; border-radius: 8px; }
            .checkbox-item { display: flex; align-items: center; gap: 5px; font-size: 0.85rem; color: #ccc; cursor: pointer; }

            .preview-area { background: #000; color: #00ff41; font-family: 'Consolas', monospace; padding: 15px; border-radius: 8px; margin-top: 20px; min-height: 100px; white-space: pre-wrap; border-left: 4px solid #0078d4; font-size: 0.95rem; line-height: 1.4; }

            .btn-container { display: flex; gap: 10px; margin-top: 20px; }
            .btn-main { background: #4a7fd5; border: none; font-weight: bold; cursor: pointer; padding: 12px; }
            .btn-main:hover { background: #5c92eb; }
            .btn-copy { background: #444; border: none; cursor: pointer; }
        </style>
    </head>
    <body>
        <div class='close-btn' onclick='sendAhk(\"cancel\")'>&times;</div>
        <div class='card'>
            <h2>🔬 Gastrite Crônica</h2>
            <div class='grid'>
                <div><label>Grau</label><select id='Grau' onchange='update()'><option>leve</option><option selected>moderada</option><option>intensa</option></select></div>
                <div><label>Mucosa</label><select id='Mucosa' onchange='update()'><option selected>de padrão fúndico</option><option>de padrão antral</option><option>juncional</option><option>de cárdia</option></select></div>
                <div><label>Atividade</label><select id='Atividade' onchange='update()'><option selected>ausente</option><option>leve</option><option>moderada</option><option>intensa</option></select></div>
                <div><label>Atrofia</label><select id='Atrofia' onchange='update()'><option selected>ausente</option><option>leve</option><option>moderada</option><option>intensa</option></select></div>
                <div class='full-width'><label>Metaplasia Intestinal</label><select id='MI' onchange='update()'><option selected>ausente</option><option>incompleta, focal e sem displasia</option><option>incompleta, difusa e sem displasia</option><option>completa, focal e sem displasia</option></select></div>
                <div class='full-width'><label>H. pylori (Giemsa)</label><select id='HP' onchange='update()'><option selected>negativa</option><option>positiva</option></select></div>
            </div>
            <div class='checkbox-group'>
                <div class='checkbox-item'><input type='checkbox' id='oa1' onchange='update()'>agregado linfoide</div>
                <div class='checkbox-item'><input type='checkbox' id='oa2' onchange='update()'>folículo linfoide</div>
                <div class='checkbox-item'><input type='checkbox' id='oa3' onchange='update()'>erosão</div>
            </div>
            <div class='preview-area' id='Preview'></div>
            <div class='btn-container'>
                <button class='btn-main' onclick='sendAhk(\"insert\")'>INSERIR</button>
                <button class='btn-copy' onclick='sendAhk(\"copy\")'>COPIAR</button>
            </div>
        </div>
        <script>
            function update() {
                const g = document.getElementById('Grau').value;
                const m = document.getElementById('Mucosa').value;
                const a = document.getElementById('Atividade').value;
                const at = document.getElementById('Atrofia').value;
                const mi = document.getElementById('MI').value;
                const hp = document.getElementById('HP').value;
                let txt = 'Gastrite crônica ' + g + ' em mucosa ' + m + '.\n. Atividade ' + a + '\n. Atrofia ' + at + '\n. Metaplasia intestinal ' + mi + '\n. H. pylori: ' + hp;
                document.getElementById('Preview').innerText = txt;
            }
            function sendAhk(action) { window.chrome.webview.postMessage(action); }
            window.onload = update;
        </script>
    </body>
    </html>
    )"

    try {
        ; Mostra a GUI para obter o HWND válido
        myGui.Show("w700 h780 Center")

        ; Inicializa o controlador de forma síncrona com await2()
        wvc := WebView2.create(myGui.Hwnd)
        wv := wvc.CoreWebView2

        ; Preenche a área da janela
        wvc.Fill()

        ; Registra evento de mensagem
        wv.WebMessageReceived(ProcessarMensagem)
        wv.NavigateToString(html)

    } catch Error as e {
        MsgBox("Erro ao iniciar WebView2: " e.Message)
        return
    }

    ; --- FUNÇÕES DE APOIO ---
    ProcessarMensagem(sender, args) {
        action := StrReplace(args.WebMessageAsJson, '"', '')

        if (action = "cancel") {
            myGui.Destroy()
            return
        }

        ; Executa script assíncrono e trata o resultado na função interna
        sender.ExecuteScriptAsync("document.getElementById('Preview').innerText").then(Finalizar)

        Finalizar(result) {
            txtFinal := StrReplace(Trim(result, '"'), "\n", "`r`n")
            txtFinal := StrReplace(txtFinal, "\\", "\")
            A_Clipboard := txtFinal
            ClipWait(1)

            if (action = "insert") {
                if WinExist(prevWin) {
                    WinActivate(prevWin)
                    Sleep(150)
                    Send("^v")
                }
                myGui.Destroy()
            } else {
                ToolTip("Copiado com sucesso!")
                SetTimer(() => ToolTip(), -2000)
            }
        }
    }
}