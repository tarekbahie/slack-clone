//
//  AuthService.swift
//  slackClone
//
//  Created by tarek bahie on 1/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



class AuthService {
static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defaults.value(forKey:  TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var userEmail : String {
        get {
            return defaults.value(forKey:  USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    var userId: String {
        get {
            return defaults.value(forKey: USER_ID) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_ID)
        }
    }
    

    func registerUser(email : String, password : String, completion : @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body : [String : Any] = ["email": lowerCaseEmail, "password": password]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER ).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func loginUser(email : String, password : String, completion : @escaping CompletionHandler) {
        let body : [String : Any] = ["email": email, "password": password]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default , headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                let loginJson = JSON(response.result.value!)
                self.userEmail = loginJson["user"].stringValue
                self.authToken = loginJson["token"].stringValue
                self.isLoggedIn = true
                completion(true)
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
        
        
    }
    func createUser(name : String, email : String, avatarName: String, avatarColor : String, completion : @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String:Any]  = ["name": name,"email":lowerCaseEmail,"avatarName": avatarName, "avatarColor":avatarColor
        ]
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                self.setUserInfo(data: data)
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    func findUserByEmail(completion : @escaping CompletionHandler){
        
        Alamofire.request("\(URL_USER_BY_MAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else{return}
                self.setUserInfo(data: data)
                completion(true)
                print(response.value)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    func setUserInfo(data : Data) {
        let json = try! JSON(data : data)
        let id = json["_id"].stringValue
        let name = json["name"].stringValue
        let email = json["email"].stringValue
        let avatarName = json["avatarName"].stringValue
        let color = json["avatarColor"].stringValue
        UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
    }
}
