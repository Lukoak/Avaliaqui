<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Postagem" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Declaração da fila no topo do arquivo para estar disponível em toda a página
    List<Postagem> fila = (List<Postagem>) request.getAttribute("filaPendentes");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mod_Queue - Avaliaqui</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        body { transition: background-color 0.3s, color 0.3s; }
        
        .scanlines {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.15) 50%);
            background-size: 100% 4px; pointer-events: none; z-index: 9999;
        }

        body.light-mode { background-color: #f0f9ff; color: #111827; }
        body.light-mode .bg-panel { background-color: #ffffff; border-color: #94a3b8; }
        body.light-mode .text-gray-400 { color: #475569; }
        body.light-mode .text-white { color: #0f172a; }
        body.light-mode .border-line { border-color: #cbd5e1; }
        body.light-mode .input-light { background-color: #f8fafc; border-color: #94a3b8; color: #0f172a; }
        body.light-mode .scanlines { opacity: 0.3; }

        .space-background {
            background-color: #050505;
            background-image: 
                radial-gradient(2px 2px at 40px 60px, rgba(255,255,255,0.8), rgba(0,0,0,0)),
                radial-gradient(2px 2px at 150px 30px, rgba(255,255,255,0.6), rgba(0,0,0,0)),
                radial-gradient(2px 2px at 90px 140px, rgba(255,255,255,0.5), rgba(0,0,0,0));
            background-repeat: repeat; background-size: 300px 300px;
        }

        body.light-mode .space-background {
            background-color: #38bdf8;
            background-image: linear-gradient(180deg, #0284c7 0%, #38bdf8 50%, #bae6fd 100%);
            background-repeat: no-repeat; background-size: 100% 100%; background-attachment: fixed;
        }

        .btn-reject {
            background-color: transparent; border: 1px solid #7f1d1d; color: #f87171; transition: all 0.2s;
        }
        .btn-reject:hover { background-color: #7f1d1d; color: #fff; box-shadow: inset 0 0 8px rgba(220,38,38,0.5); }
        
        .btn-approve {
            background-color: transparent; border: 1px solid #14532d; color: #4ade80; transition: all 0.2s;
        }
        .btn-approve:hover { background-color: #14532d; color: #fff; box-shadow: inset 0 0 8px rgba(34,197,94,0.5); }

        .terminal-scroll::-webkit-scrollbar { width: 6px; }
        .terminal-scroll::-webkit-scrollbar-track { background: #0a0a0c; border-left: 1px solid #333; }
        .terminal-scroll::-webkit-scrollbar-thumb { background: #333; }
        body.light-mode .terminal-scroll::-webkit-scrollbar-track { background: #f8fafc; border-left: 1px solid #cbd5e1; }
        body.light-mode .terminal-scroll::-webkit-scrollbar-thumb { background: #94a3b8; }

        .item-ativo {
            background-color: #1a1a1a; border-left-width: 4px; border-left-color: #a855f7;
        }
        body.light-mode .item-ativo {
            background-color: #e2e8f0; border-left-color: #ea580c;
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
<body class="space-background text-gray-200 font-sans min-h-screen relative select-none">
    
    <div class="scanlines"></div>
    <script>if (localStorage.getItem("theme") === "light") document.body.classList.add("light-mode");</script>

    <header class="h-14 border-b border-[#333] border-line flex items-center justify-between px-6 bg-[#0a0a0c] bg-panel relative z-10 shadow-[0_4px_0_rgba(0,0,0,0.5)] body.light-mode:shadow-[0_4px_0_rgba(0,0,0,0.05)]">
        <div class="flex items-center gap-4">
            <a href="arvore" class="text-lg font-bold text-[#a855f7] tracking-widest font-mono" style="text-shadow: 0 0 8px rgba(168,85,247,0.5);">
                AVALIA<span class="text-white">QUI</span>
            </a>
            <span class="bg-[#111] input-light text-yellow-600 font-mono text-[10px] px-2 py-0.5 border border-[#333] border-line uppercase">Mod_Queue.SYS</span>
        </div>
        <div class="flex items-center gap-4 text-xs font-mono uppercase tracking-wider">
            <button onclick="toggleTheme()" id="theme-btn" class="text-gray-400 hover:text-white border border-[#333] border-line px-2 py-1 bg-[#111] bg-panel transition-colors">
                [ MODO CLARO ]
            </button>
            <a href="arvore" class="text-[#a855f7] hover:text-white transition-colors border-b border-[#a855f7] pb-0.5">< VOLTAR</a>
        </div>
    </header>

    <main class="max-w-6xl mx-auto p-6 mt-4 relative z-10">
        
        <div class="flex justify-between items-center border-b border-[#333] border-line pb-3 mb-6">
            <h2 class="text-xl font-bold tracking-widest text-white uppercase font-mono">> Fila_Moderação</h2>
            <span class="font-mono text-[10px] text-yellow-600 border border-yellow-700 bg-[#1a1a0f] input-light px-2 py-1 uppercase tracking-widest">
                [ ITENS PENDENTES: <%= (fila != null) ? fila.size() : 0 %> ]
            </span>
        </div>

        <% String sucesso = (String) request.getAttribute("mensagemSucesso"); %>
        <% if (sucesso != null) { %>
            <div class="bg-[#0f1f0f] border border-green-700 text-green-400 p-3 mb-6 font-mono text-[11px] shadow-[4px_4px_0_rgba(0,0,0,0.5)] uppercase">
                [SYS_OK] <%= sucesso %>
            </div>
        <% } %>

        <% String erro = (String) request.getAttribute("mensagemErro"); %>
        <% if (erro != null) { %>
            <div class="bg-[#2a1111] border border-red-900 text-red-400 p-3 mb-6 font-mono text-[11px] shadow-[4px_4px_0_rgba(0,0,0,0.5)] uppercase">
                [SYS_WARN] <%= erro %>
            </div>
        <% } %>

        <div class="grid grid-cols-1 md:grid-cols-12 gap-6 items-start">
            
            <div class="md:col-span-5 bg-[#0a0a0c] bg-panel border border-[#333] border-line shadow-[6px_6px_0_rgba(0,0,0,0.8)] body.light-mode:shadow-[4px_4px_0_rgba(0,0,0,0.1)] rounded-none flex flex-col h-[500px]">
                <div class="p-3 border-b border-[#333] border-line bg-[#111] input-light">
                    <p class="font-mono text-[10px] text-gray-500 uppercase tracking-widest">> INDEX_FILA</p>
                </div>
                
                <div class="flex-1 overflow-y-auto terminal-scroll divide-y divide-[#333] border-line">
                    <%
                        if (fila != null && !fila.isEmpty()) {
                            for (Postagem p : fila) {
                                // Escapando aspas para o JavaScript não quebrar
                                String tituloTratado = p.getTitulo() != null ? p.getTitulo().replace("'", "\\'") : "";
                                String descTratada = p.getDescricao() != null ? p.getDescricao().replace("'", "\\'").replace("\r\n", " ").replace("\n", " ") : "";
                    %>
                    <div id="item-<%= p.getId() %>" class="fila-item p-4 hover:bg-[#111] cursor-pointer transition-colors border-l-4 border-transparent" 
                         onclick="inspecionarPostagem('<%= p.getId() %>', '<%= tituloTratado %>', '<%= p.getAutorEmail() %>', '<%= p.getDataFormatada() %>', '<%= descTratada %>')">
                        <div class="flex justify-between items-start mb-1">
                            <span class="font-mono text-[10px] text-[#a855f7]">ID: #<%= p.getId() %></span>
                            <span class="font-mono text-[9px] text-gray-500"><%= p.getDataFormatada() %></span>
                        </div>
                        <h4 class="font-bold text-sm text-white font-mono truncate"><%= p.getTitulo() %></h4>
                    </div>
                    <%
                            } 
                        } else {
                    %>
                    <div class="p-6 text-center text-xs font-mono text-gray-600 uppercase tracking-widest mt-10">
                        [ FILA DE MODERAÇÃO VAZIA ]
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="md:col-span-7 bg-[#0a0a0c] bg-panel border border-[#333] border-line shadow-[6px_6px_0_rgba(0,0,0,0.8)] body.light-mode:shadow-[4px_4px_0_rgba(0,0,0,0.1)] rounded-none h-[500px] flex flex-col relative">
                
                <div id="placeholder-viewer" class="absolute inset-0 flex items-center justify-center bg-[#0a0a0c] bg-panel z-10">
                    <p class="font-mono text-xs text-gray-600 uppercase tracking-widest text-center">
                        > AGUARDANDO_INSTRUCAO<br><br>
                        [ SELECIONE UMA POSTAGEM PARA DETALHES ]
                    </p>
                </div>

                <div id="content-viewer" class="flex flex-col h-full hidden">
                    <div class="p-6 flex-1 overflow-y-auto terminal-scroll">
                        <div class="flex flex-col mb-4">
                            <p class="font-mono text-[10px] text-[#a855f7] uppercase tracking-widest mb-2 border-b border-[#333] border-line pb-1">
                                ID_NODE: <span id="viewer-id"></span> | ORIGIN: <span id="viewer-autor"></span> | TIMESTAMP: <span id="viewer-data"></span>
                            </p>
                            <h3 id="viewer-titulo" class="text-base font-bold text-white font-mono uppercase tracking-wide">> Título</h3>
                        </div>

                        <div class="bg-[#111] input-light p-4 border border-[#333] border-line text-sm text-gray-300 font-mono mb-6 leading-relaxed relative min-h-[200px]">
                            <span class="absolute top-0 left-0 bg-[#333] border-line text-[9px] text-gray-400 px-1 uppercase">DATA_PAYLOAD</span>
                            <br>
                            <span id="viewer-conteudo"></span>
                        </div>
                    </div>

                    <div class="p-4 border-t border-[#333] border-line bg-[#111] input-light flex justify-between items-center">
                        <button onclick="fecharInspecao()" class="font-mono text-[10px] text-gray-500 hover:text-white uppercase tracking-widest transition-colors">
                            < FECHAR
                        </button>
                        
                        <div class="flex gap-3">
                            <form action="moderacao" method="POST" class="inline">
                                <input type="hidden" name="postagemId" id="form-reject-id" value="">
                                <input type="hidden" name="acao" value="rejeitar">
                                <button type="submit" class="btn-reject px-4 py-2 font-mono text-[11px] font-bold tracking-widest rounded-none">
                                    [ REJEITAR_DADO ]
                                </button>
                            </form>
                            
                            <form action="moderacao" method="POST" class="inline">
                                <input type="hidden" name="postagemId" id="form-approve-id" value="">
                                <input type="hidden" name="acao" value="aprovar">
                                <button type="submit" class="btn-approve px-4 py-2 font-mono text-[11px] font-bold tracking-widest rounded-none">
                                    [ APROVAR_PUBLICAR ]
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <script>
        function toggleTheme() {
            const isLight = document.body.classList.toggle("light-mode");
            localStorage.setItem("theme", isLight ? "light" : "dark");
            document.getElementById("theme-btn").innerText = isLight ? '[ MODO ESCURO ]' : '[ MODO CLARO ]';
        }
        
        window.onload = function() {
            if (localStorage.getItem("theme") === "light") {
                document.getElementById("theme-btn").innerText = '[ MODO ESCURO ]';
            }
        };

        function inspecionarPostagem(id, titulo, autor, data, conteudo) {
            document.getElementById('placeholder-viewer').classList.add('hidden');
            document.getElementById('content-viewer').classList.remove('hidden');

            document.getElementById('viewer-id').innerText = '#' + id;
            document.getElementById('viewer-titulo').innerText = '> ' + titulo;
            document.getElementById('viewer-autor').innerText = autor;
            document.getElementById('viewer-data').innerText = data;
            document.getElementById('viewer-conteudo').innerText = '"' + conteudo + '"';

            document.getElementById('form-reject-id').value = id;
            document.getElementById('form-approve-id').value = id;

            const itens = document.querySelectorAll('.fila-item');
            itens.forEach(item => {
                item.classList.remove('item-ativo', 'border-[#a855f7]', 'border-[#ea580c]');
                item.classList.add('border-transparent');
            });

            const itemClicado = document.getElementById('item-' + id);
            itemClicado.classList.add('item-ativo');
            itemClicado.classList.remove('border-transparent');
            
            if (document.body.classList.contains("light-mode")) {
                itemClicado.classList.add('border-[#ea580c]');
            } else {
                itemClicado.classList.add('border-[#a855f7]');
            }
        }

        function fecharInspecao() {
            document.getElementById('placeholder-viewer').classList.remove('hidden');
            document.getElementById('content-viewer').classList.add('hidden');
            
            const itens = document.querySelectorAll('.fila-item');
            itens.forEach(item => {
                item.classList.remove('item-ativo', 'border-[#a855f7]', 'border-[#ea580c]');
                item.classList.add('border-transparent');
            });
        }
    </script>
</body>
</html>