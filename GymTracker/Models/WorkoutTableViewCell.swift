//
//  WorkoutTableViewCell.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-05-22.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet var workoutNameLabel: UILabel!
    @IBOutlet var workoutCell: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
