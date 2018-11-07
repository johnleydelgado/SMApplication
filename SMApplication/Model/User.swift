//
//  User.swift
//  SMApplication
//
//  Created by Rapha Solution on 11/7/18.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import MessengerKit

struct User: MSGUser {
    
    var displayName: String
    
    var avatar: UIImage?
    
    var avatarUrl: URL?
    
    var isSender: Bool
    
}
