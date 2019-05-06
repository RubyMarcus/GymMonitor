//
//  MonitorViewController.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-21.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import DropDown

class MonitorViewController: UIViewController {

    @IBOutlet weak var dropDown: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func MenuButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DropDownMenu(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = dropDown // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["MonthToDate", "QuarterToDate", "YearToDate"]
        dropDown.show()
        dropDown.bottomOffset = CGPoint(x: 0, y: 120)
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDown.setTitle(item, for: .normal)
        }
    }
}
