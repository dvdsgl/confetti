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
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    // ...
                    if let error = error {
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
