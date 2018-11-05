//
//  Loading.swift
//  SMApplication
//
//  Created by Johnley Delgado on 06/11/2018.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import UIKit
import MBProgressHUD
class Loading : UIViewController {
    
    func showLoading(to_view : UIView){
        
        let loading = MBProgressHUD.showAdded(to: to_view, animated: true)
        to_view.endEditing(true)
        loading.label.text = "Loading"
        loading.detailsLabel.text = "Please Wait"
        
    }
    
    func hideLoading(to_view : UIView) {
        MBProgressHUD.hide(for: to_view, animated: true)
    }
    
    
}
