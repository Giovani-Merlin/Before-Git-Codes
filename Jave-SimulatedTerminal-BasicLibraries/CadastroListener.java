 


/**
 * Escreva a descrição da classe CadastroListener aqui.
 * 
 * @author (seu nome) 
 * @version (número de versão ou data)
 */
public interface CadastroListener
{
    void cadastrarPeca(int id,Peca peca);
    double achaPreco(int id);
    void venderPeca(int id, int quantidade);
    void removeKey(int id);
    boolean verificaKey(int id);
}

