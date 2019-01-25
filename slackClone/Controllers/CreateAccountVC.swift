//
//  CreateAccountVC.swift
//  slackClone
//
//  Created by tarek bahie on 1/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTxtField: ColorPlaceHolder!
    @IBOutlet weak var passwordTxtField: ColorPlaceHolder!
    @IBOutlet weak var emailTxtField: ColorPlaceHolder!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxtField.delegate = self
        passwordTxtField.delegate = self
        emailTxtField.delegate = self
        createBtn.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
            
        }
    }
    

    @IBAction func chooseAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAvatarChoose", sender: self)
        
    }
    @IBAction func generateColorPressed(_ sender: Any) {
        
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        print(r,g,b)
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r),\(g),\(b),1]"
        UIView.animate(withDuration: 0.3){
            self.userImg.backgroundColor = self.bgColor
        }
        
        
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        if emailTxtField.text != "" && passwordTxtField.text  != "" && usernameTxtField.text != "" {
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
            SVProgressHUD.setHapticsEnabled(true)
            SVProgressHUD.show()
        AuthService.instance.registerUser(email: emailTxtField.text!, password: passwordTxtField.text!) { (success) in
            if (success){
                AuthService.instance.loginUser(email: self.emailTxtField.text!, password: self.passwordTxtField.text!, completion: { (success) in
                    if success{
                        AuthService.instance.createUser(name: self.usernameTxtField.text!, email: self.emailTxtField.text!, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                AuthService.instance.findUserByEmail(completion: { (success) in
                                    if success {
                                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                        SVProgressHUD.dismiss()
                                        self.performSegue(withIdentifier: "unwindToChannel", sender: nil)
                                    }
                                })
                                
                            }
                        })
                    }
                })
            }
        }
        }
            
        
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToChannel", sender: self)
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createBtn.isEnabled = true
    }
}
