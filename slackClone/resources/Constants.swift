//
//  Constants.swift
//  slackClone
//
//  Created by tarek bahie on 1/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import Foundation

// USER_DEFAULTS
let TOKEN_KEY = "token"
let LOGGED_IN_KEY  = "loggedin"
let USER_EMAIL = "useremail"
let USER_ID = "USERID"


// HEADERS
let HEADER =  ["Content-Type": "application/json; charsetutf=8"]
let BEARER_HEADER = ["Authorization": "Bearer \(AuthService.instance.authToken)","Content-Type": "application/json; charsetutf=8"]

///Completion Handlers\\\
typealias CompletionHandler = (_ Success: Bool) -> ()


///URL\\\
let Base_URL = "https://chattychatchat12323.herokuapp.com/V1/"
let URL_REGISTER = "\(Base_URL)account/register"
let URL_LOGIN = "\(Base_URL)account/login"
let URL_USER_ADD = "\(Base_URL)user/add"
let URL_USER_BY_MAIL = "\(Base_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(Base_URL)channel/"
let URL_GET_Messages = "\(Base_URL)message/byChannel/"
let URL_USER_BY_ID = "\(Base_URL)user/"



/// notifications
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_FOUND_CHANNELS = Notification.Name("notifFoundChannels")
let NOTIF_CHANNEL_SELECTED = Notification.Name("notifChannelSelected")
