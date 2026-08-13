package model;

public class Usuario {
    private Long id;
    private String email;
    private String cpf;
    private String nome;
    private String senhaHash;
    private int pontuacao;
    private String status;
    private String perfilAcesso;

    public Usuario() {}

    public Usuario(Long id, String email, String cpf, String nome, int pontuacao, String status, String perfilAcesso) {
        this.id = id;
        this.email = email;
        this.cpf = cpf;
        this.nome = nome;
        this.pontuacao = pontuacao;
        this.status = status;
        this.perfilAcesso = perfilAcesso;
    }

    public Long getId() { 
    	return id; 
    }
    public void setId(Long id) { 
    	this.id = id; 
    }
    
    public String getEmail() { 
    	return email; 
    }
    public void setEmail(String email) { 
    	this.email = email; 
    }
    
    public String getCpf() { 
    	return cpf; 
    }
    public void setCpf(String cpf) { 
    	this.cpf = cpf; 
    }
    
    public String getNome() { 
    	return nome; 
    }
    public void setNome(String nome) { 
    	this.nome = nome; 
    }
    
    public String getSenhaHash() { 
    	return senhaHash; 
    }
    public void setSenhaHash(String senhaHash) { 
    	this.senhaHash = senhaHash; 
    }
    
    public int getPontuacao() { 
    	return pontuacao; 
    }
    public void setPontuacao(int pontuacao) { 
    	this.pontuacao = pontuacao; 
    }
    
    public String getStatus() { 
    	return status; 
    }
    public void setStatus(String status) { 
    	this.status = status; 
    }
    
    public String getPerfilAcesso() { 
    	return perfilAcesso; 
    }
    public void setPerfilAcesso(String perfilAcesso) { 
    	this.perfilAcesso = perfilAcesso; 
    }
}