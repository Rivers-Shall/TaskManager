//
//  CompletedTask.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/16.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation
import os.log

class CompletedTask : NSObject, NSCoding {

    var taskName : String
    var startTime : Date
    var endTime : Date
    
    init(taskName : String, startTime : Date, endTime : Date) {
        self.taskName = taskName
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func getIntervalLength() -> TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(taskName, forKey: CompletedTaskPropertyKey.taskName)
        coder.encode(startTime, forKey: CompletedTaskPropertyKey.startTime)
        coder.encode(endTime, forKey: CompletedTaskPropertyKey.endTime)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let taskName = coder.decodeObject(forKey: CompletedTaskPropertyKey.taskName) as? String else {
            os_log("Cannot load taskName for Completed Task")
            return nil
        }
        
        guard let startTime = coder.decodeObject(forKey: CompletedTaskPropertyKey.startTime) as? Date else {
            os_log("Cannot load startTime for Completed Task")
            return nil
        }
        
        guard let endTime = coder.decodeObject(forKey: CompletedTaskPropertyKey.endTime) as? Date else {
            os_log("Cannot load endTime for Completed Task")
            return nil
        }
        
        self.init(taskName: taskName, startTime : startTime, endTime : endTime)
    }
    
}
