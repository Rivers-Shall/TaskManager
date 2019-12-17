//
//  TaskTableViewController.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var EditButtom: UIBarButtonItem!
    @IBOutlet weak var projectDeadlineViewButton: UIBarButtonItem!
    @IBOutlet weak var addProjectButtom: UIBarButtonItem!
    
    private let model = TaskManagerModel.getInstance()
    private let reportModel = ReportModel.getInstance()
    private var projectExpanded = [Bool]()
    private var projectView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        for _ in 0..<model.getProjects().count {
            projectExpanded.append(false)
        }
        EditButtom.title = tableView.isEditing ? "Done" : "Edit"
        projectDeadlineViewButton.title = "<->"
    }
    
    // MARK: Edit Buttom
    @IBAction func EditButtomTapped(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
        sender.title = tableView.isEditing ? "Done" : "Edit"
        if !tableView.isEditing {
            tableView.reloadData()
        }
    }
    
    // MARK: Project and Deadline View Exchange Buttom
    @IBAction func projectDeadlineButtomTapped(_ sender: Any) {
        projectView = !projectView
        // 在deadline的视图下
        // 禁止使用Edit和+按钮
        EditButtom.isEnabled = !EditButtom.isEnabled
        addProjectButtom.isEnabled = !addProjectButtom.isEnabled
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if projectView {
            return 1
        } else {
            return model.getDeadlines().count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if projectView {
            var sum = 0
            for (projectIndex, expanded) in projectExpanded.enumerated() {
                if expanded {
                    sum += model.getTasks(in: model.getProjects()[projectIndex]).count
                }
            }
            sum += model.getProjects().count
            return sum
        } else {
            return model.getTasksDead(at: model.getDeadlines()[section]).count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if projectView {
            let (projectIndex, taskIndex) = projectAndTaskIndex(of: indexPath.row)
            if let taskIndex = taskIndex {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell
                let project = model.getProjects()[projectIndex]
                let task = model.getTasks(in: project)[taskIndex]
                
                if let cell = cell {
                    cell.taskNameLabel.text = task.name
                    cell.backgroundColor = task.idColor
                    cell.taskDescriptionLabel.text = task.description()
                } else {
                    fatalError("Unknown reusable cell")
                }
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell
                let project = model.getProjects()[projectIndex]
                cell?.projectNameLabel.text = project.name
                cell?.projectExpandButton.setTitle(projectExpanded[projectIndex] ? "V" : "<", for: .normal)
                cell?.selectionStyle = .none
                return cell!
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell
            let task = model.getTasksDead(at: model.getDeadlines()[indexPath.section])[indexPath.row]
            if let cell = cell {
                cell.taskNameLabel.text = task.name
                cell.backgroundColor = task.idColor
                cell.taskDescriptionLabel.text = task.description()
                cell.isUserInteractionEnabled = true
            } else {
                fatalError("Unknown reusable cell")
            }
            
            return cell!
        }
    }
    
    private func projectAndTaskIndex(of row : Int) -> (Int, Int?) {
        var projectIndex = 0
        var currentRow = 0
        while currentRow < row {
            if projectExpanded[projectIndex] {
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !projectView {
            let deadline = model.getDeadlines()[section]
            return Utility.dateString(from: deadline)
        } else {
            return ""
        }
    }
    
    // MARK: Table Edit (Delete, Move)
    //TODO: Delete, drag and drop
    
    // Delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let (projectIndex, taskIndex) = projectAndTaskIndex(of: indexPath.row)
            if let taskIndex = taskIndex {
                // delete a task
                model.delete(task: taskIndex, in: projectIndex)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                // delete a project
                var indexPathsToDelete = [indexPath]
                if projectExpanded[projectIndex] {
                    // delete an expanded project
                    let taskCount = model.getTasks(in: projectIndex).count
                    for i in 1...taskCount {
                        indexPathsToDelete += [IndexPath(row: indexPath.row + i, section: 0)]
                    }
                }
                model.delete(projectAt: projectIndex)
                projectExpanded.remove(at: projectIndex)
                tableView.deleteRows(at: indexPathsToDelete, with: .automatic)
            }
        }
    }
    
    // move (drag and drop)
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let (_, taskIndex) = projectAndTaskIndex(of: indexPath.row)
        if projectExpanded.contains(true) && taskIndex == nil {
            // 如果有项目是处在展开状态，就不可以移动项目格
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let (srcProjectIndex, srcTaskIndex) = projectAndTaskIndex(of: sourceIndexPath.row)
        var (destProjectIndex, destTaskIndex) = projectAndTaskIndex(of: destinationIndexPath.row)
        
        if let srcTaskIndex = srcTaskIndex {
            // move a task cell
            if destProjectIndex <= srcProjectIndex && destTaskIndex == nil {
                // 其实是移动到了前一个项目的最后一个
                if destProjectIndex > 0 {
                    destProjectIndex = destProjectIndex - 1
                    destTaskIndex = model.getTasks(in: destProjectIndex).count
                } else {
                    // 第一个项目的前面，这是一个非法位置，默认放到第一个项目的第一个
                    destTaskIndex = 0
                }
            } else if destProjectIndex > srcProjectIndex {
                if destTaskIndex == nil {
                    destTaskIndex = 0
                } else {
                    destTaskIndex = destTaskIndex! + 1
                }
            }
            if !projectExpanded[destProjectIndex] {
                projectExpanded[destProjectIndex] = true
            }
            model.move(taskAt: srcTaskIndex, in: srcProjectIndex, intoNth: destProjectIndex, at: destTaskIndex!)
        } else {
            // 移动项目格
            let toMove = projectExpanded.remove(at: srcProjectIndex)
            projectExpanded.insert(toMove, at: destProjectIndex)
            model.move(projectAt: srcProjectIndex, to: destProjectIndex)
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.reloadData()
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "ShowTaskDetail":
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
        case "ShowProjectDetail":
            guard let destProjectView = segue.destination as? ProjectViewController else {
                fatalError("showDetail not to taskView")
            }
            guard let sender = sender as? ProjectTableViewCell else {
                fatalError("sender not TaskTableCell")
            }
            guard let indexPath = tableView.indexPath(for: sender) else {
                fatalError("sender cell not in Table")
            }
            let (projectIndex, taskIndex) = projectAndTaskIndex(of: indexPath.row)
            if taskIndex != nil {
                fatalError("Not a project cell")
            }
            destProjectView.project = model.getProject(at: projectIndex)
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
            destTimerView.task = model.getTask(taskIndex!, in: projectIndex)
            destTimerView.pomodoroTime = model.getTask(taskIndex!, in: projectIndex).pomodoroDuration ?? 0
            destTimerView.countUp = model.getTask(taskIndex!, in: projectIndex).pomodoroDuration == nil
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
        case "AddNewProject":
            break
        default:
            fatalError("Unknown segue")
        }
    }
    
    // MARK: Other view unwind to list
    @IBAction func unwindToTaskTable(_ sender : UIStoryboardSegue) {
        if let taskController = sender.source as? TaskViewController, let newTask = taskController.task {
            if let _ = tableView.indexPathForSelectedRow {
                model.addOrUpdate(task: newTask, in: newTask.project)
                tableView.reloadData()
            } else {
                model.addOrUpdate(task: newTask, in: newTask.project)
                tableView.reloadData()
            }
        } else if let timerController = sender.source as? TimerViewController, let newTask = timerController.task {
            model.addOrUpdate(task : newTask, in: newTask.project)
            reportModel.complete(task: newTask, from: timerController.startTime!, to: timerController.endTime!)
        } else {
            fatalError()
        }
    }
    
    @IBAction func fromProjectViewToTaskList(_ sender : UIStoryboardSegue) {
        if let projectController = sender.source as? ProjectViewController, let newProject = projectController.project {
            let add = model.addOrUpdate(project: newProject)
            if add {
                projectExpanded.append(false)
            }
            tableView.reloadData()
        } else {
            fatalError("Error from ProjectView to TaskTableView")
        }
    }
    
    //MARK: Table Expand
    
    @IBAction func projectExpandButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview as? ProjectTableViewCell else {
            fatalError("Not a project cell")
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            fatalError("Cell not in the table")
        }
        let (projectIndex, taskIndex) = projectAndTaskIndex(of: indexPath.row)
        if taskIndex == nil {
            projectExpanded[projectIndex] = !projectExpanded[projectIndex]
            
            let cell = tableView.cellForRow(at: indexPath) as? ProjectTableViewCell
            cell?.projectExpandButton.setTitle(projectExpanded[projectIndex] ? "V" : "<", for: .normal)
            // 加载或者删除任务格子
            let tasksCount = model.getTasks(in: model.getProjects()[projectIndex]).count
            var indexPaths = [IndexPath]()
            if tasksCount > 0 {
                for index in indexPath.row + 1...indexPath.row + tasksCount {
                    indexPaths += [IndexPath(row: index, section: 0)]
                }
                if projectExpanded[projectIndex] {
                    tableView.insertRows(at: indexPaths, with: .automatic)
                } else {
                    tableView.deleteRows(at: indexPaths, with: .automatic)
                }
            }
        }
    }
    
}
