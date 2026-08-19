<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
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
    <title>A R V O R E [Wired]</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://d3js.org/d3.v7.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { transition: background-color 0.3s, color 0.3s; }
        
        .scanlines {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.15) 50%);
            background-size: 100% 4px; pointer-events: none; z-index: 9999;
        }

        /* --- BLOCO UNIVERSAL DE CONTRASTE & DESIGN SYSTEM --- */
        body.light-mode { background-color: #f8fafc; color: #0f172a; }
        body.light-mode .bg-panel { background-color: #ffffff; border-color: #94a3b8; }
        body.light-mode .border-line { border-color: #cbd5e1; }
        body.light-mode .input-light { background-color: #f1f5f9; border-color: #94a3b8; color: #0f172a; }
        body.light-mode .scanlines { opacity: 0.2; } 

        body.light-mode .text-white { color: #0f172a !important; }
        body.light-mode .text-gray-200 { color: #1e293b !important; }
        body.light-mode .text-gray-300 { color: #334155 !important; }
        body.light-mode .text-gray-400 { color: #475569 !important; font-weight: 600; }
        body.light-mode .text-gray-500 { color: #64748b !important; }
        body.light-mode .text-[#a855f7] { color: #6b21a8 !important; }
        body.light-mode .text-yellow-500 { color: #b45309 !important; }

        .menu-item { transition: all 0.2s; }
        .menu-item:hover { background-color: #222; color: #ffffff !important; }
        body.light-mode .menu-item { color: #334155; }
        body.light-mode .menu-item:hover { background-color: #e2e8f0; color: #0f172a !important; }
        
        .hover-logout { transition: all 0.2s; }
        .hover-logout:hover { background-color: rgba(127, 29, 29, 0.3); color: #f87171 !important; }
        body.light-mode .hover-logout:hover { background-color: #fee2e2; color: #dc2626 !important; }

        .space-background {
            background-color: #050505;
            background-image: 
                radial-gradient(2px 2px at 40px 60px, rgba(255,255,255,0.8), rgba(0,0,0,0)),
                radial-gradient(2px 2px at 150px 30px, rgba(255,255,255,0.6), rgba(0,0,0,0)),
                radial-gradient(2px 2px at 90px 140px, rgba(255,255,255,0.5), rgba(0,0,0,0));
            background-repeat: repeat; background-size: 300px 300px;
        }

        body.light-mode .space-background {
            background-color: #f1f5f9;
            background-image: radial-gradient(#cbd5e1 1.5px, transparent 1.5px);
            background-size: 24px 24px; background-attachment: fixed;
        }

        /* --- D3.JS ELEMENTOS DA ÁRVORE --- */
        .node text { 
            font-family: monospace; font-size: 14px; fill: #e5e7eb; 
            text-shadow: 0px 0px 8px rgba(168, 85, 247, 0.9), 0px 0px 15px rgba(168, 85, 247, 0.5);
            transition: all 0.2s;
        }
        .node:hover text { fill: #ffffff; text-shadow: 0px 0px 10px rgba(168, 85, 247, 1), 0px 0px 20px rgba(255, 255, 255, 0.8); }
        body.light-mode .node text { 
            fill: #0f172a; font-weight: 800; paint-order: stroke fill;
            stroke: #ffffff; stroke-width: 4px; stroke-linejoin: round; text-shadow: none;
        }
        body.light-mode .node:hover text { fill: #ea580c; }
        
        .link { fill: none; stroke: #4c1d95; stroke-width: 1.5px; opacity: 0.6; }
        body.light-mode .link { stroke: #2563eb; stroke-width: 2px; opacity: 0.85; }

        .btn-action { background-color: transparent; border: 1px solid #a855f7; color: #a855f7; transition: all 0.2s; }
        .btn-action:hover { background-color: #a855f7; color: #fff; box-shadow: inset 0 0 8px rgba(168,85,247,0.5); }
        body.light-mode .btn-action { background-color: #2563eb; color: #ffffff; border: 1px solid #1d4ed8; }
        body.light-mode .btn-action:hover { background-color: #1d4ed8; }

        .btn-terminal { background-color: transparent; color: #a855f7; border: 1px solid #a855f7; transition: all 0.2s ease-in-out; text-transform: uppercase; letter-spacing: 0.1em; }
        .btn-terminal:hover { background-color: #a855f7; color: #fff; box-shadow: 0 0 8px rgba(168,85,247,0.5); }
        body.light-mode .btn-terminal { color: #6b21a8; border-color: #6b21a8; font-weight: bold; }
        body.light-mode .btn-terminal:hover { background-color: #6b21a8; color: #ffffff !important; }
        
        .terminal-scroll::-webkit-scrollbar { width: 6px; }
        .terminal-scroll::-webkit-scrollbar-track { background: #0a0a0c; border-left: 1px solid #333; }
        .terminal-scroll::-webkit-scrollbar-thumb { background: #333; }
        body.light-mode .terminal-scroll::-webkit-scrollbar-track { background: #f8fafc; border-left: 1px solid #cbd5e1; }
        body.light-mode .terminal-scroll::-webkit-scrollbar-thumb { background: #94a3b8; }

        /* --- ANIMAÇÕES DE IMERSÃO (RIPPLE / PULSE) --- */
        @keyframes haloPulse {
            0% { r: 6px; opacity: 0.8; stroke-width: 2px; }
            100% { r: 22px; opacity: 0; stroke-width: 0px; }
        }
        .node .halo { fill: none; pointer-events: none; }
        .node .halo.active { animation: haloPulse 2s infinite cubic-bezier(0.1, 0.8, 0.3, 1); }
        
        .node .node-dot { transition: all 0.3s; stroke-width: 2.5px; }
        .node:hover .node-dot { box-shadow: 0 0 10px #fff; }

        @keyframes moveClick {
            0% { transform: translate(0px, 0px); }
            35% { transform: translate(-30px, -25px); }
            45% { transform: translate(-30px, -25px) scale(0.85); }
            55% { transform: translate(-30px, -25px) scale(1); }
            100% { transform: translate(0px, 0px); }
        }
        .pointer-anim { animation: moveClick 3s infinite ease-in-out; }
        
        @keyframes circleReactDark {
            0%, 40% { background-color: #a855f7; border: 2px solid transparent; }
            50%, 100% { background-color: transparent; border: 2px solid #a855f7; }
        }
        @keyframes circleReactLight {
            0%, 40% { background-color: #ea580c; border: 2px solid transparent; }
            50%, 100% { background-color: #ffffff; border: 2px solid #ea580c; }
        }
        
        #sim-circle { animation: circleReactDark 3s infinite ease-in-out; }
        body.light-mode #sim-circle { animation: circleReactLight 3s infinite ease-in-out; }
        
        .sim-halo {
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
            width: 16px; height: 16px; rounded: full; border: 2px solid #a855f7; border-radius: 50%;
            animation: simHaloPulse 3s infinite ease-out; opacity: 0;
        }
        body.light-mode .sim-halo { border-color: #ea580c; }
        
        @keyframes simHaloPulse {
            0%, 40% { width: 16px; height: 16px; opacity: 0.8; }
            50%, 100% { width: 50px; height: 50px; opacity: 0; }
        }
    </style>
</head>
<body class="bg-[#050505] text-gray-200 flex h-screen overflow-hidden font-sans select-none relative">
    
    <div class="scanlines"></div>
    <script>if (localStorage.getItem("theme") === "light") document.body.classList.add("light-mode");</script>

    <div id="tutorial-modal" class="fixed inset-0 z-[200] flex items-center justify-center bg-black/80 backdrop-blur-sm hidden">
        <div class="bg-[#0a0a0c] bg-panel border border-[#a855f7] border-line p-8 max-w-md w-full shadow-[0_0_30px_rgba(168,85,247,0.3)] body.light-mode:shadow-[0_10px_30px_rgba(0,0,0,0.1)]">
            <h2 class="text-lg font-bold text-white font-mono mb-2 uppercase tracking-widest">> MANUAL_DO_SISTEMA</h2>
            <p class="text-sm text-gray-400 font-sans mb-6">Para explorar o diretório de produtos, clique nas <span class="text-[#a855f7] font-bold">esferas coloridas</span> que estão a pulsar ou nos <span class="text-white font-bold">nomes</span> para expandir os ramais da árvore.</p>
            
            <div class="relative w-full h-32 bg-[#050505] input-light border border-[#333] border-line flex items-center justify-center overflow-hidden mb-6 shadow-[inset_0_0_15px_rgba(0,0,0,0.5)]">
                <div class="flex items-center gap-3 relative z-10">
                    <div class="relative w-4 h-4 flex items-center justify-center">
                        <div class="sim-halo"></div>
                        <div id="sim-circle" class="w-4 h-4 rounded-full bg-[#a855f7] relative z-10"></div>
                    </div>
                    <span class="font-mono text-sm text-white font-bold tracking-widest">EXPANDIR_NÓ</span>
                </div>
                <i class="fas fa-mouse-pointer absolute text-white text-xl z-20 pointer-anim" style="top: 75px; left: 220px; filter: drop-shadow(2px 2px 2px rgba(0,0,0,0.8));"></i>
            </div>

            <div class="flex items-center gap-3 mb-6">
                <input type="checkbox" id="dont-show-again" class="w-4 h-4 accent-[#a855f7] cursor-pointer">
                <label for="dont-show-again" class="text-xs font-mono text-gray-500 uppercase tracking-widest cursor-pointer hover:text-white transition">NÃO MOSTRAR ESTE GUIA NOVAMENTE</label>
            </div>
            
            <button onclick="closeTutorial()" class="w-full bg-transparent border border-[#a855f7] text-[#a855f7] hover:bg-[#a855f7] hover:text-white py-2.5 font-mono text-xs font-bold uppercase tracking-widest transition-colors">
                [ ENTENDIDO. INICIAR SISTEMA ]
            </button>
        </div>
    </div>

    <main class="flex-1 flex flex-col min-w-0 relative">
        <header class="h-14 border-b border-[#333] border-line flex items-center justify-between px-6 bg-[#0a0a0c] bg-panel z-[60] relative">
            <div class="flex items-center gap-6">
                <a href="arvore" class="text-lg font-bold tracking-widest text-[#a855f7] uppercase font-mono" style="text-shadow: 0 0 8px rgba(168,85,247,0.5);">
                    AVALIA<span class="text-white">QUI</span>
                </a>
                <nav class="hidden md:flex gap-4 text-sm font-bold uppercase tracking-wider">
                    <a href="arvore" class="text-[#a855f7] border-b-2 border-[#a855f7] pb-1 hover:text-white transition-colors">Explorar</a>
                    
                    <% if (usuarioLogado.getPerfilAcesso().equals("Revisor") || usuarioLogado.getPerfilAcesso().equals("Administrador") || usuarioLogado.getPerfilAcesso().equals("Root")) { %>
                        <a href="moderacao" class="text-gray-400 hover:text-white transition-colors border-b-2 border-transparent hover:border-gray-400 pb-1">Moderação</a>
                    <% } %>

                    <% if (usuarioLogado.getPerfilAcesso().equals("Suporte")) { %>
                        <a href="admin" class="text-gray-400 hover:text-white transition-colors border-b-2 border-transparent hover:border-gray-400 pb-1">Contas_SYS</a>
                    <% } else if (usuarioLogado.getPerfilAcesso().equals("Administrador") || usuarioLogado.getPerfilAcesso().equals("Root")) { %>
                        <a href="admin" class="text-gray-400 hover:text-white transition-colors border-b-2 border-transparent hover:border-gray-400 pb-1">Painel_Admin</a>
                    <% } %>
                </nav>
            </div>
            
            <div class="flex items-center gap-4">
                
                <div class="w-64 hidden lg:block relative">
                    <input type="text" id="search-input" autocomplete="off" placeholder="Buscar produto..." 
                           class="w-full bg-[#111] input-light border border-[#333] border-line rounded-none py-1.5 px-3 text-sm focus:outline-none focus:border-[#a855f7] transition-colors">
                    
                    <div id="search-results" class="hidden absolute top-full left-0 w-full bg-[#0a0a0c] bg-panel border border-[#333] border-line mt-1 shadow-[4px_4px_0_rgba(0,0,0,0.8)] body.light-mode:shadow-[4px_4px_0_rgba(0,0,0,0.1)] z-[100] max-h-60 overflow-y-auto terminal-scroll divide-y divide-[#333] border-line">
                    </div>
                </div>

                <button onclick="toggleTheme()" id="theme-btn" class="text-[11px] font-mono text-gray-400 hover:text-white border border-[#333] border-line px-2 py-1 bg-[#111] bg-panel uppercase">
                    [ Modo Claro ]
                </button>

                <div class="flex items-center gap-3 border-l border-[#333] border-line pl-4 ml-2 relative" id="user-menu-container">
                    <div class="text-right hidden sm:block">
                        <p class="text-xs font-bold text-white uppercase"><%= usuarioLogado.getNome() %></p>
                        <p class="text-[10px] text-[#a855f7] font-mono font-bold uppercase"><%= usuarioLogado.getPontuacao() %> pts</p>
                    </div>
                    
                    <button onclick="toggleDropdown(event)" class="w-8 h-8 rounded-none bg-[#111] input-light border border-[#a855f7] flex items-center justify-center text-[#a855f7] font-mono font-bold uppercase focus:outline-none hover:bg-[#a855f7] hover:text-white transition-colors shadow-[0_0_8px_rgba(168,85,247,0.3)]">
                        <%= usuarioLogado.getNome().substring(0, 1) %>
                    </button>

                    <div id="profile-dropdown" class="hidden absolute top-12 right-0 w-40 bg-[#0a0a0c] bg-panel border border-[#333] border-line z-[100] font-sans text-sm shadow-[4px_4px_0_rgba(0,0,0,0.8)] body.light-mode:shadow-[4px_4px_0_rgba(0,0,0,0.1)]">
                        <a href="perfil" class="block px-4 py-2 text-gray-300 menu-item border-b border-[#333] border-line font-bold">Meu Perfil</a>
                        <a href="login.jsp" class="block px-4 py-2 text-red-500 hover-logout font-bold">Sair</a>
                    </div>
                </div>
            </div>
        </header>

        <div class="absolute top-16 left-1/2 transform -translate-x-1/2 z-[80] w-full max-w-2xl px-4 pointer-events-none">
            <% 
                String msgSucessoAvaliacao = (String) session.getAttribute("mensagemSucesso");
                String msgErroAvaliacao = (String) session.getAttribute("mensagemErro");
                if (msgSucessoAvaliacao != null) { session.removeAttribute("mensagemSucesso"); }
                if (msgErroAvaliacao != null) { session.removeAttribute("mensagemErro"); }
            %>
            <% if (msgSucessoAvaliacao != null) { %>
                <div class="bg-[#0f1f0f] border border-green-700 text-green-400 p-3 mb-2 font-mono text-[11px] shadow-[4px_4px_0_rgba(0,0,0,0.5)] uppercase text-center w-full pointer-events-auto">
                    [SYS_OK] <%= msgSucessoAvaliacao %>
                </div>
            <% } %>
            <% if (msgErroAvaliacao != null) { %>
                <div class="bg-[#2a1111] border border-red-900 text-red-400 p-3 mb-2 font-mono text-[11px] shadow-[4px_4px_0_rgba(0,0,0,0.5)] uppercase text-center w-full pointer-events-auto">
                    [SYS_WARN] <%= msgErroAvaliacao %>
                </div>
            <% } %>
        </div>

        <div id="tree-container" class="flex-1 overflow-hidden space-background cursor-grab active:cursor-grabbing z-0 relative"></div>
    </main>

    <aside id="side-panel" class="w-[400px] bg-[#0a0a0c] bg-panel border-l border-[#333] border-line flex flex-col h-full translate-x-full transition-transform duration-300 ease-in-out absolute right-0 z-[70] shadow-[-8px_0_20px_rgba(0,0,0,0.8)] body.light-mode:shadow-[-4px_0_15px_rgba(0,0,0,0.1)]">
        <div class="p-5 border-b border-[#333] border-line flex items-start justify-between bg-[#111] input-light">
            <div>
                <span id="product-breadcrumb" class="font-mono text-[10px] text-[#a855f7] uppercase tracking-wider">Caminho</span>
                <h2 id="product-title" class="text-xl font-bold text-white mt-1">Produto</h2>
                <div class="font-mono text-sm text-yellow-500 mt-1">
                    <span id="product-stars">★★★★☆</span> <span id="product-rating-avg" class="text-gray-500">(4.5/5)</span>
                </div>
            </div>
            <button onclick="closePanel()" class="text-xs font-mono font-bold text-gray-500 hover:text-white border border-transparent hover:border-[#333] border-line px-2 py-1 transition-colors uppercase">
                [ Fechar ]
            </button>
        </div>

        <div class="flex-1 overflow-y-auto p-5 space-y-5 terminal-scroll">
            <div class="bg-[#111] input-light p-4 border border-[#333] border-line flex items-center justify-between shadow-[2px_2px_0_rgba(0,0,0,0.5)] body.light-mode:shadow-[2px_2px_0_rgba(0,0,0,0.1)]">
                <p class="text-[10px] font-mono text-gray-400 uppercase">> AVALIAR PRODUTO</p>
                <button onclick="window.location.href='criar-postagem'" class="btn-terminal text-[10px] font-bold px-3 py-1.5 transition-colors">
                    [ CRIAR RELATO ]
                </button>
            </div>
            <h3 class="text-xs font-bold uppercase text-gray-500 border-b border-[#333] border-line pb-1 font-mono tracking-widest">> TIMELINE_DE_POSTAGENS</h3>
            <div id="timeline-container" class="space-y-5">
                <p class="text-xs font-mono text-gray-600 text-center py-8 uppercase">> A aguardar seleção de nó...</p>
            </div>
        </div>
    </aside>

    <script>
        // --- GERENCIAMENTO DO MODAL DE TUTORIAL ---
        document.addEventListener("DOMContentLoaded", function() {
            if (!localStorage.getItem("hideTutorial")) {
                document.getElementById("tutorial-modal").classList.remove("hidden");
            }
        });

        function closeTutorial() {
            if (document.getElementById("dont-show-again").checked) {
                localStorage.setItem("hideTutorial", "true");
            }
            document.getElementById("tutorial-modal").classList.add("hidden");
        }

        // --- GERENCIAMENTO DE TEMA E MENUS ---
        function toggleTheme() {
            const isLight = document.body.classList.toggle("light-mode");
            localStorage.setItem("theme", isLight ? "light" : "dark");
            document.getElementById("theme-btn").innerText = isLight ? '[ MODO ESCURO ]' : '[ MODO CLARO ]';
            update(root);
        }

        window.onload = function() {
            if (localStorage.getItem("theme") === "light") document.getElementById("theme-btn").innerText = '[ MODO ESCURO ]';
        };

        function toggleDropdown(event) {
            event.stopPropagation();
            document.getElementById('profile-dropdown').classList.toggle('hidden');
        }

        window.addEventListener('click', function(event) {
            const dropdown = document.getElementById('profile-dropdown');
            const menuContainer = document.getElementById('user-menu-container');
            if (!dropdown.classList.contains('hidden') && !menuContainer.contains(event.target)) dropdown.classList.add('hidden');
        });

        // --- D3.JS: ÁRVORE E SALVAMENTO DE CONTEXTO ---
        const treeData = <%= request.getAttribute("treeDataJSON") %>;

        const containerInfo = document.getElementById('tree-container').getBoundingClientRect();
        const width = containerInfo.width;
        const height = containerInfo.height;
        const margin = {top: 20, right: 120, bottom: 20, left: 150};

        const zoom = d3.zoom().scaleExtent([0.3, 4]).on("zoom", function(event) { svgGroup.attr("transform", event.transform); });
        const svg = d3.select("#tree-container").append("svg").attr("width", "100%").attr("height", "100%").call(zoom).on("dblclick.zoom", null);
        const svgGroup = svg.append("g");
        svg.call(zoom.transform, d3.zoomIdentity.translate(margin.left, height / 2));

        let i = 0, duration = 400, root;
        const treemap = d3.tree().nodeSize([35, 220]);

        root = d3.hierarchy(treeData, function(d) { return d.children; });
        root.x0 = 0; root.y0 = 0;

        let openNodes = JSON.parse(localStorage.getItem("openTreeNodes")) || ["Avaliaqui"];

        function initTreeState(d) {
            if (d.children) {
                if (!openNodes.includes(d.data.name)) {
                    d._children = d.children;
                    d.children = null;
                }
                if (d.children) d.children.forEach(initTreeState);
                if (d._children) d._children.forEach(initTreeState);
            }
        }
        initTreeState(root);
        update(root);

        function saveTreeState() {
            let opened = [];
            root.each(function(node) {
                if (node.children) opened.push(node.data.name);
            });
            localStorage.setItem("openTreeNodes", JSON.stringify(opened));
        }

        function update(source) {
            const treeDataMapped = treemap(root);
            const nodes = treeDataMapped.descendants();
            const links = treeDataMapped.descendants().slice(1);

            const node = svgGroup.selectAll('g.node').data(nodes, function(d) { return d.id || (d.id = ++i); });
            const nodeEnter = node.enter().append('g')
                .attr('class', 'node')
                .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
                .on('click', click)
                .attr('cursor', 'pointer'); 

            nodeEnter.append('circle').attr('class', 'halo').attr('r', 1e-6);
            nodeEnter.append('circle').attr('class', 'node-dot').attr('r', 1e-6);
                
            nodeEnter.append('text')
                .attr("dy", ".35em")
                .attr("x", function(d) { return d.children || d._children ? -15 : 15; }) 
                .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
                .text(function(d) { return d.data.name; });

            const nodeUpdate = nodeEnter.merge(node);
            nodeUpdate.transition().duration(duration)
                .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

            nodeUpdate.select('.halo')
                .classed('active', d => !!d._children)
                .style("stroke", function() { return document.body.classList.contains("light-mode") ? "#ea580c" : "#a855f7"; });

            nodeUpdate.select('.node-dot').attr('r', 6)
                .style("fill", function(d) { 
                    const isLight = document.body.classList.contains("light-mode");
                    if (d._children) return isLight ? "#ea580c" : "#a855f7"; 
                    return isLight ? "#ffffff" : "#050505"; 
                })
                .style("stroke", function() { return document.body.classList.contains("light-mode") ? "#ea580c" : "#a855f7"; });

            const nodeExit = node.exit().transition().duration(duration)
                .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
                .remove();

            nodeExit.select('.node-dot').attr('r', 1e-6);
            nodeExit.select('.halo').attr('r', 1e-6);
            nodeExit.select('text').style('fill-opacity', 1e-6);

            const link = svgGroup.selectAll('path.link').data(links, function(d) { return d.id; });
            const linkEnter = link.enter().insert('path', "g").attr("class", "link")
                .attr('d', function(d) { const o = {x: source.x0, y: source.y0}; return diagonal(o, o); });

            const linkUpdate = linkEnter.merge(link);
            linkUpdate.transition().duration(duration).attr('d', function(d) { return diagonal(d, d.parent); });

            link.exit().transition().duration(duration).attr('d', function(d) {
                const o = {x: source.x, y: source.y}; return diagonal(o, o);
            }).remove();

            nodes.forEach(function(d) { d.x0 = d.x; d.y0 = d.y; });
        }

        function diagonal(s, d) { return "M " + s.y + " " + s.x + " L " + d.y + " " + d.x; }

        function click(event, d) {
            if (d.data.type === "produto") {
                openPanel(d.data);
            } else {
                if (d.children) { d._children = d.children; d.children = null; } 
                else { d.children = d._children; d._children = null; }
                update(d);
                saveTreeState();
            }
        }

        // --- PAINEL LATERAL & AVALIAÇÕES ---
        function closePanel() { document.getElementById("side-panel").classList.add("translate-x-full"); }
        
        function toggleAvaliacao(idPost) {
            const formDiv = document.getElementById('aval-' + idPost);
            formDiv.classList.toggle('hidden');
        }

        function openPanel(product) {
            document.getElementById("product-title").innerText = product.name;
            document.getElementById("product-breadcrumb").innerText = "root > " + product.category.toLowerCase() + " > " + product.brand.toLowerCase();
            document.getElementById("side-panel").classList.remove("translate-x-full");

            const timeline = document.getElementById("timeline-container");
            timeline.innerHTML = "<p class='text-xs font-mono text-gray-500 uppercase text-center mt-10'>[ A CARREGAR DADOS_BD... ]</p>";

            fetch('api/produto-detalhe?produtoId=' + product.id)
                .then(response => response.json())
                .then(data => {
                    const mediaProd = data.mediaProduto ? data.mediaProduto.toFixed(1) : "0.0";
                    const estrelasProd = Math.round(data.mediaProduto || 0);
                    document.getElementById("product-rating-avg").innerText = "(" + mediaProd + "/5)";
                    document.getElementById("product-stars").innerText = "★".repeat(estrelasProd) + "☆".repeat(5 - estrelasProd);

                    const posts = data.postagens;
                    if (!posts || posts.length === 0) {
                        timeline.innerHTML = "<p class='text-xs font-mono text-gray-600 uppercase text-center py-8'>> Nenhuma postagem aprovada para este produto.</p>";
                        return;
                    }

                    let html = "";
                    posts.forEach(post => {
                        const autor = post.autorNome && post.autorNome !== 'null' ? post.autorNome : "Usuário";
                        const mediaPost = post.mediaNotas ? post.mediaNotas.toFixed(1) : "0.0";
                        const idPost = post.id || "";
                        const notaAutor = post.notaProduto || 5;
                        const estrelasAutor = "★".repeat(notaAutor) + "☆".repeat(5 - notaAutor);

                        let comentariosHtml = "";
                        if (post.avaliacoes && post.avaliacoes.length > 0) {
                            comentariosHtml += "<div class='mt-4 pt-3 border-t border-[#333] border-line border-dashed space-y-2'>";
                            comentariosHtml += "<p class='text-[9px] text-gray-500 uppercase tracking-widest font-mono'>Avaliações da Comunidade sobre este relato:</p>";
                            post.avaliacoes.forEach(av => {
                                const estrelasAv = "★".repeat(av.nota) + "☆".repeat(5 - av.nota);
                                comentariosHtml += "<div class='bg-panel input-light p-2.5 border border-[#333] border-line'>" +
                                    "<div class='flex justify-between items-center mb-1'>" +
                                        "<span class='text-[#a855f7] font-mono text-[9px]'>@" + av.autor + "</span>" +
                                        "<span class='text-yellow-500 font-mono text-[9px]'>" + estrelasAv + " (" + av.nota + "/5)</span>" +
                                    "</div>" +
                                    "<p class='text-xs text-gray-300 font-sans'>" + av.comentario + "</p>" +
                                "</div>";
                            });
                            comentariosHtml += "</div>";
                        }

                        html += "<div class='bg-[#111] input-light border border-[#333] border-line p-4 relative shadow-[2px_2px_0_rgba(0,0,0,0.5)]'>" +
                            "<div class='flex justify-between items-start mb-2 border-b border-[#333] border-line pb-2'>" +
                                "<span class='text-[#a855f7] font-mono text-[10px] uppercase'>@" + autor + "</span>" +
                                "<span class='text-gray-500 font-mono text-[9px]'>" + post.dataFormatada + "</span>" +
                            "</div>" +
                            "<div class='mb-2 font-mono text-xs text-yellow-500 bg-panel input-light p-1.5 border border-[#333] border-line'>" +
                                "<span class='text-[9px] text-gray-400 block uppercase'>Avaliação do Autor para o Produto:</span>" +
                                estrelasAutor + " (" + notaAutor + "/5)" +
                            "</div>" +
                            "<h4 class='text-sm font-bold text-white font-mono mb-1'>" + post.titulo + "</h4>" +
                            "<p class='text-xs text-gray-400 mb-3 font-sans'>" + post.descricao + "</p>" +
                            "<div class='flex justify-between items-center mt-3 pt-2 border-t border-[#333] border-line'>" +
                                "<span class='text-[10px] font-mono text-yellow-500'>REPUTAÇÃO DO RELATO: ★ (" + mediaPost + ")</span>" +
                                "<button onclick=\"toggleAvaliacao('" + idPost + "')\" class='text-[10px] font-mono text-blue-400 hover:text-blue-300 transition-colors uppercase cursor-pointer z-10 relative'>[ AVALIAR_RELATO ]</button>" +
                            "</div>" +
                            comentariosHtml +
                            "<div id='aval-" + idPost + "' class='hidden mt-3 p-3 bg-panel input-light border border-[#333] border-line'>" +
                                "<form action='avaliar' method='POST' class='space-y-3'>" +
                                    "<input type='hidden' name='postagemId' value='" + idPost + "'>" +
                                    "<div class='flex items-center justify-between'>" +
                                        "<label class='text-[9px] font-mono text-gray-500 uppercase'>SUA NOTA SOBRE ESTE RELATO:</label>" +
                                        "<select name='nota' required class='bg-[#111] input-light border border-[#333] border-line text-[10px] text-white p-1 font-mono outline-none focus:border-[#a855f7]'>" +
                                            "<option value='5'>★★★★★ (5)</option>" +
                                            "<option value='4'>★★★★☆ (4)</option>" +
                                            "<option value='3'>★★★☆☆ (3)</option>" +
                                            "<option value='2'>★★☆☆☆ (2)</option>" +
                                            "<option value='1'>★☆☆☆☆ (1)</option>" +
                                        "</select>" +
                                    "</div>" +
                                    "<textarea name='comentario' rows='2' placeholder='Deixe seu comentário sobre a postagem...' class='w-full bg-[#111] input-light border border-[#333] border-line text-xs p-2 text-white outline-none focus:border-[#a855f7] font-mono'></textarea>" +
                                    "<button type='submit' class='btn-terminal w-full py-1 text-[10px] mt-1 cursor-pointer'>[ SUBMETER AVALIAÇÃO ]</button>" +
                                "</form>" +
                            "</div>" +
                        "</div>";
                    });
                    timeline.innerHTML = html;
                })
                .catch(error => {
                    console.error("Erro na API:", error);
                    timeline.innerHTML = "<p class='text-xs font-mono text-red-500 uppercase text-center py-8'>[ ERRO_DE_LIGAÇÃO ]</p>";
                });
        }

        // --- MOTOR DE BUSCA DE PRODUTOS ---
        const searchInput = document.getElementById('search-input');
        const searchResults = document.getElementById('search-results');
        let todosProdutos = [];
        let matchesGlobais = [];

        function mapearProdutos(node) {
            if (node.type === "produto") todosProdutos.push(node);
            if (node.children) node.children.forEach(mapearProdutos);
        }
        if (treeData) mapearProdutos(treeData);

        searchInput.addEventListener('input', function() {
            const termo = this.value.toLowerCase().trim();
            if (termo.length === 0) { searchResults.classList.add('hidden'); return; }

            matchesGlobais = todosProdutos.filter(p => 
                p.name.toLowerCase().includes(termo) || p.brand.toLowerCase().includes(termo) || p.category.toLowerCase().includes(termo)
            );

            if (matchesGlobais.length > 0) {
                let html = '';
                matchesGlobais.forEach((match, index) => {
                    html += "<div class='p-3 hover:bg-[#111] input-light cursor-pointer transition-colors' onclick='selecionarResultadoBusca(" + index + ")'>" +
                        "<p class='text-sm font-bold text-white uppercase font-mono'>" + match.name + "</p>" +
                        "<p class='text-[9px] font-mono text-[#a855f7] uppercase mt-0.5'>> " + match.category + " > " + match.brand + "</p>" +
                    "</div>";
                });
                searchResults.innerHTML = html;
            } else {
                searchResults.innerHTML = "<div class='p-4 text-[10px] font-mono text-red-500 uppercase tracking-widest text-center'>[ RESULTADO_NÃO_ENCONTRADO ]</div>";
            }
            searchResults.classList.remove('hidden');
        });

        document.addEventListener('click', function(event) {
            if (!searchInput.contains(event.target) && !searchResults.contains(event.target)) searchResults.classList.add('hidden');
        });

        function selecionarResultadoBusca(index) {
            searchResults.classList.add('hidden');
            searchInput.value = ''; 
            openPanel(matchesGlobais[index]);
        }
    </script>
</body>
</html>
