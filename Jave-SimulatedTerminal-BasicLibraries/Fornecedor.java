/* TRABALHO FINAL - [INF01057] PROGRAMAÇÃO ORIENTADA À OBJETO
 * 
 * NOMES: ALEX TREVISO
 *        GIOVANI B. MERLIN
 *        ENZO OLIVEIRA
 * 
 * SISTEMA DE GERENCIAMENTO DE UMA LOJA
 */ 

public class Fornecedor
{
    private String razaoSocial;
    private String cnpj;
    private String inscEstadual;
    private String endereco, bairro, complemento, cep, uf, cidade;
    private String telefone;
    private String email;
    private String observacoes;

    //Inicializa os atributos de fornecedor
    public Fornecedor(String razaoSocial, String cnpj, String inscEstadual, String endereco, String bairro, String complemento, String cep, String uf, String cidade, String telefone, String email, String observacoes)
    {
        this.razaoSocial = razaoSocial;
        this.cnpj = cnpj;
        this.inscEstadual = inscEstadual;
        this.endereco = endereco;
        this.bairro = bairro;
        this.complemento = complemento;
        this.uf = uf;
        this.cidade = cidade;
        this.cep = cep;
        this.telefone = telefone;
        this.email = email;
        this.observacoes = observacoes;
    }
    public Fornecedor()
    {
    }
    
    //getters e setters
    public void setRazaoSocial(String razaoSocial){
        this.razaoSocial = razaoSocial;
    }
    
    public String getRazaoSocial(){
        return razaoSocial;
    }
    
    public void setCNPJ(String cnpj){
        this.cnpj = cnpj;
    }
    
    public String getCNPJ(){
        return cnpj;
    }
    
    public void setInscEstadual(String inscEstadual){
        this.inscEstadual = inscEstadual;
    }
    
    public String getInscEstadual(){
        return inscEstadual;
    }
    
    public void setEndereco(String endereco){
        this.endereco = endereco;
    }
    
    public String getEndereco(){
        return endereco;
    }
    
    public void setTelefone(String telefone){
        this.telefone = telefone;
    }
    
    public String getTelefone(){
        return telefone;
    }
    
    public void setEmail(String email){
        this.email = email;
    }
    
    public String getEmail(){
        return email;
    }
    
    public void setObservacoes(String observacoes){
        this.observacoes = observacoes;
    }
    
    public String getObservacoes(){
        return observacoes;
    }
    
    public void setComplemento(String complemento){
        this.complemento = complemento;
    }
    
    public String getComplemento(){
        return complemento;
    }
    
    public void setBairro(String bairro){
        this.bairro = bairro;
    }
    
    public String getBairro(){
        return bairro;
    }
    
    public void setUF(String uf){
        this.uf = uf;
    }
    
    public String getUF(){
        return uf;
    }
    
    public void setCidade(String cidade){
        this.cidade = cidade;
    }
    
    public String getCidade(){
        return cidade;
    }
    
    public void setCEP(String cep){
        this.cep = cep;
    }
    
    public String getCEP(){
        return cep;
    }
    
     
    
}