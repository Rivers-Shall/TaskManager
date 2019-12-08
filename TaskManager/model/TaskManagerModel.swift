//
//  TaskManagerModel.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation


class TaskManagerModel {
    typealias Project = String

    // MARK: Static Member
    static let instance : TaskManagerModel = TaskManagerModel()
    
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
            tasks[taskIndex] = task
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
