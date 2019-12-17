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
           // if let currentTask = currentTask, let startTime = startTime {
                let data = try NSKeyedArchiver.archivedData(withRootObject: currentTask, requiringSecureCoding: false)
                try data.write(to: CurrentTaskModel.CurrentTaskArchiveURL)
                let data2 = try NSKeyedArchiver.archivedData(withRootObject: startTime, requiringSecureCoding: false)
                try data2.write(to: CurrentTaskModel.StartTimeArchiveURL)
                
                let encoder = NSKeyedArchiver(requiringSecureCoding: false)
                encoder.encode(currentTask, forKey: CurrentTaskModelPropertyKey.currentTask)
                encoder.encode(startTime, forKey: CurrentTaskModelPropertyKey.startTime)
                try encoder.encodedData.write(to: CurrentTaskModel.TestArchiveURL)
           // }
        } catch {
            print("Cannot save to file: " + error.localizedDescription)
        }
        
        do {
            let data = try Data(contentsOf: CurrentTaskModel.CurrentTaskArchiveURL)
            let currentTask = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Task
            let data2 = try Data(contentsOf: CurrentTaskModel.StartTimeArchiveURL)
            let startTime = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data2) as? Date
            print("\(currentTask) \(startTime)")
            
            let testData = try Data(contentsOf: CurrentTaskModel.TestArchiveURL)
            let decoder = try NSKeyedUnarchiver(forReadingFrom: testData)
            let currentTask2 = decoder.decodeObject(forKey: CurrentTaskModelPropertyKey.currentTask)
            let startTime2 = decoder.decodeObject(forKey: CurrentTaskModelPropertyKey.startTime)
            print("2: \(currentTask2) \(startTime2)")
        } catch {
            print("No current task")
        }
    }
    
    func getCurrentTaskAndStartTime() -> (Task?, Date?) {
        loadCurrentTaskAndStartTime()
        if let currentTask = currentTask, let startTime = startTime {
            if Date().timeIntervalSince(startTime) >= currentTask.pomodoroDuration! {
                self.currentTask = nil
                self.startTime = nil
            }
        }
        saveCurrentTaskAndStartTime()
        return (currentTask, startTime)
    }
    
    func complete() {
        currentTask = nil
        startTime = nil
        saveCurrentTaskAndStartTime()
    }
}
