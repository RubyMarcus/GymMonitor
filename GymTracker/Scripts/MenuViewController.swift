//
//  MenuViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-21.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {

    
    @IBOutlet var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (Auth.auth().currentUser?.email! != nil) {
            userNameLabel.text = (Auth.auth().currentUser?.displayName)! // Change to name
            
        }
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let NavLoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavLoginVC") as! UINavigationController
            present(NavLoginViewController, animated: true)
        } catch {
            print("There was a problem logging out")
        }
    }

    @IBAction func WorkoutsMenuButton(_ sender: Any) {
        
        let WorkoutsViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        
        present(WorkoutsViewController, animated: true)
    }
    
    
    @IBAction func BodyWeightMenuButton(_ sender: Any) {
        
        let BodyWeightViewController = self.storyboard?.instantiateViewController(withIdentifier: "BodyWeightVC") as! BodyWeightViewController
        
        present(BodyWeightViewController, animated: true)
        
    }
    
    @IBAction func MonitorMenuButton(_ sender: Any) {
        
        let MonitorViewController = self.storyboard?.instantiateViewController(withIdentifier: "MonitorVC") as! MonitorViewController
        
        present(MonitorViewController, animated: true)
        
    }
    
    /*
    @IBAction func SettingsMenuButton(_ sender: Any) {
        
        let SettingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
        
        present(SettingsViewController, animated: true)
        
    }
    */
}
