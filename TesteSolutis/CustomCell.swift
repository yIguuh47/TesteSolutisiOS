//
//  CustomCell.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 23/02/22.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var extractView: UIView!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func start(extractModel: ExtractModel!) {
        let extractD = extractModel!
        if extractD.valor <= 0.0 {
            self.stateLbl.text = "Pagamento"
            self.descriptionLbl.text = extractD.descricao
            self.dataLbl.text = extractD.data
            self.valueLbl.text = "R$\(String(extractD.valor))"
            self.valueLbl.textColor = UIColor.red
        } else {
            self.stateLbl.text = "Recebimento"
            self.descriptionLbl.text = extractD.descricao
            self.dataLbl.text = extractD.data
            self.valueLbl.text = "R$\(String(extractD.valor))"
            self.valueLbl.textColor = UIColor.green
        }
    }
    
}


