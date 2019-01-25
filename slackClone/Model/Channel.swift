//
//  Channel.swift
//  slackClone
//
//  Created by tarek bahie on 1/20/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import Foundation
struct Channel {
    public private(set) var channelTitle : String!
    public private(set) var channelDescription : String!
    public private(set) var id : String!


    init(title : String, description : String, id : String) {
        self.channelDescription = description
        self.channelTitle = title
        self.id = id
    }

}
