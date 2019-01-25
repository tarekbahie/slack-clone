//
//  LoginVC.swift
//  slackClone
//
//  Created by tarek bahie on 1/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap))
        view.addGestureRecognizer(tap)
        
    }

    @objc func handleTap(){
        view.endEditing(true)
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if passwordTxtField.text != "" && usernameTxtField.text != "" {
           SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
            SVProgressHUD.setHapticsEnabled(true)
            SVProgressHUD.show()
            AuthService.instance.loginUser(email: usernameTxtField.text!, password: passwordTxtField.text!) { (success) in
            if success{     
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        SVProgressHUD.dismiss()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        }
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCreateAccount", sender: self)
    }
}
