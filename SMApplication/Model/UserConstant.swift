//
//  UserConstant.swift
//  SMApplication
//
//  Created by Rapha Solution on 11/6/18.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import Foundation
import Firebase
struct UserConstant {
    
    struct refs {
        static let root = Database.database().reference()
        static let child = root.child("user")
    }
    
}
