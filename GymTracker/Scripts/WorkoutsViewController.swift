//
//  WorkoutsViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-21.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import SwiftSpinner

class WorkoutsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var workoutItem = WorkoutItem()
    
    @IBOutlet var WorkoutNameInput: UITextField!
    @IBOutlet var workoutsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.workoutsTableView.allowsMultipleSelectionDuringEditing = false
        
        LoadWorkouts()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func menuButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func LoadWorkouts ()
    {
        //SwiftSpinner.show("Loading...")
        
        workoutItem.LoadWorkout(completion: {(result: Bool) in
            
            self.workoutsTableView.reloadData()
            
            //SwiftSpinner.hide()
        })
    }
    
    @IBAction func SaveWorkoutButton(_ sender: Any) {
        
        if(WorkoutNameInput.text != "")
        {
            //SwiftSpinner.show("Saving to database...")
            
            workoutItem.SaveWorkout(name: WorkoutNameInput.text!, completion: {(result: Bool) in
                
                self.LoadWorkouts()
                self.WorkoutNameInput.text = ""
                /*
                SwiftSpinner.show("Successful save.", animated: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                    
                    
                    SwiftSpinner.hide()
                }
                */
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "exercises", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "exercises") {
            let dest = segue.destination as! ExercisesViewController
            dest.tempWorkoutItem = workoutItem.item![sender as! Int]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //SwiftSpinner.show("Deleting...")
            workoutItem.deleteItem(item: (workoutItem.item?[indexPath.row].fbKey)!, completion: {(result : Bool) in
                
                self.workoutItem.item?.removeAll()
                self.LoadWorkouts()
                self.workoutsTableView.reloadData()
                
                //SwiftSpinner.hide()
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let itemcount = workoutItem.item?.count
        {
            return itemcount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as! WorkoutTableViewCell
     
        cell.workoutNameLabel.text = workoutItem.item![indexPath.row].workoutName
        
        return cell
    }
}
