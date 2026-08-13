package controller;

import dao.PostagemDAO;
import model.Postagem;
import model.Usuario;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/criar-postagem")
public class CriarPostagemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostagemDAO postagemDAO = new PostagemDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        //procra arquivos banco
        dao.ArvoreDAO arvoreDAO = new dao.ArvoreDAO();
        request.setAttribute("listaProdutos", arvoreDAO.listarProdutos());
        
        request.getRequestDispatcher("criar-postagem.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        //Limite Diário de 2
        if (postagemDAO.atingiuLimiteDiario(usuarioLogado.getId())) {
            request.setAttribute("mensagemErro", "Ação bloqueada: Você atingiu o limite de 2 postagens diárias imposto pelo sistema.");
            request.getRequestDispatcher("criar-postagem.jsp").forward(request, response);
            return;
        }

        //coletar daods usuario
        Long produtoId = Long.parseLong(request.getParameter("produtoId"));
        String titulo = request.getParameter("titulo");
        String descricao = request.getParameter("descricao");
        String urlImagem = request.getParameter("imagemUrl");
        String linkReferencia = request.getParameter("linkReferencia");
        int notaProduto = Integer.parseInt(request.getParameter("notaProduto"));

        //nova -postagem para aprovação admin
        Postagem novaPostagem = new Postagem();
        novaPostagem.setTitulo(titulo);
        novaPostagem.setDescricao(descricao);
        novaPostagem.setImagem_url(urlImagem);
        novaPostagem.setLink_referencia(linkReferencia);
        novaPostagem.setProduto_id(produtoId);
        novaPostagem.setUsuario_id(usuarioLogado.getId());
        novaPostagem.setNotaProduto(notaProduto);
        

        //chamadno metodo de inserção no banco
        if (postagemDAO.criarPostagem(novaPostagem)) {
            request.setAttribute("mensagemSucesso", "Dados submetidos. A postagem encontra-se na fila de moderação e ficará visível após análise.");
        } else {
            request.setAttribute("mensagemErro", "Ocorreu um erro interno ao processar a requisição no banco de dados.");
        }

        request.getRequestDispatcher("criar-postagem.jsp").forward(request, response);
    }
}