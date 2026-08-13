package dao;

import util.Conexao;
import model.Postagem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PostagemDAO {

	//limite de 2 postagens
	public boolean atingiuLimiteDiario(Long usuarioId) {
        String sql = "SELECT COUNT(*) AS total FROM postagem WHERE usuario_id = ? AND DATE(data_criacao) = CURDATE()";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, usuarioId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total") >= 2;
                }
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean criarPostagem(Postagem p) {
        String sql = "INSERT INTO postagem (titulo, descricao, imagem_url, link_referencia, status, produto_id, usuario_id, nota_produto) VALUES (?, ?, ?, ?, 'PENDENTE', ?, ?, ?)";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, p.getTitulo());
            stmt.setString(2, p.getDescricao());
            stmt.setString(3, p.getImagem_url());
            stmt.setString(4, p.getLink_referencia());
            stmt.setLong(5, p.getProduto_id());
            stmt.setLong(6, p.getUsuario_id());
            stmt.setInt(7, p.getNotaProduto());
            
            return stmt.executeUpdate() > 0;
        } 
        catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public java.util.List<Postagem> listarPendentes() {
        java.util.List<Postagem> pendentes = new java.util.ArrayList<>();
        String sql = "SELECT p.*, u.email AS autor_email, DATE_FORMAT(p.data_criacao, '%d/%m/%Y') AS data_fmt " +
                     "FROM postagem p " +
                     "JOIN usuario u ON p.usuario_id = u.id " +
                     "WHERE p.status = 'PENDENTE' ORDER BY p.data_criacao ASC";
        
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
             while (rs.next()) {
                 Postagem p = new Postagem();
                 p.setId(rs.getLong("id"));
                 p.setTitulo(rs.getString("titulo"));
                 p.setDescricao(rs.getString("descricao"));
                 p.setImagem_url(rs.getString("imagem_url"));
                 p.setLink_referencia(rs.getString("link_referencia"));
                 p.setStatus(rs.getString("status"));
                 p.setProduto_id(rs.getLong("produto_id"));
                 p.setUsuario_id(rs.getLong("usuario_id"));
                 
                 // Campos auxiliares para a UI
                 p.setAutorEmail(rs.getString("autor_email"));
                 p.setDataFormatada(rs.getString("data_fmt"));
                 
                 pendentes.add(p);
             }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
        return pendentes;
    }

    public boolean atualizarStatus(Long id, String novoStatus) {
        String sql = "UPDATE postagem SET status = ? WHERE id = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novoStatus);
            stmt.setLong(2, id);
            return stmt.executeUpdate() > 0;
        } 
        catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public java.util.List<Postagem> listarAprovadasPorProduto(Long produtoId) {
        java.util.List<Postagem> lista = new java.util.ArrayList<>();
        String sql = "SELECT p.*, u.nome AS autor_nome, " +
                     "DATE_FORMAT(p.data_criacao, '%d/%m/%Y') AS data_fmt, " +
                     "COALESCE((SELECT AVG(nota) FROM avaliacao WHERE postagem_id = p.id), 0.0) AS media_notas " +
                     "FROM postagem p " +
                     "JOIN usuario u ON p.usuario_id = u.id " +
                     "WHERE p.produto_id = ? AND p.status = 'APROVADA' " +
                     "ORDER BY p.data_criacao DESC";
        
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, produtoId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Postagem p = new Postagem();
                    p.setId(rs.getLong("id"));
                    p.setTitulo(rs.getString("titulo"));
                    p.setDescricao(rs.getString("descricao"));
                    p.setAutorNome(rs.getString("autor_nome"));
                    p.setDataFormatada(rs.getString("data_fmt"));
                    p.setMediaNotas(rs.getDouble("media_notas"));
                    p.setNotaProduto(rs.getInt("nota_produto"));
                    lista.add(p);
                }
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public double calcularMediaProduto(Long produtoId) {
        String sql = "SELECT COALESCE(AVG(nota_produto), 0.0) AS media_prod FROM postagem WHERE produto_id = ? AND status = 'APROVADA'";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, produtoId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("media_prod");
                }
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public java.util.List<Postagem> listarPorUsuario(Long usuarioId) {
        java.util.List<Postagem> lista = new java.util.ArrayList<>();
        String sql = "SELECT p.*, " +
                     "DATE_FORMAT(p.data_criacao, '%d/%m/%Y') AS data_fmt " +
                     "FROM postagem p " +
                     "WHERE p.usuario_id = ? " +
                     "ORDER BY p.data_criacao DESC";
        
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, usuarioId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Postagem p = new Postagem();
                    p.setId(rs.getLong("id"));
                    p.setTitulo(rs.getString("titulo"));
                    p.setDescricao(rs.getString("descricao"));
                    p.setStatus(rs.getString("status"));
                    p.setDataFormatada(rs.getString("data_fmt"));
                    p.setNotaProduto(rs.getInt("nota_produto"));
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}