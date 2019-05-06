//
//  WorkingOutTableViewCell.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-06-19.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit

class WorkingOutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var setsAndRepsLabel: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBOutlet weak var exerciseSwitchOutlet: UISwitch!
    
    var exerciseFinished : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func SetupStepper () {
        let weightStr = weightInput.text!
        stepperOutlet.stepValue = 0.5
        let newWeightStr = RemovePartOfString(string: weightStr)
        if (newWeightStr == "") {
            stepperOutlet.value = 0
        } else {
            stepperOutlet.value = Double(newWeightStr)!
        }
    }

    func RemovePartOfString (string : String) -> String {
        let weightUpdated = string.replacingOccurrences(of: " kg", with: "", options: .regularExpression)
        return weightUpdated
    }
    
    @IBAction func WeightStepper(_ sender: UIStepper) {
        weightInput.text = String("\(sender.value) kg")
    }
    
    @IBAction func FinishExercise(_ sender: Any) {
        if(exerciseSwitchOutlet.isOn) {
            exerciseFinished = true
        } else {
            exerciseFinished = false
        }
    }
}
