//
//  ViewController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 11/21/16.
//  Copyright © 2016 CNBT. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topNavTitle: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var userNameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        topNavTitle.addCharactersSpacing(spacing: 1.5, text: "LIMITLESSgameprep")
        titleName.addCharactersSpacing(spacing: 1.5, text: "LIMITLESSgameprep")
        self.perform(#selector(self.removeLoader), with: nil, afterDelay: 3)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loginResponse), name: NSNotification.Name(rawValue: "LoginResponse"), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc private func removeLoader(){
        loaderView.isHidden = true
    }
    @IBAction func loginwithFaceBook(_ sender: Any) {
        
        
        loadDashView()
    }
    @IBAction func getLoginClicked(_ sender: Any) {
        if (userNameText.text?.characters.count)! > 0 && (passwordText.text?.characters.count)! > 0 {
            
            self.loginService(userName: userNameText.text!, password: passwordText.text!)
        }
        else if userNameText.text?.characters.count == 0{
            appdel.window?.makeToast("Enter User Name")
        }
        else if passwordText.text?.characters.count == 0{
            appdel.window?.makeToast("Enter Password")
        }
        
        let count = 3
        let buttons = self.view.subviews.filter { (view) -> Bool in
            return  view.tag >= 100 && view.tag-100 < 3
        }
        
        for button in buttons {
            let heightConstraint = button.constraints.filter { (constraint) -> Bool in
                return constraint.firstAttribute == .height
            }
            heightConstraint.first?.constant = CGFloat(0)
            button.addConstraint(heightConstraint.first!)
        }
        
    }
    private func loadDashView()
    {
    
        appdel.tabBarView()
    }
    
    private func loginService(userName: String, password: String){
        showHud()
        let parameter  = ["Email" : userName, "Password" : password.sha1(), "UserType": "1"]
        let serviceView = CNBTServiceController()
        serviceView.callServiceForlogin(requestParameter: parameter)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginResponse(notification : Notification)  {
        
        guard let responseData = notification.userInfo?["Response"] as? NSData    else {
            return
        }
        do {
            if let userDetails  = try JSONSerialization.jsonObject(with: responseData as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
            {
                
                print(userDetails)
                
                guard let userInfomations = userDetails["UserInformations"] as? String else {
                    return
                }
                
                let userInfomationsData = userInfomations.data(using: .utf8)
                if let userInfomationsArray = try? JSONSerialization.jsonObject(with: userInfomationsData!, options: JSONSerialization.ReadingOptions.allowFragments){
                    let userInfomation = (userInfomationsArray as! [[String: Any]]).first!
                    UserDefaults.standard.setValuesForKeys(userInfomation)
                    let params = ["username" : userNameText.text!, "password" : passwordText.text!.sha1(),  "grant_type" : "password"]
                    
                    CNBTServiceController.getToken(params: params, completionHandler: { _ in
                        
                        DispatchQueue.main.async{
                            print(UserDefaults.standard.value(forKey: "access_token") ?? "token")
                            self.loadDashView()
                            self.hideHUD()
                            
                        }
                        
                    })
                    
                }
                
            }
        } catch let error as NSError {
           //self.loginActivityIndicator.stopAnimating()
            hideHUD()
            appdel.window?.makeToast("Parse Issue")
            print("Failed to load: \(error.localizedDescription)")
        }
        
    }

}
extension ViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameText {
            passwordText.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }

}
