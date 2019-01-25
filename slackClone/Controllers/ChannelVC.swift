//
//  ChannelVC.swift
//  slackClone
//
//  Created by tarek bahie on 1/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareforUnwind(segue : UIStoryboardSegue){}
    @IBOutlet weak var userImg: RoundedCornerImage!
    @IBOutlet weak var channelTableView: UITableView!
 
    var label: UILabel = UILabel()
    var delegate: NewNotifications? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector (ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_FOUND_CHANNELS, object: nil)
        channelTableView.delegate = self
        channelTableView.dataSource = self
        SocketService.instance.getNewChannels { (success) in
            self.channelTableView.reloadData()
            let endIndex : IndexPath = IndexPath(item: MessageService.instance.channels.count - 1, section: 0)
            self.channelTableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
        }
        SocketService.instance.getNewMessages { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.channelTableView.reloadData()
            }
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        setUpUserInfo()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        }else{
            performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }
    func setUpUserInfo(){
        if AuthService.instance.isLoggedIn{
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(Components: UserDataService.instance.avatarColor)
        }else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            channelTableView.reloadData()
        }
    }
    
    @objc func userDataDidChange(_ notif : Notification){
        setUpUserInfo()
    }
    
    @objc func channelsLoaded(_ notif : Notification){
        channelTableView.reloadData()
    }

    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
        let addChannelVC = AddChannelVC()
        present(addChannelVC, animated: true, completion: nil)
        }
    }
}

extension ChannelVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell else {
            return UITableViewCell()
        }
        let channel = MessageService.instance.channels[indexPath.row]
        cell.configureCell(channel: channel)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.id}
            delegate?.userDidEnterChannel(numberOfMessages: 0)
            
        }
        let index = IndexPath(row: indexPath.row, section: 0)
        channelTableView.reloadRows(at: [index], with: .none)
        channelTableView.selectRow(at: index, animated: false, scrollPosition: .none)
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }

    
}
