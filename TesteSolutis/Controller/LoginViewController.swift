//
//  ViewController.swift
//  TesteSolutis
//
//  Created by Virtual Machine on 15/02/22.
//

import UIKit
import SVProgressHUD
import KeychainSwift

class LoginViewController: UIViewController, LoginManagerDelegate {
    
    @IBOutlet weak var loginButtom: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var solutisImage: UIImageView!
    
    var service = Service()
    var user: LoginModel?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButtom.layer.cornerRadius = 25
        
        self.dismissKeyboardOnTap()
        service.delegateLog = self
        userTextField.delegate = self
        passwordTextField.delegate = self
        
        updateLogin()
        tapGestureRecognizer()
        
    }
    
    // MARK: - Action Logo
    func tapGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        solutisImage.isUserInteractionEnabled = true
        solutisImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        guard let url = URL(string: "https://solutis.com.br/") else { return }
                UIApplication.shared.open(url)
    }
    
    // MARK: - Delegation
    func didLogin(user: LoginModel) {
        DispatchQueue.main.async {
            self.loginButtom.isUserInteractionEnabled = true
            self.user = user
            let keychain = KeychainSwift()
            keychain.set(self.userTextField!.text!, forKey: "username")
            self.performSegue(withIdentifier: "goToAccount", sender: self)
        }
    }
    
    func didErrorLog() {
        self.errorLog()
    }
    
}

// MARK: - TextFields
extension LoginViewController: UITextFieldDelegate {
    
    @IBAction func userTextFieldPressed(_ sender: UITextField) {
        userTextField.endEditing(true)
    }
    
    @IBAction func passwordTextFieldPressed(_ sender: UITextField) {
        passwordTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTextField {
            
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.resignFirstResponder()
            } else {
                textField.becomeFirstResponder()
            }
            return false
        } else {
            textField.endEditing(true)
            guard let user = userTextField.text else {return true}
            guard let password = passwordTextField.text else {return true}
            validInputs(user, password)
            return true
        }
    }
    
    func dismissKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}

// MARK: - Keychain
extension LoginViewController {
    
    @IBAction func switchRemembe(_ sender: UISwitch) {
        remember(sender)
    }
    
    func updateLogin(){
        let keyChain = KeychainSwift()
        rememberSwitch.isOn = keyChain.getBool("rememberSwitch") ?? false
        
        if rememberSwitch.isOn {
            username = keyChain.get("username")
            userTextField.text = username
        } else {
            rememberSwitch.isOn = false
            keyChain.delete("username")
        }
    }
    
    func remember(_ sender: UISwitch) {
        let keyChain = KeychainSwift()

        if sender.isOn {
            keyChain.set(true, forKey: "rememberSwitch")
        } else {
            keyChain.set(false, forKey: "rememberSwitch")
            keyChain.delete("username")
        }
    }
}

// MARK: - Validation
extension LoginViewController {
    
    func validInputs(_ user: String, _ password: String) {
        let loginModel = ValidationModel(user: user, password: password)
        
        if loginModel.validEmail(user) || loginModel.validCpf(user){
            if loginModel.validPassword(password) {
                service.requestLogin(username: user, password: password)
            } else {
                errorLog()
            }
        } else {
            errorLog()
        }
    }
    
    func errorLog() {
        DispatchQueue.main.async {
            self.validationLabel.text = "Usuario ou Senha invalidos."
            SVProgressHUD.dismiss()
            self.loginButtom.isUserInteractionEnabled = true
        }
    }
    
}

// MARK: - Navigation
extension LoginViewController {
    
    @IBAction func loginPressed(_ sender: UIButton) {
        self.loginButtom.isUserInteractionEnabled = false
        
        guard let user = userTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        SVProgressHUD.show()
        validInputs(user, password)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAccount" {
            let login = segue.destination as! ExtractViewController
            login.user = user
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}

