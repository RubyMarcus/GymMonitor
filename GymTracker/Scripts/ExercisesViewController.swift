//
//  ExercisesViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-23.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import SwiftSpinner

class ExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet var nameExerciseInput: UITextField!
    @IBOutlet var weightExerciseInput: UITextField!
    @IBOutlet var repsExerciseInput: UITextField!
    @IBOutlet var setsExerciseInput: UITextField!
    @IBOutlet var timeExerciseInput: UITextField!
    @IBOutlet var exerciseTableView: UITableView!
    @IBOutlet var workoutNameLabel: UILabel!
    
    var tempWorkoutItem = WorkoutItem()
    var tempExcerciseItem = ExerciseItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightExerciseInput.delegate = self
        repsExerciseInput.delegate = self
        setsExerciseInput.delegate = self
        timeExerciseInput.delegate = self
        
        workoutNameLabel.text = tempWorkoutItem.workoutName
        //SwiftSpinner.show("Loading...")
        tempExcerciseItem.LoadExercises(fbKeyWorkout: tempWorkoutItem.fbKey, completion: {(result : Bool) in
            self.exerciseTableView.reloadData()
            //SwiftSpinner.hide()
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.exerciseTableView.allowsMultipleSelectionDuringEditing = false;
        exerciseTableView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @IBAction func AddExercise(_ sender: Any) {
        if(nameExerciseInput.text != "") {
            tempExcerciseItem.workoutFbKey = tempWorkoutItem.fbKey
            tempExcerciseItem.exerciseName = nameExerciseInput.text!
            tempExcerciseItem.weight = weightExerciseInput.text!
            tempExcerciseItem.reps = repsExerciseInput.text!
            tempExcerciseItem.sets = setsExerciseInput.text!
            tempExcerciseItem.time = timeExerciseInput.text!
            
            //SwiftSpinner.show("Saving to database...")
            
            tempExcerciseItem.SaveExercises(exerciseItem: tempExcerciseItem, completion: {(result: Bool) in
                
                //SwiftSpinner.show("Successful save.", animated: false)
                
                self.nameExerciseInput.text = ""
                self.weightExerciseInput.text = ""
                self.repsExerciseInput.text = ""
                self.setsExerciseInput.text = ""
                self.timeExerciseInput.text = ""
                
                //SwiftSpinner.show("Loading...")
                
                self.tempExcerciseItem.LoadExercises(fbKeyWorkout: self.tempWorkoutItem.fbKey, completion: {(result : Bool) in
                    self.exerciseTableView.reloadData()
                    
                   // SwiftSpinner.hide()
                })
                /*
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
                    SwiftSpinner.hide()
                }
                */
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailExerciseViewController
        tempExcerciseItem.item?[sender as! Int].workoutFbKey = tempWorkoutItem.fbKey
        dest.tempExercise = tempExcerciseItem.item![sender as! Int]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //SwiftSpinner.show("Deleting...")
            tempExcerciseItem.item![indexPath.row].workoutFbKey = tempWorkoutItem.fbKey
            tempExcerciseItem.deleteItem(item: tempExcerciseItem.item![indexPath.row], completion: {(result : Bool) in
                
                self.tempExcerciseItem.item?.removeAll()
                //SwiftSpinner.show("Loading...")
                self.tempExcerciseItem.LoadExercises(fbKeyWorkout: self.tempWorkoutItem.fbKey, completion: {(result : Bool) in
                    
                    self.exerciseTableView.reloadData()
                    
                    //SwiftSpinner.hide()
                })
                //SwiftSpinner.hide()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemcount = tempExcerciseItem.item?.count
        {
            return itemcount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell") as! WorkoutTableViewCell
        cell.workoutNameLabel.text = tempExcerciseItem.item![indexPath.row].exerciseName
        return cell
    }
}


