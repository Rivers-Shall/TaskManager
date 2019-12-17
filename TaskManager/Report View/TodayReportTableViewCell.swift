//
//  TodayReportTableViewCell.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/16.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class TodayReportTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskIntervalLabel: UILabel!
    @IBOutlet weak var intervalLengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
