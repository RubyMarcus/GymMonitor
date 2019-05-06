//
//  WorkingOutViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-06-08.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import SwiftSpinner

class WorkingOutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var workoutTableView: UITableView!
    
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    var tempWorkoutitem = WorkoutItem()
    var tempExerciseItem = ExerciseItem()
    var tempFinsishedWorkout = FinishedWorkout()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        workoutNameLabel.text = tempWorkoutitem.workoutName
        runTimer()
        tempExerciseItem.LoadExercises(fbKeyWorkout: tempWorkoutitem.fbKey, completion: {(result : Bool) in
            self.workoutTableView.reloadData()
        })
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:      (#selector(WorkingOutViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will decrement(count down)the seconds.
        timerLabel.text = timeString(time: TimeInterval(seconds)) //This will update the label.
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @IBAction func FinishWorkoutButton(_ sender: Any) {
        func cells(tableView:UITableView) -> [WorkingOutTableViewCell]{
            var cells:[WorkingOutTableViewCell] = []
            (0..<tableView.numberOfSections).indices.forEach { sectionIndex in
                (0..<tableView.numberOfRows(inSection: sectionIndex)).indices.forEach { rowIndex in
                    if let cell:WorkingOutTableViewCell = workoutTableView.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex)) as? WorkingOutTableViewCell {
                        cells.append(cell)
                    }
                }
            }
            return cells
        }
        
        for cell in cells(tableView: workoutTableView) {
            if(cell.exerciseFinished == false) {
                return
            }
            for item in tempExerciseItem.item! {
                if(cell.exerciseNameLabel.text == item.exerciseName) {
                    let newWeightStr = RemovePartOfString(string: cell.weightInput.text!)
                    item.weight = newWeightStr
                }
            }
        }
        
        tempExerciseItem.ReSaveWeight(fbkeyWorkout: tempWorkoutitem.fbKey,list: tempExerciseItem.item!,completion: {(result: Bool) in
            let tempFW = FinishedWorkout()
            tempFW.workoutName = self.workoutNameLabel.text!
            tempFW.time = self.timerLabel.text!
            tempFW.exercises = self.tempExerciseItem.item!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MM dd"
            tempFW.date = formatter.string(from: Date())
            
            tempFW.SaveFinishedWorkout(item: tempFW, completion: {(result : Bool) in
                
                // Do Something
            })
            SwiftSpinner.show("Well Done!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
                SwiftSpinner.hide()
                
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func RemovePartOfString (string : String) -> String {
        let weightUpdated = string.replacingOccurrences(of: " kg", with: "", options: .regularExpression)
        return weightUpdated
    }
    
    @IBAction func CancelWorkout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemcount = tempExerciseItem.item?.count
        {
            return itemcount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutexercise") as! WorkingOutTableViewCell
        cell.exerciseNameLabel.text = tempExerciseItem.item![indexPath.row].exerciseName
        cell.setsAndRepsLabel.text = "\(tempExerciseItem.item![indexPath.row].sets) sets of \(tempExerciseItem.item![indexPath.row].reps) reps"
        cell.weightInput.text = "\(tempExerciseItem.item![indexPath.row].weight) kg"
        
        cell.SetupStepper()
        
        return cell
    }
}





