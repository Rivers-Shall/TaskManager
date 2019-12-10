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
    func getProjects() -> [Project] {
        return projects
    }
    
    func getTasks(in project: Project) -> [Task] {
        return tasks.filter() { task in
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
    
    init() {
        tasks = [Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]), Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[0]),Task(name: "task2", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: projects[1])]
    }
}
