//
//  LoginViewController.swift
//  Confetti
//
//  Created by David SIegel on 5/8/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import UIKit
import Foundation

import ConfettiKit

import FacebookLogin

import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBAction func loginTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let _, let _, let accessToken):
                print("Logged in!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    // ...
                    if let error = error {
                        // ...
                        return
                    }
                }
            }
        }
    }
}
