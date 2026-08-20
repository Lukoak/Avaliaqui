package controller;

import dao.UsuarioDAO;
import dao.ArvoreDAO;
import model.Usuario;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private ArvoreDAO arvoreDAO = new ArvoreDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Usuario user = (Usuario) session.getAttribute("usuarioLogado");
        if (!user.getPerfilAcesso().equals("Administrador") && !user.getPerfilAcesso().equals("Root") && !user.getPerfilAcesso().equals("Suporte")) {
            response.sendRedirect("arvore"); 
            return;
        }

        request.setAttribute("listaUsuarios", usuarioDAO.listarTodos());
        request.setAttribute("listaCategorias", arvoreDAO.listarCategorias());
        request.setAttribute("listaMarcas", arvoreDAO.listarMarcas());
        request.setAttribute("listaProdutos", arvoreDAO.listarProdutos());

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String acao = request.getParameter("acao");

        if ("suspender".equals(acao)) {
            Long id = Long.parseLong(request.getParameter("usuarioId"));
            if (usuarioDAO.atualizarStatus(id, "Suspenso")) request.setAttribute("mensagemSucesso", "Nó de utilizador SUSPENSO com sucesso.");
        } 
        else if ("reativar".equals(acao)) {
            Long id = Long.parseLong(request.getParameter("usuarioId"));
            if (usuarioDAO.atualizarStatus(id, "Ativo")) request.setAttribute("mensagemSucesso", "Nó de utilizador REATIVADO.");
        } 
        else if ("mudarCargo".equals(acao)) {
            Long id = Long.parseLong(request.getParameter("usuarioId"));
            String novoCargo = request.getParameter("novoCargo");
            if (usuarioDAO.atualizarPerfil(id, novoCargo)) request.setAttribute("mensagemSucesso", "Privilégios atualizados para " + novoCargo + ".");
        }
        
        else if ("criarCategoria".equals(acao)) {
            String nome = request.getParameter("nome_no");
            if (arvoreDAO.criarCategoria(nome, null)) request.setAttribute("mensagemSucesso", "Categoria Raiz injetada com sucesso.");
        }
        else if ("criarMarca".equals(acao)) {
            String nome = request.getParameter("nome_no");
            String parentId = request.getParameter("parent_id");
            if (arvoreDAO.criarMarca(nome, Long.parseLong(parentId))) request.setAttribute("mensagemSucesso", "Marca injetada com sucesso.");
        }
        else if ("criarProduto".equals(acao)) {
            String nome = request.getParameter("nome_no");
            String parentId = request.getParameter("parent_id");
            if (arvoreDAO.criarProduto(nome, Long.parseLong(parentId))) request.setAttribute("mensagemSucesso", "Produto injetado com sucesso.");
        }
        
        else if ("excluirNode".equals(acao)) {
            String tipo = request.getParameter("tipo_no");
            Long id = Long.parseLong(request.getParameter("id_no"));
            
            boolean sucesso = false;
            if ("categoria".equals(tipo)) sucesso = arvoreDAO.excluirCategoria(id);
            else if ("marca".equals(tipo)) sucesso = arvoreDAO.excluirMarca(id);
            else if ("produto".equals(tipo)) sucesso = arvoreDAO.excluirProduto(id);
            
            if (sucesso) request.setAttribute("mensagemSucesso", "Nó (" + tipo + ") e seus dependentes foram obliterados.");
            else request.setAttribute("mensagemErro", "Falha crítica ao obliterar o nó.");
        }

        doGet(request, response);
    }
}
