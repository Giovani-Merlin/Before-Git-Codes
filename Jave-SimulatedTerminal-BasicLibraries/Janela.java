/* TRABALHO FINAL - [INF01057] PROGRAMAÇÃO ORIENTADA À OBJETO
 * 
 * NOMES: ALEX TREVISO
 *        GIOVANI B. MERLIN
 *        ENZO OLIVEIRA
 * 
 * SISTEMA DE GERENCIAMENTO DE UMA LOJA
 */ 

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.awt.BorderLayout;
import javax.swing.border.*;
import java.io.File;
import java.io.FileReader;
import java.io.IOException; 
import java.io.*; 
import java.util.ArrayList;

public class Janela extends JFrame implements ActionListener
{
    private ConsultaEstoque painelEstoque;
    private Compra compra;
    private CadastraCliente cadastraCliente;
    private CadastraFornecedor cadastraFornecedor;
    private Venda venda;
    private JMenuItem estoque, sair, clientes, fornecedores, comprar, vender;
        
    public Janela()
    {
        //Chama construtor do JFrame, onde pode se passar o título da janela
        super("SISTEMA DE GERENCIAMENTO DE UMA LOJA");
        
        this.setJMenuBar(carregarMenu());

        //Caso queira que a janela tenha o tamanho exato dos objetos que compõe ela
        
        this.setContentPane(painelInicial());
        this.pack();
        
        //Configura os limites do tamanho da janela, nesse caso, não vai ser possível modificar o tamanho da janela caso ambos estejam ativos
        this.setMaximumSize(this.getSize()); 
        this.setMinimumSize(this.getSize());
        
        //Faz com que sua janela apareça
        this.setVisible(true);
    }
    
    private JPanel carregarPainelVenda()
    {
        JPanel panVen = new JPanel(); //Inicializa um novo JPanel;
        JTabbedPane tabpanVen = new JTabbedPane(); //Inicializa um novo JTabbedPane;
        
        venda = new Venda(); //Inicializa a venda;
        
        painelEstoque = new ConsultaEstoque(); //Inicializa um novo objeto ConsultaEstoque;
        venda.addCadastroListener(painelEstoque); //Adiciona um listener do estoque na função venda;
        
        tabpanVen.add("Venda", venda); //Configurando o JTabbedPane;
        
        panVen.add(tabpanVen); //Adiciona o JTabbedPane no nosso JPanel
        
        return panVen;
    }
    
    private JPanel carregarPainelCompra()
    {
        JPanel panCompra = new JPanel(); //Inicializa um novo JPanel;
        JTabbedPane tab_panCompra = new JTabbedPane(); //Inicializa um novo JTabbedPane;
        
        compra = new Compra(); //Inicializa a compra;
        
        painelEstoque = new ConsultaEstoque(); //Inicializa um novo objeto ConsultaEstoque;
        compra.addCadastroListener(painelEstoque); //Adiciona um listener do estoque na função compra;
        
        tab_panCompra.add("Compra", compra); //Configurando o JTabbedPane;
        
        panCompra.add(tab_panCompra); //Adiciona o JTabbedPane no nosso JPanel
        
        return panCompra;
    }
            
        
    
    private JPanel carregarPainelClientes()
    {
        JPanel pan_cliente = new JPanel(); //Inicializa um novo JPanel;
        JTabbedPane tab_pan_cliente = new JTabbedPane(); //Inicializa um novo JTabbedPane;
        
        cadastraCliente = new CadastraCliente(); //Inicializando o cadastraCliente;
                
        tab_pan_cliente.add("Clientes", cadastraCliente); //Configurando o JTabbedPane;
                
        pan_cliente.add(tab_pan_cliente);  //Adiciona o JTabbedPane no nosso JPanel
        
        return pan_cliente;
    }
    
    private JPanel carregarPainelFornecedores()
    {
        JPanel pan_fornecedor = new JPanel(); //Inicializa um novo JPanel;
        JTabbedPane tab_pan_fornecedor = new JTabbedPane(); //Inicializa um novo JTabbedPane;
        
        cadastraFornecedor = new CadastraFornecedor(); //Inicializando o cadastraFornecedor;
                
        tab_pan_fornecedor.add("Fornecedores", cadastraFornecedor); //Configurando o JTabbedPane;
        
        pan_fornecedor.add(tab_pan_fornecedor); //Adiciona o JTabbedPane no nosso JPanel
        
        return pan_fornecedor;
    }
        
    
    private JPanel carregarPainelEstoque()
    {
        JPanel pan_main = new JPanel(); //Declarando painel (agrupador de componentes)
        JTabbedPane tab_pan = new JTabbedPane(); //Declarando e instanciando o JTabbedPane
        
        painelEstoque = new ConsultaEstoque(); //Cria o painel de consulta 
                
        tab_pan.add("Estoque", painelEstoque); //Adicionando a aba consulta no nosso JTabbedPane
                
        pan_main.add(tab_pan); //Adicionando o JTabbedPane no JPanel para exibição
                               
        return pan_main;
    }
    
    private JMenuBar carregarMenu()
    {
        //Barras de menus são compostas por menus
        JMenuBar mbr_barra = new JMenuBar();
        JMenu menuLoja = new JMenu("Minha Loja"); //cria o menu principal
        
        clientes = new JMenuItem("Clientes"); //criando o JMenuItem que dará acesso aos clientes
        fornecedores = new JMenuItem("Fornecedores"); //criando o JMenuItem que dará acesso aos fornecedores
        estoque = new JMenuItem("Estoque"); //criando o JMenuItem que dará acesso ao estoque
        comprar = new JMenuItem("Comprar"); //criando o JMenuItem que dará acesso as compras
        vender = new JMenuItem("Vender"); //criando o JMenuItem que dará acesso as vendas
        
        sair = new JMenuItem("Sair"); //cria o item sair
        
             
        setAction(); // implementa as acoes nos botoes
        
        //Adicionando os itens no nosso menu
        menuLoja.add(vender);
        menuLoja.add(comprar);
        menuLoja.addSeparator();
        menuLoja.add(clientes);
        menuLoja.add(fornecedores);
        menuLoja.addSeparator();
        menuLoja.add(estoque);
        menuLoja.addSeparator();
        menuLoja.add(sair);
        mbr_barra.add(menuLoja);
        
        
        return mbr_barra;
    }
    
     private void setAction()
    {
        //DECLARANDO OS LISTENERS JMENU
        
        estoque.addActionListener(this);
        estoque.setActionCommand("estoque"); 
        
        clientes.addActionListener(this);
        clientes.setActionCommand("clientes");
        
        fornecedores.addActionListener(this);
        fornecedores.setActionCommand("fornecedores");
        
        vender.addActionListener(this);
        vender.setActionCommand("vender");
        
        comprar.addActionListener(this);
        comprar.setActionCommand("comprar");
               
        sair.addActionListener(this);
        sair.setActionCommand("sair");
               
    }
    
     public void actionPerformed(ActionEvent eve)
    {
        if(eve.getActionCommand() == "estoque"){
            this.setContentPane(carregarPainelEstoque());
            this.setVisible(true);
            this.carregarEstoque();
        }
        
            else if(eve.getActionCommand() == "clientes"){
                this.setContentPane(carregarPainelClientes());
                this.setVisible(true);
                this.carregarClientes();
            }
                else if(eve.getActionCommand() == "fornecedores"){
                    this.setContentPane(carregarPainelFornecedores());
                    this.setVisible(true);
                    this.carregarFornecedores();
                }
            
                    else if(eve.getActionCommand() == "vender"){
                        this.setContentPane(carregarPainelVenda());
                        this.setVisible(true);
                        this.carregarEstoque();              
                    }
                    
                        else if(eve.getActionCommand() == "comprar"){
                            this.setContentPane(carregarPainelCompra());
                            this.setVisible(true);
                            this.carregarEstoque();
                        }
           
             
                    
                            else if(eve.getActionCommand() == "sair"){
                                int result = JOptionPane.showConfirmDialog(null,"Deseja mesmo sair? ","Sair",JOptionPane.YES_NO_OPTION);
                                if(result == JOptionPane.YES_OPTION)
                                System.exit(0);
                            }
    } 
    
    //Declarando a função que irá carregar o estoque do arquivo .csv toda vez que chamada
    private void carregarEstoque(){
                  try{
                        String diretorio = System.getProperty("user.dir");
                             diretorio = diretorio + "\\" + "Estoque.csv";
                             
                             File file = new File(diretorio);
                                if(!file.exists()){
                                 file.createNewFile();
                                }
                             FileReader fr = new FileReader(file);
                             BufferedReader br = new BufferedReader(fr);
                             ArrayList<Peca> pecalista = new ArrayList<Peca>();
                          
                        while (br.ready()) {
                             //lê a proxima linha
                             String linha = br.readLine();
                             //usa a virgula como delimitador (arquivo tipo CSV)
                             String[] csvData = linha.split(",");
                             //instancia novo objeto do tipo Peca e preenche os seus atributos.
                             Peca peca = new Peca();
                             
                             peca.setId(Integer.parseInt(csvData[0]));
                             if(csvData[1] != null)
                             peca.setMarca(csvData[1]);
                             if(csvData[2] != null)
                             peca.setFornecedor(csvData[2]);
                             if(csvData[3] != null)
                             peca.setQuantidade(Integer.parseInt(csvData[3]));
                             else
                             peca.setQuantidade(0);
                             peca.setCategoria(csvData[4]);
                             peca.setTamanho(csvData[5]);
                             if(csvData[6] != null)
                             peca.setPreco(csvData[6]);
                             if(csvData.length > 7 )
                             peca.setDescricao(csvData[7]);
                                                          
                             pecalista.add(peca);
                        }
                        //fechando os recursos
                        br.close();
                        fr.close();
                        //antes de concluir, atualiza este novo ArrayList no PainelConsulta
                        painelEstoque.setArrayData(pecalista);
                    } catch (IOException ioe) {
                        System.err.println("Erro na abertura do arquivo.csv");
                    } 
                }
             
                 private void carregarClientes(){
                  try{
                        String diretorio = System.getProperty("user.dir");
                             diretorio = diretorio + "\\" + "Clientes.csv";
                             
                             File file = new File(diretorio);
                             
                             if(!file.exists()){
                                 file.createNewFile();
                                }
                            
                             FileReader fr = new FileReader(file);
                             BufferedReader br = new BufferedReader(fr);
                             ArrayList<Cliente> clientelista = new ArrayList<Cliente>();
                             
                        while (br.ready()) {
                             //lê a proxima linha
                             String linha = br.readLine();
                             //usa a virgula como delimitador (arquivo tipo CSV)
                             String[] csvData = linha.split(",");
                             //instancia novo objeto do tipo Peca e preenche os seus atributos.
                             Cliente cliente = new Cliente();
                             int i;
                             for(i=0;i<13;i++){
                                if(csvData[i]==null)
                                    csvData[i]=" ";
                                }
                             cliente.setNome(csvData[0]);
                             cliente.setCPF(csvData[1]);
                              
                             cliente.setRG(csvData[2]);
                             
                             cliente.setNascimento(csvData[3]);
                            
                             cliente.setSexo(csvData[4]);
                            
                             cliente.setEndereco(csvData[5]);
                            
                             cliente.setBairro(csvData[6]);
                         
                             cliente.setComplemento(csvData[7]);
                            
                             cliente.setCEP(csvData[8]);
                      
                             cliente.setUF(csvData[9]);
                          
                             cliente.setCidade(csvData[10]);
                           
                             cliente.setTelefone(csvData[11]);
                              
                             cliente.setEmail(csvData[12]);
                             if(csvData.length > 13 )
                                 if(cliente.getObservacoes() == null)
                                    cliente.setObservacoes(" ");
                                    else
                                        cliente.setObservacoes(csvData[13]);
                                                          
                             clientelista.add(cliente);
                        }
                        //fechando os recursos
                        br.close();
                        fr.close();
                        //antes de concluir, atualiza este novo ArrayList no PainelConsulta
                        
                        cadastraCliente.setArrayData(clientelista);
                    } 
                    catch (IOException ioe) {
                        System.err.println("Erro na abertura do arquivo.csv");
                    } 
                }
                
     private void carregarFornecedores(){
         try{
             String diretorio = System.getProperty("user.dir");
             diretorio = diretorio + "\\" + "Fornecedores.csv";
                             
             File file = new File(diretorio);
             if(!file.exists()){
                 file.createNewFile();
             }
             
             FileReader fr = new FileReader(file);
             BufferedReader br = new BufferedReader(fr);
             ArrayList<Fornecedor> fornecedorlista = new ArrayList<Fornecedor>();
                             
             while (br.ready()) {
             //lê a proxima linha
             String linha = br.readLine();
             //usa a virgula como delimitador (arquivo tipo CSV)
             String[] csvData = linha.split(",");
             //instancia novo objeto do tipo Peca e preenche os seus atributos.
             Fornecedor fornecedor = new Fornecedor();
             int i;
             
             for(i=0;i<=10;i++){
               if(csvData[i]==null)
                   csvData[i]=" ";
             }
             fornecedor.setRazaoSocial(csvData[0]);
             
             fornecedor.setCNPJ(csvData[1]);
                              
             fornecedor.setInscEstadual(csvData[2]);
                             
             fornecedor.setEndereco(csvData[3]);
                            
                                                         
                                                        
             fornecedor.setBairro(csvData[4]);
                         
             fornecedor.setComplemento(csvData[5]);
                            
             fornecedor.setCEP(csvData[6]);
                      
             fornecedor.setUF(csvData[7]);
                          
             fornecedor.setCidade(csvData[8]);
                           
             fornecedor.setTelefone(csvData[9]);
                              
             fornecedor.setEmail(csvData[10]);
                            
             if(csvData.length > 11 )
                   if(fornecedor.getObservacoes() == null)
                        fornecedor.setObservacoes(" ");
                        else
                           fornecedor.setObservacoes(csvData[11]);
                                                                                      
             fornecedorlista.add(fornecedor);
             }
                       
             //fechando os recursos
             br.close();
             fr.close();
             //antes de concluir, atualiza este novo ArrayList no PainelConsulta
                        
             cadastraFornecedor.setArrayData(fornecedorlista);
         } catch (IOException ioe) {
                 System.err.println("Erro na abertura do arquivo.csv");
           } 
                    
    }
                
    public JPanel painelInicial(){
                    
        JPanel panel = new JPanel(); //cria o JPanel inicial;
        JLabel jlabel = new JLabel("SISTEMA DE GERENCIAMENTO"); //Declarando as JLabel a serem exibidas na tela inicio;
        JLabel jlabel2 = new JLabel("DE UMA LOJA");
        jlabel.setFont(new Font("Verdana",1,20));
        jlabel2.setFont(new Font("Verdana",1,20));
        
        //Configurando a tela inicial de exibição
        panel.setLayout(new BoxLayout(panel,BoxLayout.Y_AXIS));
        Box box = Box.createHorizontalBox();
        panel.add(Box.createRigidArea(new Dimension(100,250)));
        box.add(Box.createRigidArea(new Dimension(220,50)));
        box.add(jlabel);
        box.add(Box.createRigidArea(new Dimension(220,50)));
                                                                
        panel.add(box);
                      
                      
        box = Box.createHorizontalBox();
                      
        box.add(Box.createRigidArea(new Dimension(220,50)));
        box.add(jlabel2);
        box.add(Box.createRigidArea(new Dimension(220,50)));
                      
        panel.add(box);
        panel.add(Box.createRigidArea(new Dimension(500,400)));
                      
        panel.setBorder(new LineBorder(Color.BLACK));
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
                     
                 
        panel.setSize(400,400);
        return(panel);
    }
}