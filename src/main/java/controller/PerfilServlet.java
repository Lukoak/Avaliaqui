package controller;

import dao.PostagemDAO;
import dao.AvaliacaoDAO;
import model.Postagem;
import model.Avaliacao;
import model.Usuario;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostagemDAO postagemDAO = new PostagemDAO();
    private AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        List<Postagem> minhasPostagens = postagemDAO.listarPorUsuario(usuario.getId());
        List<Avaliacao> minhasAvaliacoes = avaliacaoDAO.listarPorUsuario(usuario.getId());

        request.setAttribute("minhasPostagens", minhasPostagens);
        request.setAttribute("minhasAvaliacoes", minhasAvaliacoes);

        request.getRequestDispatcher("perfil.jsp").forward(request, response);
    }
}