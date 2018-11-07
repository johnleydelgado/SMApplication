//
//  ChatConstant.swift
//  SMApplication
//
//  Created by Rapha Solution on 11/8/18.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import Firebase
struct ChatConstant {
    
    struct refs {
        static let root = Database.database().reference()
        static let child = root.child("chat")
    }
    
}
