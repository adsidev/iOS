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
    
    
    static func getToken(params: [String: String], completionHandler:@escaping (() -> Void )){
        
        var trimmedString = "http://limitless.saasitsol.com/token"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = URL(string:trimmedString)
        var urlComponents = URLComponents(url: urlPath!, resolvingAgainstBaseURL: true)!
        var queryItems = [URLQueryItem]()
        for (key, value) in params{
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        let request = NSMutableURLRequest(url: urlPath!)
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: String.Encoding.utf8)
        let  dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                print(error!.localizedDescription)
                appdel.window?.makeToast((error?.localizedDescription)!)
            }else {
                
                if let tokenDict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]{
                    UserDefaults.standard.setValuesForKeys(tokenDict!)
                    completionHandler()
                }
            }
        })
        dataTask.resume()
        
    }
    
    func callServiceForSubject(requestParameter : [String : Any])  {
        
        var trimmedString = mainpUrl + "Subject/GridList"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = URL(string:trimmedString)
        var request = URLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.populateAuthorizationHeader()
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
                print(String(data: data!, encoding: String.Encoding.utf8) ?? "")
            }
        })
        dataTask.resume()
    }
    
    
    func callServiceForQuestion(requestParameter : [String : Any])  {
        var trimmedString = mainpUrl + "Question/GridList"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = URL(string:trimmedString)
        var request = URLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.populateAuthorizationHeader()
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
        let urlPath = URL(string:trimmedString)
        var request = URLRequest(url: urlPath!)
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.populateAuthorizationHeader()
        
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
    
    
    func callServiceForlogin(requestParameter : [String : String])  {
        
        var trimmedString = mainpUrl + "Login/GetUserData"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = URL(string:trimmedString)
        var request = URLRequest(url: urlPath! as URL)
        
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

extension URLRequest{
    
    mutating func populateAuthorizationHeader()  {
        
        //let tokenType = UserDefaults.standard.value(forKey: "token_type") as! String
        let accessToken = UserDefaults.standard.value(forKey: "access_token") as! String
        self.setValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        
    }
    
}
