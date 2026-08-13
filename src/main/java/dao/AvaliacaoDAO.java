package dao;

import util.Conexao;
import model.Avaliacao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AvaliacaoDAO {

    //block autor da pstagem de avaliar a própria postagem
    public boolean isAutorDaPostagem(Long usuarioId, Long postagemId) {
        String sql = "SELECT id FROM postagem WHERE id = ? AND usuario_id = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, postagemId);
            stmt.setLong(2, usuarioId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean salvarAvaliacao(Avaliacao aval) {
        String sql = "INSERT INTO avaliacao (nota, comentario, postagem_id, usuario_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, aval.getNota());
            stmt.setString(2, aval.getComentario());
            stmt.setLong(3, aval.getPostagemId());
            stmt.setLong(4, aval.getUsuarioId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public java.util.List<Avaliacao> listarPorPostagem(Long postagemId) {
        java.util.List<Avaliacao> lista = new java.util.ArrayList<>();
        String sql = "SELECT a.*, u.nome AS autor_nome " +
                     "FROM avaliacao a " +
                     "JOIN usuario u ON a.usuario_id = u.id " +
                     "WHERE a.postagem_id = ? ORDER BY a.data_avaliacao DESC"; /*criar view depois no banco*/
                     
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, postagemId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Avaliacao av = new Avaliacao();
                    av.setId(rs.getLong("id"));
                    av.setNota(rs.getInt("nota"));
                    av.setComentario(rs.getString("comentario"));
                    av.setPostagemId(rs.getLong("postagem_id"));
                    av.setUsuarioId(rs.getLong("usuario_id"));
                    av.setAutorNome(rs.getString("autor_nome"));
                    lista.add(av);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public java.util.List<Avaliacao> listarPorUsuario(Long usuarioId) {
        java.util.List<Avaliacao> lista = new java.util.ArrayList<>();
        String sql = "SELECT a.*, " +
                     "DATE_FORMAT(a.data_avaliacao, '%d/%m/%Y') AS data_fmt " + /*criar view dps*/
                     "FROM avaliacao a " +
                     "WHERE a.usuario_id = ? " +
                     "ORDER BY a.data_avaliacao DESC";
                     
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, usuarioId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Avaliacao av = new Avaliacao();
                    av.setId(rs.getLong("id"));
                    av.setNota(rs.getInt("nota"));
                    av.setComentario(rs.getString("comentario"));
                    av.setPostagemId(rs.getLong("postagem_id"));
                    av.setUsuarioId(rs.getLong("usuario_id"));
                    lista.add(av);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}