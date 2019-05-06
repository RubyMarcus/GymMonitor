//
//  WorkoutItem.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-22.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class WorkoutItem {
    
    var ref: DatabaseReference!
    var item : [WorkoutItem]?
    var workoutName = ""
    var fbKey = ""
    
    func SaveWorkout (name : String, completion: @escaping (_ result: Bool) -> Void)
    {
        ref = Database.database().reference()
        var saveRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        saveRef = saveRef.ref.child("Workouts")
        saveRef = saveRef.childByAutoId()
        saveRef.child("WorkoutName").setValue(name)
        
        completion(true)
    }
    
    func LoadWorkout (completion: @escaping (_ result: Bool) -> Void)
    {
        ref = Database.database().reference()
        let fbLoad = ref.child("Users").child(Auth.auth().currentUser!.uid)
        fbLoad.child("Workouts").observeSingleEvent(of: .value) { (snapshot) in
            
            self.item = [WorkoutItem]()
            for workout in snapshot.children
            {
                let loopingWorkout = workout as! DataSnapshot
                let workoutDict = loopingWorkout.value as! NSDictionary
                let tempWorkout = WorkoutItem()
                
                tempWorkout.fbKey = loopingWorkout.key
                tempWorkout.workoutName = workoutDict.value(forKey: "WorkoutName") as! String
                
                self.item!.append(tempWorkout)
            }
             completion(true)
        }
    }
    
    func deleteItem (item : String, completion: @escaping (_ result: Bool) -> Void)
    {
        ref = Database.database().reference()
        var deleteRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        deleteRef = deleteRef.child("Workouts")
        deleteRef.observeSingleEvent(of: .value) { (snapshot) in
            
            for workout in snapshot.children
            {
                let loopingBirthday = workout as! DataSnapshot
                if(item == loopingBirthday.key)
                {
                    deleteRef.ref.child(item).removeValue()
                    
                    completion(true)
                }
            }
            completion(true)
        }
    }
}
