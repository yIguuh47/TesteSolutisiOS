//
//  login.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 25/02/22.
//

import Foundation

class LoginData: Codable {
    var nome: String
    var cpf: String
    var saldo: Double
    var token: String
    
    init(nome: String, cpf: String, saldo: Double, token: String){
        self.nome = nome
        self.cpf = cpf
        self.saldo = saldo
        self.token = token
    }
}
