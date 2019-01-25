//
//  MessageCell.swift
//  slackClone
//
//  Created by tarek bahie on 1/24/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageBodyLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var userAvatarImg: RoundedCornerImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message : Message){
        self.messageBodyLbl.text = message.messageBody
        self.senderNameLbl.text = message.userName
        self.userAvatarImg.image = UIImage(named: message.userAvatar)
        self.userAvatarImg.backgroundColor = UserDataService.instance.returnUIColor(Components: message.userAvatarColor)
        guard var isoDate = message.timeStamp as? String else {return}
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = String(isoDate.prefix(upTo: end))
        print(isoDate)
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        print("this is \(chatDate)")
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        if let finalDate = chatDate{
            let finalDate = newFormatter.string(from: finalDate)
            timeStampLbl.text = finalDate
        
    }

}
}
