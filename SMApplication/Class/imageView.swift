//
//  imageView.swift
//  SMApplication
//
//  Created by Johnley Delgado on 08/11/2018.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}
