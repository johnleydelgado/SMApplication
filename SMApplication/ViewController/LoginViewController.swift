//
//  ViewController.swift
//  SMApplication
//
//  Created by Rapha Solution on 11/5/18.
//  Copyright © 2018 Rapha Solution. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    
    let loading = Loading()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        LoginValidation()
    }
    
    func LoginValidation(){
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if email == "" || password == "" {
            
            let alert = UIAlertController(title: "Login", message: "Wrong Credentials", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }else{
            loading.showLoading(to_view: self.view)
            Auth.auth().signIn(withEmail: email, password: password){
                (user,error) in
                if error == nil{
                    self.loading.hideLoading(to_view: self.view)
                    let alert = UIAlertController(title: "Login", message: "Login Success", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                    //  self.performSegue(withIdentifier: "", sender: nil)
                    
                }
                else{
                    self.loading.hideLoading(to_view: self.view)
                    let alert = UIAlertController(title: "Error", message: "Invalid credentials", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    
}

