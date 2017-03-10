//
//  UIViewController+ProgressHud.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 25/02/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController{
    
    func showHud(_ message: String = "") {
        DispatchQueue.main.async { [weak self] _ in
            guard let weakSelf = self else { return }
            let hud = MBProgressHUD.showAdded(to: weakSelf.view, animated: true)
            hud.label.text = message
            hud.isUserInteractionEnabled = false
        }
    }
    
    func hideHUD() {
        
        DispatchQueue.main.async { [weak self] _ in
            guard let weakSelf = self else { return }
            MBProgressHUD.hide(for: weakSelf.view, animated: true)
        }
        
    }
    
}
