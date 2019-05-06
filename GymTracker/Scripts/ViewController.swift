//
//  ViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-04-17.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DropDown

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource {

    @IBOutlet var ProgressView: UIView!
    @IBOutlet var dropDownButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addWeightButton: UIButton!
    @IBOutlet weak var montorTableView: UITableView!
    @IBOutlet weak var noWorkoutsAvailableLabel: UILabel!
    
    let dropDown = DropDown()
    let tempWorkouts = WorkoutItem()
    let tempCalendar = CalendarWeightItem()
    var currentSelectedRowInt = 0
    let formatter = DateFormatter()
    let tempFinishedWorkouts = FinishedWorkout()
    
    fileprivate let digits: Set<String> = ["0","1","2","3","4","5","6","7","8","9"]
    fileprivate let decimalPlaces = 1
    fileprivate let suffix = " kg"
    fileprivate lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = self.decimalPlaces
        formatter.maximumFractionDigits = self.decimalPlaces
        formatter.locale = NSLocale.current
        return formatter
    }()
    fileprivate var amount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Tangentbordet förvinner vid klickande på skärmen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser == nil)
        {
            print("Not logged in")
            performSegue(withIdentifier: "login", sender: nil)
        } else {
            print("INLOGGAD")
            print(Auth.auth().currentUser?.uid)
            self.navigationItem.title = Auth.auth().currentUser?.uid
            
            tempWorkouts.LoadWorkout(completion: {(result : Bool) in
                self.pickerView.reloadAllComponents()
                let listCount = self.tempWorkouts.item!.count
                self.pickerView.selectRow(listCount / 2, inComponent: 0, animated: false)
                self.currentSelectedRowInt = listCount / 2
            })
            
            self.weightTextField.isUserInteractionEnabled = true
            self.addWeightButton.isUserInteractionEnabled = true
            
            formatter.dateFormat = "yyyy MM dd"
            self.dateLabel.text = "Today: " + formatter.string(from: Date())
            
            tempCalendar.LoadWeight(completion: {(result : Bool) in
                for date in self.tempCalendar.item! {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy MM dd"
                    let currentDate = formatter.string(from: Date())
                    if (date.date == currentDate) { // Already added weight
                        print("Test: Working")
                        self.weightTextField.isUserInteractionEnabled = false
                        self.weightTextField.text = "Added"
                        self.addWeightButton.isUserInteractionEnabled = false
                    }
                }
                self.dropDown.dataSource = ["MonthToDate", "QuarterToDate", "YearToDate"]
                self.dropDown.selectRow(at: 0)
                self.montorTableView.reloadData()
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "homemonitor") as! HomeMonitorTableViewCell
        formatter.dateFormat = "yyyy MM dd"
        
        let currentDateString = formatter.string(from: Date())
        let currentDate = formatter.date(from: currentDateString)
        
        switch dropDown.selectedItem {
        case "MonthToDate":
            // 1 month back
            let fromMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            let newFormatString = formatter.string(from: fromMonthDate!)
            let absoluteMonthDate = formatter.date(from: newFormatString)
            let weightDifference = GetBodyWeightDiffernce(startDate: absoluteMonthDate!, EndDate: currentDate!)
            
            cell.nameLabel.text = "Body weight"
            cell.weightLabel.text = weightDifference + " kg"
            
            if (Double(weightDifference)! >= 0) {
                cell.weightLabel.textColor = UIColor.green
            } else {
                cell.weightLabel.textColor = UIColor.red
            }
        case "QuarterToDate":
            // 3 months back
            let fromMonthDate = Calendar.current.date(byAdding: .month, value: -3, to: Date())
            let newFormatString = formatter.string(from: fromMonthDate!)
            let absoluteMonthDate = formatter.date(from: newFormatString)
            let weightDifference = GetBodyWeightDiffernce(startDate: absoluteMonthDate!, EndDate: currentDate!)
            
            cell.nameLabel.text = "Body Weight"
            cell.weightLabel.text = weightDifference + " kg"
            
            if (Double(weightDifference)! >= 0) {
                cell.weightLabel.textColor = UIColor.green
            } else {
                cell.weightLabel.textColor = UIColor.red
            }
        case "YearToDate":
            // 1 year back
            let fromMonthDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
            let newFormatString = formatter.string(from: fromMonthDate!)
            let absoluteMonthDate = formatter.date(from: newFormatString)
            let weightDifference = GetBodyWeightDiffernce(startDate: absoluteMonthDate!, EndDate: currentDate!)
            
            cell.nameLabel.text = "Body Weight"
            cell.weightLabel.text = weightDifference + " kg"
            
            if (Double(weightDifference)! >= 0) {
                cell.weightLabel.textColor = UIColor.green
            } else {
                cell.weightLabel.textColor = UIColor.red
            }
        default:
            break
        }
        return cell
    }
    
    func GetBodyWeightDiffernce (startDate : Date, EndDate : Date) -> String {
        var firstDate : Date?
        var lastDate : Date?
        var firstWeight : Double?
        var lastWeight : Double?
        formatter.dateFormat = "yyyy MM dd"
        
        for date in 0..<tempCalendar.item!.count {
            let weightDate = formatter.date(from: tempCalendar.item![date].date)
            if (weightDate! <= EndDate && weightDate! >= startDate) {
                if (firstWeight == nil) {
                    firstWeight = Double(tempCalendar.item![date].weight)!
                    firstDate = formatter.date(from: tempCalendar.item![date].date)!
                    print("First:" + String(firstWeight!))
                } else if (formatter.date(from: tempCalendar.item![date].date)! < firstDate!) {
                    firstWeight = Double(tempCalendar.item![date].weight)!
                }
                if (lastWeight == nil) {
                    lastWeight = Double(tempCalendar.item![date].weight)!
                    print("Last" + String(lastWeight!))
                    lastDate = formatter.date(from: tempCalendar.item![date].date)!
                } else if (formatter.date(from: tempCalendar.item![date].date)! >= lastDate!) {
                    lastDate = formatter.date(from: tempCalendar.item![date].date)
                    lastWeight = Double(tempCalendar.item![date].weight)!
                    print("Changed" + String(lastWeight!))
                }
            }
        }
        
        var newWeight : Double = 0.0
        if (lastWeight != nil && firstWeight != nil) {
            newWeight = lastWeight! - firstWeight!
        }
        return String(newWeight)
    }
    
    @IBAction func DropDownButton(_ sender: Any) {
        dropDown.anchorView = dropDownButton // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        dropDown.show()
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDownButton.setTitle(item, for: .normal)
            self.montorTableView.reloadData()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectedRowInt = Int("\(row)")!
        print(currentSelectedRowInt)
    }
    
    @IBAction func GoWorkoutButton(_ sender: Any) {
        if(tempWorkouts.item?.isEmpty == false) {
            performSegue(withIdentifier: "WorkingOut", sender: currentSelectedRowInt)
        } else {
            noWorkoutsAvailableLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "WorkingOut") {
            let dest = segue.destination as! WorkingOutViewController
            if(tempWorkouts.item?.isEmpty == false) {
                noWorkoutsAvailableLabel.isHidden = true
                dest.tempWorkoutitem = self.tempWorkouts.item![sender as! Int]
            } else {
                noWorkoutsAvailableLabel.isHidden = false
            }
        }
    }
    
    @IBAction func AddBodyWeightButton(_ sender: Any) {
        if(weightTextField.text == "") {
            return
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MM dd"
            let temp = CalendarWeightItem()
            temp.date = formatter.string(from: Date())
            temp.weight = RemovePartOfString(string: weightTextField.text!)
            tempCalendar.SaveWeight(item: temp, completion: {(result : Bool) in
                self.weightTextField.isUserInteractionEnabled = false
                self.weightTextField.text = "Added"
                self.addWeightButton.isUserInteractionEnabled = false
            })
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: ".SFUIText-Medium", size: 19) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = tempWorkouts.item![row].workoutName
        return pickerLabel
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (tempWorkouts.item?.isEmpty == true) {
            noWorkoutsAvailableLabel.isHidden = false
        }
        if let itemcount = tempWorkouts.item?.count {
            return itemcount
        }
        return 0
    }
    
    func RemovePartOfString (string : String) -> String {
        let weightUpdated = string.replacingOccurrences(of: " kg", with: "", options: .regularExpression)
        return weightUpdated
    }
}

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
}

extension ViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(amount)
        
        if (amount >= 1999) {
            
            amount = 0
            textField.text = ""
            
            return false
        }
        
        if digits.contains(string) {
            amount *= 10
            amount += Int(string)!
        } else if string == "" {
            amount /= 10
        }
        
        guard amount > 0 else {
            textField.text = ""
            return false
        }
        
        let digitsAfterDecimal = numberFormatter.maximumFractionDigits
        var value = Double(amount)
        for _ in 0..<digitsAfterDecimal {
            value /= 10
        }
        
        textField.text = numberFormatter.string(from: NSNumber(value: value))! + suffix
        
        return false
    }
}



