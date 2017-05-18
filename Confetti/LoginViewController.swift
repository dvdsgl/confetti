import UIKit
import Foundation

import ConfettiKit

import FacebookLogin

import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    @IBAction func loginTapped(_ sender: Any) {        
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                Auth.auth().signIn(with: credential) { (user, error) in
                    // ...
                    if let _ = error {
                        // ...
                        return
                    } else {
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                }
            }
        }
    }
}
