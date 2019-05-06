//
//  ExerciseItem.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-23.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase

class ExerciseItem {
    
    var ref: DatabaseReference!
    var item : [ExerciseItem]?
    
    var workoutFbKey = ""
    var exerciseFbKey = ""
    var exerciseName = ""
    var weight = ""
    var reps = ""
    var sets = ""    
    var time = ""
    
    func SaveExercises (exerciseItem : ExerciseItem, completion: @escaping (_ result: Bool) -> Void)
    {
        ref = Database.database().reference()
        var saveRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        saveRef = saveRef.child("Workouts")
        saveRef = saveRef.child(exerciseItem.workoutFbKey)
        saveRef = saveRef.child("Exercise")
        
        let key = ""
        if key == exerciseItem.exerciseFbKey {
            saveRef = saveRef.childByAutoId()
            
            saveRef.child("ExerciseName").setValue(exerciseItem.exerciseName)
            saveRef.child("Weight").setValue(exerciseItem.weight)
            saveRef.child("Reps").setValue(exerciseItem.reps)
            saveRef.child("Sets").setValue(exerciseItem.sets)
            saveRef.child("Time").setValue(exerciseItem.time)
            
            
            completion(true)
        } else {
            saveRef = saveRef.child(exerciseItem.exerciseFbKey)
            
            saveRef.child("ExerciseName").setValue(exerciseItem.exerciseName)
            saveRef.child("Weight").setValue(exerciseItem.weight)
            saveRef.child("Reps").setValue(exerciseItem.reps)
            saveRef.child("Sets").setValue(exerciseItem.sets)
            saveRef.child("Time").setValue(exerciseItem.time)
            saveRef.child("StartingWeight").setValue(exerciseItem.weight)
            
            completion(true)
        }
    }
    
    func ReSaveWeight (fbkeyWorkout : String, list : [ExerciseItem],completion: @escaping (_ result : Bool) -> Void) {
        ref = Database.database().reference()
        
        var updateRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        updateRef = updateRef.child("Workouts")
        updateRef = updateRef.child(fbkeyWorkout)
        updateRef = updateRef.child("Exercise")
        updateRef.observeSingleEvent(of: .value) { (snapshot) in
            for exercise in snapshot.children {
                let loopingExercise = exercise as! DataSnapshot
                for item in list {
                    if (loopingExercise.key == item.exerciseFbKey) {
                        updateRef.child(item.exerciseFbKey).child("Weight").setValue(item.weight)
                    }
                }
            }
            completion(true)
        }
    }
    
    func LoadExercises (fbKeyWorkout : String,completion: @escaping (_ result: Bool) -> Void)
    {
        ref = Database.database().reference()
        var fbLoad = ref.child("Users").child(Auth.auth().currentUser!.uid)
        fbLoad = fbLoad.child("Workouts")
        fbLoad = fbLoad.child(fbKeyWorkout)
        fbLoad = fbLoad.child("Exercise")
        fbLoad.observeSingleEvent(of: .value) { (snapshot) in
            self.item = [ExerciseItem]()
            
            for exercise in snapshot.children
            {
                let loopingExercise = exercise as! DataSnapshot
                let exerciseDict = loopingExercise.value as! NSDictionary
                let tempExercise = ExerciseItem()
                
                tempExercise.exerciseFbKey = loopingExercise.key
                tempExercise.workoutFbKey = fbKeyWorkout
                tempExercise.exerciseName = exerciseDict.value(forKey: "ExerciseName") as! String
                tempExercise.reps = exerciseDict.value(forKey: "Reps") as! String
                tempExercise.sets = exerciseDict.value(forKey: "Sets") as! String
                tempExercise.time = exerciseDict.value(forKey: "Time") as! String
                tempExercise.weight = exerciseDict.value(forKey: "Weight") as! String
                
                self.item!.append(tempExercise)
            }
            completion(true)
        }
    }
    
    func deleteItem (item : ExerciseItem, completion: @escaping (_ result: Bool) -> Void)
    {
        ref = Database.database().reference()
        var deleteRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        deleteRef = deleteRef.child("Workouts")
        deleteRef = deleteRef.child(item.workoutFbKey)
        deleteRef = deleteRef.child("Exercise")
        deleteRef.observeSingleEvent(of: .value) { (snapshot) in
            
            for exercise in snapshot.children
            {
                let loopingBirthday = exercise as! DataSnapshot
                
                if(item.exerciseFbKey == loopingBirthday.key)
                {
                    deleteRef.ref.child(item.exerciseFbKey).removeValue()

                    completion(true)
                }
            }

            completion(true)
        }
    }
}
