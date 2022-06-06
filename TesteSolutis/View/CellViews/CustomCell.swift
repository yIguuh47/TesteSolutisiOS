//
//  CustomCell.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 23/02/22.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var extractView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    
    var extractFormat = Formattation()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applyShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        extractView.layer.cornerRadius = 12

    }
    
    func applyShadow(){
        extractView.layer.masksToBounds = false
        extractView.layer.shadowRadius = 4.0
        extractView.layer.shadowOpacity = 0.60
        extractView.layer.shadowColor = UIColor.gray.cgColor
        extractView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

    func start(extractModel: ExtractModel!) {
        let extractD = extractModel!
        if extractD.valor <= 0.0 {
            self.statusLbl.text = "Pagamento"
            self.descriptionLbl.text = extractD.descricao
            self.dataLbl.text = extractFormat.formatDate(date: extractD.data)
            self.valueLbl.text = "R$\(extractFormat.formatValue(value: extractD.valor))"
            self.valueLbl.textColor = #colorLiteral(red: 0.9989479184, green: 0.258279562, blue: 0.2214803398, alpha: 1)

        } else {
            self.statusLbl.text = "Recebimento"
            self.descriptionLbl.text = extractD.descricao
            self.dataLbl.text = "\(extractFormat.formatDate(date: extractD.data))"
            self.valueLbl.text = "R$\(extractFormat.formatValue(value: extractD.valor))"
            self.valueLbl.textColor = #colorLiteral(red: 0.1944899857, green: 0.7790219188, blue: 0.3397343755, alpha: 1)
        
        }
    }
    
}


