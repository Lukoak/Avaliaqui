package controller;

import dao.UsuarioDAO;
import model.Usuario;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("cadastro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nickname = request.getParameter("nickname");
        String cpf = request.getParameter("cpf");
        String email = request.getParameter("email");
        String confirmarEmail = request.getParameter("confirmarEmail");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");

        if (!email.equals(confirmarEmail)) {
            request.setAttribute("mensagemErro", "Os e-mails informados não coincidem.");
            request.getRequestDispatcher("cadastro.jsp").forward(request, response);
            return;
        }

        if (!senha.equals(confirmarSenha)) {
            request.setAttribute("mensagemErro", "As senhas informadas não coincidem.");
            request.getRequestDispatcher("cadastro.jsp").forward(request, response);
            return;
        }

        Usuario novoUsuario = new Usuario();
        novoUsuario.setNome(nickname); 
        novoUsuario.setEmail(email);
        novoUsuario.setCpf(cpf);
        novoUsuario.setSenhaHash(senha);

        // 4. Inserção no Banco
        if (usuarioDAO.cadastrarUsuario(novoUsuario)) {
            request.setAttribute("mensagemErro", null); // Limpa erros
            request.setAttribute("mensagemSucesso", "Registro efetuado com sucesso! Faça login para continuar.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("mensagemErro", "Erro ao criar conta. O E-mail ou CPF já existe, ou ocorreu falha no banco de dados.");
            request.getRequestDispatcher("cadastro.jsp").forward(request, response);
        }
    }
}