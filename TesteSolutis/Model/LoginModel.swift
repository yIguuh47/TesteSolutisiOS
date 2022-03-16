//
//  LoginModel.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 25/02/22.
//

import Foundation

struct LoginModel: Decodable {
    let nome: String
    let cpf: String
    let saldo: Double
    let token: String
    
}
