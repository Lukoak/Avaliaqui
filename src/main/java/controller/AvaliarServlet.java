package controller;

import dao.AvaliacaoDAO;
import model.Avaliacao;
import model.Usuario;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/avaliar")
public class AvaliarServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario user = (Usuario) session.getAttribute("usuarioLogado");
        Long postagemId = Long.parseLong(request.getParameter("postagemId"));
        int nota = Integer.parseInt(request.getParameter("nota"));
        String comentario = request.getParameter("comentario");

        if (avaliacaoDAO.isAutorDaPostagem(user.getId(), postagemId)) {
            session.setAttribute("mensagemErro", "Você não pode avaliar a sua própria postagem.");
            response.sendRedirect("arvore");
            return;
        }

        Avaliacao aval = new Avaliacao();
        aval.setNota(nota);
        aval.setComentario(comentario);
        aval.setPostagemId(postagemId);
        aval.setUsuarioId(user.getId());

        if (avaliacaoDAO.salvarAvaliacao(aval)) {
            // ---- INÍCIO DO CÓDIGO NOVO (GAMIFICAÇÃO) ----
            dao.UsuarioDAO usuarioDAO = new dao.UsuarioDAO();
            usuarioDAO.adicionarPontos(user.getId(), 10); // Dá 10 pontos no banco
            user.setPontuacao(user.getPontuacao() + 10); 
            
            session.setAttribute("mensagemSucesso", "A sua avaliação foi registrada com sucesso! (+10 Pontos)");
        } else {
            session.setAttribute("mensagemErro", "Não foi possível registrar a avaliação. É provável que você já tenha avaliado esta postagem.");
        }
        
        response.sendRedirect("arvore");
    }
}