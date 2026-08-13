<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar_Acesso - Avaliaqui</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        body { transition: background-color 0.3s, color 0.3s; }
        
        /* Efeito Monitor CRT (Fauux / Lain Aesthetic) */
        .scanlines {
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.15) 50%);
            background-size: 100% 4px;
            pointer-events: none;
            z-index: 9999;
        }

        /* Tema Claro */
        body.light-mode { background-color: #f0f9ff; color: #111827; }
        body.light-mode .bg-panel { background-color: #ffffff; border-color: #94a3b8; }
        body.light-mode .text-gray-400 { color: #475569; }
        body.light-mode .text-white { color: #0f172a; }
        body.light-mode .border-line { border-color: #cbd5e1; }
        body.light-mode .input-light { background-color: #f8fafc; border-color: #94a3b8; color: #0f172a; }
        body.light-mode .scanlines { opacity: 0.3; }

        /* Fundo Estrelado Escuro Integrado */
        .space-background {
            background-color: #050505;
            background-image: 
                radial-gradient(2px 2px at 40px 60px, rgba(255,255,255,0.8), rgba(0,0,0,0)),
                radial-gradient(2px 2px at 150px 30px, rgba(255,255,255,0.6), rgba(0,0,0,0)),
                radial-gradient(2px 2px at 90px 140px, rgba(255,255,255,0.5), rgba(0,0,0,0));
            background-repeat: repeat;
            background-size: 300px 300px;
        }

        /* Fundo Céu Claro Vetorial Integrado */
        body.light-mode .space-background {
            background-color: #38bdf8;
            background-image: 
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='120' viewBox='0 0 200 120'%3E%3Cpath fill='%23ffffff' fill-opacity='0.55' d='M 30 80 a 18 18 0 0 1 18 -18 a 24 24 0 0 1 42 -7 a 18 18 0 0 1 26 7 a 15 15 0 0 1 7 18 a 15 15 0 0 1 -15 15 H 30 a 15 15 0 0 1 -15 -15 z'/%3E%3Cpath fill='%23ffffff' fill-opacity='0.35' d='M 120 45 a 12 12 0 0 1 12 -12 a 16 16 0 0 1 28 -5 a 12 12 0 0 1 17 5 a 10 10 0 0 1 5 12 a 10 10 0 0 1 -10 10 h-42 a 10 10 0 0 1 -10 -10 z'/%3E%3C/svg%3E"),
                linear-gradient(180deg, #0284c7 0%, #38bdf8 50%, #bae6fd 100%);
            background-repeat: repeat, no-repeat;
            background-size: 260px 160px, 100% 100%;
            background-attachment: fixed;
        }
        
			/* --- BLOCO UNIVERSAL DE CONTRASTE & DESIGN SYSTEM --- */
			body.light-mode { 
			    background-color: #f8fafc; 
			    color: #0f172a; 
			}
			body.light-mode .bg-panel { 
			    background-color: #ffffff; 
			    border-color: #94a3b8; 
			}
			body.light-mode .border-line { 
			    border-color: #cbd5e1; 
			}
			body.light-mode .input-light { 
			    background-color: #f1f5f9; 
			    border-color: #94a3b8; 
			    color: #0f172a; 
			}
			body.light-mode .scanlines { 
			    opacity: 0.2; 
			}
			
			/* Inversão Forçada de Cores para Alto Contraste (Acessibilidade WCAG) */
			body.light-mode .text-white { color: #0f172a !important; }
			body.light-mode .text-gray-200 { color: #1e293b !important; }
			body.light-mode .text-gray-300 { color: #334155 !important; }
			body.light-mode .text-gray-400 { color: #475569 !important; font-weight: 600; }
			body.light-mode .text-gray-500 { color: #64748b !important; }
			body.light-mode .text-[#a855f7] { color: #6b21a8 !important; }
			body.light-mode .text-yellow-500 { color: #b45309 !important; }
    </style>
</head>
<body class="space-background text-gray-200 flex items-center justify-center min-h-screen font-sans relative select-none">

    <div class="scanlines"></div>

    <script>
        if (localStorage.getItem("theme") === "light") {
            document.body.classList.add("light-mode");
        }
    </script>

    <button onclick="toggleTheme()" id="theme-btn" class="absolute top-6 right-6 text-[11px] font-mono uppercase tracking-wider text-gray-500 hover:text-white transition px-3 py-1 border border-[#333] border-line bg-[#0a0a0c] bg-panel rounded-none z-50">
        [ MODO CLARO ]
    </button>

    <div class="w-full max-w-sm p-8 bg-[#0a0a0c] bg-panel border border-[#333] border-line rounded-none shadow-[8px_8px_0px_rgba(0,0,0,0.8)] body.light-mode:shadow-[4px_4px_0px_rgba(0,0,0,0.1)] z-10">
        
        <div class="text-center mb-8 border-b border-[#333] border-line pb-4">
            <h1 class="text-2xl font-bold tracking-widest text-[#a855f7]" style="text-shadow: 0 0 8px rgba(168,85,247,0.5);">AVALIA<span class="text-white">QUI</span></h1>
            <p class="text-[10px] font-mono text-gray-500 mt-2 uppercase tracking-widest">> Recuperar Acesso</p>
        </div>

        <% String erro = (String) request.getAttribute("mensagemErro"); %>
        <% if (erro != null) { %>
            <div class="bg-[#2a1111] border border-red-900 text-red-400 text-[11px] font-mono p-3 mb-6 uppercase">
                [ERRO] <%= erro %>
            </div>
        <% } %>

        <% String sucesso = (String) request.getAttribute("mensagemSucesso"); %>
        <% if (sucesso != null) { %>
            <div class="bg-[#0f1f0f] border border-green-900 text-green-400 text-[11px] font-mono p-3 mb-6 uppercase">
                [SYS_OK] <%= sucesso %>
            </div>
        <% } %>

        <form action="recuperar" method="POST" class="space-y-5">
            <div>
                <label for="identifier" class="block text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">Identificação (E-mail ou CPF)</label>
                <input type="text" id="identifier" name="identifier" required placeholder="Digite o dado cadastrado..."
                       class="w-full px-3 py-2 bg-[#111] input-light border border-[#333] border-line rounded-none text-gray-300 focus:outline-none focus:border-[#a855f7] transition-colors font-mono text-sm">
            </div>

            <button type="submit" class="w-full py-2.5 mt-4 bg-transparent border border-[#a855f7] text-[#a855f7] hover:bg-[#a855f7] hover:text-white font-bold rounded-none transition-all text-xs uppercase tracking-widest" style="box-shadow: inset 0 0 5px rgba(168,85,247,0.2);">
                [ GERAR NOVA CHAVE ]
            </button>
        </form>

        <div class="text-center mt-6 pt-4 border-t border-[#333] border-line flex justify-between items-center">
            <span class="text-[10px] font-mono text-gray-600">SYS_AUTH</span>
            <a href="login.jsp" class="text-[11px] font-mono text-gray-400 hover:text-white transition-colors uppercase">
                < Voltar ao Login
            </a>
        </div>
    </div>

    <script>
        function toggleTheme() {
            const isLight = document.body.classList.toggle("light-mode");
            const btn = document.getElementById("theme-btn");
            if (isLight) {
                localStorage.setItem("theme", "light");
                btn.innerHTML = '[ MODO ESCURO ]';
            } else {
                localStorage.setItem("theme", "dark");
                btn.innerHTML = '[ MODO CLARO ]';
            }
        }

        window.onload = function() {
            if (localStorage.getItem("theme") === "light") {
                document.getElementById("theme-btn").innerHTML = '[ MODO ESCURO ]';
            } else {
                document.getElementById("theme-btn").innerHTML = '[ MODO CLARO ]';
            }
        };
    </script>
</body>
</html>