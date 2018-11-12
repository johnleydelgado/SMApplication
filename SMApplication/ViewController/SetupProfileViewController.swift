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
import Photos
class SetupProfileViewController : UIViewController {
    let loading = Loading()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        profileImageView.setRounded()
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
        let age = ageTextField.text!
        let gender = genderTextField.text!
        if name == "" || age == "" || gender == ""{
            
            let alert = UIAlertController(title: "Sign Up", message: "Please fill up all the required fields", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
            
        else{
           
            let filePath = "profiles"
            let storageRef = Storage.storage().reference().child(filePath)
            
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                  loading.showLoading(to_view: self.view)
                let riversRef = storageRef.child("profile-\(Auth.auth().currentUser!.uid).png")
                _ = riversRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    guard let _ = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    riversRef.downloadURL { (url2, error) in
                        
                        if let error = error {
                            // Uh-oh, an error occurred!
                            
                        }
                        else{
                            let userEmail = Auth.auth().currentUser?.email
                           let uid = Auth.auth().currentUser!.uid
                            
                            UserConstant.refs.root.child("user").child(uid).setValue(["uid":uid,"name":name,"email":userEmail,"age":age,"gender":gender,"photo":url2!.absoluteString])
                            
                            self.loading.hideLoading(to_view: self.view)
                            let alert = UIAlertController(title: "Sucess", message: "Profile Created", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "OK", style: .default){
                                (ok) in
                                self.performSegue(withIdentifier: "userMenu", sender: nil)
                                
                            }
                            
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    
                }
       
                
            }
            
            
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}

extension SetupProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @objc func profileTouch (){
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedPicker : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"]as? UIImage{
            selectedPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"]as? UIImage{
            selectedPicker = originalImage
        }
        if let selectedImage = selectedPicker {
            self.profileImageView.image = selectedImage
            
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
