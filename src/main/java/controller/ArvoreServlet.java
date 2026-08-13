package controller;

import dao.ArvoreDAO;
import model.Categoria;
import model.Marca;
import model.Produto;
import model.Usuario;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/arvore")
public class ArvoreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ArvoreDAO arvoreDAO = new ArvoreDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("usuarioLogado") != null) {
            
            List<Categoria> categorias = arvoreDAO.listarCategorias();
            List<Marca> marcas = arvoreDAO.listarMarcas();
            List<Produto> produtos = arvoreDAO.listarProdutos();

            String treeDataJSON = montarJSONArvore(categorias, marcas, produtos);
            
            request.setAttribute("treeDataJSON", treeDataJSON);
            request.getRequestDispatcher("arvore.jsp").forward(request, response);
            
        } else {
            request.setAttribute("mensagemErro", "Você precisa autenticar-se no sistema.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }


    private String montarJSONArvore(List<Categoria> categorias, List<Marca> marcas, List<Produto> produtos) {
        StringBuilder sb = new StringBuilder();
        sb.append("{ \"name\": \"Avaliaqui\", \"children\": [");
        
        List<Categoria> raizes = categorias.stream()
                .filter(c -> c.getParent_id() == null || c.getParent_id() == 0)
                .collect(Collectors.toList());
                
        for (int i = 0; i < raizes.size(); i++) {
            sb.append(montarCategoriaNode(raizes.get(i), categorias, marcas, produtos, raizes.get(i).getNome()));
            if (i < raizes.size() - 1) sb.append(",");
        }
        
        sb.append("] }");
        return sb.toString();
    }

    private String montarCategoriaNode(Categoria cat, List<Categoria> allCat, List<Marca> allMarcas, List<Produto> allProd, String caminho) {
        StringBuilder sb = new StringBuilder();
        sb.append("{ \"name\": \"").append(cat.getNome()).append("\"");
        
        List<Categoria> subcategorias = allCat.stream()
                .filter(c -> c.getParent_id() != null && c.getParent_id().equals(cat.getId()))
                .collect(Collectors.toList());
                
        List<Marca> marcas = allMarcas.stream()
                .filter(m -> m.getCategoria_id().equals(cat.getId()))
                .collect(Collectors.toList());
                
        if (!subcategorias.isEmpty() || !marcas.isEmpty()) {
            sb.append(", \"children\": [");
            boolean primeiro = true;
            
            for (Categoria sub : subcategorias) {
                if (!primeiro) sb.append(",");
                sb.append(montarCategoriaNode(sub, allCat, allMarcas, allProd, caminho + " > " + sub.getNome()));
                primeiro = false;
            }
            
            for (Marca marca : marcas) {
                if (!primeiro) sb.append(",");
                sb.append(montarMarcaNode(marca, allProd, caminho));
                primeiro = false;
            }
            
            sb.append("]");
        }
        sb.append("}");
        return sb.toString();
    }

    private String montarMarcaNode(Marca marca, List<Produto> allProd, String caminhoCat) {
        StringBuilder sb = new StringBuilder();
        sb.append("{ \"name\": \"").append(marca.getNome()).append("\"");
        
        List<Produto> prods = allProd.stream()
                .filter(p -> p.getMarca_id().equals(marca.getId()))
                .collect(Collectors.toList());
                
        if (!prods.isEmpty()) {
            sb.append(", \"children\": [");
            for (int i = 0; i < prods.size(); i++) {
                Produto p = prods.get(i);
                sb.append("{ \"name\": \"").append(p.getNome()).append("\", ")
                  .append("\"id\": ").append(p.getId()).append(", ")
                  .append("\"type\": \"produto\", ")
                  .append("\"brand\": \"").append(marca.getNome()).append("\", ")
                  .append("\"category\": \"").append(caminhoCat).append("\", ")
                  .append("\"rating\": \"Sem avaliações (0.0)\" }"); 
                if (i < prods.size() - 1) sb.append(",");
            }
            sb.append("]");
        }
        sb.append("}");
        return sb.toString();
    }
}