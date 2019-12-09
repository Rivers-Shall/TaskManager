//
//  Project.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/9.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation

struct Project {
    var id : Int
    var name : String
    var defaultPomodoroDuration : TimeInterval?
    
    static var validID = 0
    static func getID() -> Int {
        let ID = validID
        validID += 1
        return ID
    }
    
    init(name : String, defaultPomodoroDuration : TimeInterval?) {
        self.name = name
        self.defaultPomodoroDuration = defaultPomodoroDuration
        self.id = Project.getID()
    }
}
