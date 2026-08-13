package dao;

import model.Usuario;
import util.Conexao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public Usuario autenticar(String identifier, String password) {
        String sql = "SELECT u.*, g.nome AS perfil " +
                     "FROM usuario u " +
                     "JOIN grupo_acesso g ON u.grupo_acesso_id = g.id " +
                     "WHERE (u.email = ? OR u.cpf = ?) AND u.senha_hash = ? AND u.status = 'Ativo'";
        
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, identifier);
            stmt.setString(2, identifier);
            stmt.setString(3, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Usuario(
                        rs.getLong("id"),
                        rs.getString("email"),
                        rs.getString("cpf"),
                        rs.getString("nome"),
                        rs.getInt("pontuacao"),
                        rs.getString("status"),
                        rs.getString("perfil")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, g.nome AS perfil FROM usuario u JOIN grupo_acesso g ON u.grupo_acesso_id = g.id";
        
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                lista.add(new Usuario(
                    rs.getLong("id"),
                    rs.getString("email"),
                    rs.getString("cpf"),
                    rs.getString("nome"),
                    rs.getInt("pontuacao"),
                    rs.getString("status"),
                    rs.getString("perfil")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean alterarStatus(Long usuarioId, String novoStatus) {
        String sql = "UPDATE usuario SET status = ? WHERE id = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novoStatus);
            stmt.setLong(2, usuarioId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean alterarCargo(Long usuarioId, String novoCargoNome) {
        String sql = "UPDATE usuario SET grupo_acesso_id = (SELECT id FROM grupo_acesso WHERE nome = ?) WHERE id = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novoCargoNome);
            stmt.setLong(2, usuarioId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean cadastrarUsuario(Usuario u) {
        //cadastro de avaliadores apenas, a setagem de perfil do usuario 
        String sql = "INSERT INTO usuario (email, cpf, nome, senha_hash, pontuacao, status, grupo_acesso_id) " +
                     "VALUES (?, ?, ?, ?, 0, 'Ativo', (SELECT id FROM grupo_acesso WHERE nome = 'Avaliador'))";
        
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, u.getEmail());
            stmt.setString(2, u.getCpf());
            stmt.setString(3, u.getNome());
            stmt.setString(4, u.getSenhaHash());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void adicionarPontos(Long usuarioId, int pontos) {
        String sql = "UPDATE usuario SET pontuacao = pontuacao + ? WHERE id = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pontos);
            stmt.setLong(2, usuarioId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public boolean atualizarStatus(Long id, String novoStatus) {
        String sql = "UPDATE usuario SET status = ? WHERE id = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novoStatus);
            stmt.setLong(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizarPerfil(Long id, String novoCargo) {
        String sql = "UPDATE usuario SET grupo_acesso_id = (SELECT id FROM grupo_acesso WHERE nome = ?) WHERE id = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novoCargo);
            stmt.setLong(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
}