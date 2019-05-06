//
//  ForgotPasswordViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-18.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftSpinner

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var emailResetPassInputField: UITextField!
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

    @IBAction func resetPasswordButton(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: emailResetPassInputField.text!) { error in
            
            if(error == nil)
            {
                print("Email has been sent!")
                
                SwiftSpinner.show("Email sent.", animated: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                    
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
            }
        }
    }
}
