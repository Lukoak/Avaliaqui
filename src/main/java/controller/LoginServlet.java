package controller;

import dao.UsuarioDAO;
import model.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //rdr para a página JSP de login
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");
        //auth via MySQL através do DAO
        Usuario usuarioLogado = usuarioDAO.autenticar(identifier, password);

        if (usuarioLogado != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogado", usuarioLogado);
            response.sendRedirect("arvore");
        } else {
            request.setAttribute("mensagemErro", "E-mail/CPF ou chave de acesso incorretos (ou conta suspensa).");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}