//
//  BodyWeightViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-21.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftSpinner

class BodyWeightViewController: UIViewController, UIBarPositioningDelegate, UITextFieldDelegate {

    //
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var inputWeight: UITextField!
    
    //buttons
    @IBOutlet weak var editWeightBtn: UIButton!
    @IBOutlet weak var saveWeightBtn: UIButton!
    @IBOutlet weak var addWeightBtn: UIButton!
    
    var CalendarBodyWeight = CalendarWeightItem()
    let temp = CalendarWeightItem()
    let formatter = DateFormatter()
    
    // Calendar Variables
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x9B9A9C)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedVieColor = UIColor(colorWithHexValue: 0x4e3f5d )
    let selectedDateColor = UIColor(colorWithHexValue: 0x9F202D)
    let todaysDate = Date()
    
    // Kg correction
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
        inputWeight.delegate = self
        
        DownloadWeightData()
        
        self.inputWeight.isUserInteractionEnabled = false
        self.setupCalendarView()
        self.selectedDateLabel.text = "Select date"
        // Do any additional setup after loading the view.
    }
    
    //MARK: Button actions
    @IBAction func EditWeightFunc(_ sender: Any) {
        editModeOn()
    }
    
    @IBAction func SaveWeightFunc(_ sender: Any) {
        SaveWeightData()
        editModeOff()
    }
    
    @IBAction func AddWeight(_ sender: Any) {
        SaveWeightData()
    }
    
    //MARK: Database functions
    func DownloadWeightData (){
        CalendarBodyWeight.LoadWeight(completion: {(result : Bool) in
            self.calendarView.scrollToDate(Date(), animateScroll: false)
            self.calendarView.deselectAllDates()
//            self.calendarView.reloadData()
        })
    }
    
    func SaveWeightData ()
    {
        guard let bodyWeight = inputWeight.text, !bodyWeight.isEmpty else {
            print("Bodyweight can´t be empty.")
            return
        }
        
        if (selectedDateLabel.text == "Select date") {
            return
        }
        
        temp.weight = RemoveKgFromString(string: bodyWeight)
        temp.date = RemoveDateFromString(string: selectedDateLabel.text!)
        
        CalendarBodyWeight.SaveWeight(item: temp, completion: {(result : Bool) in
            
            self.normalMode()
            self.DownloadWeightData()
        })
    }
    
    //MARK: Modes of edting and normal mode
    func editModeOn () {
        self.editWeightBtn.isHidden = true
        self.saveWeightBtn.isHidden = false
        self.inputWeight.isUserInteractionEnabled = true
        self.addWeightBtn.isHidden = true
    }
    
    func editModeOff () {
        self.editWeightBtn.isHidden = false
        self.saveWeightBtn.isHidden = true
        self.inputWeight.isUserInteractionEnabled = false
        self.addWeightBtn.isHidden = true
    }
    
    func normalMode () {
        self.inputWeight.text = ""
        self.amount = 0
        
        self.editWeightBtn.isHidden = true
        self.saveWeightBtn.isHidden = true
        self.inputWeight.isUserInteractionEnabled = true
        self.addWeightBtn.isHidden = false
    }
    
    //MARK: Remove parts of string
    func RemoveDateFromString (string : String) -> String {
        let weightUpdated = string.replacingOccurrences(of: "Selected date: ", with: "", options: .regularExpression)
        return weightUpdated
    }
    
    func RemoveKgFromString (string : String) -> String {
        let weightUpdated = string.replacingOccurrences(of: " kg", with: "", options: .regularExpression)
        return weightUpdated
    }
    
    //MARK: Calendar Functions
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func setupCalendarView () {
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup Labels
        calendarView.visibleDates{ (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    // Configure cells
    func configureCell (cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCellCollectionViewCell else { return }
        
        handleCelltextColour(cell: validCell, cellState: cellState)
        handleCellSelection(cell: validCell, cellState: cellState)
        handleCellVisibility(cell: validCell, cellState: cellState)
        handleWeightView(cell: validCell, cellState: cellState)
    }
    
    func handleCellVisibility (cell: CustomCellCollectionViewCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.isUserInteractionEnabled = true
        } else {
            cell.dateLabel.textColor = UIColor.gray
            cell.isUserInteractionEnabled = false
        }
    }
    
    func handleWeightView (cell: CustomCellCollectionViewCell, cellState: CellState) {
        formatter.dateFormat = "yyyy MM dd"
        
        if CalendarBodyWeight.item != nil
        {
            for weight in CalendarBodyWeight.item! {
                let savedDate = formatter.date(from: weight.date)
                
                if (savedDate == cellState.date) {
                    cell.weightAdded.isHidden = false
                    cell.weight = weight.weight
                    cell.fbKey = weight.fbKey
                    return
                } else {
                    cell.weightAdded.isHidden = true
                }
            }
        }
    }
    
    func handleCelltextColour (cell: CustomCellCollectionViewCell, cellState: CellState) {
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        if todaysDateString == monthDateString
        {
            cell.dateLabel.textColor = UIColor.blue
        } else {
            cell.dateLabel.textColor = cellState.isSelected ? selectedDateColor : UIColor.white
        }
    }
    
    func handleCellSelection (cell: CustomCellCollectionViewCell, cellState: CellState) {
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        cell.selectedView.isHidden = cellState.isSelected ? false : true
        if(cellState.isSelected) {
            guard monthDateString <= todaysDateString  else {
                cell.selectedView.isHidden = true
                
                normalMode()
                self.inputWeight.isUserInteractionEnabled = false
                self.selectedDateLabel.text = "Select date"
                
                return
            }
            
            let selectedDate = formatter.string(from: cellState.date)
            selectedDateLabel.text = "Selected date: " + selectedDate
            
            if(cell.weightAdded.isHidden) {
                normalMode()
                temp.fbKey = ""
            } else {
                editModeOff()
                
                inputWeight.text = cell.weight + " kg"
                temp.fbKey = cell.fbKey
            }
        }
    }
    
    func setupViewsOfCalendar (from visibleDate: DateSegmentInfo) {
        let date = visibleDate.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = self.formatter.string(from: date)
    }
    
    @IBAction func MenuButton(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
}

extension BodyWeightViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: Date())
        return parameters
    }
}

extension BodyWeightViewController: JTAppleCalendarViewDelegate {
    //Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCellCollectionViewCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        cell.dateLabel.text = cellState.text
        
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension BodyWeightViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (amount >= 2000) {
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


