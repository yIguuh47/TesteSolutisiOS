//
//  ExtractViewController.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 22/02/22.
//

import UIKit
import SVProgressHUD

// MARK: - Data Population
class ExtractViewController: UIViewController, ExtractManegerDelegate{
    
    var extractFormat = Formattation()
    var extractList: [ExtractModel] = []
    var service = Service()
    var user: LoginModel?
    
    var username: String?
    var viewSaldo = false
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cpfLbl: UILabel!
    @IBOutlet weak var saldoLbl: UILabel!
    @IBOutlet weak var bgGradient: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSaldoButton: UIButton!
    
    
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var popupStatusLbl: UILabel!
    @IBOutlet weak var popupValueLbl: UILabel!
    @IBOutlet weak var popupDescLbl: UILabel!
    @IBOutlet weak var popupDataLbl: UILabel!
    @IBOutlet weak var popupDoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        service.delegateExt = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        popupDoneButton.layer.cornerRadius = 22
        
        setGradient()
        getData()
        requestExtrac()
        refreshExtract()
        getPopup()

    }
    
    func setGradient() {
        let view = self.bgGradient
        let gradient = CAGradientLayer()
        let startColor: UIColor = #colorLiteral(red: 0.6941176471, green: 0.7803921569, blue: 0.8941176471, alpha: 1)
        let endColor: UIColor = #colorLiteral(red: 0.1958471239, green: 0.4886431694, blue: 0.7751893401, alpha: 1)
        gradient.frame = view!.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        view!.layer.insertSublayer(gradient, at: 0)
    }
    
 
    @IBAction func ExitTapOnPopup(_ sender: Any) {
        animateOut(desiredView: blurView)
        animateOut(desiredView: popupView)
    }
    
    @IBAction func exitPopupButton(_ sender: UIButton) {
        animateOut(desiredView: blurView)
        animateOut(desiredView: popupView)
    }
    
    func getPopup() {
        blurView.bounds = self.view.bounds
    }
    
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        })
    }
    
    @IBAction func viewSaldoPressed(_ sender: UIButton) {
        if viewSaldo == true {
            self.viewSaldo = false
            self.viewSaldoButton.setImage(UIImage(systemName: "eye.slash"), for: UIControl.State.normal)
            getData()
        } else {
            self.viewSaldo = true
            self.viewSaldoButton.setImage(UIImage(systemName: "eye"), for: UIControl.State.normal)
            getData()
            }
        }
    
}

// MARK: - Population User Data
extension ExtractViewController {
    func getData(){
    
        if let safeUser = user {
            self.nameLbl.text = safeUser.nome
            self.cpfLbl.text = "\(extractFormat.formatCpf(cpf: safeUser.cpf))"
            if viewSaldo == true {
            self.saldoLbl.text = "R$ \(extractFormat.formatValue(value: safeUser.saldo))"
            } else {
                self.saldoLbl.text = "R$ ••••"
            }
        }
    }
}

// MARK: - Service Request Extract
extension ExtractViewController {
    func requestExtrac(){
        service.requestExtract(token: user!.token, delegate: service.delegateExt as! ExtractManegerDelegate)
    }
}

// MARK: - TableView
extension ExtractViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extractList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        cell.start(extractModel: extractList[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? CustomCell else { return }
        
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView)
        
        CustomPopUp(extract: extractList[indexPath.row])
    }
    
    func didExtract(extractList: [ExtractModel]) {
        self.extractList = extractList
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
}

// MARK: - Refresh TableView
extension ExtractViewController {
    func refreshExtract() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }

    @objc private func didPullToRefresh() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Navigation
extension ExtractViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBack" {
            let login = segue.destination as! LoginViewController
            login.username = self.username
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func exitButtom(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goBack", sender: self)
        }
    }
}

extension ExtractViewController {
    
    func CustomPopUp(extract: ExtractModel!) {
        if extract.valor <= 0.0 {
            self.popupStatusLbl.text = "Pagamento"
        } else {
            self.popupStatusLbl.text = "Recebimento"
        }
        self.popupDescLbl.text = extract.descricao
        self.popupDataLbl.text = extractFormat.formatDate(date: extract.data)
        self.popupValueLbl.text = "R$\(extractFormat.formatValue(value: extract.valor))"
    }
    
}
