//
//  SignUpViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-04-26.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftSpinner

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailSignUpTextfield: UITextField!
    @IBOutlet var fullnameSignUpTextfield: UITextField!
    
    @IBOutlet var passwordSignUpTextfield: UITextField!
    @IBOutlet var confirmPasswordSignUpTextfield: UITextField!
    
    @IBOutlet weak var imageBackground: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageBackground.addBlur()
        
        // Do any additional setup after loading the view.
    }
    
    // Tangentbordet förvinner vid klickande på skärmen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpUser(_ sender: Any) {
        
        if (passwordSignUpTextfield.text == confirmPasswordSignUpTextfield.text)
        {
            Auth.auth().createUser(withEmail: emailSignUpTextfield.text!, password: passwordSignUpTextfield.text!) {(user, error) in
                
                if(error == nil)
                {
                    SwiftSpinner.show("Creating account...")
                    
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()
                        
                        changeRequest.displayName = self.fullnameSignUpTextfield.text
                        changeRequest.commitChanges { error in
                            if error != nil {
                                // An error happened.
                            } else {
                                // Profile updated.
                            }
                        }
                    }
                    
                    SwiftSpinner.show(duration: 2.0, title: "User has been created.", animated: false)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                        
                        print("Created user succes")
                        
                        SwiftSpinner.hide()
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } else {
                    print("Something went wrong")
                    print(error.debugDescription)
                    
                    let newErrorMessage = error?.makePrettyError(error: error)
                    
                    let alert = UIAlertController(title: "Error", message: newErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    SwiftSpinner.hide()
                }
            }
            
        } else {
            print("Password does not match")
            
            let alert = UIAlertController(title: "Error", message: "Password does not match", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
}

extension Error
{
    func makePrettyError(error : Error?) -> String
    {
        var error_code = (error as! NSError).userInfo["error_name"] as! String
        
        switch error_code
        {
        case "ERROR_WEAK_PASSWORD":
            return "The password must be 6 characters long or more."
        case "ERROR_MISSING_EMAIL":
            return "Missing email"
        case "ERROR_INVALID_EMAIL":
            return "Invalid email"
        case "ERROR_EMAIL_ALREADY_IN_USE":
            return "Email already used"
        case "ERROR_WRONG_PASSWORD":
            return "Wrong password"
        default:
            return "Something went wrong"
        }
    }
}
