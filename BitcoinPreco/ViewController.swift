//
//  ViewController.swift
//  BitcoinPreco
//
//  Created by Victor on 19/03/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var precoBiticoins: UILabel!
    
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperaPrecoBitCoin()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.recuperaPrecoBitCoin()

    }
    
    func formaratPReco(preco: NSNumber)-> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let precoFinal = nf.string(from: preco){
            return precoFinal
        }
        return "0,00"
    }

    func recuperaPrecoBitCoin(){
        
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal)
        
        if let url = URL(string: "https://blockchain.info/pt/ticker"){
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                
                if erro == nil{
                    
                    if let dadosRetorno = dados {
                        
                        do{
                            let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]
                            
                            if let brl = objetoJson?["BRL"] as? [String: Any]{
                                if let preco = brl["last"] as? Double {
                                    let precoFormatado = self.formaratPReco(preco: NSNumber(value: preco))
                                    
                                    DispatchQueue.main.async(execute: {
                                        self.precoBiticoins.text = "R$ \(precoFormatado)"
                                        self.botaoAtualizar.setTitle("Atualizar", for: .normal)
                                    })
                                }
                            }
                            
                        }catch{
                            print("Erro ao formatar Retorno ou seja converter")
                        }
                        
                    }
                    
                    
                } else{
                    print("Erro ao realizar consulta de preco")
                }
            }
            tarefa.resume()
        }
        
    }

}

