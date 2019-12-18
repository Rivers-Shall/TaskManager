//
//  CurrentTaskModel.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/17.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation

class CurrentTaskModel {
    static let instance = CurrentTaskModel()
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let CurrentTaskArchiveURL = DocumentsDirectory.appendingPathComponent("CurrentTask")
    static let StartTimeArchiveURL = DocumentsDirectory.appendingPathComponent("StartTime")
    
    static let TestArchiveURL = DocumentsDirectory.appendingPathComponent("test")
    
    static func getInstance() -> CurrentTaskModel {
        return CurrentTaskModel.instance
    }
    
    var currentTask : Task?
    var startTime : Date?
    
    func start(task : Task) {
        loadCurrentTaskAndStartTime()
        if let currentTask = currentTask {
            if currentTask.id != task.id {
                fatalError()
            }
        } else {
            currentTask = task
            startTime = Date()
        }
        saveCurrentTaskAndStartTime()
    }
    
    func loadCurrentTaskAndStartTime() {
        do {
            let data = try Data(contentsOf: CurrentTaskModel.CurrentTaskArchiveURL)
            currentTask = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Task
            let data2 = try Data(contentsOf: CurrentTaskModel.StartTimeArchiveURL)
            startTime = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data2) as? Date
        } catch {
            print("No current task")
        }
    }
    
    func saveCurrentTaskAndStartTime() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: currentTask as Any, requiringSecureCoding: false)
            try data.write(to: CurrentTaskModel.CurrentTaskArchiveURL)
            let data2 = try NSKeyedArchiver.archivedData(withRootObject: startTime as Any, requiringSecureCoding: false)
            try data2.write(to: CurrentTaskModel.StartTimeArchiveURL)
        } catch {
            print("Cannot save to file: " + error.localizedDescription)
        }
    }
    
    func getCurrentTaskAndStartTime() -> (Task?, Date?) {
        loadCurrentTaskAndStartTime()
        if let currentTask = currentTask, let startTime = startTime,
            let pomodoroDuration = currentTask.pomodoroDuration {
            if Date().timeIntervalSince(startTime) >= pomodoroDuration {
                complete()
            }
        }
        saveCurrentTaskAndStartTime()
        return (currentTask, startTime)
    }
    
    func complete() {
        currentTask!.pomodoroUsed += 1
        var endTime = Date()
        if let pomodoroDuration = currentTask!.pomodoroDuration {
            currentTask!.timeUsed += pomodoroDuration
            endTime = startTime!.addingTimeInterval(pomodoroDuration)
        }
        TaskManagerModel.getInstance().addOrUpdate(task: currentTask!, in: currentTask!.project)
        ReportModel.getInstance().complete(task: currentTask!, from: startTime!, to: endTime)
        currentTask = nil
        startTime = nil
        saveCurrentTaskAndStartTime()
    }
}
