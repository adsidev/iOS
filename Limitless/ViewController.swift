//
//  ViewController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 11/21/16.
//  Copyright © 2016 CNBT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topNavTitle: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var userNameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginActivityIndicator.stopAnimating()
        topNavTitle.addCharactersSpacing(spacing: 1.5, text: "LIMILESSgameprep")
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
            
            if userNameText.text! == "giri331982@gmail.com"  && passwordText.text! == "test" {
                loginService()
            }
            else{
                appdel.window?.makeToast("invalid user")
            }
        }
        else if userNameText.text?.characters.count == 0{
            appdel.window?.makeToast("Enter User Name")
        }
        else if passwordText.text?.characters.count == 0{
            appdel.window?.makeToast("Enter Password")
        }
        
        
    }
    private func loadDashView()
    {
        
        
        appdel.tabBarView()

    }
    
    private func loginService(){
        loginActivityIndicator.startAnimating()
        let parameter  = ["ID" : 2] as [String : Any]
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
            if let json  = try JSONSerialization.jsonObject(with: responseData as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
            {
                DispatchQueue.main.async{
                    print(json)
                    self.loadDashView()
                    self.loginActivityIndicator.stopAnimating()
//                    self.activityIndicator.stopAnimating()
                    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostOTP"), object: nil, userInfo: ["userType" : json["type"] as! String , "mobile" : json["mobile"] as! String , "UserId" : json["userid"] as! String] )
                }
            }
        } catch let error as NSError {
           self.loginActivityIndicator.stopAnimating()
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
