//
//  CustomCellCollectionViewCell.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-29.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCellCollectionViewCell: JTAppleCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightAdded: UIView!
    @IBOutlet weak var selectedView: UIView!
    
    var weight = ""
    var fbKey = ""
    
}
