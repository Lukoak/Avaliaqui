package model;

public class Produto {
	private Long id;
	private String nome;
	private Long marca_id;
	
	
    public Produto() {}

    public Produto(Long id, String nome, Long marca_id) {
        this.id = id;
        this.nome = nome;
        this.marca_id = marca_id;
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
	
	
	public Long getMarca_id() {
		return marca_id;
	}
	public void setMarca_id(Long marca_id) {
		this.marca_id = marca_id;
	}
}
