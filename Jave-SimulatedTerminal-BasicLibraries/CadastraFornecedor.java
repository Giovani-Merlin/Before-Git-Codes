/* TRABALHO FINAL - [INF01057] PROGRAMAÇÃO ORIENTADA À OBJETO
 * 
 * NOMES: ALEX TREVISO
 *        GIOVANI B. MERLIN
 *        ENZO OLIVEIRA
 * 
 * SISTEMA DE GERENCIAMENTO DE UMA LOJA
 */ 

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.*; 
import javax.swing.*;
import java.util.* ;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import javax.swing.table.*;
import javax.swing.event.*;
import java.io.IOException; 
import java.io.*; 
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

public class CadastraFornecedor extends JPanel implements ActionListener
{
    private JTextField razaoSocial; //Declarando um JText para identificação
    private JTextField email;
    private JTextField endereco, bairro, complemento, cep, uf, cidade; //Declarando abas de texto JTextFiel para nome e fornecedor
    private JTextField cnpj;
    private JTextField inscEstadual;
    private JTextField telefone;
    private JTextArea observacoes; //Declarando JTextArea para observações
    private JButton salvar, buscar;
    
    private static ArrayList<Fornecedor> fornecedoresList = new ArrayList();   
    private Fornecedor fornecedor = null;

    public CadastraFornecedor()
    {
       razaoSocial = new JTextField(); 
       cnpj = new JTextField(); //Inicializando JTextFiel
       inscEstadual = new JTextField(); //Inicializando JTextFiel
       email = new JTextField();
       endereco = new JTextField();
       bairro = new JTextField();
       complemento = new JTextField();
       cep = new JTextField();
       uf = new JTextField();
       cidade = new JTextField();
       telefone = new JTextField();
              
       observacoes = new JTextArea(2,30);
       
       
       JLabel label_razaoSocial = new JLabel("Nome:");
       JLabel label_cnpj = new JLabel("CNPJ:"); //Criando as JLabels para exibição
       JLabel label_ie = new JLabel("Insc. Estadual:");
       JLabel label_email = new JLabel("E-mail:");
       JLabel label_observacoes = new JLabel("Observações:");
       JLabel label_telefone = new JLabel("Telefone:");
       JLabel label_endereco = new JLabel("Endereço:");
       JLabel label_bairro = new JLabel("Bairro:");
       JLabel label_complemento = new JLabel("Complemento:");
       JLabel label_cep = new JLabel("CEP:");
       JLabel label_cidade = new JLabel("Cidade:");
       JLabel label_uf = new JLabel("Estado:");
       
       salvar = new JButton("Salvar"); //Criando o JButton salvar
       salvar.addActionListener(this); 
       salvar.setActionCommand("salvar");
       
       buscar = new JButton("Buscar"); //Criando o JButton salvar
       buscar.addActionListener(this); 
       buscar.setActionCommand("buscar");
       
       
       //Configurando a interface a ser exibida em fornecedores
       this.setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
       this.add(label_razaoSocial);
       this.add(razaoSocial); 
       this.add(label_cnpj);
       this.add(cnpj);
       this.add(label_ie);
       this.add(inscEstadual);
       this.add(label_endereco);
       this.add(endereco);       
       this.add(label_bairro);
       this.add(bairro);
       this.add(label_complemento);
       this.add(complemento);
       this.add(label_cep);
       this.add(cep);
       this.add(label_uf);
       this.add(uf);
       this.add(label_cidade);
       this.add(cidade);
       this.add(label_email);
       this.add(email);
       this.add(label_telefone);
       this.add(telefone);
       this.add(label_observacoes);
       this.add(observacoes);
       this.add(salvar);
       this.add(buscar);
       
       this.setVisible(true);     
         
       
    }
    
    public CadastraFornecedor(Fornecedor fornecedor)
    {
        this();
        
        this.fornecedor = fornecedor;
        
    }
    
    //Configurando os eventos
    public void actionPerformed(ActionEvent evento)
    {
            if(evento.getActionCommand() == "salvar"){
                fornecedor = new Fornecedor();
                
                //atualiza os campos do fornecedor com os dados informados
                fornecedor.setRazaoSocial(razaoSocial.getText());
                fornecedor.setCNPJ(cnpj.getText());
                fornecedor.setInscEstadual(inscEstadual.getText());
                fornecedor.setEndereco(endereco.getText());
                fornecedor.setBairro(bairro.getText());
                fornecedor.setComplemento(complemento.getText());
                fornecedor.setCidade(cidade.getText());
                fornecedor.setUF(uf.getText());
                fornecedor.setCEP(cep.getText());
                fornecedor.setTelefone(telefone.getText());
                fornecedor.setEmail(email.getText());
                fornecedor.setObservacoes(observacoes.getText());
                
                cadastrarFornecedor(fornecedor.getCNPJ(), fornecedor); //Chama a função cadastrarFornecedor que realizará o cadastro do novo fornecedor
                
                JOptionPane.showMessageDialog(this, "Novo fornecedor cadastrado!");
                
                razaoSocial.setText(" "); //reseta os campos de preenchimento
                cnpj.setText(" ");
                inscEstadual.setText(" ");
                endereco.setText(" ");
                bairro.setText(" ");
                complemento.setText(" ");
                cidade.setText(" ");
                uf.setText(" ");
                cep.setText(" "); 
                telefone.setText(" ");
                email.setText(" ");
                observacoes.setText(" ");
                this.salvarFornecedores();
                 
            }
            
            else if (evento.getActionCommand() == "buscar")
                    {
                        fornecedor = new Fornecedor();
                        
                        //Verifica se informou a razão social e busca ou busca por cnpj
                        if(!razaoSocial.getText().isEmpty())
                            fornecedor = buscaFornecedor(razaoSocial.getText());
                            else{
                                fornecedor = buscaFornecedor(cnpj.getText());}
                              
                        //Atualiza os campos com os dados do fornecedor buscado     
                       
                        razaoSocial.setText(fornecedor.getRazaoSocial());
                        cnpj.setText(fornecedor.getCNPJ());
                        inscEstadual.setText(fornecedor.getInscEstadual());
                        endereco.setText(fornecedor.getEndereco());
                        bairro.setText(fornecedor.getBairro());
                        complemento.setText(fornecedor.getComplemento());
                        cidade.setText(fornecedor.getCidade());
                        uf.setText(fornecedor.getUF());
                        cep.setText(fornecedor.getCEP());
                        email.setText(fornecedor.getEmail());
                        telefone.setText(fornecedor.getTelefone());
                        observacoes.setText(fornecedor.getObservacoes());
                
             }
    }
    
    public void cadastrarFornecedor(String cnpj, Fornecedor fornecedor){ 
        int i=0;
        int n;
        n = fornecedoresList.size();
        //Adicionando um novo fornecedor na lista
       for(i=0; i<n; i++){
        if(fornecedoresList.get(i).getCNPJ() == cnpj)  
            fornecedoresList.set(i,fornecedor); 
            else
            fornecedoresList.add(fornecedor);
        
      } 
   }
   
   //Função que busca o fornecedor e retorna-o
   public Fornecedor buscaFornecedor(String achou){
        int i,n;
        Fornecedor fornecedor = null;
        
        n = fornecedoresList.size();
        for(i=0;i<n;i++){
            if(achou.equals(fornecedoresList.get(i).getRazaoSocial()))
                fornecedor = fornecedoresList.get(i);
               else if(achou.equals(String.valueOf(fornecedoresList.get(i).getCNPJ())))
                    fornecedor = fornecedoresList.get(i);
                
            }
            
            return fornecedor;
      
    }
    
    //Funções de manipulação de arquivo para salvar a lista de fornecedores
    private void salvarFornecedores(){
         try{
                             String diretorio = System.getProperty("user.dir");
                             diretorio = diretorio + "\\" + "Fornecedores.csv";
                             
                             File file = new File(diretorio);
                             FileWriter writer = new FileWriter(file,false);
                             BufferedWriter bw = new BufferedWriter(writer);
                             
                             bw.write(this.getCsvData());
                             
                             bw.close();
                             writer.close();
                        } catch (IOException ioe) {
                            System.err.println("Erro na salvada do arquivo.csv");
                        } 
    }
    
    public String getCsvData(){
        String csvData = "";
        
        for (Fornecedor fornecedor : fornecedoresList ) { //percorro do identificador ("0" até o final do chaves)
                
            csvData += fornecedor.getRazaoSocial() + "," + fornecedor.getCNPJ() + "," + fornecedor.getInscEstadual();
          
            csvData += "," + fornecedor.getEndereco() + "," + fornecedor.getBairro() + "," + fornecedor.getComplemento() + "," + fornecedor.getCEP() + "," + fornecedor.getUF() + "," + fornecedor.getCidade() + "," + fornecedor.getTelefone() + "," + fornecedor.getEmail() + "," + fornecedor.getObservacoes() + "\n" ; 
        }
        return csvData;
    }
    
    public void setArrayData(ArrayList<Fornecedor> fornecedorList){
         fornecedoresList = fornecedorList;
          
        
        }
}
