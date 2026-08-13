package model;
import java.time.LocalDateTime;


public class Postagem {

	private Long id;
	private String titulo;
	private String descricao;
	private String imagem_url;
	private String link_referencia;
	private String status;
	private LocalDateTime data_criacao;
	private Long produto_id;
	private Long usuario_id;
    private String autorEmail;
    private String dataFormatada;
    private String autorNome;
    private double mediaNotas;
    private int notaProduto;
	
    public Postagem() {}

    public Postagem(Long id, String titulo, String descricao, String imagem_url, String link_referencia, String status, LocalDateTime data_criacao, Long produto_id, Long usuario_id, int notaProduto) {
        this.id = id;
        this.titulo = titulo;
        this.descricao = descricao;
        this.imagem_url = imagem_url;
        this.link_referencia = link_referencia;
        this.status = status;
        this.data_criacao = data_criacao;
        this.produto_id = produto_id;
        this.usuario_id = usuario_id;
        this.notaProduto = notaProduto;
    }
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	
	public String getTitulo() {
		return titulo;
	}
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	
	
	public String getDescricao() {
		return descricao;
	}
	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}
	
	
	public String getImagem_url() {
		return imagem_url;
	}
	public void setImagem_url(String imagem_url) {
		this.imagem_url = imagem_url;
	}
	
	
	public String getLink_referencia() {
		return link_referencia;
	}
	public void setLink_referencia(String link_referencia) {
		this.link_referencia = link_referencia;
	}
	
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	
	public LocalDateTime getData_criacao() {
		return data_criacao;
	}
	public void setData_criacao(LocalDateTime data_criacao) {
		this.data_criacao = data_criacao;
	}
	
	
	public Long getProduto_id() {
		return produto_id;
	}
	public void setProduto_id(Long produto_id) {
		this.produto_id = produto_id;
	}
	
	
	public Long getUsuario_id() {
		return usuario_id;
	}
	public void setUsuario_id(Long usuario_id) {
		this.usuario_id = usuario_id;
	}
	
	
    public String getAutorEmail() { 
    	return autorEmail; 
    }
    
    public void setAutorEmail(String autorEmail) { 
    	this.autorEmail = autorEmail; 
    }

    public String getDataFormatada() { 
    	return dataFormatada; 
    }
    public void setDataFormatada(String dataFormatada) { 
    	this.dataFormatada = dataFormatada; 
    }
    
    public String getAutorNome() {
    	return autorNome; 
	}
    public void setAutorNome(String autorNome) { 
    	this.autorNome = autorNome; 
	}

    public double getMediaNotas() { 
    	return mediaNotas; 
	}
    public void setMediaNotas(double mediaNotas) { 
    	this.mediaNotas = mediaNotas; 
	}
    
    
    public int getNotaProduto() { return notaProduto; }
    public void setNotaProduto(int notaProduto) { this.notaProduto = notaProduto; }
}
