package model;

public class Categoria {
	private Long id;
	private String nome;
	private Long parent_id;
	
    public Categoria() {}

    public Categoria(Long id, String nome, Long parent_id) {
        this.id = id;
        this.nome = nome;
        this.parent_id = parent_id;
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
	
	
	public Long getParent_id() {
		return parent_id;
	}
	public void setParent_id(Long parent_id) {
		this.parent_id = parent_id;
	}
}
