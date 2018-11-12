//
//  SignUpViewController.swift
//  SMApplication
//
//  Created by Johnley Delgado on 06/11/2018.
//  Copyright © 2018 Rapha Solution. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class SignUpViewController : UIViewController {
    let loading = Loading()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SignupButton(_ sender: UIButton) {
        
        SignUpValidation()
        
    }
    func SignUpValidation(){
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirmationPassword = confirmPasswordTextField.text!
        if email == "" || password == "" {
            
            let alert = UIAlertController(title: "Sign Up", message: "Please fill up all the required fields", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        else if password != confirmationPassword{
            let alert = UIAlertController(title: "Sign Up", message: "Confirm Password is incorrect", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            loading.showLoading(to_view: self.view)
            Auth.auth().createUser(withEmail: email, password: password){
                (user,error) in
                // print(error)
                
                if error == nil{
                    self.loading.hideLoading(to_view: self.view)
//                    let alert = UIAlertController(title: "Sign up", message: "Login Success", preferredStyle: .alert)
//                    let okButton = UIAlertAction(title: "OK", style: .default){
//                        (ok) in
//                        let ref = Database.database().reference()
//                        ref.child("user").child(Auth.auth().currentUser!.uid).setValue(["emal":email,"age":"18","gender":"male"])
//                    }
//
//                    alert.addAction(okButton)
//                    self.present(alert, animated: true, completion: nil)
                    
                    self.performSegue(withIdentifier: "SetupProfile", sender: nil)
                    
                }
                else{
                    if let errorCode = AuthErrorCode(rawValue: (error?._code)!) {
                        self.loading.hideLoading(to_view: self.view)
                        let alert = UIAlertController(title: "Error", message: "\(errorCode.errorMessage)", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
    }
}
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        default:
            return "Unknown error occurred"
        }
    }
}
