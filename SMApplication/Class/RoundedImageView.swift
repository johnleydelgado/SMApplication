//
//  imageView.swift
//  SMApplication
//
//  Created by Johnley Delgado on 08/11/2018.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = self.frame.width/2.0
        layer.cornerRadius = radius
        clipsToBounds = true // This could get called in the (requiered) initializer
        // or, ofcourse, in the interface builder if you are working with storyboards
    }
    
}
