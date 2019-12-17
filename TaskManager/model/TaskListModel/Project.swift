//
//  Project.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/9.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation
import os.log

class Project : NSObject, NSCoding {

    var id : Int
    var name : String
    var defaultPomodoroDuration : TimeInterval?
    var defaultDeadline : Date
    
    static var validID = 0
    static func getID() -> Int {
        let ID = validID
        validID += 1
        return ID
    }
    
    init(name : String, defaultPomodoroDuration : TimeInterval?, defaultDeadline : Date) {
        self.name = name
        self.defaultPomodoroDuration = defaultPomodoroDuration
        self.defaultDeadline = defaultDeadline
        self.id = Project.getID()
    }
    
    init(id : Int, name : String, defaultPomodoroDuration : TimeInterval?, defaultDeadline : Date) {
        self.name = name
        self.defaultPomodoroDuration = defaultPomodoroDuration
        self.defaultDeadline = defaultDeadline
        self.id = id
    }
    
    // MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: ProjectPropertyKey.id)
        coder.encode(name, forKey: ProjectPropertyKey.name)
        coder.encode(defaultDeadline, forKey: ProjectPropertyKey.defaultDeadline)
        coder.encode(defaultPomodoroDuration, forKey: ProjectPropertyKey.defaultPomodoroDuration)
    }
    
    required convenience init?(coder: NSCoder) {
        // every thing is required
        let id = coder.decodeInteger(forKey: ProjectPropertyKey.id)
        
        guard let name = coder.decodeObject(forKey: ProjectPropertyKey.name) as? String else {
            os_log("Cannot decode name for project")
            return nil
        }
        
        guard let defaultPomodoroDuration = coder.decodeObject(forKey: ProjectPropertyKey.defaultPomodoroDuration)
            as? TimeInterval?  else {
            os_log("Cannot decode defaultPomodoroDuration for project")
            return nil
        }
        
        guard let defaultDeadline = coder.decodeObject(forKey: ProjectPropertyKey.defaultDeadline) as? Date else {
            os_log("Cannot decode defaultDeadline for project")
            return nil
        }
        
        self.init(id: id, name: name, defaultPomodoroDuration: defaultPomodoroDuration, defaultDeadline: defaultDeadline)
    }
    
}
