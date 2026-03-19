#Requires AutoHotkey v2.0

AbrirMascaraIHQ(*) {
    static MyGui := 0
    static wv := 0

    if (MyGui != 0) {
        MyGui.Show("Center")
        return
    }

    MyGui := Gui("+Resize", "GUILIS - Imuno-histoquímica (WebView2)")
    MyGui.OnEvent("Close", (*) => MyGui.Hide())

    ; --- SEU JSON DE ANTICORPOS ---
    estoqueJSON := '{""RE"": [""EP1 - Agilent"", ""SP1 - Ventana""], ""RP"": [""PgR 636 - Agilent"", ""1E2 - Ventana""], ""Ki-67"": [""MIB1 - Agilent"", ""30-9 - Ventana""], ""HER2"": [""4B5 - Ventana""]}'

    htmlCode := "
    (
    <!DOCTYPE html>
    <html lang='pt-br'>
    <head>
        <meta charset='UTF-8'>
        <script src='https://cdn.tailwindcss.com'></script>
        <style>
            body { font-family: 'Segoe UI', sans-serif; background: #f3f4f6; margin: 0; padding: 20px; }
            .laudo-preview { background: white; padding: 30px; border: 1px solid #ccc; min-height: 600px; font-family: 'Times New Roman', serif; }
            table { border-collapse: collapse; width: 100%; border: 1.8pt solid black; }
            th, td { border: 1.8pt solid black; padding: 8px; font-size: 14px; text-align: left; }
            th { background: #d9d9d9; font-weight: bold; }
            .erro-input { border: 2px solid #ef4444 !important; background: #fef2f2; }
        </style>
    </head>
    <body>
        <div class='flex gap-5'>
            <div class='w-[380px] bg-white p-5 rounded-xl shadow-lg h-fit'>
                <h2 class='text-blue-800 font-extrabold text-xl mb-4 border-b pb-2'>GUILIS IHQ</h2>
                <div id='container-inputs' class='space-y-2'></div>
                <button onclick='addLinha()' class='w-full mt-3 bg-gray-100 p-2 rounded font-bold hover:bg-gray-200'>+ LINHA</button>
                <button onclick='copyHtml()' class='w-full mt-6 bg-orange-600 text-white p-3 rounded-lg font-bold shadow-md hover:bg-orange-700'>COPIAR PARA O WORD</button>
            </div>
            <div id='preview' class='laudo-preview flex-1 shadow-sm'>
                <div id='area-tabela'></div>
            </div>
        </div>
        <script>
            const estoque = " . estoqueJSON . ";

            function addLinha() {
                const d = document.createElement('div');
                d.className = 'flex gap-2';
                d.innerHTML = `<input type='text' placeholder='Ant...' class='ant border p-1 w-32 text-sm rounded' oninput='check(this)'>
                               <select class='clo border p-1 flex-1 text-sm rounded bg-white'></select>
                               <input type='text' placeholder='Res' class='res border p-1 w-16 text-sm rounded' oninput='render()'>`;
                document.getElementById('container-inputs').appendChild(d);
            }

            function check(el) {
                const val = el.value.trim().toLowerCase();
                const sel = el.parentElement.querySelector('.clo');
                const match = Object.keys(estoque).find(k => k.toLowerCase() === val);
                if(match) {
                    el.classList.remove('erro-input');
                    sel.innerHTML = estoque[match].map(c => `<option value='${c}'>${c}</option>`).join('');
                } else {
                    el.classList.add('erro-input');
                    sel.innerHTML = '<option value=\"\">---</option>';
                }
                render();
            }

            function render() {
                let h = '<table><thead><tr><th>ANTICORPO</th><th>CLONE-FABRICANTE</th><th>RESULTADO</th></tr></thead><tbody>';
                let has = false;
                document.querySelectorAll('#container-inputs > div').forEach(div => {
                    const a = div.querySelector('.ant').value;
                    const c = div.querySelector('.clo').value;
                    const r = div.querySelector('.res').value;
                    if(a) { h += `<tr><td>${a.toUpperCase()}</td><td>${c}</td><td>${r}</td></tr>`; has = true; }
                });
                document.getElementById('area-tabela').innerHTML = has ? h + '</tbody></table>' : '';
            }

            function copyHtml() {
                const content = document.getElementById('preview').innerHTML;
                window.chrome.webview.postMessage(content);
            }

            for(let i=0; i<6; i++) addLinha();
        </script>
    </body>
    </html>
    )"

    ; Inicializa o WebView2
    wv := WebView2.create(MyGui.Hwnd)
    wv.on("Message", (wv, msg) => (A_Clipboard := msg, MsgBox("Tabela copiada!", "GUILIS", "T1")))

    ; Define o conteúdo HTML
    wv.navigateToString(htmlCode)

    MyGui.Show("w1200 h800 Center")
}