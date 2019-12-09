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
    typealias Project = String

    // MARK: Static Member
    static let instance : TaskManagerModel = TaskManagerModel()
    static let colors = [
        UIColor.lightGray,
        UIColor(red: CGFloat(1), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.5)),
        UIColor(red: CGFloat(0), green: CGFloat(1), blue: CGFloat(0), alpha: CGFloat(0.5)),
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
    private var projects = ["Stand Alone", "iOS APP"]
    private var tasks = [Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"), Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task1", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "Stand Alone"),Task(name: "task2", deadline: Date(), pomodoroDuration: TimeInterval(5 * 60), project: "iOS APP")]
    
    // MARK: Instance Method
    func getProjects() -> [Project] {
        return projects
    }
    
    func getTasks(in project: Project) -> [Task] {
        return tasks.filter() { task in
            task.project == project
        }
    }
    
    func addOrUpdate(task : Task, in project : Project) {
        let taskIndex = tasks.firstIndex { taskInList in
            taskInList.id == task.id
        }

        if let taskIndex = taskIndex { // update
            if tasks[taskIndex].project != project {
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
    
    func add(project : Project) {
        projects.append(project)
    }
    
    func getTask(_ taskIndex : Int, in projectIndex : Int) -> Task {
        return getTasks(in: getProjects()[projectIndex])[taskIndex]
    }
}
