//
//  ExtractViewController.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 22/02/22.
//

import UIKit

class ExtractViewController: UIViewController, ExtractManegerDelegate{
    
    let count = 0
    var extractList: [ExtractModel] = []
    var service = Service()
    var user: LoginModel?
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cpfLbl: UILabel!
    @IBOutlet weak var saldoLbl: UILabel!
    
    @IBOutlet weak var bgGradient: UIView!
    @IBOutlet weak var extractView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        service.delegateExt = self
        
        service.requestExtract(token: user!.token, delegate: service.delegateExt as! ExtractManegerDelegate)
        
        extractView.delegate = self
        extractView.dataSource = self
        
        setGradient()
        
        if let safeUser = user {
            self.nameLbl.text = safeUser.nome
            self.cpfLbl.text = safeUser.cpf
            self.saldoLbl.text = String("R$\(safeUser.saldo)")
        }
    }
    
    
    
    @IBAction func exitButtom(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func didExtract(extractList: [ExtractModel]) {
        self.extractList = extractList
        self.extractView.reloadData()
    }
    
    func setGradient() {
        let view = self.bgGradient
        let gradient = CAGradientLayer()
        let startColor: UIColor = #colorLiteral(red: 0.6941176471, green: 0.7803921569, blue: 0.8941176471, alpha: 1)
        let endColor: UIColor = #colorLiteral(red: 0.1958471239, green: 0.4886431694, blue: 0.7751893401, alpha: 1)
        gradient.frame = self.bgGradient!.bounds
        gradient.frame = view!.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        view!.layer.insertSublayer(gradient, at: 0)
    }
    
}


// MARK: - TableView
extension ExtractViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extractList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = extractView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        cell.start(extractModel: extractList[indexPath.row])

        return cell
    }
    
    
}

