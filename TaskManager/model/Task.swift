//
//  Task.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Task : NSObject, NSCoding {

    static var validID = 0
    static func getID() -> Int {
        let ID = validID
        validID += 1
        return ID
    }
    
    var name : String
    var deadline : Date?
    var pomodoroDuration : TimeInterval?
    var timeUsed : TimeInterval
    var pomodoroUsed : Int
    var project : Project
    var id : Int
    var idColor : UIColor = UIColor.gray
    
    let userCalendar = Calendar.current
    
    // 返回列表任务格子中的描述文字
    func description() -> String {
        if let duration = self.pomodoroDuration {
            return Utility.durationString(for: duration)
        } else {
            return "Already devoted \(self.timeUsed / 3600) h"
        }
    }
    
    init(name : String, deadline : Date?, pomodoroDuration : TimeInterval?, project : Project) {
        self.name = name
        self.deadline = deadline
        self.pomodoroDuration = pomodoroDuration
        self.project = project
        self.timeUsed = 0
        self.pomodoroUsed = 0
        self.id = Task.getID()
    }
    
    init(name : String, deadline : Date?, pomodoroDuration : TimeInterval?, project : Project, timeUsed : TimeInterval,
         pomodoroUsed : Int, id : Int, idColor : UIColor) {
        self.name = name
        self.deadline = deadline
        self.pomodoroDuration = pomodoroDuration
        self.project = project
        self.timeUsed = timeUsed
        self.pomodoroUsed = pomodoroUsed
        self.id = id
        self.idColor = idColor
    }
    
    // MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: TaskPropertyKey.name)
        coder.encode(deadline, forKey: TaskPropertyKey.deadline)
        coder.encode(pomodoroDuration, forKey: TaskPropertyKey.pomodoroDuration)
        coder.encode(timeUsed, forKey: TaskPropertyKey.timeUsed)
        coder.encode(pomodoroUsed, forKey: TaskPropertyKey.pomodoroUsed)
        coder.encode(project, forKey: TaskPropertyKey.project)
        coder.encode(id, forKey: TaskPropertyKey.id)
        coder.encode(idColor, forKey: TaskPropertyKey.idColor)
    }
    
    required convenience init?(coder: NSCoder) {
        // everything is required
        guard let name = coder.decodeObject(forKey: TaskPropertyKey.name) as? String else {
            os_log("cannot decode name for task")
            return nil
        }
        
        guard let deadline = coder.decodeObject(forKey: TaskPropertyKey.deadline) as? Date? else {
            os_log("cannot decode deadline for task")
            return nil
        }
        
        guard let pomodoroDuration = coder.decodeObject(forKey: TaskPropertyKey.pomodoroDuration) as? TimeInterval? else {
            os_log("cannot decode pomodoroDuration for task")
            return nil
        }
        
        let timeUsed = coder.decodeDouble(forKey: TaskPropertyKey.timeUsed)
        
        let pomodoroUsed = coder.decodeInteger(forKey: TaskPropertyKey.pomodoroUsed)
        
        guard let project = coder.decodeObject(forKey: TaskPropertyKey.project) as? Project else {
            os_log("cannot decode project for task")
            return nil
        }
        
        let id = coder.decodeInteger(forKey: TaskPropertyKey.id)
        
        guard let idColor = coder.decodeObject(forKey: TaskPropertyKey.idColor) as? UIColor else {
            os_log("cannot decode idColor for task")
            return nil
        }
        
        self.init(name : name, deadline : deadline, pomodoroDuration : pomodoroDuration, project : project, timeUsed : timeUsed,
                  pomodoroUsed : pomodoroUsed, id : id, idColor : idColor)
    }
    
}
