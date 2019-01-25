//
//  ProfileVC.swift
//  slackClone
//
//  Created by tarek bahie on 1/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var userImg: RoundedCornerImage!
    @IBOutlet weak var usrnameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    func setUpView(){
        userImg.image = UIImage(named: UserDataService.instance.avatarName)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(Components: UserDataService.instance.avatarColor)
        usrnameLbl.text = UserDataService.instance.name
        emailLbl.text = UserDataService.instance.email
    }

  
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserDataService.instance.logOutUser()
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
}
