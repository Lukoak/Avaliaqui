package model;

import java.time.LocalDateTime;

public class Avaliacao {
    private Long id;
    private int nota;
    private String comentario;
    private LocalDateTime dataAvaliacao;
    private Long postagemId;
    private Long usuarioId;
    private String autorNome;

    public Avaliacao() {}

    public Avaliacao(Long id, int nota, String comentario, LocalDateTime dataAvaliacao, Long postagemId, Long usuarioId) {
        this.id = id;
        this.nota = nota;
        this.comentario = comentario;
        this.dataAvaliacao = dataAvaliacao;
        this.postagemId = postagemId;
        this.usuarioId = usuarioId;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public int getNota() { return nota; }
    public void setNota(int nota) { this.nota = nota; }

    public String getComentario() { return comentario; }
    public void setComentario(String comentario) { this.comentario = comentario; }

    public LocalDateTime getDataAvaliacao() { return dataAvaliacao; }
    public void setDataAvaliacao(LocalDateTime dataAvaliacao) { this.dataAvaliacao = dataAvaliacao; }

    public Long getPostagemId() { return postagemId; }
    public void setPostagemId(Long postagemId) { this.postagemId = postagemId; }

    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }
    
    public String getAutorNome() { return autorNome; }
    public void setAutorNome(String autorNome) { this.autorNome = autorNome; }
}