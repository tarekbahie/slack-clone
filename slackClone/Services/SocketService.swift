//
//  SocketService.swift
//  slackClone
//
//  Created by tarek bahie on 1/21/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    
    static let instance = SocketService()

    
    var numberOfNewMessages = 0
    
    override init() {
        super.init()
    }
    let manager = SocketManager(socketURL: URL(string: Base_URL)!)
    lazy var socket : SocketIOClient = manager.defaultSocket
    
    
    
    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }

    
    
    
    func newChannelCreated(title : String, description : String, completion : @escaping CompletionHandler) {
        socket.emit("newChannel", title, description)
        completion(true)
    }
    func getNewChannels(completion : @escaping CompletionHandler) {
        socket.on("channelCreated") { (data, ACK) in
            guard let channelName = data[0] as? String else {return}
            guard let channelDescription = data[1] as? String else {return}
            guard let channelId = data[2] as? String else {return}
            let newChannel = Channel(title: channelName, description: channelDescription, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    func addMessage(messageBody : String, userId : String, channelId : String, completion : @escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
        
    }
    func getNewMessages(completion : @escaping (_ newMessage : Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ACK) in
            guard let messageBody = dataArray[0] as? String else{return}
            guard let channelId = dataArray[2] as? String else{return}
            guard let userName = dataArray[3] as? String else{return}
            guard let userAvatar = dataArray[4] as? String else{return}
            guard let userAvatarColor = dataArray[5] as? String else{return}
            guard let messageId = dataArray[6] as? String else{return}
            guard let timeStamp = dataArray[7] as? String else{return}
            let newMessage = Message(id: messageId, messageBody: messageBody, channelId: channelId, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
            completion(newMessage)
        }
    }
    
    func isTyping(_ completionHandler : @escaping (_ typingUsers : [String:String])-> Void) {
        socket.on("userTypingUpdate") { (dataArray, ACK) in
            guard let typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
        }
    }
    
    
    
    
    
    
}
