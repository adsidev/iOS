//
//  CNBTServiceController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 12/30/16.
//  Copyright © 2016 CNBT. All rights reserved.
//

import UIKit

protocol ansDetailListResponse {
    func getAnsList(response : NSData)
}

let appdel = UIApplication.shared.delegate as! AppDelegate
public let mainpUrl = "http://limitless.saasitsol.com:80/api/"
class CNBTServiceController: NSObject {
    
    let session = URLSession.shared
    var delegate : ansDetailListResponse!
    
    func callServiceForSubject(requestParameter : [String : Any])  {
             var trimmedString = mainpUrl + "Subject/GridList"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = NSURL(string:trimmedString)
        let request = NSMutableURLRequest(url: urlPath! as URL)

            request.timeoutInterval = 60
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestParameter, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
            let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if((error) != nil) {
                    print(error!.localizedDescription)
                   appdel.window?.makeToast((error?.localizedDescription)!)
                }else {
                 
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "subjectResponse"), object: nil, userInfo: ["Response" : data! as NSData])
                }
            })
            dataTask.resume()
        }
    
   
    func callServiceForQuestion(requestParameter : [String : Any])  {
        var trimmedString = mainpUrl + "Question/GridList"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = NSURL(string:trimmedString)
        let request = NSMutableURLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestParameter, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            appdel.window?.makeToast(error.localizedDescription)
        }
        
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                print((error?.localizedDescription)!)
                
            }else {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "QuestionResponse"), object: nil, userInfo: ["Response" : data! as NSData])
            }
        })
        dataTask.resume()
    }
    func callServiceForselectQuestionAns(requestParameter : [String : Any])  {
        
        var trimmedString = mainpUrl + "Answer/GetAnswerDetails"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = NSURL(string:trimmedString)
        let request = NSMutableURLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestParameter, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            appdel.window?.makeToast(error.localizedDescription)
        }
        
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                print((error?.localizedDescription)!)
                
            }else {
                
                self.delegate.getAnsList(response: data! as NSData)
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "QuestionResponse"), object: nil, userInfo: ["Response" : data! as NSData])
            }
        })
        dataTask.resume()
    }

    
    func callServiceForlogin(requestParameter : [String : Any])  {
        
        var trimmedString = mainpUrl + "User/GetUserDetails"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = NSURL(string:trimmedString)
        let request = NSMutableURLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestParameter, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            appdel.window?.makeToast(error.localizedDescription)
        }
        
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                print((error?.localizedDescription)!)
                
            }else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginResponse"), object: nil, userInfo: ["Response" : data! as NSData])
            }
        })
        dataTask.resume()
    }
    


}
