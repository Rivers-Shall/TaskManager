//
//  Task.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation
import UIKit

struct Task {
    
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
}
