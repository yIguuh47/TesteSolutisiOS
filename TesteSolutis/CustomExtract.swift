//
//  CustomExtract.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 22/02/22.
//

import UIKit

class CustomExtract: UITableViewCell {
    
    
    @IBOutlet weak var extractView: UIView!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var stateElement: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func start(extractData:ExtractData!){
        
        let extra = extractData!
        if extra.valor! <= 0.0{
            self.stateElement.text = "Pagamento"
            self.dataLbl.text = extra.data!
            self.descriptionLbl.text = extra.descricao!
            self.valueLbl.text = String(extra.valor!)
            self.valueLbl.textColor = UIColor.red
            self.descriptionLbl.textColor = UIColor.red
        } else {
            self.stateElement.text = "Recebimento"
            self.dataLbl.text = extra.data!
            self.descriptionLbl.text = extra.descricao!
            self.valueLbl.text = String(extra.valor!)
            self.valueLbl.textColor = UIColor.green
        }
    }

}
