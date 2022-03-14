//
//  Formattation.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 10/03/22.
//

import Foundation

struct Formattation {
    
    var user: LoginModel?
    
    func formatValue(value: Double ) -> String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: value))!
    }
    
    func formatDate(date: String) -> String {
        let dateFormatStart = DateFormatter()
        dateFormatStart.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatEnd = DateFormatter()
        dateFormatEnd.dateFormat = "dd/MM/yyyy"
        
        var dateFormat = dateFormatStart.date(from: date)
        var dateFormatString = dateFormatEnd.string(from: dateFormat!)
        return dateFormatString
    }
    
    func formatCpf(cpf: String) -> String {
 
        var char = Array(cpf)
        char.insert(".", at: 3)
        char.insert(".", at: 7)
        char.insert("-", at: 11)
        
        let masked = String(char)
        
        return masked
    }
    
}
