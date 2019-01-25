//
//  AddChannelVC.swift
//  slackClone
//
//  Created by tarek bahie on 1/20/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddChannelVC: UIViewController {

    @IBOutlet weak var titleLbl: ColorPlaceHolder!
    @IBOutlet weak var descriptionLbl: ColorPlaceHolder!
    @IBOutlet weak var createChannelBtn: RoundedCorner!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }

    @IBAction func createChannelPressed(_ sender: Any) {
        if titleLbl.text != "" && descriptionLbl.text != "" {
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
            SVProgressHUD.setHapticsEnabled(true)
            SVProgressHUD.show()
            SocketService.instance.newChannelCreated(title: titleLbl.text!, description: descriptionLbl.text!) { (success) in
                if success {
                        SVProgressHUD.dismiss()
                         self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
