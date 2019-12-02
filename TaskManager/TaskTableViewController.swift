//
//  TaskTableViewController.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    private let model = TaskManagerModel.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.getProjects().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let project = model.getProjects()[section]
        return model.getTasks(in: project).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell
        let project = model.getProjects()[indexPath.section]
        let task = model.getTasks(in: project)[indexPath.row]

        if let cell = cell {
            cell.taskNameLabel.text = task.name
            if let duration = task.pomodoroDuration {
                cell.taskDescriptionLabel.text = Utility.durationString(for: duration)
            } else {
                cell.taskDescriptionLabel.text = "Already devoted \(task.timeUsed / 3600) h"
            }
        } else {
            fatalError("Unknown reusable cell")
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.getProjects()[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "ShowDetail":
            guard let destTaskView = segue.destination as? TaskViewController else {
                fatalError("showDetail not to taskView")
            }
            guard let sender = sender as? TaskTableViewCell else {
                fatalError("sender not TaskTableCell")
            }
            guard let indexPath = tableView.indexPath(for: sender) else {
                fatalError("sender cell not in Table")
            }
            destTaskView.task = model.getTask(in: indexPath)
        case "StartTimer":
            guard let destTimerView = segue.destination as? TimerViewController else {
                fatalError("StartTimer not to TimerView")
            }
            guard let sender = sender as? UIButton else {
                fatalError("sender not Button")
            }
            guard let senderCell = sender.superview?.superview?.superview as? TaskTableViewCell else {
                fatalError("sender button not in Cell")
            }
            guard let indexPath = tableView.indexPath(for: senderCell) else {
                fatalError("sender cell ont in table")
            }
            destTimerView.pomodoroTime = model.getTask(in: indexPath).pomodoroDuration ?? 0
        case "AddTask":
            break
        default:
            fatalError("Unknown segue")
        }
    }
    
    @IBAction func unwindToTaskTable(_ sender : UIStoryboardSegue) {
        if let taskController = sender.source as? TaskViewController, let newTask = taskController.task {
            if let selectedPath = tableView.indexPathForSelectedRow {
                model.addOrUpdate(task: newTask, in: newTask.project)
                tableView.reloadRows(at: [selectedPath], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: model.getTasks(in: newTask.project).count, section: model.getProjects().firstIndex(of: newTask.project) ?? 0)
                model.addOrUpdate(task: newTask, in: newTask.project)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }

}
