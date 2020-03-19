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
import java.text.SimpleDateFormat;
import java.io.IOException; 
import java.io.*; 
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

public class CadastraCliente extends JPanel implements ActionListener
{
    //Declarando todos os componentes a serem utilizados na interface
    
    private JTextField nome; 
    private JTextField email;
    private JTextField endereco, bairro, complemento, cep, uf, cidade; 
    private JTextField cpf;
    private JTextField rg;
    private JTextField telefone;
    private JRadioButton masculino; 
    private JRadioButton feminino;
    private ButtonGroup sexo; 
    private JTextArea observacoes; 
    private JButton salvar, buscar;
    private JTextField nascimento;
    private JDialog dialog;
    private static ArrayList<Cliente> clientesList = new ArrayList(); //criando um ArrayList de clientes
    
    private Cliente cliente = null;

    public CadastraCliente()
    {
       //clientesList.add(new Cliente("Alex Treviso", "01593651040", "4114175831", "Rua Doutora Rita Lobato - 150", "Praia de Belas", "Apto 302", "90.110-040", "RS", "Porto Alegre", "07/02/1996","Masculino", "54-999646329", "alextreviso@gmail.com", ""));
       
       nome = new JTextField(""); 
       cpf = new JTextField(); 
       rg = new JTextField(); 
       email = new JTextField();
       endereco = new JTextField();
       bairro = new JTextField();
       complemento = new JTextField();
       cep = new JTextField();
       uf = new JTextField();
       cidade = new JTextField();
       telefone = new JTextField();
       nascimento = new JTextField();
       
       /*spinnerData = new SpinnerDateModel();   //IAMOS USAR UM JSPINNERDATA, MAS NÃO CONSEGUIMOS SUA MANIPULAÇÃO CORRETA
       nascimento = new JSpinner(spinnerData);
       nascimento.setEditor(new JSpinner.DateEditor(nascimento,"dd/MM/yyyy"));*/
    
             
       masculino = new JRadioButton("Masculino"); //Inicializando os JRadioButton
       masculino.setActionCommand("masculino"); 
       feminino = new JRadioButton("Feminino");
       feminino.setActionCommand("feminino"); 
       sexo = new ButtonGroup(); //Agrupando os 2 JRadioButton
       sexo.add(masculino);
       sexo.add(feminino);
       
       observacoes = new JTextArea(2,30);
       
       //Criando as JLabels para exibição
       JLabel label_nome = new JLabel("Nome:");
       JLabel label_cpf = new JLabel("CPF:"); 
       JLabel label_rg = new JLabel("RG:");
       JLabel label_email = new JLabel("E-mail:");
       JLabel label_sexo = new JLabel("Sexo:");
       JLabel label_nascimento = new JLabel("Data de Nascimento:");
       JLabel label_observacoes = new JLabel("Observações:");
       JLabel label_telefone = new JLabel("Telefone:");
       JLabel label_endereco = new JLabel("Endereço:");
       JLabel label_bairro = new JLabel("Bairro:");
       JLabel label_complemento = new JLabel("Complemento:");
       JLabel label_cep = new JLabel("CEP:");
       JLabel label_cidade = new JLabel("Cidade:");
       JLabel label_uf = new JLabel("Estado:");
       
       //Implementando os botões salvar e buscar
       salvar = new JButton("Salvar"); //Criando o JButton salvar
       salvar.addActionListener(this); 
       salvar.setActionCommand("salvar");
       
       buscar = new JButton("Buscar"); //Criando o JButton buscar
       buscar.addActionListener(this); 
       buscar.setActionCommand("buscar");
       
       //configurando a exibição da interface
       this.setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
       this.add(label_nome); 
       this.add(nome); 
       this.add(label_cpf);
       this.add(cpf);
       this.add(label_rg);
       this.add(rg);
       this.add(label_nascimento);
       this.add(nascimento);
       this.add(label_sexo);
       this.add(masculino);
       masculino.setSelected(true);
       this.add(feminino);
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
    
    public CadastraCliente(Cliente cliente)
    {
        this(); //chama o construtor acima
        
        this.cliente = cliente;
        
        salvar.setText("Alterar e Salvar");
                 
        nome.setText(cliente.getNome()); 
        rg.setText(String.valueOf(cliente.getRG()));
        endereco.setText(cliente.getEndereco());
        cpf.setText(String.valueOf(cliente.getCPF()));
         
        observacoes.setText(cliente.getObservacoes()); 
        
    }
    //implementa as ações dos botões salvar e buscar
    public void actionPerformed(ActionEvent evento){
            if(evento.getActionCommand() == "salvar")
            {
                cliente = new Cliente();
                     
                //Atribui o valor informado ao novo cliente
                cliente.setRG(rg.getText()); 
                cliente.setNome(nome.getText());
                cliente.setEndereco(endereco.getText());
                cliente.setBairro(bairro.getText());
                cliente.setComplemento(complemento.getText());
                cliente.setCidade(cidade.getText());
                cliente.setUF(uf.getText());
                cliente.setCEP(cep.getText());
                cliente.setCPF(cpf.getText());
                cliente.setSexo(sexo.getSelection().getActionCommand());
                cliente.setTelefone(telefone.getText());
                cliente.setObservacoes(observacoes.getText());
                
                
                cadastrarCliente(cliente.getCPF(),cliente); //Chama a função cadastrarCliente para realizar o novo cadastro
                           
                JOptionPane.showMessageDialog(this, "Novo cliente cadastrado!");
                
                //reseta os campos de preenchimento
                nome.setText(" "); 
                rg.setText(" ");
                cpf.setText("");
                nascimento.setText(" ");
                sexo.clearSelection();
                endereco.setText(" ");
                bairro.setText(" ");
                complemento.setText(" ");
                cidade.setText(" ");
                uf.setText(" ");
                cep.setText(" ");    
                email.setText(" ");
                telefone.setText(" ");
                observacoes.setText(" ");
                
                this.salvarClientes(); //Salva de novo para atualizar a lista de clientes
                this.setVisible(false);
                
            
            }
            else if(evento.getActionCommand() == "buscar")
                    {
                        cliente = new Cliente();
                        
                        //Verifica se informou o nome, caso contrário realiza a busca por CPF
                        if(!nome.getText().isEmpty())
                            cliente = buscaCliente(nome.getText());
                            else
                                cliente = buscaCliente(cpf.getText());
                              
                        //preenche os campos com os atributos do cliente buscado 
                        nome.setText(cliente.getNome());
                        cpf.setText(cliente.getCPF());
                        rg.setText(cliente.getRG());
                        endereco.setText(cliente.getEndereco());
                        bairro.setText(cliente.getBairro());
                        complemento.setText(cliente.getComplemento());
                        cidade.setText(cliente.getCidade());
                        uf.setText(cliente.getUF());
                        cep.setText(cliente.getCEP());
                        email.setText(cliente.getEmail());
                        telefone.setText(cliente.getTelefone());
                        
                        if(cliente.getSexo().equals("Masculino"))
                            masculino.setSelected(true);
                            else
                                feminino.setSelected(true);
                                
                        observacoes.setText(cliente.getObservacoes());
                        nascimento.setText(cliente.getNascimento());
                        
                        
             }
        
           }
    
            
   public void cadastrarCliente(String cpf, Cliente cliente){ //Função pra fazer a ação de quando um cliente é cadastrado
        int i=0;
        int n;
        
        n = clientesList.size();
        
       for(i=0; i<n; i++){
        if(clientesList.get(i).getCPF() == cpf)  //SE ELE NÃO TEM JÁ UM CLIENTE REFERENTE À ESSE ID (CLIENTE NOVO)
            clientesList.set(i,cliente); 
            else
            clientesList.add(cliente);
        
        
        
      } 
   }
   
    //Função de busca para encontrar clientes já existentes
   public Cliente buscaCliente(String achou){
        int i,n;
        Cliente cliente = null;
        
        n = clientesList.size(); //Pega tamanho da arrayList 
        for(i=0;i<n;i++){
            if(achou.equals(clientesList.get(i).getNome()))
                cliente = clientesList.get(i); //Se encontrar o cliente com mesmo nome, atribui a variavel
               else if(achou.equals(String.valueOf(clientesList.get(i).getCPF())))
                    cliente = clientesList.get(i); //Se encontrar o cliente com mesmo CPF atribui a variavel
                
            }
            
        return cliente;
      
    }
    
   //Funções de manipulação de arquivos para salvar clientes 
   private void salvarClientes(){
         try{

                             String diretorio = System.getProperty("user.dir");
                             diretorio = diretorio + "\\" + "Clientes.csv";
                             
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
        for (Cliente cliente : clientesList ) { //percorro do identificador ("0" até o final do chaves)
                 
          csvData += cliente.getNome()+","+cliente.getCPF()+","+cliente.getRG();
          
          csvData += "," + cliente.getNascimento() + "," + cliente.getSexo() + ","+cliente.getEndereco() + "," +cliente.getBairro()+ "," + cliente.getComplemento() + "," + cliente.getCEP() + "," + cliente.getUF() + "," + cliente.getCidade() + "," + cliente.getTelefone() + "," + cliente.getEmail() + "," + cliente.getObservacoes()+"\n" ; 
        }
        return csvData;
    }
          
   public void setArrayData(ArrayList<Cliente> clienteList){
         clientesList = clienteList;
             
        
   }
            
}
    
   
        