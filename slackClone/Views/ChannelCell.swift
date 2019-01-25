//
//  ChannelCell.swift
//  slackClone
//
//  Created by tarek bahie on 1/20/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell, NewNotifications {
    
    
    func userDidEnterChannel(numberOfMessages: Int) {
        self.numberOfNewMessagesLbl.text = "\(numberOfMessages)"
    }
    

    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var numberOfNewMessagesLbl: UILabel!
    
    var numerONewMessages = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberOfNewMessagesLbl.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }


    }
    func configureCell(channel : Channel) {
        self.channelNameLbl.text = channel.channelTitle
        numberOfNewMessagesLbl.text = "\(0)"
        numberOfNewMessagesLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                let allNewMessages = MessageService.instance.unreadChannels.count
                let wantedNewMessages = MessageService.instance.unreadChannels.filter{$0 != channel.id}.count
                let numberOfNewMessages = allNewMessages - wantedNewMessages
                numberOfNewMessagesLbl.isHidden = false
//                SocketService.instance.numberOfNewMessages = numberOfNewMessages
//                numerONewMessages = SocketService.instance.numberOfNewMessages
//                numerONewMessages += 1
                userDidEnterChannel(numberOfMessages: numberOfNewMessages)
                numberOfNewMessagesLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            }
            
        }
        
        
    }

}
