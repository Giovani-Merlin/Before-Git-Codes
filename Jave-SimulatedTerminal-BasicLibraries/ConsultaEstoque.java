/* TRABALHO FINAL - [INF01057] PROGRAMAÇÃO ORIENTADA À OBJETO
 * 
 * NOMES: ALEX TREVISO
 *        GIOVANI B. MERLIN
 *        ENZO OLIVEIRA
 * 
 * SISTEMA DE GERENCIAMENTO DE UMA LOJA
 */ 

import java.io.IOException; 
import java.io.*; 
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.*; 
import javax.swing.*;
import java.util.* ;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import javax.swing.table.*;

public class ConsultaEstoque extends JPanel implements CadastroListener, MouseListener 
{
    private JTable table;
    private static Map<Integer,Peca> originalPecaList; //cria uma List utilizando Map das peças presentes no estoque
    private JDialog dialog;
    
    public ConsultaEstoque()
    {
                           
         originalPecaList = new Hashtable<Integer,Peca>();
         
         table = new JTable(getTableModel());
         table.addMouseListener(this); //Faz a table ser um listener do mouse
         
        
         JScrollPane scroll = new JScrollPane(table); //Inicializa um scroll pra tabela
         table.setFillsViewportHeight(true); //Deixa o tamanho da tabela se adaptar ao scroll
         this.add(scroll); //Adiciona o scroll pra tabela
         
         
                   

    }
     
        
    private DefaultTableModel getTableModel(){
   
        String[] columnNames = {"Código","Marca","Fornecedor","Quantidade","Categoria","Preco", "Tamanho", "Descricao"};
         DefaultTableModel tableModel = new DefaultTableModel(columnNames, 0){// The 0 argument is number rows.
    
             public boolean isCellEditable(int row, int column){
            return false;//This causes all cells to be not editable
        }}; 
    
        for (Map.Entry<Integer,Peca> identificador : originalPecaList.entrySet() ) { //percorro do identificador ("0" até o final do chaves)
            Peca peca = new Peca();
            peca = identificador.getValue();
       
            tableModel.addRow(new Object[] {    
            
                peca.getId(),
                peca.getMarca(),
                peca.getFornecedor(),
                peca.getQuantidade(),
                peca.getCategoria(),
                peca.getPreco(),
                peca.getTamanho(),
                peca.getDescricao(),
                        });
                    }
    
    return tableModel;
    }

        
    public void cadastrarPeca(int id,Peca peca){ //Função do listener pra fazer a ação de quando uma peça é cadastrada
        
        if( !originalPecaList.containsKey( id ) ) { //SE ELE NÃO TEM JÁ UMA PEÇA REFERENTE À ESSE ID (peça nova)
            originalPecaList.put(id,peca); //bota no map uma nova peca
            this.salvarEstoque();}
        
        
            else{ 
                originalPecaList.put(id,peca);
                this.salvarEstoque();
                dialog.dispose();
        }
        table.setModel(getTableModel()); //atualiza a tabela
        
    }
    
    public void venderPeca(int id, int quantidade){ //Função do listener pra fazer a ação de quando uma peça é cadastrada
        Peca peca = new Peca();
        
        if( !originalPecaList.containsKey( id ) ) { //SE ELE NÃO TEM JÁ UMA PEÇA REFERENTE À ESSE ID (peça nova)
            JOptionPane mensagem = new JOptionPane();           
            mensagem.showMessageDialog(null, "Peça inexistente no estoque!");//bota no map uma nova peca    
            }
            else{ 
                peca = originalPecaList.get(id);
                if(peca.getQuantidade() >= quantidade){
                    peca.setQuantidade(peca.getQuantidade()-quantidade);
                    originalPecaList.put(id,peca);
                    JOptionPane.showMessageDialog(this, "Venda efetuada!");
                    this.salvarEstoque();
                }
                else
                   JOptionPane.showMessageDialog(this, "Quantidade indisponível no estoque!"); 
            }
        table.setModel(getTableModel());
        
    }
   
    public void mousePressed(MouseEvent e) {
        
        JTable table =(JTable) e.getSource(); //pega origem do evento
        if (e.getClickCount() == 2){ //se foi um clique duplo
    
        //pega o modelo da jtable
        DefaultTableModel model = (DefaultTableModel) table.getModel();
        //pega a linha selecionada
        int selectedRowIndex = table.getSelectedRow();
        // Pega o valor em string (getValueAt pega objeto, converte pra String)
        String IdStringMap = model.getValueAt(selectedRowIndex,0).toString();
        // e então converte pra int
        int IdMap = Integer.parseInt(IdStringMap);
        Peca pecatransferida = originalPecaList.get(IdMap);
       
        
        dialog = new JDialog();
        Compra painelEdicao = new Compra(pecatransferida);
        
        painelEdicao.addCadastroListener(this);
        dialog.add(painelEdicao);
        dialog.pack();
        dialog.show();
        
        
    }
  
    }
 
   public void removeKey(int id){
     originalPecaList.remove(id);
      
    }
    
    public boolean verificaKey(int id){
        if(originalPecaList.get(id) == null)
        return(false);
        else
        return(true);
     }
    
     //Função que verifica a ID informada e retorna seu preço
    public double achaPreco(int id){
        Peca peca = new Peca();
        
        if(originalPecaList.containsKey(id)){
            peca = originalPecaList.get(id);
            }
        
            else{
                JOptionPane mensagem = new JOptionPane();
                mensagem.showMessageDialog(null, "Peça inexistente no estoque!");
            }
            
        return Double.parseDouble(peca.getPreco().replace(',','.'));
    }
        
    //Funções referente a manipulação do arquivo Estoque
   public String getCsvData(){
        String csvData = "";
        for (Map.Entry<Integer,Peca> identificador : originalPecaList.entrySet() ) { //percorro do identificador ("0" até o final do chaves)
            Peca peca = new Peca();
            peca = identificador.getValue();
            peca.setPreco(peca.getPreco().replace(',','.'));
            csvData += peca.getId()+","+peca.getMarca()+","+peca.getFornecedor()+","+peca.getQuantidade()+","+peca.getCategoria()+","+peca.getTamanho()+"," +peca.getPreco()+","+peca.getDescricao()+"\n";
        }
        System.out.println("PENES");
        return csvData;
    }
          
     public void setArrayData(ArrayList<Peca> pecaList){
         for(Peca peca : pecaList){
             int i = peca.getId();
             originalPecaList.put(i,peca);
            }
             
        
        if ( table != null){
            table.setModel(getTableModel());
        }
    }
    
    private void salvarEstoque(){
         try{

                             String diretorio = System.getProperty("user.dir");
                             diretorio = diretorio + "\\" + "Estoque.csv";
                             
                             File file = new File(diretorio);
                             FileWriter writer = new FileWriter(file,false);
                             BufferedWriter bw = new BufferedWriter(writer);
                             
                             bw.write(this.getCsvData());
                             
                             bw.close();
                             writer.close();
                        } catch (IOException ioe) {
                            System.err.println("Não foi possível salvar o arquivo.csv");
                        } 
     }
    
            
       
    public void mouseReleased(MouseEvent e) {}
    public void mouseEntered(MouseEvent e) {}
    public void mouseExited(MouseEvent e) {}
    public void mouseClicked(MouseEvent e) {}
}

