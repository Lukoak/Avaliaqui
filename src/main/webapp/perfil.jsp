<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Postagem" %>
<%@ page import="model.Avaliacao" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Postagem> postagens = (List<Postagem>) request.getAttribute("minhasPostagens");
    List<Avaliacao> avaliacoes = (List<Avaliacao>) request.getAttribute("minhasAvaliacoes");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil_USR - Avaliaqui</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        body { transition: background-color 0.3s, color 0.3s; }
        .scanlines {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.15) 50%);
            background-size: 100% 4px; pointer-events: none; z-index: 9999;
        }
        
        /* Tema Claro - Ajustes de Contraste Profundos */
        body.light-mode { background-color: #f0f9ff; color: #111827; }
        body.light-mode .bg-panel { background-color: #ffffff; border-color: #94a3b8; }
        body.light-mode .border-line { border-color: #cbd5e1; }
        body.light-mode .input-light { background-color: #f8fafc; border-color: #94a3b8; color: #0f172a; }
        body.light-mode .scanlines { opacity: 0.3; }
        
        /* Força a inversão de textos cinzas para leitura no fundo branco */
        body.light-mode .text-gray-300 { color: #334155; }
        body.light-mode .text-gray-400 { color: #475569; }
        body.light-mode .text-gray-500 { color: #64748b; }
        body.light-mode .text-gray-600 { color: #94a3b8; }
        body.light-mode .text-white { color: #0f172a; }

        /* Ajustes específicos do Dropdown do Cabeçalho */
        .menu-item { transition: all 0.2s; }
        .menu-item:hover { background-color: #222; color: #ffffff; }
        body.light-mode .menu-item { color: #334155; }
        body.light-mode .menu-item:hover { background-color: #e2e8f0; color: #0f172a; }
        .hover-logout { transition: all 0.2s; }
        .hover-logout:hover { background-color: rgba(127, 29, 29, 0.3); }
        body.light-mode .hover-logout:hover { background-color: #fee2e2; }

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

        .terminal-scroll::-webkit-scrollbar { width: 6px; }
        .terminal-scroll::-webkit-scrollbar-track { background: #0a0a0c; border-left: 1px solid #333; }
        .terminal-scroll::-webkit-scrollbar-thumb { background: #333; }
        body.light-mode .terminal-scroll::-webkit-scrollbar-track { background: #f8fafc; border-left: 1px solid #cbd5e1; }
        body.light-mode .terminal-scroll::-webkit-scrollbar-thumb { background: #94a3b8; }
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

    <header class="h-14 border-b border-[#333] border-line flex items-center justify-between px-6 bg-[#0a0a0c] bg-panel relative z-10 shadow-[0_4px_0_rgba(0,0,0,0.5)]">
        <div class="flex items-center gap-4">
            <a href="arvore" class="text-lg font-bold text-[#a855f7] tracking-widest font-mono" style="text-shadow: 0 0 8px rgba(168,85,247,0.5);">
                AVALIA<span class="text-white">QUI</span>
            </a>
            <span class="bg-[#111] input-light text-[#a855f7] font-mono text-[10px] px-2 py-0.5 border border-[#333] border-line uppercase">PERFIL.SYS</span>
        </div>
        <div class="flex items-center gap-4 text-xs font-mono uppercase tracking-wider">
            <button onclick="toggleTheme()" id="theme-btn" class="text-gray-400 hover:text-white border border-[#333] border-line px-2 py-1 bg-[#111] bg-panel transition-colors">
                [ MODO CLARO ]
            </button>
            <a href="arvore" class="text-[#a855f7] hover:text-white transition-colors border-b border-[#a855f7] pb-0.5">< VOLTAR</a>
        </div>
    </header>

    <main class="max-w-5xl mx-auto p-6 mt-4 relative z-10 space-y-6">
        
        <div class="bg-[#0a0a0c] bg-panel border border-[#333] border-line p-6 shadow-[6px_6px_0_rgba(0,0,0,0.8)] body.light-mode:shadow-[4px_4px_0_rgba(0,0,0,0.1)]">
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 border-b border-[#333] border-line pb-4 mb-4">
                <div>
                    <span class="text-[10px] font-mono text-gray-500 uppercase tracking-widest">> DADOS_DO_USUÁRIO</span>
                    <h2 class="text-2xl font-bold text-white uppercase font-mono mt-1"><%= usuarioLogado.getNome() %></h2>
                    <p class="text-xs font-mono text-gray-400 mt-0.5"><%= usuarioLogado.getEmail() %></p>
                </div>
                <div class="text-right bg-[#111] input-light p-3 border border-[#333] border-line font-mono">
                    <span class="text-[9px] text-gray-500 block uppercase tracking-widest">PONTUAÇÃO ACUMULADA</span>
                    <span class="text-xl font-bold text-[#a855f7]"><%= usuarioLogado.getPontuacao() %> PTS</span>
                </div>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-xs font-mono">
                <div>
                    <span class="text-[9px] text-gray-500 block uppercase">ID DA CONTA:</span>
                    <span class="text-gray-300 font-bold">#<%= usuarioLogado.getId() %></span>
                </div>
                <div>
                    <span class="text-[9px] text-gray-500 block uppercase">CPF:</span>
                    <span class="text-gray-300 font-bold"><%= usuarioLogado.getCpf() %></span>
                </div>
                <div>
                    <span class="text-[9px] text-gray-500 block uppercase">GRUPO DE ACESSO:</span>
                    <span class="text-[#a855f7] font-bold uppercase"><%= usuarioLogado.getPerfilAcesso() %></span>
                </div>
                <div>
                    <span class="text-[9px] text-gray-500 block uppercase">STATUS DA CONTA:</span>
                    <span class="text-green-400 font-bold uppercase"><%= usuarioLogado.getStatus() %></span>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            
            <div class="bg-[#0a0a0c] bg-panel border border-[#333] border-line p-5 shadow-[6px_6px_0_rgba(0,0,0,0.8)] h-[400px] flex flex-col">
                <div class="border-b border-[#333] border-line pb-2 mb-3 flex justify-between items-center">
                    <h3 class="text-xs font-bold font-mono text-white uppercase tracking-widest">> Minhas_Postagens</h3>
                    <span class="text-[10px] font-mono text-gray-500">[ <%= (postagens != null) ? postagens.size() : 0 %> ]</span>
                </div>

                <div class="flex-1 overflow-y-auto terminal-scroll space-y-3 pr-1">
                    <% 
                        if (postagens != null && !postagens.isEmpty()) {
                            for (Postagem p : postagens) {
                                String statusColor = "text-yellow-500 border-yellow-800 bg-[#1a1a0f]";
                                if ("APROVADA".equals(p.getStatus())) { statusColor = "text-green-400 border-green-800 bg-[#0f1f0f]"; }
                                else if ("REJEITADA".equals(p.getStatus())) { statusColor = "text-red-400 border-red-800 bg-[#2a1111]"; }
                    %>
                    <div class="bg-[#111] input-light p-3 border border-[#333] border-line space-y-1.5 font-mono">
                        <div class="flex justify-between items-start">
                            <span class="text-[9px] text-gray-500"><%= p.getDataFormatada() %></span>
                            <span class="text-[9px] px-1.5 py-0.5 border uppercase font-bold <%= statusColor %>"><%= p.getStatus() %></span>
                        </div>
                        <h4 class="text-xs font-bold text-white truncate"><%= p.getTitulo() %></h4>
                        <p class="text-[10px] text-gray-400 line-clamp-2"><%= p.getDescricao() %></p>
                        <p class="text-[9px] text-yellow-500 pt-1">Nota dada ao produto: <%= p.getNotaProduto() %>/5 ★</p>
                    </div>
                    <% 
                            }
                        } else { 
                    %>
                    <p class="text-xs font-mono text-gray-600 uppercase text-center py-10">> Nenhuma postagem criada.</p>
                    <% } %>
                </div>
            </div>

            <div class="bg-[#0a0a0c] bg-panel border border-[#333] border-line p-5 shadow-[6px_6px_0_rgba(0,0,0,0.8)] h-[400px] flex flex-col">
                <div class="border-b border-[#333] border-line pb-2 mb-3 flex justify-between items-center">
                    <h3 class="text-xs font-bold font-mono text-white uppercase tracking-widest">> Minhas_Avaliações</h3>
                    <span class="text-[10px] font-mono text-gray-500">[ <%= (avaliacoes != null) ? avaliacoes.size() : 0 %> ]</span>
                </div>

                <div class="flex-1 overflow-y-auto terminal-scroll space-y-3 pr-1">
                    <% 
                        if (avaliacoes != null && !avaliacoes.isEmpty()) {
                            for (Avaliacao av : avaliacoes) {
                                String estrelas = "★".repeat(av.getNota()) + "☆".repeat(5 - av.getNota());
                    %>
                    <div class="bg-[#111] input-light p-3 border border-[#333] border-line space-y-1 font-mono">
                        <div class="flex justify-between items-center">
                            <span class="text-[10px] text-[#a855f7]">Postagem #<%= av.getPostagemId() %></span>
                            <span class="text-[10px] text-yellow-500"><%= estrelas %> (<%= av.getNota() %>/5)</span>
                        </div>
                        <p class="text-xs text-gray-300 font-sans"><%= av.getComentario() %></p>
                    </div>
                    <% 
                            }
                        } else { 
                    %>
                    <p class="text-xs font-mono text-gray-600 uppercase text-center py-10">> Nenhuma avaliação enviada.</p>
                    <% } %>
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
    </script>
</body>
</html>