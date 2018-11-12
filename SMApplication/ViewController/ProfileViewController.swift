//
//  ProfileViewController.swift
//  SMApplication
//
//  Created by Rapha Solution on 11/6/18.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class ProfileViewController : UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var hideOne: UITableViewCell!
    @IBOutlet weak var hideTwo: UITableViewCell!
    @IBOutlet weak var hideThree: UITableViewCell!
    @IBOutlet weak var hideFour: UITableViewCell!
    
    
    
    @IBOutlet var customTableView: UITableView!
    let loading = Loading()
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        customTableView.delegate = self
        customTableView.dataSource = self
        self.profileImageView.setRounded()
        self.loading.showLoading(to_view: self.view)
        
        self.hideOne.isHidden = true
        self.hideTwo.isHidden = true
        self.hideThree.isHidden = true
        self.hideFour.isHidden = true
        
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let ref = UserConstant.refs.root.child("user")
        
        ref.queryOrdered(byChild: uid!).observeSingleEvent(of: .value) {
            (snapshot) in
            if snapshot.exists() {
                let dic = snapshot.value as? [String:Any]
                if let uidDic = dic![uid!] as? [String:Any]{
                    //let age = uidDic["age"] as! String
                    let email = uidDic["email"] as! String
                    //let gender = uidDic["gender"] as! String
                    let name = uidDic["name"] as! String
                    let photoUrl = uidDic["photo"] as! String
                    let storageRef = Storage.storage().reference(forURL: photoUrl)
                    storageRef.downloadURL(completion: { (url,error) in
                        
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data! )
                        self.profileImageView.image = image
                        self.loading.hideLoading(to_view: self.view)
                        self.nameLabel.text = name
                        self.emailLabel.text = email
                        self.hideOne.isHidden = false
                        self.hideTwo.isHidden = false
                        self.hideThree.isHidden = false
                        self.hideFour.isHidden = false
                        })
                }
                
            }
            
        }
    }
    
    
}

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = self.frame.size.width / 2
        
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.white.cgColor
        
        self.layer.borderWidth = 5
    }
    
}

