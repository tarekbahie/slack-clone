//
//  Message.swift
//  slackClone
//
//  Created by tarek bahie on 1/24/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import Foundation
struct Message {
    public private(set) var id : String!
    public private(set) var messageBody : String!
    public private(set) var channelId : String!
    public private(set) var userName : String!
    public private(set) var userAvatar : String!
    public private(set) var userAvatarColor : String!
    public private(set) var timeStamp : String!
    
    
    init(id: String, messageBody : String, channelId : String, userName : String, userAvatar : String, userAvatarColor : String, timeStamp : String) {
        self.id = id
        self.messageBody = messageBody
        self.channelId = channelId
        self.userName = userName
        self.userAvatar = userAvatar
        self.userAvatarColor = userAvatarColor
        self.timeStamp = timeStamp
    }
    
}
