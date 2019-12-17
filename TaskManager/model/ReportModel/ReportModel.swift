//
//  ReportModel.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/16.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation

class ReportModel {
    static let instance = ReportModel()
    
    static func getInstance() -> ReportModel {
        return ReportModel.instance
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let CompletedTaskArchiveURL = DocumentsDirectory.appendingPathComponent("completedTasksToday")
    static let TotalDevotionArchiveURL = DocumentsDirectory.appendingPathComponent("totalDevotion")
    
    var todayCompletedTasks = [CompletedTask]()
    var timeDevoted : TimeInterval = 0
    var pomodoroDevoted : Int = 0
    
    func complete(task : Task, from startTime : Date, to endTime : Date) {
        let completedTask = CompletedTask(taskName: task.name, startTime: startTime, endTime: endTime)
        
        if (Utility.userCalendar.isDateInToday(startTime)) {
            todayCompletedTasks.append(completedTask)
        }
        
        timeDevoted += endTime.timeIntervalSince(startTime)
        pomodoroDevoted += 1
        
        saveCompletedTasks()
        saveTotalDevotion()
    }
    
    func getTimeDevoted() -> TimeInterval {
        return timeDevoted
    }
    
    func getPomodoroDevoted() -> Int {
        return pomodoroDevoted
    }
    
    func getCompletedTasks() -> [CompletedTask] {
        return todayCompletedTasks
    }
    
    func getCompletedTask(at index : Int) -> CompletedTask {
        return getCompletedTasks()[index]
    }
    
    func loadCompletedTasks() -> [CompletedTask] {
        do {
            let completedTaskData = try Data(contentsOf: ReportModel.CompletedTaskArchiveURL)
            var completedTasks = (try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(completedTaskData)) as?
                                [CompletedTask]
            completedTasks = completedTasks?.filter({ (completedTask) -> Bool in
                Utility.userCalendar.isDateInToday(completedTask.startTime)
            }) ?? [CompletedTask]()
            return completedTasks ?? [CompletedTask]()
        } catch {
            print("Cannot load completed Tasks")
            return [CompletedTask]()
        }
    }
    
    func loadTotalDevotion() {
        if let data = try? Data(contentsOf: ReportModel.TotalDevotionArchiveURL) {
            let decoder = try! NSKeyedUnarchiver(forReadingFrom: data)
            pomodoroDevoted = Int(decoder.decodeInt64(forKey: ReportModelPropertyKey.pomodoroDevoted))
            timeDevoted = decoder.decodeDouble(forKey: ReportModelPropertyKey.timeDevoted)
        }
    }
    
    func saveCompletedTasks() {
        let completedTasksData = try!
            NSKeyedArchiver.archivedData(withRootObject: todayCompletedTasks, requiringSecureCoding: false)
        
        do {
            try completedTasksData.write(to: ReportModel.CompletedTaskArchiveURL)
        } catch {
            print("Cannot write to file: " + error.localizedDescription)
        }
    }
    
    func saveTotalDevotion() {
        let coder = NSKeyedArchiver(requiringSecureCoding: false)
        coder.encode(Int64(pomodoroDevoted), forKey: ReportModelPropertyKey.pomodoroDevoted)
        coder.encode(timeDevoted, forKey: ReportModelPropertyKey.timeDevoted)
        do {
            try coder.encodedData.write(to: ReportModel.TotalDevotionArchiveURL)
        } catch {
            print("Cannot write to file: " + error.localizedDescription)
        }
    }
    
    init() {
        todayCompletedTasks = loadCompletedTasks()
        loadTotalDevotion()
        saveCompletedTasks()
    }
}
