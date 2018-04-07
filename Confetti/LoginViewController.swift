import UIKit
import Foundation
import SafariServices

import ConfettiKit

import FacebookLogin

import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: RoundRectangleButton!
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        facebookButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func showPrivacyPolicy(_ sender: Any) {
        let url = URL(string: "http://confettiapp.com/privacy/")!
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func loginAnonymously(_ sender: Any) {
        Auth.auth().signInAnonymously() { (user, error) in
            if let _ = error {
                return
            } else if let _ = user {
                UserViewModel.current.beginSession()
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { loginResult in
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
                    } else if let _ = user {
                        UserViewModel.current.beginSession()
                        
                        // Save profile image to firebase
                        if let uid = Auth.auth().currentUser?.providerData.first?.uid {
                            let photoUrl = URL(string: "https://graph.facebook.com/\(uid)/picture?height=500")
                            UserViewModel.current.saveImage(url: photoUrl!)
                        }
                        
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                }
            }
        }
    }
}
