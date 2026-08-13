package controller;

import dao.PostagemDAO;
import model.Postagem;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/produto-detalhe")
public class ProdutoDetalheServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostagemDAO postagemDAO = new PostagemDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String produtoIdParam = request.getParameter("produtoId");
        if (produtoIdParam == null || produtoIdParam.trim().isEmpty() || produtoIdParam.equals("undefined")) {
            response.getWriter().write("{\"mediaProduto\": 0.0, \"postagens\": []}");
            return;
        }

        Long produtoId = Long.parseLong(produtoIdParam);
        List<Postagem> postagens = postagemDAO.listarAprovadasPorProduto(produtoId);
        double mediaProduto = postagemDAO.calcularMediaProduto(produtoId);
        dao.AvaliacaoDAO avaliacaoDAO = new dao.AvaliacaoDAO();

        StringBuilder json = new StringBuilder();
        json.append("{ \"mediaProduto\": ").append(mediaProduto).append(", \"postagens\": [");

        for (int i = 0; i < postagens.size(); i++) {
            Postagem p = postagens.get(i);
            List<model.Avaliacao> avaliacoes = avaliacaoDAO.listarPorPostagem(p.getId());

            String titulo = p.getTitulo() != null ? p.getTitulo().replace("\"", "\\\"") : "";
            String desc = p.getDescricao() != null ? p.getDescricao().replace("\"", "\\\"").replace("\n", " ").replace("\r", "") : "";
            String autor = p.getAutorNome() != null ? p.getAutorNome() : "Usuario";
            String data = p.getDataFormatada() != null ? p.getDataFormatada() : "";
            
            json.append("{")
                .append("\"id\":").append(p.getId()).append(",")
                .append("\"titulo\":\"").append(titulo).append("\",")
                .append("\"descricao\":\"").append(desc).append("\",")
                .append("\"autorNome\":\"").append(autor).append("\",")
                .append("\"dataFormatada\":\"").append(data).append("\",")
                .append("\"notaProduto\":").append(p.getNotaProduto()).append(",")
                .append("\"mediaNotas\":").append(p.getMediaNotas()).append(",")
                .append("\"avaliacoes\": [");

            for (int j = 0; j < avaliacoes.size(); j++) {
                model.Avaliacao av = avaliacoes.get(j);
                String com = av.getComentario() != null ? av.getComentario().replace("\"", "\\\"").replace("\n", " ").replace("\r", "") : "";
                json.append("{")
                    .append("\"autor\":\"").append(av.getAutorNome()).append("\",")
                    .append("\"nota\":").append(av.getNota()).append(",")
                    .append("\"comentario\":\"").append(com).append("\"")
                    .append("}");
                if (j < avaliacoes.size() - 1) json.append(",");
            }
            json.append("]}");
            if (i < postagens.size() - 1) json.append(",");
        }

        json.append("]}");

        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }
}