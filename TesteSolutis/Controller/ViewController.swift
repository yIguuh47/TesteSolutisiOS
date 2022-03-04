//
//  ViewController.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 15/02/22.
//

import UIKit

class ViewController: UIViewController, LoginManagerDelegate {

    @IBOutlet weak var loginButtom: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    var service = Service()
    var user: LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButtom.layer.cornerRadius = 25
        
        service.delegateLog = self
        userTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAccount" {
            let login = segue.destination as! ExtractViewController
            login.user = user
        }
    }
    
    
    func didLogin(user: LoginModel) {
        DispatchQueue.main.async {
            self.user = user
            self.performSegue(withIdentifier: "goToAccount", sender: self)
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            
            guard let user = userTextField.text else {return}
            guard let password = passwordTextField.text else {return}
            
            validInputs(user, password)
            
            userTextField.text = ""
            passwordTextField.text = ""
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userTextField {

            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                     nextField.becomeFirstResponder()
                  } else {
                     textField.resignFirstResponder()
                  }
                  return false
        } else {
            
            textField.endEditing(true)
            
            return true
        }
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        guard let user = userTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        validInputs(user, password)
        //print(user)
    }
    
    func validInputs(_ user: String, _ password: String) {
       
        let loginModel = ValidationModel(user: user, password: password)
        
        if loginModel.validEmail(user) || loginModel.validCpf(user){
            if loginModel.validPassword(password) {
                service.requestLogin(username: user, password: password)
            } else {
                validationLabel.text = "Password Invalid (Must have uppercase, lowercase, number and a special character)"
            }
        } else {
            validationLabel.text = "User Invalid (Check the User field)"
        }
        
    }
        
    
    
}
