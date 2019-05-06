//
//  DetailExerciseViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-24.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import SwiftSpinner

class DetailExerciseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameExerciseInput: UITextField!
    @IBOutlet var weightExerciseInput: UITextField!
    @IBOutlet var setsExerciseInput: UITextField!
    @IBOutlet var repsExerciseInput: UITextField!
    @IBOutlet var timeExerciseInput: UITextField!
    
    var tempExercise = ExerciseItem()
    var currentColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightExerciseInput.delegate = self
        setsExerciseInput.delegate = self
        repsExerciseInput.delegate = self
        timeExerciseInput.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameExerciseInput.text = tempExercise.exerciseName
        weightExerciseInput.text = tempExercise.weight
        setsExerciseInput.text = tempExercise.sets
        repsExerciseInput.text = tempExercise.reps
        timeExerciseInput.text = tempExercise.time
        
        nameExerciseInput.layer.cornerRadius = 5.0
        weightExerciseInput.layer.cornerRadius = 5.0
        setsExerciseInput.layer.cornerRadius = 5.0
        repsExerciseInput.layer.cornerRadius = 5.0
        timeExerciseInput.layer.cornerRadius = 5.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        super.setEditing(editing,animated:animated)
        if(self.isEditing)
        {
            nameExerciseInput.isUserInteractionEnabled = true
            weightExerciseInput.isUserInteractionEnabled = true
            setsExerciseInput.isUserInteractionEnabled = true
            repsExerciseInput.isUserInteractionEnabled = true
            timeExerciseInput.isUserInteractionEnabled = true
            
            nameExerciseInput.backgroundColor = UIColor.white
            weightExerciseInput.backgroundColor = UIColor.white
            setsExerciseInput.backgroundColor = UIColor.white
            repsExerciseInput.backgroundColor = UIColor.white
            timeExerciseInput.backgroundColor = UIColor.white
        } else {
            tempExercise.exerciseName = nameExerciseInput.text!
            tempExercise.weight = weightExerciseInput.text!
            tempExercise.sets = setsExerciseInput.text!
            tempExercise.reps = repsExerciseInput.text!
            tempExercise.time = timeExerciseInput.text!
            
            //SwiftSpinner.show("Loading...")
            
            tempExercise.SaveExercises(exerciseItem: tempExercise, completion: {(result: Bool) in
                
                //SwiftSpinner.hide()
            })
            
            nameExerciseInput.isUserInteractionEnabled = false
            weightExerciseInput.isUserInteractionEnabled = false
            setsExerciseInput.isUserInteractionEnabled = false
            repsExerciseInput.isUserInteractionEnabled = false
            timeExerciseInput.isUserInteractionEnabled = false
            
            nameExerciseInput.backgroundColor = nil
            weightExerciseInput.backgroundColor = nil
            setsExerciseInput.backgroundColor = nil
            repsExerciseInput.backgroundColor = nil
            timeExerciseInput.backgroundColor = nil
        }
    }
}
