//
//  FinishedWorkout.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-06-26.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import Foundation
import Firebase

class FinishedWorkout {
    
    var ref : DatabaseReference!
    var workoutName = ""
    var time = ""
    var date = ""
    var exercises = [ExerciseItem]()
    var item = [FinishedWorkout]()
    var monitorItem = [MonitorCalculating]()
    
    func SaveFinishedWorkout (item : FinishedWorkout, completion: @escaping (_ result : Bool) -> Void) {
        ref = Database.database().reference()
        
        var saveRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        saveRef = saveRef.ref.child("FinishedWorkouts")
        saveRef = saveRef.ref.childByAutoId()
        
        saveRef.child("WorkoutName").setValue(item.workoutName)
        saveRef.child("Time").setValue(item.time)
        saveRef.child("Date").setValue(item.date)
        
        saveRef = saveRef.child("Exercises")
        
        for exercise in 0..<item.exercises.count {
            saveRef = saveRef.childByAutoId()
            
            saveRef.child("ExerciseName").setValue(item.exercises[exercise].exerciseName)
            saveRef.child("Weight").setValue(item.exercises[exercise].weight)
            saveRef = saveRef.parent!
        }
        completion(true)
    }
    
    func LoadFinishedWorkouts (completion: @escaping (_ result : Bool) -> Void) {
        ref = Database.database().reference()
        let temp = FinishedWorkout()
        let tempExercise = ExerciseItem()
        let monitor = MonitorCalculating()
        
        var loadRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        loadRef = loadRef.ref.child("FinishedWorkouts")
        
        loadRef.observeSingleEvent(of: .value) {(snapshot) in
            for finishedWorkout in snapshot.children {
                let loopingWorkout = finishedWorkout as! DataSnapshot
                let workoutDict = loopingWorkout.value as! NSDictionary
                
                temp.workoutName = workoutDict.value(forKey: "WorkoutName") as! String
                temp.date = workoutDict.value(forKey: "Date") as! String
                temp.time = workoutDict.value(forKey: "Time") as! String
                
                let exercises = workoutDict["Exercises"] as! NSDictionary //array of dictionaries
                
                //now iterate over the array
                for (key,_) in exercises {
                    
                    let exercise:NSObject = exercises[key] as! NSObject
                    monitor.name = exercise.value(forKey: "ExerciseName") as! String
                    monitor.weight = exercise.value(forKey: "Weight") as! String
                    monitor.Date = temp.date
                    
                    self.monitorItem.append(monitor)
                }
            }
            completion(true)
        }
    }
}
