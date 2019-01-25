//
//  MessageService.swift
//  slackClone
//
//  Created by tarek bahie on 1/20/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel : Channel?
    var messages = [Message]()
    var unreadChannels = [String]()
    
    
    func getChannels (completion : @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else{return}
                if let json = try! JSON(data : data).array {
                for item in json {
                    let name = item["name"].stringValue
                    let channelDescription = item["description"].stringValue
                    let id = item["_id"].stringValue
                    let newChannel = Channel(title: name, description: channelDescription, id: id)
                    self.channels.append(newChannel)
                    
                }
                
            }
                NotificationCenter.default.post(name: NOTIF_FOUND_CHANNELS, object: nil)
                completion(true)
        }
        }
    }
    
    func getMessagesForChannel(withId id : String, completion : @escaping CompletionHandler){
        Alamofire.request(("\(URL_GET_Messages)\(id)"), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else{return}
                if let messagesJson = try! JSON(data: data).array {
                    for item in messagesJson {
                        let id = item["_id"].stringValue
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        let newMessage = Message(id: id, messageBody: messageBody, channelId: channelId, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
                        self.messages.append(newMessage)
                        
                    }
                    completion(true)
                }
                
            }else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    func clearMessages () {
        messages.removeAll()
    }
    func clearChannels () {
        channels.removeAll()
    }
}

