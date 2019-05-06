//
//  CalendarWeightItem.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-31.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import Foundation
import Firebase


class CalendarWeightItem
{
    var ref: DatabaseReference!
    
    var item : [CalendarWeightItem]?
    var date = ""
    var weight = ""
    var fbKey = ""
    
    func SaveWeight(item : CalendarWeightItem, completion: @escaping (_ result: Bool) -> Void) {
        ref = Database.database().reference()
        
        var saveRef = ref.child("Users").child(Auth.auth().currentUser!.uid)
        
        saveRef = saveRef.ref.child("DateWeights")
        
        let key = ""
        
        if key == item.fbKey {
            
            saveRef = saveRef.ref.childByAutoId()
            
            saveRef.child("Date").setValue(item.date)
            saveRef.child("Weight").setValue(item.weight)
            
            completion(true)
        } else {
            
            saveRef = saveRef.ref.child(item.fbKey)
            
            saveRef.child("Date").setValue(item.date)
            saveRef.child("Weight").setValue(item.weight)
            
            completion(true)
        }
    }
    
    func LoadWeight (completion: @escaping (_ result: Bool) -> Void) {
        ref = Database.database().reference()
        
        let fbLoad = ref.child("Users").child(Auth.auth().currentUser!.uid)
        
        fbLoad.child("DateWeights").observeSingleEvent(of: .value) { (snapshot) in
            
            self.item = [CalendarWeightItem]()
            
                            print("test")
            for weight in snapshot.children
            {
                let loopingWeight = weight as! DataSnapshot
                
                let weightDict = loopingWeight.value as! NSDictionary
                
                let tempWeight = CalendarWeightItem()
                
                tempWeight.fbKey = loopingWeight.key
                
                tempWeight.date = weightDict.value(forKey: "Date") as! String
                tempWeight.weight = weightDict.value(forKey: "Weight") as! String
                
                self.item!.append(tempWeight)
            }
            completion(true)
        }
    }
}
