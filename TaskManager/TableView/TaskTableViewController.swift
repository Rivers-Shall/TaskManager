//
//  TaskTableViewController.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    typealias Project = String
    
    private let model = TaskManagerModel.getInstance()
    private var projectExpanded = [Int:Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        for projectIndex in 0..<model.getProjects().count {
            projectExpanded[projectIndex] = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sum = 0
        for (projectIndex, expanded) in projectExpanded {
            if expanded {
                sum += model.getTasks(in: model.getProjects()[projectIndex]).count
            }
        }
        sum += model.getProjects().count
        return sum
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (projectIndex, taskIndex) = projectAndTaskIndex(of: indexPath.row)
        if let taskIndex = taskIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell
            let project = model.getProjects()[projectIndex]
            let task = model.getTasks(in: project)[taskIndex]

            if let cell = cell {
                cell.taskNameLabel.text = task.name
                cell.backgroundColor = task.idColor
                if let duration = task.pomodoroDuration {
                    cell.taskDescriptionLabel.text = Utility.durationString(for: duration)
                } else {
                    cell.taskDescriptionLabel.text = "Already devoted \(task.timeUsed / 3600) h"
                }
            } else {
                fatalError("Unknown reusable cell")
            }

            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell
            let project = model.getProjects()[projectIndex]
            cell?.projectNameLabel.text = project
            cell?.projectExpandButton.setTitle(projectExpanded[projectIndex]! ? "V" : "<", for: .normal)
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    private func projectAndTaskIndex(of row : Int) -> (Int, Int?) {
        var projectIndex = 0
        var currentRow = 0
        while currentRow < row {
            if projectExpanded[projectIndex]! {
                if currentRow + model.getTasks(in: model.getProjects()[projectIndex]).count < row {
                    currentRow += model.getTasks(in: model.getProjects()[projectIndex]).count // for current task-cells
                    currentRow += 1 // for next project cell
                } else {
                    return (projectIndex, row - currentRow - 1)
                }
            } else {
                currentRow += 1
            }
            projectIndex += 1
        }
        return (projectIndex, nil)
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (projectIndex, _) = projectAndTaskIndex(of: indexPath.row)
        projectExpanded[projectIndex] = !projectExpanded[projectIndex]!
        
        let cell = tableView.cellForRow(at: indexPath) as? ProjectTableViewCell
        cell?.projectExpandButton.setTitle(projectExpanded[projectIndex]! ? "V" : "<", for: .normal)
        // 加载或者删除任务格子
        let tasksCount = model.getTasks(in: model.getProjects()[projectIndex]).count
        var indexPaths = [IndexPath]()
        for index in indexPath.row + 1...indexPath.row + tasksCount {
            indexPaths += [IndexPath(row: index, section: 0)]
        }
        if projectExpanded[projectIndex]! {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } else {
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
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
            let (projectIndex, taskIndex) = projectAndTaskIndex(of: indexPath.row)
            destTaskView.task = model.getTask(taskIndex!, in: projectIndex)
        case "StartTimer":
            guard let destTimerView = segue.destination as? TimerViewController else {
                fatalError("StartTimer not to TimerView")
            }
            guard let sender = sender as? UIButton else {
                fatalError("sender not Button")
            }
            guard let senderCell = sender.superview?.superview?.superview as? TaskTableViewCell else {
                fatalError("sender button not in TaskTableViewCell")
            }
            guard let indexPath = tableView.indexPath(for: senderCell) else {
                fatalError("sender cell ont in table")
            }
            let (projectIndex, taskIndex) = projectAndTaskIndex(of: indexPath.row)
            destTimerView.pomodoroTime = model.getTask(taskIndex!, in: projectIndex).pomodoroDuration ?? 0
        case "AddNewTask":
            guard let destTaskView = segue.destination as? TaskViewController else {
                fatalError("showDetail not to taskView")
            }
            guard let sender = sender as? UIButton else {
                fatalError("sender not Button")
            }
            guard let senderCell = sender.superview?.superview?.superview as? ProjectTableViewCell else {
                fatalError("sender button not in ProjectTableViewCell")
            }
            guard let indexPath = tableView.indexPath(for: senderCell) else {
                fatalError("sender cell ont in table")
            }
            let (projectIndex, _) = projectAndTaskIndex(of: indexPath.row)
            destTaskView.defaultProject = model.getProjects()[projectIndex]
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
    
    //MARK: Table Expand
    
    @IBAction func projectExpandButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview as? ProjectTableViewCell else {
            fatalError("Not a project cell")
        }
        guard let cellIndex = tableView.indexPath(for: cell) else {
            fatalError("Cell not in the table")
        }
        tableView(tableView, didSelectRowAt: cellIndex)
    }
    
}
