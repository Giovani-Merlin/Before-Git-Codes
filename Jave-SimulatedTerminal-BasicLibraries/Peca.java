/* TRABALHO FINAL - [INF01057] PROGRAMAÇÃO ORIENTADA À OBJETO
 * 
 * NOMES: ALEX TREVISO
 *        GIOVANI B. MERLIN
 *        ENZO OLIVEIRA
 * 
 * SISTEMA DE GERENCIAMENTO DE UMA LOJA
 */ 

public class Peca
{
    //declarando as variáveis 
    private int id = 0;
    private String marca;
    private String fornecedor;
    private int quantidade;
    private String categoria;
    private String preco;
    private String descricao;
    private String tamanho;

    //Inicializa os atributos da peça
    public Peca(int id, String marca, String fornecedor, int quantidade, String categoria, String tamanho,String descricao, String preco)
    {
        this.id = id;
        this.marca = marca;
        this.fornecedor = fornecedor;
        this.quantidade = quantidade;
        this.categoria = categoria;
        this.preco = preco;
        this.descricao = descricao;
        this.tamanho = tamanho;
    }
    public Peca()
    {
    }
    
    //Declarando os getter e setters
    public void setId(int id){
        this.id = id;
    }
    
    public int getId(){
        return id;
    }
    
    public void setMarca(String nome){
        this.marca = nome;
    }
    
    public String getMarca(){
        return marca;
    }

    public void setFornecedor(String fornecedor){
        this.fornecedor = fornecedor;
    }
    
    public String getFornecedor(){
        return fornecedor;
    }
    
    public void setQuantidade(int quantidade){
        this.quantidade = quantidade;
    }
    
    public int getQuantidade(){
        return quantidade;
    }

    public void setCategoria(String categoria){
        this.categoria = categoria;
    }
    
    public String getCategoria(){
        return categoria;
    }
    
    public void setTamanho(String tamanho){
        this.tamanho = tamanho;
    }
    
    public String getTamanho(){
        return tamanho;
    }
    
    public void setDescricao(String descricao){
        this.descricao = descricao;
    }
    
    public String getDescricao(){
        return descricao;
    }
    public void setPreco(String preco){
        this.preco = preco;
    }
    public String getPreco(){
        return preco;
    }
}
