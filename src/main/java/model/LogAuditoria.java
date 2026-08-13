package model;
import java.time.LocalDateTime;


public class LogAuditoria {
	private Long id;
	private String acao;
	private String detalhe;
	private LocalDateTime data_registro;
	private Long usuario_id;
	
    public LogAuditoria() {}

    public LogAuditoria(Long id, String acao, String detalhe, LocalDateTime data_registro, Long usuario_id) {
        this.id = id;
        this.acao = acao;
        this.detalhe = detalhe;
        this.data_registro = data_registro;
        this.usuario_id = usuario_id;
    }
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	
	public String getAcao() {
		return acao;
	}
	public void setAcao(String acao) {
		this.acao = acao;
	}
	
	
	public String getDetalhe() {
		return detalhe;
	}
	public void setDetalhe(String detalhe) {
		this.detalhe = detalhe;
	}
	
	
	public LocalDateTime getData_registro() {
		return data_registro;
	}
	public void setData_registro(LocalDateTime data_registro) {
		this.data_registro = data_registro;
	}
	
	
	public Long getUsuario_id() {
		return usuario_id;
	}
	public void setUsuario_id(Long usuario_id) {
		this.usuario_id = usuario_id;
	}
	
}
