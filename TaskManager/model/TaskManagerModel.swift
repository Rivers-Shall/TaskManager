//
//  TaskManagerModel.swift
//  TaskManager
//
//  Created by 肖江 on 0.219/12/1.
//  Copyright © 0.219 rivers. All rights reserved.
//

import Foundation
import UIKit

class TaskManagerModel {

    // MARK: Static Member
    static let instance : TaskManagerModel = TaskManagerModel()
    static let colors = [
        UIColor.lightGray,
        UIColor(red: CGFloat(1), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(0), green: CGFloat(0.3), blue: CGFloat(0), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(1), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(1), green: CGFloat(0.2), blue: CGFloat(0.5), alpha: CGFloat(0.7)),
        UIColor(red: CGFloat(1), green: CGFloat(0.5), blue: CGFloat(0.5), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(1), green: CGFloat(0), blue: CGFloat(1), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(1), green: CGFloat(0.5), blue: CGFloat(0), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(1), green: CGFloat(0), blue: CGFloat(0.5), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(0.5), green: CGFloat(0), blue: CGFloat(1), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(0.5), green: CGFloat(0.2), blue: CGFloat(0.7), alpha: CGFloat(0.9)),
        UIColor(red: CGFloat(0.9), green: CGFloat(0.1), blue: CGFloat(0.3), alpha: CGFloat(0.9)),
    ]
    
    // MARK: Static Method
    static func getInstance() -> TaskManagerModel {
        return instance
    }

    // MARK: Instance Member
    private var projects = [
        Project(name: "Stand Alone", defaultPomodoroDuration: 25 * 60, defaultDeadline: Date()),
        Project(name: "iOS APP", defaultPomodoroDuration: 25 * 60, defaultDeadline: Date()) 
    ]
    
    private var tasks : [Task]
    
    // MARK: Instance Method
    
    // MARK: Projects and Tasks
    func getProjects() -> [Project] {
        return projects
    }
    
    func getTasks(in project: Project) -> [Task] {
        return tasks.filter() { task in
            task.project.id == project.id
        }
    }
    
    func getTasks(in projectIndex : Int) -> [Task] {
        let project = projects[projectIndex]
        return tasks.filter { (task) -> Bool in
            task.project.id == project.id
        }
    }
    
    func addOrUpdate(task : Task, in project : Project) {
        let taskIndex = tasks.firstIndex { taskInList in
            taskInList.id == task.id
        }

        if let taskIndex = taskIndex { // update
            if tasks[taskIndex].project.id != project.id {
                // 如果项目改变，那么就删除而后插入
                tasks.remove(at: taskIndex)
                tasks.insert(task, at: 0)
            } else {
                tasks[taskIndex] = task
            }
        } else { // add
            tasks.append(task)
        }
    }
    
    // 返回值为true代表是新加入，false代表更新
    func addOrUpdate(project : Project) -> Bool {
        let projectIndex = projects.firstIndex { (projectInList) -> Bool in
            projectInList.id == project.id
        }
        if let projectIndex = projectIndex { // update
            projects[projectIndex] = project
            return false
        } else { // add
            projects.append(project)
            return true
        }
    }
    
    func getTask(_ taskIndex : Int, in projectIndex : Int) -> Task {
        return getTasks(in: getProjects()[projectIndex])[taskIndex]
    }
    
    func getProject(name : String) -> Project? {
        let projectIndex = projects.firstIndex { (project) -> Bool in
            project.name == name
        }
        if let projectIndex = projectIndex {
            return projects[projectIndex]
        }
        return nil
    }
    
    func getProject(at index: Int) -> Project {
        return projects[index]
    }
    
    func delete(task taskIndex : Int, in projectIndex : Int) {
        let toDelete = getTask(taskIndex, in: projectIndex)
        tasks.removeAll { (taskInList) -> Bool in
            taskInList.id == toDelete.id
        }
    }
    
    func delete(projectAt projectIndex : Int) {
        let deletedProject = projects.remove(at: projectIndex)
        tasks.removeAll { (task) -> Bool in
            task.project.id == deletedProject.id
        }
    }
    
    func move(taskAt srcTaskIndex : Int, in srcProjectIndex : Int, intoNth destProjectIndex : Int, at destTaskIndex : Int) {
        var srcTask = getTask(srcTaskIndex, in: srcProjectIndex)
        let modelSrcTaskIndex = tasks.firstIndex { (taskInList) -> Bool in
            taskInList.id == srcTask.id
        }
        tasks.remove(at: modelSrcTaskIndex!)
        
        srcTask.project = getProject(at: destProjectIndex)
        
        var modelDestTaskIndex = tasks.count
        if destTaskIndex != getTasks(in: destProjectIndex).count {
            let destTask = getTask(destTaskIndex, in: destProjectIndex)
            modelDestTaskIndex = tasks.firstIndex { (taskInList) -> Bool in
                taskInList.id == destTask.id
            } ?? tasks.count
        }
        tasks.insert(srcTask, at: modelDestTaskIndex)
    }
    
    func move(projectAt srcProjectIndex : Int, to destProjectIndex : Int) {
        let projectToMove = projects.remove(at: srcProjectIndex)
        projects.insert(projectToMove, at: destProjectIndex)
    }
    
    // MARK: Deadlines and Tasks
    func getDeadlines() -> [Date] {
        var dateDeadlines =
            tasks.filter { (task) -> Bool in
                task.deadline != nil
            }.map { (task) -> Date in
                task.deadline!
            }
        dateDeadlines = dateDeadlines.map({ (date) -> Date in
            Utility.userCalendar.startOfDay(for: date)
            }).sorted()
        return Array(Set(dateDeadlines)).sorted()
    }
    
    func getTasksDead(at deadline : Date) -> [Task] {
        let deadline = Utility.userCalendar.startOfDay(for: deadline)
        return tasks.filter { (task) -> Bool in
            if let taskDeadline = task.deadline {
                return Utility.userCalendar.startOfDay(for: taskDeadline) == deadline
            } else {
                return false
            }
        }
    }
    
    init() {
        tasks = [
            Task(name: "列表右上角+新增项目", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "列表上方<->切换视图", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "列表左上角进入编辑模式", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "编辑模式可以删除项目或任务", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "编辑模式可以重排项目和任务", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "编辑模式快速在项目间移动任务", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "Start按钮开启番茄钟", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "task8", deadline: Date().addingTimeInterval(24 * 3600), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "task9", deadline: Date().addingTimeInterval(24 * 3600), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "task10", deadline: Date().addingTimeInterval(24 * 3600), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "task11", deadline: Date().addingTimeInterval(24 * 3600), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),
            Task(name: "task12", deadline: Date().addingTimeInterval(24 * 3600), pomodoroDuration: TimeInterval(5 * 60), project: projects[1])
        ]
    }
}
