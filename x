<!DOCTYPE html>
<html lang="pt-BR" class="h-full bg-gray-50">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Controle de Voz Profissional</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-full flex items-start justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-3xl w-full space-y-8">
        
        <header class="text-center">
            <h1 class="text-4xl font-extrabold text-gray-900">
                Controle de Voz Inteligente
            </h1>
            <p class="mt-2 text-lg text-gray-600">
                Uma interface profissional para automação residencial via ESP32.
            </p>
        </header>

        <main class="space-y-8">
            <!-- Card de Reconhecimento de Voz -->
            <div class="bg-white shadow-lg rounded-xl p-6 border border-gray-200">
                <h2 class="text-2xl font-bold text-gray-800 border-b pb-3 mb-4 flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-3 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11a7 7 0 01-7 7m0 0a7 7 0 01-7-7m7 7v4m0 0H8m4 0h4m-4-8a3 3 0 01-3-3V5a3 3 0 116 0v6a3 3 0 01-3 3z" /></svg>
                    Reconhecimento de Voz
                </h2>
                <div class="flex items-center space-x-4 mt-4">
                    <button id="start" class="w-full inline-flex justify-center items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 disabled:opacity-50 disabled:cursor-not-allowed">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" /></svg>
                        Iniciar
                    </button>
                    <button id="stop" disabled class="w-full inline-flex justify-center items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 disabled:opacity-50 disabled:cursor-not-allowed">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8 7a1 1 0 00-1 1v4a1 1 0 001 1h4a1 1 0 001-1V8a1 1 0 00-1-1H8z" clip-rule="evenodd" /></svg>
                        Parar
                    </button>
                </div>
                <div id="saida" class="mt-5 p-4 bg-gray-100 rounded-lg min-h-[60px] text-gray-700 font-mono text-center text-lg transition-all duration-300">
                    Aguardando início...
                </div>
            </div>

            <!-- Card de Gerenciamento de Binds -->
            <div class="bg-white shadow-lg rounded-xl p-6 border border-gray-200">
                <h2 class="text-2xl font-bold text-gray-800 border-b pb-3 mb-4 flex items-center">
                   <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-3 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" /></svg>
                    Gerenciar Binds
                </h2>
                <div class="flex flex-col sm:flex-row items-stretch gap-3">
                    <input type="text" id="bind-phrase" placeholder="Frase de ativação (ex: ligar led)" class="flex-grow appearance-none block w-full px-4 py-3 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                    <input type="number" id="bind-gpio" placeholder="Pino GPIO (ex: 2)" class="w-full sm:w-32 appearance-none block px-4 py-3 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                    <button id="add-bind" class="w-full sm:w-auto inline-flex justify-center items-center px-4 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" /></svg>
                        Adicionar
                    </button>
                </div>
                <ul id="binds-list" class="mt-6 space-y-3">
                    <!-- Binds salvas aparecerão aqui -->
                </ul>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const saida = document.getElementById("saida");
            const startBtn = document.getElementById("start");
            const stopBtn = document.getElementById("stop");
            const addBindBtn = document.getElementById("add-bind");
            const bindPhraseInput = document.getElementById("bind-phrase");
            const bindGpioInput = document.getElementById("bind-gpio");
            const bindsList = document.getElementById("binds-list");

            const ESP_IP = "192.168.4.1";
            let binds = {};
            let lastTriggeredPhrase = null;
            let finalTranscriptProcessed = true;
            let pinTimers = {}; // Objeto para armazenar os temporizadores de cada pino

            // --- Lógica de Reconhecimento de Voz ---
            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

            if (!SpeechRecognition) {
                saida.innerHTML = `<span class="text-red-500 font-bold">Seu navegador não suporta a Web Speech API. Use o Chrome ou Edge.</span>`;
                startBtn.disabled = true;
                return;
            }

            const recognition = new SpeechRecognition();
            recognition.lang = 'pt-BR';
            recognition.interimResults = true;
            recognition.continuous = true;

            recognition.onresult = (event) => {
                let interimTranscript = '';
                let finalTranscript = '';

                for (let i = event.resultIndex; i < event.results.length; ++i) {
                    if (event.results[i].isFinal) {
                        finalTranscript += event.results[i][0].transcript;
                        finalTranscriptProcessed = false;
                    } else {
                        interimTranscript += event.results[i][0].transcript;
                    }
                }
                
                const fullTranscript = (finalTranscript + interimTranscript).toLowerCase().trim();
                saida.textContent = fullTranscript || '...';
                
                checkBinds(fullTranscript, event.results[event.results.length-1].isFinal);
            };
            
            recognition.onerror = (event) => {
                console.error('Erro no reconhecimento de voz:', event.error);
                saida.innerHTML = `<span class="text-red-500">Erro: ${event.error}</span>`;
                setTimeout(() => startBtn.onclick(), 100);
            };
            
            recognition.onstart = () => {
                startBtn.disabled = true;
                stopBtn.disabled = false;
                saida.textContent = 'Ouvindo...';
                saida.classList.add('bg-green-100', 'text-green-800');
                saida.classList.remove('bg-gray-100', 'text-gray-700');
            };
            
            recognition.onend = () => {
                startBtn.disabled = false;
                stopBtn.disabled = true;
                saida.textContent = 'Reconhecimento parado.';
                saida.classList.remove('bg-green-100', 'text-green-800');
                saida.classList.add('bg-gray-100', 'text-gray-700');
                lastTriggeredPhrase = null; // Reseta ao parar
            };

            startBtn.onclick = () => recognition.start();
            stopBtn.onclick = () => recognition.stop();
            
            // --- Lógica das Binds ---
            
            const loadBinds = () => {
                try {
                    const storedBinds = localStorage.getItem('voiceBinds');
                    if (storedBinds) {
                        binds = JSON.parse(storedBinds);
                    }
                } catch(e) {
                    console.error("Falha ao carregar binds do localStorage:", e);
                    binds = {};
                }
                renderBinds();
            };

            const saveBinds = () => {
                localStorage.setItem('voiceBinds', JSON.stringify(binds));
            };

            const renderBinds = () => {
                bindsList.innerHTML = '';
                if (Object.keys(binds).length === 0) {
                     bindsList.innerHTML = '<li class="text-center text-gray-500 py-3">Nenhuma bind configurada.</li>';
                     return;
                }
                for (const phrase in binds) {
                    const gpio = binds[phrase];
                    const li = document.createElement('li');
                    li.className = 'flex justify-between items-center p-3 bg-gray-50 rounded-lg border border-gray-200';
                    li.innerHTML = `
                        <div class="font-mono text-sm">
                            <span class="font-semibold text-indigo-700">"${phrase}"</span>
                            <span class="mx-2 text-gray-400">&rarr;</span>
                            <span class="font-bold text-gray-900">GPIO ${gpio}</span>
                        </div>
                        <button class="delete-btn text-red-500 hover:text-red-700 p-1" data-phrase="${phrase}">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>
                        </button>
                    `;
                    bindsList.appendChild(li);
                }
            };

            addBindBtn.onclick = () => {
                const phrase = bindPhraseInput.value.trim().toLowerCase();
                const gpio = bindGpioInput.value.trim();

                if (phrase && gpio && !isNaN(gpio)) {
                    binds[phrase] = gpio;
                    saveBinds();
                    renderBinds();
                    bindPhraseInput.value = '';
                    bindGpioInput.value = '';
                } else {
                    alert('Por favor, preencha a frase e um número de pino válido.');
                }
            };
            
            bindsList.addEventListener('click', (event) => {
                const deleteButton = event.target.closest('.delete-btn');
                if (deleteButton) {
                    const phraseToDelete = deleteButton.dataset.phrase;
                    if (confirm(`Tem certeza que deseja remover a bind para a frase "${phraseToDelete}"?`)) {
                        delete binds[phraseToDelete];
                        saveBinds();
                        renderBinds(); 
                    }
                }
            });

            // --- Lógica de Verificação e Envio ---

            const checkBinds = (transcript, isFinal) => {
                if (lastTriggeredPhrase && isFinal && !finalTranscriptProcessed) {
                    // Se a fala terminou, reseta para permitir novo comando.
                    lastTriggeredPhrase = null;
                    finalTranscriptProcessed = true;
                }

                for (const phrase in binds) {
                    if (transcript.includes(phrase) && phrase !== lastTriggeredPhrase) {
                        const gpio = binds[phrase];
                        console.log(`Frase detectada: "${phrase}". Acionando GPIO ${gpio}.`);
                        
                        // Atualiza a UI para feedback imediato
                        const tempSaida = document.createElement('div');
                        tempSaida.className = "mt-2 p-2 bg-blue-100 text-blue-800 rounded-md text-sm";
                        tempSaida.innerHTML = `Comando <strong>"${phrase}"</strong> reconhecido! Ativando pino ${gpio}.`;
                        saida.parentNode.insertBefore(tempSaida, saida.nextSibling);
                        setTimeout(() => tempSaida.remove(), 4000); // Remove a notificação após 4 segundos

                        lastTriggeredPhrase = phrase; // Bloqueia a repetição do mesmo comando
                        
                        // Sempre chama para LIGAR o pino. A lógica de desligar fica no togglePin.
                        togglePin(gpio, 1);
                        break;
                    }
                }
            };

            const togglePin = (gpio, state) => {
                // Cancela qualquer temporizador existente para este pino
                if (pinTimers[gpio]) {
                    clearTimeout(pinTimers[gpio]);
                    console.log(`Temporizador anterior para GPIO ${gpio} cancelado.`);
                }
                
                const url = `http://${ESP_IP}/update?gpio=${gpio}&state=${state}`;
                console.log(`Enviando requisição para: ${url}`);
                
                fetch(url).catch(error => {
                    console.error('Erro ao enviar comando para o ESP32:', error);
                    const errorSaida = document.createElement('div');
                    errorSaida.className = "mt-2 p-2 bg-red-100 text-red-800 rounded-md text-sm";
                    errorSaida.innerHTML = `<strong>Erro:</strong> Não foi possível conectar ao ESP32. Verifique o IP e a conexão.`;
                    saida.parentNode.insertBefore(errorSaida, saida.nextSibling);
                    setTimeout(() => errorSaida.remove(), 5000);
                });

                // Se o estado for LIGAR (1), inicia um novo temporizador para desligar
                if (state === 1) {
                    console.log(`Temporizador de 10s iniciado para desligar GPIO ${gpio}.`);
                    pinTimers[gpio] = setTimeout(() => {
                        console.log(`Tempo esgotado. Desligando GPIO ${gpio}.`);
                        togglePin(gpio, 0); // Chama a função novamente para desligar
                        delete pinTimers[gpio]; // Remove a referência ao temporizador
                    }, 10000); // 10 segundos
                }
            };

            // Carregar binds salvas ao iniciar
            loadBinds();
        });
    </script>
</body>
</html>
