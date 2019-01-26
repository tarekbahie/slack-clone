//
//  ChatVC.swift
//  slackClone
//
//  Created by tarek bahie on 1/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var isTypingLabel: UILabel!
    @IBOutlet weak var messageTxtHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonTextFieldView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    
    
    var numberOfNewMessages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.isHidden = true
        isTypingLabel.isHidden = true
//        buttonTextFieldView.bindToKeyboard()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTxtField.delegate = self
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDidSelectChannel(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                
                SocketService.instance.getNewMessages(completion: { (newMessage) in
                    if newMessage.channelId == MessageService.instance.selectedChannel?.id {
                        MessageService.instance.messages.append(newMessage)
                        self.messageTableView.reloadData()
                        if MessageService.instance.messages.count > 0 {
                            let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                            self.messageTableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                        }
                    } else {
                        
                        
                        
                        
                    }
                })
            }
        }
        SocketService.instance.isTyping { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else{return}
            var names = ""
            var numberOfTypers = 0
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names),\(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1{
                    verb = "are"
                }
                self.isTypingLabel.isHidden = false
                self.isTypingLabel.text = "\(names) \(verb) typing a message"
            }else {
                self.isTypingLabel.text = ""
                self.isTypingLabel.isHidden = true
            }
        }
        
    }
    

    @objc func userDataDidChange(_ notif : Notification){
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            loginLbl.text = "Please Login!"
            messageTableView.reloadData()
        }
    }
    @objc func userDidSelectChannel(_ notif : Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        let channelDesc = MessageService.instance.selectedChannel?.channelDescription ?? ""
        loginLbl.text = "# \(channelName)"
        channelNameLbl.text = channelDesc
        getMessages()
    }
    
    func onLoginGetMessages () {
        MessageService.instance.getChannels { (success) in
            if success{
                if MessageService.instance.channels.count>0{
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }else{
                    self.loginLbl.text = "No Channels Yet!"
                }
            }
        }
    }
    func getMessages(){
        guard let channelId = MessageService.instance.selectedChannel?.id else{return}
        MessageService.instance.getMessagesForChannel(withId: channelId) { (success) in
            if success{
                self.messageTableView.reloadData()
            }
        }
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else{return}
            guard let message  = messageTxtField.text , messageTxtField.text != "" else {return}
            SocketService.instance.numberOfNewMessages += 1           
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageTxtField.text = ""
                    self.messageTxtField.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType",UserDataService.instance.name, channelId )
                    self.sendBtn.isHidden = true
                }
            }
            
        }
    }
}

extension ChatVC : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        let message = MessageService.instance.messages[indexPath.row]
        cell.configureCell(message: message)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let channelId = MessageService.instance.selectedChannel?.id else{return}
        sendBtn.isHidden = false
        SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let channelId = MessageService.instance.selectedChannel?.id else{return}
        sendBtn.isHidden = true
        SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId )
    }
    
}
