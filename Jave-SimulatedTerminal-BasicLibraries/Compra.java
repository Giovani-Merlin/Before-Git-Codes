/* TRABALHO FINAL - [INF01057] PROGRAMAÇÃO ORIENTADA À OBJETO
 * 
 * NOMES: ALEX TREVISO
 *        GIOVANI B. MERLIN
 *        ENZO OLIVEIRA
 * 
 * SISTEMA DE GERENCIAMENTO DE UMA LOJA
 */ 

import java.awt.*;
import javax.swing.*;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.util.*;

public class Compra extends JPanel implements ActionListener  
    {
    private JSpinner quantidade; //Declarando um JSpinner para quantidade
    private JTextField id; //Declarando um JText para identificação
    private JComboBox<String> tamanhos;
    private JTextField fornecedor;
    private JTextField preco;
    private ButtonGroup tamanho;
    private JTextField marca; //Declarando abas de texto JTextFiel para nome e fornecedor
    private ButtonGroup categoria; //Declarando ButtonGroup para categoria
    private JComboBox<String> categorias; //Declarando JComboBox para listagem de veiculos
    private JTextArea descricao; //Declarando JTextArea para observações
    private Peca peca = null; 
    private CadastroListener listener; //CadastroListener listener vai "ouvir" eventos e mandar pro consultaEstoque
    private JButton salvar;
    
    public Compra()
    {
       //Inicializa os JTextFields
       id = new JTextField(); 
       preco = new JTextField();
       marca = new JTextField(); //Inicializando JTextFiel
       fornecedor = new JTextField(); //Inicializando JTextFiel
       quantidade = new JSpinner(); //Inicializando JSpinner
       descricao = new JTextArea();
            
       
       
       
       
       //Inicializa os JComboBox
       String[] Tamanhos = {"PP","P","M","G","GG","XXL"}; 
         
       String[] Categorias = {"Camisa","Camiseta","Casaco","Calça","Bermuda","Tenis","Meias","Cinto","Shorts"};
           
       tamanhos = new JComboBox<String>(Tamanhos);
       categorias = new JComboBox<String>(Categorias);
       
       descricao = new JTextArea(8,20);
       JScrollPane scroll_observacoes = new JScrollPane(descricao); //Criando o JScrollPane para as observações
       
       
       JLabel label_id = new JLabel("Código:");
       JLabel label_marca = new JLabel("Marca:"); //Criando as JLabels para exibição
       JLabel label_preco = new JLabel("Preço (R$)");
       JLabel label_quantidade = new JLabel("Quantidade:");
       JLabel label_categoria = new JLabel("Categoria:");
       JLabel label_tamanho = new JLabel("Tamanho:");
       JLabel label_descricao = new JLabel("Descrição:");
       JLabel label_fornecedor = new JLabel("Fornecedor:");
       
       //Implementa as ações no botão salvar
       salvar = new JButton("Salvar"); 
       salvar.addActionListener(this); 
       salvar.setActionCommand("salvar"); 
              
       JPanel painel = new JPanel();
       this.setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
       
       //Configurando o painel
       
       Box box = Box.createHorizontalBox();
       box.add(Box.createRigidArea(new Dimension(0,20)));
       box.add(Box.createRigidArea(new Dimension(30,0)));
       box.add(label_id);
       box.add(Box.createRigidArea(new Dimension(55,0)));
       id.setMaximumSize(new Dimension(600,35));
       id.setMinimumSize(new Dimension(150,35));
           
       box.add(id);
       
     
       box.setAlignmentX(RIGHT_ALIGNMENT);
      
       this.add(box);
       
       
       
       
       box = Box.createHorizontalBox();
       box.add(Box.createRigidArea(new Dimension(30,0)));
       box.add(label_marca);
       box.add(Box.createRigidArea(new Dimension(59,0)));
       marca.setMaximumSize(new Dimension(600,35));
       box.add(marca);
       box.setAlignmentX(RIGHT_ALIGNMENT);
       this.add(box);
       
      
       box = Box.createHorizontalBox();
       box.add(Box.createRigidArea(new Dimension(30,0)));
       box.add(label_fornecedor);
       box.add(Box.createRigidArea(new Dimension(30,0)));
       fornecedor.setMaximumSize(new Dimension(600,35));
       box.add(fornecedor);
       box.setAlignmentX(RIGHT_ALIGNMENT);
       this.add(box);
     
      
       box = Box.createHorizontalBox();
       box.add(Box.createRigidArea(new Dimension(30,0)));
       box.add(label_quantidade);
       box.add(Box.createRigidArea(new Dimension(30,0)));
       quantidade.setMaximumSize(new Dimension(600,35));
       box.add(quantidade);
       box.setAlignmentX(RIGHT_ALIGNMENT);
       this.add(box);
      
       
       
       Dimension min = new Dimension(600,10);
       Dimension pref = new Dimension(600,5);
       Dimension max = new Dimension(600,400);
       box = Box.createVerticalBox();
       label_categoria.setAlignmentX(0);
       
       this.add(label_tamanho);
       this.add(tamanhos);
       this.add(label_categoria);
       this.add(categorias);
      
       this.add(new Box.Filler(min,pref,max));
        
       this.add(label_descricao);
       scroll_observacoes.setMaximumSize(new Dimension(600,300));
      
       this.add(scroll_observacoes);
       
       this.add(new Box.Filler(min,pref,max));
        box = Box.createHorizontalBox();
        box.add(Box.createRigidArea(new Dimension(30,0)));
        box.add(label_preco);
        box.add(Box.createRigidArea(new Dimension(30,0)));
        preco.setMaximumSize(new Dimension(600,35));
        box.add(preco);
        box.setAlignmentX(RIGHT_ALIGNMENT);
       this.add(box);
       
       this.add(new Box.Filler(min,pref,max));
       
       this.add(salvar);
       
       this.setVisible(true);      
    }
      public Compra(Peca peca)
    {   
        this(); //chama o construtor acima
        
        this.peca = peca;
        
         
        salvar.setText("Alterar e Salvar");   
         
        marca.setText(peca.getMarca()); //abaixo só deixa pronto ja preenchido os valores que tinha
         
        fornecedor.setText(peca.getFornecedor());
        quantidade.setValue(peca.getQuantidade());
        id.setText(String.valueOf(peca.getId()));
        preco.setText(peca.getPreco());
        marca.setText(peca.getMarca());
        descricao.setText(peca.getDescricao());
        
        tamanhos.setSelectedItem(peca.getTamanho());
        categorias.setSelectedItem(peca.getCategoria());
        
        descricao.setText(peca.getDescricao()); 
        
    }
    
    
    public void actionPerformed(ActionEvent evento){
        if(this.peca == null) { //CADASTRO
        if(evento.getActionCommand() == "salvar"){
            peca = new Peca();
                     
            //configura a nova peça com os valores informados
            peca.setId(Integer.parseInt(id.getText())); 
            peca.setMarca(marca.getText());
            peca.setFornecedor(fornecedor.getText());
            peca.setQuantidade(Integer.parseInt(quantidade.getValue().toString()));
            peca.setCategoria(categorias.getSelectedItem().toString());
            peca.setTamanho(tamanhos.getSelectedItem().toString());
            peca.setDescricao(descricao.getText());
            peca.setPreco(preco.getText());
            
            listener.cadastrarPeca(peca.getId(),peca); //chama a função cadastrarPeca para efetuar o cadastro
            
            JOptionPane.showMessageDialog(this, "Nova peça cadastrada!");
            
            id.setText(" "); //reseta os campos de preenchimento
            marca.setText(" ");
            fornecedor.setText(" ");
            quantidade.setValue(0);
            categorias.setSelectedIndex(0);
            tamanhos.setSelectedIndex(0);
            descricao.setText(" ");
       }
    }
    else { //EDIÇÃO
                
                this.peca.setMarca(marca.getText());
                this.peca.setFornecedor(fornecedor.getText());
                this.peca.setQuantidade(Integer.parseInt(quantidade.getValue().toString()));
                this.peca.setCategoria(categorias.getSelectedItem().toString());
                this.peca.setTamanho(tamanhos.getSelectedItem().toString());
                this.peca.setDescricao(descricao.getText());
                this.peca.setPreco(preco.getText());
                this.peca.setFornecedor(fornecedor.getText());
                
                 if(Integer.parseInt(id.getText()) == peca.getId() )
                    listener.cadastrarPeca(peca.getId(),peca);
                    else{ 
                     
                     ConsultaEstoque temp = new ConsultaEstoque();
                     if(!temp.verificaKey(Integer.parseInt(id.getText()))){
                             
                         listener.removeKey(peca.getId());
                         this.peca.setId(Integer.parseInt(id.getText()));
                         listener.cadastrarPeca(peca.getId(),peca);
                     
                     
                    }
                        else{
                            listener.cadastrarPeca(peca.getId(),peca);
                            JOptionPane.showMessageDialog(null, "Sem alteração em Id (já em uso)");
                            //Cria erro alerta que a key ja existente então mantem a original
                    }
                    
                    }
            
        
    }
}

public void addCadastroListener(CadastroListener listener){
        this.listener = listener;
    }
    
}
