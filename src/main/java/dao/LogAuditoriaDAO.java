package dao;

import util.Conexao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class LogAuditoriaDAO {
    
    public void registrarLog(String acao, String detalhe, Long usuarioId) {
        String sql = "INSERT INTO log_auditoria (acao, detalhe, usuario_id) VALUES (?, ?, ?)";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, acao);
            stmt.setString(2, detalhe);
            stmt.setLong(3, usuarioId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}