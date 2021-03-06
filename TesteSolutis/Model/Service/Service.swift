//
//  LoginService.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 23/02/22.
//

import Foundation
import UIKit

// MARK: - Protocols
protocol LoginManagerDelegate: NSObjectProtocol {
    func didLogin(user: LoginModel)
    func didErrorLog()
}

protocol ExtractManegerDelegate: NSObjectProtocol {
    func didExtract(extractList: [ExtractModel])
}

// MARK: - Class Service
class Service {
        
    var delegateLog: LoginManagerDelegate?
    var delegateExt: ExtractManegerDelegate?
    
    // MARK: - Request Login
    func requestLogin(username: String, password: String) {
        
        let param = ["username":username, "password":password] as Dictionary<String, String>
        
        var request = URLRequest(url: URL(string: "https://api.mobile.test.solutis.xyz/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        
        let tarefa = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error Task\(error)")
                self.delegateLog?.didErrorLog()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if httpResponse.statusCode >= 299 {
                self.delegateLog?.didErrorLog()
                return
            }
            
            if let safeData = data {
                if let user = self.parseJSONLogin(loginData: safeData) {
                    self.delegateLog?.didLogin(user: user)
                    return
                } else {
                    self.delegateLog?.didErrorLog()
                    return
                }
            } else {
                self.delegateLog?.didErrorLog()
                return
            }
                
        }
        tarefa.resume()
    }
    
    func parseJSONLogin(loginData: Data) -> LoginModel? {
        let decoder = JSONDecoder()
        do {
            let decoderData =  try decoder.decode(LoginModel.self, from: loginData)
            let nome = decoderData.nome
            let cpf = decoderData.cpf
            let saldo = decoderData.saldo
            let token = decoderData.token
            let loginModel = LoginModel(nome: nome, cpf: cpf, saldo: saldo, token: token)
            return loginModel
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: - Request Extract
    func requestExtract(token: String, delegate: ExtractManegerDelegate) {
                
        var request = URLRequest(url: URL(string: "https://api.mobile.test.solutis.xyz/extrato")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
            }
            if let safeData = data {
                if let extractList = self.parseJSONExtract(safeData) {
                    self.onResponseStatement(extractList: extractList)
                }
            }
        }
        task.resume()
    }
    
    func parseJSONExtract(_ extractData: Data) -> [ExtractModel]? {
        let decoder = JSONDecoder()
        var extractList: [ExtractModel] = []
        do {
            let decodeData = try decoder.decode([ExtractModel].self, from: extractData)
            for i in decodeData {
                let data = i.data
                let descricao = i.descricao
                let valor = i.valor
                let extract = ExtractModel(data: data, descricao: descricao, valor: valor)
                extractList.append(extract)
            }
            return extractList
        } catch {
            print("Error Decoder \(error)")
            return nil
        }
    }
    
    func onResponseStatement(extractList: [ExtractModel]) {
        DispatchQueue.main.async {
            self.delegateExt?.didExtract(extractList: extractList)
        }
    }
    
}
