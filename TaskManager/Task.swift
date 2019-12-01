//
//  Task.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation

struct Task {
    typealias Project = String
    
    var name : String
    var deadline : Date
    var pomodoroDuration : TimeInterval?
    var timeUsed : TimeInterval
    var pomodoroUsed : Int
    var project : Project
    
    let userCalendar = Calendar.current
    
    init(name : String, deadline : Date, pomodoroDuration : TimeInterval?, project : Project) {
        self.name = name
        self.deadline = deadline
        self.pomodoroDuration = pomodoroDuration
        self.project = project
        self.timeUsed = 0
        self.pomodoroUsed = 0
    }
}
