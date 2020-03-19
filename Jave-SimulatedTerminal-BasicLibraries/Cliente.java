/* TRABALHO FINAL - [INF01057] PROGRAMAÇÃO ORIENTADA À OBJETO
 * 
 * NOMES: ALEX TREVISO
 *        GIOVANI B. MERLIN
 *        ENZO OLIVEIRA
 * 
 * SISTEMA DE GERENCIAMENTO DE UMA LOJA
 */ 

public class Cliente
{
    // variáveis de instância
    private String nome;
    private String cpf, rg;
    private String nascimento;
    private String sexo;
    private String endereco, bairro, complemento, cep, uf, cidade;
    private String telefone;
    private String email;
    private String observacoes;

    //Inicializando os atributos de cliente
    public Cliente(String nome, String cpf, String rg, String endereco, String bairro, String complemento, String cep, String uf, String cidade, String nascimento, String sexo, String telefone, String email, String observacoes)
    {
        this.rg = rg;
        this.nome = nome;
        this.cpf = cpf;
        this.endereco = endereco;
        this.bairro = bairro;
        this.complemento = complemento;
        this.cep = cep;
        this.uf = uf;
        this.cidade = cidade;
        this.sexo = sexo;
        this.telefone = telefone;
        this.email = email;
        this.nascimento = nascimento;
        this.observacoes = observacoes;
    }
    public Cliente()
    {
    }
    
    //getters e setters
    
    public void setNome(String nome){
        this.nome = nome;
    }
    
    public String getNome(){
        return nome;
    }
    
    public void setRG(String rg){
        this.rg = rg;
    }
    
    public String getRG(){
        return rg;
    }

    public void setCPF(String cpf){
        this.cpf = cpf;
    }
    
    public String getCPF(){
        return cpf;
    }
    
    public void setEndereco(String endereco){
        this.endereco = endereco;
    }
    
    public String getEndereco(){
        return endereco;
    }

    public void setNascimento(String nascimento){
        this.nascimento = nascimento;
    }
    
    public String getNascimento(){
        return nascimento;
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
    
    public void setSexo(String sexo){
        this.sexo = sexo;
    }
    
    public String getSexo(){
        return sexo;
    }
    
    public void setTelefone(String telefone){
        this.telefone = telefone;
    }
    
    public String getTelefone(){
        return telefone;
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