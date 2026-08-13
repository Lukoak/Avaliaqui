package model;

public class Marca {
	private Long id;
	private String nome;
	private Long categoria_id;
	
    public Marca() {}

    public Marca(Long id, String nome, Long categoria_id) {
        this.id = id;
        this.nome = nome;
        this.categoria_id = categoria_id;
    }
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	
	
	public Long getCategoria_id() {
		return categoria_id;
	}
	public void setCategoria_id(Long categoria_id) {
		this.categoria_id = categoria_id;
	}	
}
