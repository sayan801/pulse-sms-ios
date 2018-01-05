//
//  ViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 12/31/17.
//  Copyright © 2017 Luke Klinker. All rights reserved.
//

import UIKit
import Alamofire
import Async

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        password.delegate = self
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login(0)
        return true
    }

    // MARK: Actions
    @IBAction func login(_ sender: Any) {
        if (email.text != nil && email.text!.count != 0 && password.text != nil && password.text!.count != 0) {
            login.isEnabled = false
            password.resignFirstResponder()
            
            PulseApi.accounts().login(email: email.text!, password: password.text!) { (response: DataResponse<LoginResponse>) in
                if let loginResponse = response.result.value {
                    let password = self.password.text!

                    Async.background {
                        do {
                            debugPrint("creating account encryption.")
                            try Account.createAccount(password: password, loginResponse: loginResponse)
                        } catch {
                            debugPrint("error creating encryption for account.")
                        }
                    }.main {
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessengerNavigationController") as! MessengerNavigationController
                        self.present(secondViewController, animated: true)
                    }
                }
            }
        }
    }
}
