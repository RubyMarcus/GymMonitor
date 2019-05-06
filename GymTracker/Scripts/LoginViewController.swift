//
//  LoginViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-04-26.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftSpinner

class LoginViewController: UIViewController {
    
    @IBOutlet var emailLoginTextfield: UITextField!
    @IBOutlet var passwordLoginTextfield: UITextField!
    @IBOutlet weak var imageBackground: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageBackground.addBlur(0.7)
        
        // Do any additional setup after loading the view.
    }
    
    // Tangentbordet förvinner vid klickande på skärmen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func loginUser(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailLoginTextfield.text!, password: passwordLoginTextfield.text!) { (user, error) in
            
            if(error == nil)
            {
                SwiftSpinner.show("Connecting to server...")
                
                print("Login succesful")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
                    
                    SwiftSpinner.hide()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Something went wrong")
                print(error.debugDescription)
                
                let newErrorMessage = error?.makePrettyError(error: error)
                
                let alert = UIAlertController(title: "Error", message: newErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.5) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

// Conformance
extension UIView: Bluring {}
