//
//  HomeMonitorTableViewCell.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-06-20.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit

class HomeMonitorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
