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
class ProfileViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
//
//        print(user?.email)
//        print(user?.uid)
        let uid = user?.uid
        let ref = UserConstant.refs.child
        ref.queryOrdered(byChild: uid!).observeSingleEvent(of: .value) {
            (snapshot) in
            //print(snapshot)
            if snapshot.exists() {
                let dic = snapshot.value as? [String:Any]
                
//                let email = dic!["email"] as? String
//                print(email)
                if let uidDic = dic![uid!] as? [String:Any]{
                    print(uidDic)
                    let email = uidDic["age"]
                    print(email)
//                    for index in uidDic.values {
//
//                    }

                }
               
            }
            
        }
        
        
    }
    
}
