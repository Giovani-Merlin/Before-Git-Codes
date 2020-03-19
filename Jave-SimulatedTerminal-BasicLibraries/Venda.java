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

public class Venda extends JPanel implements ActionListener
{
    private JTextField id;
    private JTextField categoria;
    private JTextField tamanho;
    private JTextField quantidade;
    private JTextField valorUnit, valorTotal;
    private JTextField cliente, cpf;
    private JTextArea observacoes;
    private JButton vender, cancelar, total;
    private Janela janela;
    private CadastroListener listener;
    private Peca peca = null;

    public Venda()
    {
        //criando os JTextField
        id = new JTextField();
        categoria = new JTextField();
        tamanho = new JTextField();
        quantidade = new JTextField();
        valorUnit = new JTextField();
        valorTotal = new JTextField();
        cliente = new JTextField();
        cpf = new JTextField();
        observacoes = new JTextArea(2,20);
        
        //Criando as JLabel à serem exibidas
        JLabel label_id = new JLabel("Referência:");
        JLabel label_categoria = new JLabel("Descrição:"); //Criando as JLabels para exibição
        JLabel label_tamanho = new JLabel("Tamanho:");
        JLabel label_quantidade = new JLabel("Quantidade:");
        JLabel label_observacoes = new JLabel("Observações:");
        JLabel label_valorUni = new JLabel("Valor Unitário:");
        JLabel label_valorTotal = new JLabel("Valor Total:");
        JLabel label_cliente = new JLabel("Cliente:");
        JLabel label_cpf = new JLabel("CPF:");
        
        //implementando as ações nos botões
        vender = new JButton("Vender"); 
        vender.addActionListener(this); 
        vender.setActionCommand("vender");
        
        cancelar = new JButton("Cancelar"); 
        cancelar.addActionListener(this); 
        cancelar.setActionCommand("cancelar");
        
        total = new JButton("Total"); 
        total.addActionListener(this); 
        total.setActionCommand("total");
        
        //Montando a interface venda
        this.setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
        this.add(label_cliente);
        this.add(cliente);
        this.add(label_cpf);
        this.add(cpf);
        this.add(label_id);
        this.add(id);
        this.add(label_categoria);
        this.add(categoria);
        this.add(label_tamanho);
        this.add(tamanho);
        this.add(label_quantidade);
        this.add(quantidade);
        this.add(total);
        this.add(label_valorUni);
        this.add(valorUnit);
        this.add(label_valorTotal);
        this.add(valorTotal);
        this.add(label_observacoes);
        this.add(observacoes);
        this.add(vender);
        this.add(cancelar);
        
        this.setVisible(true);
   
    }
        
    public void actionPerformed(ActionEvent evento){
       peca = new Peca();
       double preco;
         
       if(evento.getActionCommand() == "total"){
            peca.setId(Integer.parseInt(id.getText())); //declara a ID da peça como sendo a ID informada;
                
            preco = listener.achaPreco(peca.getId()); //declara a variavel preço como sendo o preço referente a ID informada;
            
            valorUnit.setText(String.valueOf(preco)); //declara o valor unitario como sendo o preço referente a ID informada;
            this.setVisible(true);
                    
            //Verifica se a quantidade e a referência foi informada e se são válidos e exibe o valor total da compra;
            if(!valorUnit.getText().isEmpty())
                if(!quantidade.getText().isEmpty())
                      valorTotal.setText(String.valueOf(preco*Double.parseDouble(quantidade.getText())));
                      else{
                            JOptionPane mensagem = new JOptionPane();
                            mensagem.showMessageDialog(this, "Campo QUANTIDADE não está preenchido!");
                        }
                else{
                      JOptionPane mensagem = new JOptionPane();
                      JOptionPane.showMessageDialog(this, "Referência inexistente!");
                    }
                        
            this.setVisible(true);
                            
       }
            
       if(evento.getActionCommand() == "vender"){
                //Verifica a existência da peça a ser vendida
                if(!id.getText().isEmpty()){
                    peca.setId(Integer.parseInt(id.getText()));
                    }
                    else {        
                        JOptionPane mensagem = new JOptionPane();
                        JOptionPane.showMessageDialog(this, "Campo REFERÊNCIA não preenchido!");}
                
                //Verifica a quantidade a ser vendida e se for válida realiza a venda
                if(!quantidade.getText().isEmpty())
                    listener.venderPeca(Integer.parseInt(id.getText()),Integer.parseInt(quantidade.getText()));
                    else
                    {
                    JOptionPane mensagem = new JOptionPane();
                    JOptionPane.showMessageDialog(this, "Campo QUANTIDADE não preenchido!");}
                
            
                id.setText(" "); //reseta os campos de preenchimento
                cliente.setText(" ");
                cpf.setText(" ");
                quantidade.setText(" ");
                categoria.setText(" ");
                tamanho.setText(" ");
                observacoes.setText(" ");
                valorUnit.setText(" ");
                valorTotal.setText(" ");
       }              
            
       if(evento.getActionCommand() == "cancelar")
        {
            int result = JOptionPane.showConfirmDialog(null,"Deseja cancelar a venda? ","Sim",JOptionPane.YES_NO_OPTION);
                                if(result == JOptionPane.YES_OPTION)
                                System.exit(0);
                             
        }     
           
    }
    
    public void addCadastroListener(CadastroListener listener){
        this.listener = listener;
    }
}