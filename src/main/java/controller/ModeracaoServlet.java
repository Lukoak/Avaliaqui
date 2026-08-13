package controller;

import dao.PostagemDAO;
import dao.LogAuditoriaDAO;
import model.Postagem;
import model.Usuario;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/moderacao")
public class ModeracaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostagemDAO postagemDAO = new PostagemDAO();
    private LogAuditoriaDAO logDAO = new LogAuditoriaDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Usuario user = (Usuario) session.getAttribute("usuarioLogado");
        if (!user.getPerfilAcesso().equals("Revisor") && !user.getPerfilAcesso().equals("Administrador") && !user.getPerfilAcesso().equals("Root")) {
            response.sendRedirect("arvore");
            return;
        }

        List<Postagem> filaPendentes = postagemDAO.listarPendentes();
        request.setAttribute("filaPendentes", filaPendentes);
        
        request.getRequestDispatcher("moderacao.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario user = (Usuario) request.getSession().getAttribute("usuarioLogado");
        
        Long postagemId = Long.parseLong(request.getParameter("postagemId"));
        String acao = request.getParameter("acao"); 

        if ("aprovar".equals(acao)) {
            if (postagemDAO.atualizarStatus(postagemId, "APROVADA")) {
                logDAO.registrarLog("Aprovou Postagem", "O usuário aprovou a postagem ID #" + postagemId, user.getId());
                request.setAttribute("mensagemSucesso", "Postagem #" + postagemId + " aprovada e publicada com sucesso.");
            }
        } else if ("rejeitar".equals(acao)) {
            if (postagemDAO.atualizarStatus(postagemId, "REJEITADA")) {
                logDAO.registrarLog("Rejeitou Postagem", "O usuário rejeitou a postagem ID #" + postagemId, user.getId());
                request.setAttribute("mensagemErro", "Postagem #" + postagemId + " foi rejeitada e retirada da fila.");
            }
        }

        request.setAttribute("filaPendentes", postagemDAO.listarPendentes());
        request.getRequestDispatcher("moderacao.jsp").forward(request, response);
    }
}