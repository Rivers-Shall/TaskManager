//
//  Utility.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation

class Utility {
    static let userCalendar = Calendar.current
    
    static func dateComponents(from date : Date) -> DateComponents {
        return userCalendar.dateComponents([.year, .month, .day, .weekday], from: date)
    }
    
    static func dateString(from date : Date?) -> String {
        if let date = date {
            let dc = dateComponents(from: date)
            let today = dateComponents(from: Date())
            if today.year == dc.year {
                if userCalendar.isDateInToday(date) {
                    return "Today"
                } else if userCalendar.isDateInTomorrow(date) {
                    return "Tomorrow"
                }
                return "\(userCalendar.shortWeekdaySymbols[dc.weekday! - 1]), \(dc.day!) \(userCalendar.monthSymbols[dc.month! - 1])"
            } else {
                return "\(userCalendar.shortWeekdaySymbols[dc.weekday! - 1]), \(dc.day!) \(userCalendar.monthSymbols[dc.month! - 1]) \(dc.year!)"
            }
        } else {
            return "No Deadline"
        }
    }
    
    static func durationString(for duration : TimeInterval?) -> String {
        if let duration = duration {
            if (duration == 0) {
                return "No pomodoro"
            } else {
                return "\(Int(duration) / 60) min"
            }
        } else {
            return "Count Up"
        }
    }
    
    private init() {
        
    }
}
