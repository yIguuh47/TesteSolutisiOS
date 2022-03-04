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

        if let safeUser = user {
            self.nameLbl.text = safeUser.nome
            self.cpfLbl.text = safeUser.cpf
            self.saldoLbl.text = String(safeUser.saldo)
        
        }
        
        
    }
    
    
    @IBAction func exitButtom(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func didExtract(extractList: [ExtractModel]) {
        self.extractList = extractList
        self.extractView.reloadData()
    }
    
//    func setGradient() {
//        let gradient = CAGradientLayer()
//        gradient.frame = view.bounds
//        gradient.colors = [UIColor.white, UIColor(named: "blueSolutis")]
//        //gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//        bgGradient.layer.addSublayer(gradient)
//    }
    
}


// MARK: - TableView
extension ExtractViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extractList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = extractView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        cell.start(extractModel: extractList[indexPath.row])

        return cell
    }
    
    
}

