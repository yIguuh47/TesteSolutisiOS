//
//  LoginModel.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 21/02/22.
//

import Foundation
import CPF_CNPJ_Validator

struct LoginModel {
    let nome: String
    let cpf: String
    let saldo: Double
    let token: String
}

struct ValidationModel {
    
    let user : String
    let password: String
    
    func validPassword (_ password: String) -> Bool {
        let passRegEx = "^(.*[a-z]*.)(.*[0-9]*.)(.*[!@#$%^&*]*.)$"

        
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
