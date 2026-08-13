<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Categoria" %>
<%@ page import="model.Marca" %>
<%@ page import="model.Produto" %>
<%@ page import="java.util.List" %>

<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null || (!usuarioLogado.getPerfilAcesso().equals("Administrador") && !usuarioLogado.getPerfilAcesso().equals("Root") && !usuarioLogado.getPerfilAcesso().equals("Suporte"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean isSuporte = usuarioLogado.getPerfilAcesso().equals("Suporte");
    
    // Recupera as listas enviadas pelo Servlet
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("listaUsuarios");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("listaCategorias");
    List<Marca> marcas = (List<Marca>) request.getAttribute("listaMarcas");
    List<Produto> produtos = (List<Produto>) request.getAttribute("listaProdutos");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SYS_ADMIN - Avaliaqui</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { transition: background-color 0.3s, color 0.3s; }

        .scanlines {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.15) 50%);
            background-size: 100% 4px; pointer-events: none; z-index: 9999;
        }

        /* Tema Claro */
        body.light-mode { background-color: #f0f9ff; color: #111827; }
        body.light-mode .bg-panel { background-color: #ffffff; border-color: #94a3b8; }
        body.light-mode .border-line { border-color: #cbd5e1; }
        body.light-mode .input-light { background-color: #f8fafc; border-color: #94a3b8; color: #0f172a; }
        body.light-mode .scanlines { opacity: 0.3; }

        /* Ajustes de visibilidade Modo Claro */
        body.light-mode .text-gray-300 { color: #334155; }
        body.light-mode .text-gray-400 { color: #475569; }
        body.light-mode .text-gray-500 { color: #64748b; }
        body.light-mode .text-gray-600 { color: #94a3b8; }
        body.light-mode .text-white { color: #0f172a; }

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

        .terminal-scroll::-webkit-scrollbar { width: 6px; height: 6px; }
        .terminal-scroll::-webkit-scrollbar-track { background: #0a0a0c; }
        .terminal-scroll::-webkit-scrollbar-thumb { background: #333; }
        body.light-mode .terminal-scroll::-webkit-scrollbar-track { background: #f8fafc; }
        body.light-mode .terminal-scroll::-webkit-scrollbar-thumb { background: #94a3b8; }

        .btn-action { background-color: transparent; border: 1px solid #a855f7; color: #a855f7; transition: all 0.2s; }
        .btn-action:hover { background-color: #a855f7; color: #fff; box-shadow: inset 0 0 8px rgba(168,85,247,0.5); }
        .btn-danger { background-color: transparent; border: 1px solid #7f1d1d; color: #f87171; transition: all 0.2s; }
        .btn-danger:hover { background-color: #7f1d1d; color: #fff; }

        /* Estilo da Tabela/Planilha */
        .crud-table th { padding: 10px; border-bottom: 1px solid #333; text-transform: uppercase; font-size: 10px; color: #6b7280; font-family: monospace; }
        .crud-table td { padding: 10px; border-bottom: 1px solid #333; font-size: 12px; font-family: monospace; }
        body.light-mode .crud-table th, body.light-mode .crud-table td { border-bottom-color: #cbd5e1; }
        .crud-table tbody tr:hover { background-color: #111; }
        body.light-mode .crud-table tbody tr:hover { background-color: #f1f5f9; }
        
        /* Oculta as abas que não estão ativas */
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        
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
            <span class="bg-[#111] input-light text-[#a855f7] font-mono text-[10px] px-2 py-0.5 border border-[#333] border-line uppercase">Administrador.SYS</span>
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
            <h2 class="text-xl font-bold tracking-widest text-white uppercase font-mono">> GESTÃO_DO_SISTEMA</h2>
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

        <div class="flex flex-wrap gap-2 border-b border-[#333] border-line mb-6 font-mono text-xs">
            <button onclick="openTab(event, 'tab-categorias')" class="tab-btn px-4 py-2 text-[#a855f7] border-b-2 border-[#a855f7] uppercase font-bold transition-colors">Categorias</button>
            <button onclick="openTab(event, 'tab-marcas')" class="tab-btn px-4 py-2 text-gray-500 hover:text-white border-b-2 border-transparent uppercase transition-colors">Marcas</button>
            <button onclick="openTab(event, 'tab-produtos')" class="tab-btn px-4 py-2 text-gray-500 hover:text-white border-b-2 border-transparent uppercase transition-colors">Produtos</button>
            <button onclick="openTab(event, 'tab-usuarios')" class="tab-btn px-4 py-2 text-gray-500 hover:text-white border-b-2 border-transparent uppercase transition-colors">Usuários_SYS</button>
        </div>

        <div class="bg-[#0a0a0c] bg-panel border border-[#333] border-line p-6 shadow-[6px_6px_0_rgba(0,0,0,0.8)] body.light-mode:shadow-[4px_4px_0_rgba(0,0,0,0.1)]">
            
            <div id="tab-categorias" class="tab-content active">
                <h3 class="text-sm font-bold text-white uppercase font-mono mb-4 border-b border-[#333] border-line pb-2">> Nova Categoria (Nó Raiz)</h3>
                <form action="admin" method="POST" class="flex gap-4 mb-8">
                    <input type="hidden" name="acao" value="criarCategoria">
                    <input type="text" name="nome_no" placeholder="Ex: Higiene Pessoal" required class="flex-1 bg-[#111] input-light border border-[#333] border-line p-2 text-xs font-mono text-white focus:border-[#a855f7] outline-none">
                    <button type="submit" class="btn-action px-6 py-2 text-xs font-bold font-mono uppercase">[ CRIAR ]</button>
                </form>

                <h3 class="text-sm font-bold text-gray-400 uppercase font-mono mb-4">> Planilha de Categorias</h3>
                <div class="overflow-x-auto terminal-scroll border border-[#333] border-line">
                    <table class="w-full text-left border-collapse crud-table">
                        <thead class="bg-[#111] input-light">
                            <tr>
                                <th class="w-16">ID</th>
                                <th>Nome da Categoria</th>
                                <th class="w-32 text-center">Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (categorias != null) { for (Categoria c : categorias) { %>
                            <tr>
                                <td class="text-[#a855f7]">#<%= c.getId() %></td>
                                <td class="text-white"><%= c.getNome() %></td>
                                <td class="text-center">
                                    <form action="admin" method="POST" class="inline">
                                        <input type="hidden" name="acao" value="excluirNode">
                                        <input type="hidden" name="tipo_no" value="categoria">
                                        <input type="hidden" name="id_no" value="<%= c.getId() %>">
                                        <button type="submit" class="btn-danger px-2 py-1 text-[9px] uppercase">[ DELETAR ]</button>
                                    </form>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="tab-marcas" class="tab-content">
                <h3 class="text-sm font-bold text-white uppercase font-mono mb-4 border-b border-[#333] border-line pb-2">> Nova Marca (Sub-Nó)</h3>
                <form action="admin" method="POST" class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                    <input type="hidden" name="acao" value="criarMarca">
                    <input type="text" name="nome_no" placeholder="Ex: Natura" required class="bg-[#111] input-light border border-[#333] border-line p-2 text-xs font-mono text-white focus:border-[#a855f7] outline-none">
                    <select name="parent_id" required class="bg-[#111] input-light border border-[#333] border-line p-2 text-xs font-mono text-gray-400 focus:border-[#a855f7] outline-none">
                        <option value="" disabled selected>Pertence a qual Categoria?</option>
                        <% if (categorias != null) { for (Categoria c : categorias) { %>
                            <option value="<%= c.getId() %>"><%= c.getNome() %></option>
                        <% } } %>
                    </select>
                    <button type="submit" class="btn-action py-2 text-xs font-bold font-mono uppercase">[ CRIAR ]</button>
                </form>

                <h3 class="text-sm font-bold text-gray-400 uppercase font-mono mb-4">> Planilha de Marcas</h3>
                <div class="overflow-x-auto terminal-scroll border border-[#333] border-line">
                    <table class="w-full text-left border-collapse crud-table">
                        <thead class="bg-[#111] input-light">
                            <tr>
                                <th class="w-16">ID</th>
                                <th>Nome da Marca</th>
                                <th>ID Categoria_Pai</th>
                                <th class="w-32 text-center">Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (marcas != null) { for (Marca m : marcas) { %>
                            <tr>
                                <td class="text-[#a855f7]">#<%= m.getId() %></td>
                                <td class="text-white"><%= m.getNome() %></td>
                                <td class="text-gray-500">Parent_ID: <%= m.getCategoria_id() %></td>
                                <td class="text-center">
                                    <form action="admin" method="POST" class="inline">
                                        <input type="hidden" name="acao" value="excluirNode">
                                        <input type="hidden" name="tipo_no" value="marca">
                                        <input type="hidden" name="id_no" value="<%= m.getId() %>">
                                        <button type="submit" class="btn-danger px-2 py-1 text-[9px] uppercase">[ DELETAR ]</button>
                                    </form>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="tab-produtos" class="tab-content">
                <h3 class="text-sm font-bold text-white uppercase font-mono mb-4 border-b border-[#333] border-line pb-2">> Novo Produto (Nó Final)</h3>
                <form action="admin" method="POST" class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                    <input type="hidden" name="acao" value="criarProduto">
                    <input type="text" name="nome_no" placeholder="Ex: Sabonete Líquido" required class="bg-[#111] input-light border border-[#333] border-line p-2 text-xs font-mono text-white focus:border-[#a855f7] outline-none">
                    <select name="parent_id" required class="bg-[#111] input-light border border-[#333] border-line p-2 text-xs font-mono text-gray-400 focus:border-[#a855f7] outline-none">
                        <option value="" disabled selected>Pertence a qual Marca?</option>
                        <% if (marcas != null) { for (Marca m : marcas) { %>
                            <option value="<%= m.getId() %>"><%= m.getNome() %></option>
                        <% } } %>
                    </select>
                    <button type="submit" class="btn-action py-2 text-xs font-bold font-mono uppercase">[ CRIAR ]</button>
                </form>

                <h3 class="text-sm font-bold text-gray-400 uppercase font-mono mb-4">> Planilha de Produtos</h3>
                <div class="overflow-x-auto terminal-scroll border border-[#333] border-line max-h-[500px]">
                    <table class="w-full text-left border-collapse crud-table">
                        <thead class="bg-[#111] input-light sticky top-0">
                            <tr>
                                <th class="w-16">ID</th>
                                <th>Nome do Produto</th>
                                <th>ID Marca_Pai</th>
                                <th class="w-32 text-center">Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (produtos != null) { for (Produto p : produtos) { %>
                            <tr>
                                <td class="text-[#a855f7]">#<%= p.getId() %></td>
                                <td class="text-white"><%= p.getNome() %></td>
                                <td class="text-gray-500">Parent_ID: <%= p.getMarca_id() %></td>
                                <td class="text-center">
                                    <form action="admin" method="POST" class="inline">
                                        <input type="hidden" name="acao" value="excluirNode">
                                        <input type="hidden" name="tipo_no" value="produto">
                                        <input type="hidden" name="id_no" value="<%= p.getId() %>">
                                        <button type="submit" class="btn-danger px-2 py-1 text-[9px] uppercase">[ DELETAR ]</button>
                                    </form>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="tab-usuarios" class="tab-content">
                <h3 class="text-sm font-bold text-white uppercase font-mono mb-4 border-b border-[#333] border-line pb-2">> Planilha de Usuários Registrados</h3>
                <div class="overflow-x-auto terminal-scroll border border-[#333] border-line max-h-[600px]">
                    <table class="w-full text-left border-collapse crud-table">
                        <thead class="bg-[#111] input-light sticky top-0 z-10">
                            <tr>
                                <th>ID_USR</th>
                                <th>E-mail</th>
                                <th>Nome/Nick</th>
                                <th>Pontuação</th>
                                <th>Status</th>
                                <th>Cargo Atual</th>
                                <% if (!isSuporte) { %>
                                <th class="text-right">Gerenciar Permissões</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (usuarios != null) { for (Usuario u : usuarios) { %>
                            <tr>
                                <td class="text-[#a855f7]">#<%= u.getId() %></td>
                                <td class="text-gray-400"><%= u.getEmail() %></td>
                                <td class="text-white"><%= u.getNome() %></td>
                                <td class="text-yellow-500 font-bold"><%= u.getPontuacao() %> pts</td>
                                <td>
                                    <% if ("Ativo".equals(u.getStatus())) { %>
                                        <span class="text-green-500">Ativo</span>
                                        <form action="admin" method="POST" class="inline ml-2">
                                            <input type="hidden" name="acao" value="suspender">
                                            <input type="hidden" name="usuarioId" value="<%= u.getId() %>">
                                            <button type="submit" class="text-[9px] text-red-500 hover:text-white border border-red-900 px-1 uppercase">[ BANIR ]</button>
                                        </form>
                                    <% } else { %>
                                        <span class="text-red-500">Suspenso</span>
                                        <form action="admin" method="POST" class="inline ml-2">
                                            <input type="hidden" name="acao" value="reativar">
                                            <input type="hidden" name="usuarioId" value="<%= u.getId() %>">
                                            <button type="submit" class="text-[9px] text-green-500 hover:text-white border border-green-900 px-1 uppercase">[ REATIVAR ]</button>
                                        </form>
                                    <% } %>
                                </td>
                                <td class="text-[#a855f7]"><%= u.getPerfilAcesso() %></td>
								<% if (!isSuporte) { %>
                                <td class="text-right">
                                    <%-- Trava 3: Impede a edição do usuário Root --%>
                                    <% if ("Root".equals(u.getPerfilAcesso())) { %>
                                        <span class="text-[10px] font-mono text-red-500 font-bold border border-red-900 px-2 py-1 bg-[#1a0f0f] input-light uppercase">[ ACESSO_INTOCÁVEL ]</span>
                                    <% } else { %>
                                    
                                    <%-- Trava 1: Alerta de confirmação no evento onsubmit --%>
                                    <form action="admin" method="POST" class="flex items-center justify-end gap-2" 
                                          onsubmit="return confirm('ATENÇÃO_SYS: Tem certeza que deseja alterar os privilégios deste usuário? Esta ação mudará as permissões dele imediatamente.');">
                                        <input type="hidden" name="acao" value="mudarCargo">
                                        <input type="hidden" name="usuarioId" value="<%= u.getId() %>">
                                        
                                        <%-- Trava 2: Seleciona dinamicamente o cargo atual do usuário --%>
                                        <select name="novoCargo" class="bg-[#050505] input-light border border-[#333] border-line text-[10px] text-gray-300 focus:outline-none focus:border-[#a855f7] font-mono outline-none">
                                            <option value="Avaliador" <%= "Avaliador".equals(u.getPerfilAcesso()) ? "selected" : "" %>>Avaliador</option>
                                            <option value="Revisor" <%= "Revisor".equals(u.getPerfilAcesso()) ? "selected" : "" %>>Revisor</option>
                                            <option value="Suporte" <%= "Suporte".equals(u.getPerfilAcesso()) ? "selected" : "" %>>Suporte</option>
                                            <option value="Administrador" <%= "Administrador".equals(u.getPerfilAcesso()) ? "selected" : "" %>>Administrador</option>
                                        </select>
                                        <button type="submit" class="btn-action px-2 py-1 text-[9px] uppercase">[ APLICAR ]</button>
                                    </form>
                                    
                                    <% } %>
                                </td>
                                <% } %>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
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

        // Função para trocar as abas
        function openTab(evt, tabName) {
            // Esconde todo o conteúdo das abas
            const tabContents = document.getElementsByClassName("tab-content");
            for (let i = 0; i < tabContents.length; i++) {
                tabContents[i].classList.remove("active");
            }

            // Remove a classe visual de "Ativo" de todos os botões
            const tabBtns = document.getElementsByClassName("tab-btn");
            for (let i = 0; i < tabBtns.length; i++) {
                tabBtns[i].classList.remove("text-[#a855f7]", "border-[#a855f7]");
                tabBtns[i].classList.add("text-gray-500", "border-transparent");
            }

            // Mostra o conteúdo da aba selecionada e adiciona estilo ao botão
            document.getElementById(tabName).classList.add("active");
            evt.currentTarget.classList.remove("text-gray-500", "border-transparent");
            evt.currentTarget.classList.add("text-[#a855f7]", "border-[#a855f7]");
        }
    </script>
</body>
</html>