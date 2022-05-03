//
//  Validation.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 10/03/22.
//

import Foundation
import CPF_CNPJ_Validator

// MARK: - Validation
struct ValidationModel {
    
    let user : String
    let password: String
    
    func validPassword (_ password: String) -> Bool {
        let passRegEx = "(.*[a-z])(.*[0-9])(.*[!@#$%^&*]{1,32})"
        
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
            return passPred.evaluate(with: password)
    }

    func validCpf (_ cpf: String) -> Bool {
        let cpf = BooleanValidator().validate(cpf, kind: .CPF)
        return cpf
    }
    
    func validEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]{2,52}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,52}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
