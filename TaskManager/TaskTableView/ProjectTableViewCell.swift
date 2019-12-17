//
//  ProjectTableViewCell.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/8.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectExpandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
