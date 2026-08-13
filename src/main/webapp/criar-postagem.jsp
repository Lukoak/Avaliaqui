<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Produto" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nova_Postagem - Avaliaqui</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        body { transition: background-color 0.3s, color 0.3s; }
        
        /* Scanlines */
        .scanlines {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.15) 50%);
            background-size: 100% 4px; pointer-events: none; z-index: 9999;
        }

        /* TEMA CLARO - HIGH CONTRAST DESIGN SYSTEM */
        body.light-mode { background-color: #f8fafc; color: #0f172a; }
        body.light-mode .bg-panel { background-color: #ffffff; border-color: #94a3b8; }
        body.light-mode .border-line { border-color: #cbd5e1; }
        body.light-mode .input-light { background-color: #f1f5f9; border-color: #94a3b8; color: #0f172a; }
        body.light-mode .scanlines { opacity: 0.2; }

        /* Regras Universais de Inversão de Texto para Leitura Perfeita */
        body.light-mode .text-white { color: #0f172a !important; }
        body.light-mode .text-gray-200 { color: #1e293b !important; }
        body.light-mode .text-gray-300 { color: #334155 !important; }
        body.light-mode .text-gray-400 { color: #475569 !important; font-weight: 600; }
        body.light-mode .text-gray-500 { color: #64748b !important; }
        body.light-mode .text-[#a855f7] { color: #6b21a8 !important; }
        body.light-mode .text-yellow-500 { color: #b45309 !important; }

        /* Fundo Espacial Escuro */
        .space-background {
            background-color: #050505;
            background-image: 
                radial-gradient(2px 2px at 40px 60px, rgba(255,255,255,0.8), rgba(0,0,0,0)),
                radial-gradient(2px 2px at 150px 30px, rgba(255,255,255,0.6), rgba(0,0,0,0)),
                radial-gradient(2px 2px at 90px 140px, rgba(255,255,255,0.5), rgba(0,0,0,0));
            background-repeat: repeat; background-size: 300px 300px;
        }

        /* Fundo Céu Claro Vetorial */
        body.light-mode .space-background {
            background-color: #38bdf8;
            background-image: linear-gradient(180deg, #0284c7 0%, #38bdf8 50%, #bae6fd 100%);
            background-repeat: no-repeat; background-size: 100% 100%; background-attachment: fixed;
        }

        .btn-terminal {
            background-color: transparent; color: #a855f7; border: 1px solid #a855f7;
            transition: all 0.2s ease-in-out; text-transform: uppercase; letter-spacing: 0.05em;
        }
        .btn-terminal:hover { background-color: #a855f7; color: #fff; box-shadow: 0 0 8px rgba(168,85,247,0.5); }
        body.light-mode .btn-terminal { color: #6b21a8; border-color: #6b21a8; font-weight: bold; }
        body.light-mode .btn-terminal:hover { background-color: #6b21a8; color: #ffffff; }
        
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
<body class="space-background text-gray-200 font-sans min-h-screen relative select-none pb-12">
    
    <div class="scanlines"></div>
    <script>if (localStorage.getItem("theme") === "light") document.body.classList.add("light-mode");</script>

    <header class="h-14 border-b border-[#333] border-line flex items-center justify-between px-6 bg-[#0a0a0c] bg-panel relative z-10 shadow-[0_4px_0_rgba(0,0,0,0.5)]">
        <div class="flex items-center gap-4">
            <a href="arvore" class="text-lg font-bold text-[#a855f7] tracking-widest font-mono" style="text-shadow: 0 0 8px rgba(168,85,247,0.5);">
                AVALIA<span class="text-white">QUI</span>
            </a>
            <span class="bg-[#111] input-light text-[#a855f7] font-mono text-[10px] px-2 py-0.5 border border-[#333] border-line uppercase">NOVA_POSTAGEM.SYS</span>
        </div>
        <div class="flex items-center gap-4 text-xs font-mono uppercase tracking-wider">
            <button onclick="toggleTheme()" id="theme-btn" class="text-gray-400 hover:text-white border border-[#333] border-line px-2 py-1 bg-[#111] bg-panel transition-colors">
                [ MODO CLARO ]
            </button>
            <a href="arvore" class="text-[#a855f7] hover:text-white transition-colors border-b border-[#a855f7] pb-0.5">< CANCELAR</a>
        </div>
    </header>

    <main class="max-w-2xl mx-auto p-6 mt-6 relative z-10">
        
        <div class="bg-[#0a0a0c] bg-panel border border-[#333] border-line p-6 shadow-[8px_8px_0_rgba(0,0,0,0.8)] body.light-mode:shadow-[4px_4px_0_rgba(0,0,0,0.1)]">
            
            <div class="border-b border-[#333] border-line pb-4 mb-6 flex justify-between items-center">
                <div>
                    <h2 class="text-xl font-bold text-white font-mono uppercase tracking-wide">> CRIAR_RELATO</h2>
                    <p class="text-xs font-mono text-gray-400 mt-1">Sua publicação passará por moderação antes de ser exibida.</p>
                </div>
                <span class="font-mono text-[10px] text-yellow-500 bg-[#111] input-light border border-[#333] border-line px-2 py-1 uppercase">
                    LIMITE: 2 / DIA
                </span>
            </div>

            <% String erro = (String) request.getAttribute("mensagemErro"); %>
            <% if (erro != null) { %>
                <div class="bg-[#2a1111] border border-red-900 text-red-400 p-3 mb-6 font-mono text-[11px] shadow-[4px_4px_0_rgba(0,0,0,0.5)] uppercase">
                    [SYS_WARN] <%= erro %>
                </div>
            <% } %>

            <% String sucesso = (String) request.getAttribute("mensagemSucesso"); %>
            <% if (sucesso != null) { %>
                <div class="bg-[#0f1f0f] border border-green-700 text-green-400 p-3 mb-6 font-mono text-[11px] shadow-[4px_4px_0_rgba(0,0,0,0.5)] uppercase">
                    [SYS_OK] <%= sucesso %>
                </div>
            <% } %>

            <form action="criar-postagem" method="POST" class="space-y-5">
                
                <div>
                    <label class="block text-[11px] font-bold text-gray-400 mb-1 font-mono uppercase tracking-widest">Produto Alvo (Target)</label>
                    <select name="produtoId" required class="w-full px-3 py-2.5 bg-[#111] input-light border border-[#333] border-line text-sm text-gray-200 focus:outline-none focus:border-[#a855f7] font-mono transition-colors rounded-none appearance-none">
                        <option value="" disabled selected>Selecione o produto que deseja avaliar...</option>
                        <% 
                            List<Produto> produtos = (List<Produto>) request.getAttribute("listaProdutos");
                            if (produtos != null) {
                                for (Produto p : produtos) { 
                        %>
                            <option value="<%= p.getId() %>"><%= p.getNome() %></option>
                        <%      } 
                            } 
                        %>
                    </select>
                </div>

                <div>
                    <label class="block text-[11px] font-bold text-gray-400 mb-1 font-mono uppercase tracking-widest">Sua Nota para este Produto</label>
                    <select name="notaProduto" required class="w-full px-3 py-2.5 bg-[#111] input-light border border-[#333] border-line text-sm text-yellow-500 font-bold focus:outline-none focus:border-[#a855f7] font-mono transition-colors rounded-none appearance-none">
                        <option value="5" selected>★★★★★ (5/5 - Excelente)</option>
                        <option value="4">★★★★☆ (4/5 - Bom)</option>
                        <option value="3">★★★☆☆ (3/5 - Regular)</option>
                        <option value="2">★★☆☆☆ (2/5 - Ruim)</option>
                        <option value="1">★☆☆☆☆ (1/5 - Péssimo)</option>
                    </select>
                </div>

                <div>
                    <label class="block text-[11px] font-bold text-gray-400 mb-1 font-mono uppercase tracking-widest">Título do Relato</label>
                    <input type="text" name="titulo" required placeholder="Ex: Ressecou minha pele nas primeiras 2 semanas..."
                           class="w-full px-3 py-2.5 bg-[#111] input-light border border-[#333] border-line text-sm text-gray-200 focus:outline-none focus:border-[#a855f7] font-mono transition-colors">
                </div>

                <div>
                    <label class="block text-[11px] font-bold text-gray-400 mb-1 font-mono uppercase tracking-widest">Descrição do Relato / Experiência</label>
                    <textarea name="descricao" rows="5" required placeholder="Descreva em detalhes como foi seu uso com este produto..."
                              class="w-full px-3 py-2.5 bg-[#111] input-light border border-[#333] border-line text-sm text-gray-200 focus:outline-none focus:border-[#a855f7] font-sans leading-relaxed transition-colors"></textarea>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-[11px] font-bold text-gray-400 mb-1 font-mono uppercase tracking-widest">URL da Imagem (Opcional)</label>
                        <input type="url" name="imagemUrl" placeholder="https://..."
                               class="w-full px-3 py-2 bg-[#111] input-light border border-[#333] border-line text-xs text-gray-200 focus:outline-none focus:border-[#a855f7] font-mono transition-colors">
                    </div>
                    <div>
                        <label class="block text-[11px] font-bold text-gray-400 mb-1 font-mono uppercase tracking-widest">Link de Referência (Opcional)</label>
                        <input type="url" name="linkReferencia" placeholder="https://..."
                               class="w-full px-3 py-2 bg-[#111] input-light border border-[#333] border-line text-xs text-gray-200 focus:outline-none focus:border-[#a855f7] font-mono transition-colors">
                    </div>
                </div>

                <div class="pt-4 border-t border-[#333] border-line flex justify-end gap-4">
                    <a href="arvore" class="px-5 py-2.5 border border-[#333] border-line text-xs font-mono text-gray-400 hover:text-white uppercase transition-colors">
                        [ CANCELAR ]
                    </a>
                    <button type="submit" class="btn-terminal px-6 py-2.5 text-xs font-bold font-mono uppercase">
                        [ SUBMETER PARA MODERAÇÃO ]
                    </button>
                </div>

            </form>
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