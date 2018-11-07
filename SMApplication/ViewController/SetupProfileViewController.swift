//
//  SetupProfileViewController.swift
//  SMApplication
//
//  Created by Johnley Delgado on 08/11/2018.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class SetupProfileViewController : UIViewController {
    let loading = Loading()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTouch)))
    }
    
    
    
    @IBAction func pickGender(_ sender: Any) {
        let alert = UIAlertController(title: "Gender", message: "Please select your gender", preferredStyle: .actionSheet)
        let male = UIAlertAction(title: "Male", style: .default){
            (male) in
            self.genderTextField.text? = "Male"
        }
        let female = UIAlertAction(title: "Female", style: .default)
        {
            (female) in
            self.genderTextField.text? = "Female"
        }
        alert.addAction(male)
        alert.addAction(female)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func CreateProfile(_ sender: UIButton) {
        
        SignUpValidation()
        
    }
    func SignUpValidation(){
        let name = nameTextField.text!
        let email = emailTextField.text!
        let age = ageTextField.text!
        let gender = genderTextField.text!
        if email == "" || name == "" || age == "" || gender == ""{
            
            let alert = UIAlertController(title: "Sign Up", message: "Please fill up all the required fields", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
            
        else{
            loading.showLoading(to_view: self.view)
            let filePath = "profile.png"
            let storageRef = Storage.storage().reference().child(filePath)
            
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                storageRef.putData(uploadData, metadata: nil,completion:{
                    (metaData,error) in
                    if error != nil{
                        
                    }
                    UserConstant.refs.root.child("user").child(Auth.auth().currentUser!.uid).setValue(["name":name,"email":email,"age":age,"gender":gender,"photo":])
                })
                
            }
            self.loading.hideLoading(to_view: self.view)
            let alert = UIAlertController(title: "Sucess", message: "Profile Created", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default){
                (ok) in
                
            }
            
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    func uploadImagePic(img1 :UIImage){
        var data2 = NSData()
        data2 = UIImageJPEGRepresentation(img1, 0.8)! as NSData
        // set upload path
        // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

    }
}

extension SetupProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @objc func profileTouch (){
        let picker = UIImagePickerController()
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedPicker : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"]as? UIImage{
            selectedPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"]as? UIImage{
            selectedPicker = originalImage
        }
        if let selectedImage = selectedPicker {
            self.profileImageView.image = selectedImage
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
