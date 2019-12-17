//
//  ReportViewController.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/16.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var timeDevotedLabel: UILabel!
    @IBOutlet weak var pomodoroDevoted: UILabel!
    @IBOutlet weak var todayReportTable: UITableView!
    
    let reportModel = ReportModel.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timeDevotedLabel.text = "\(String(format: "%.2f", reportModel.getTimeDevoted() / 3600))"
        pomodoroDevoted.text = "\(reportModel.getPomodoroDevoted())"
        
        // delegate assignment
        todayReportTable.delegate = self
        todayReportTable.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReportViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportModel.getCompletedTasks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayReportTableViewCell", for: indexPath) as? TodayReportTableViewCell
        
        let completedTask = reportModel.getCompletedTask(at: indexPath.row)
        
        cell?.taskNameLabel.text = completedTask.taskName
        cell?.taskIntervalLabel.text = Utility.intervalString(from: completedTask.startTime, to: completedTask.endTime)
        cell?.intervalLengthLabel.text = Utility.durationString(for: completedTask.getIntervalLength())
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
