//
//  TaskViewController.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/1.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    // MARK: Properties
    var task : Task?
    
    // MARK: ProjectPicker Properties
    @IBOutlet weak var projectPicker: UIPickerView!
    @IBOutlet weak var projectPickerLabel: UILabel!
    
    
    // MARK: DeadlinePicker Properties
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var deadlinePicker: UIPickerView!
    private let deadlineDateNum = 100_000
    private let userCalendar = Calendar.current
    
    // MARK: PomodoroDurationPicker Properties
    @IBOutlet weak var pomodoroDurationLabel: UILabel!
    @IBOutlet weak var pomodoroDurationPicker: UIPickerView!
    private let durationNum = 1 + 90 / 5 // 1 for counting up and others for counting down less than 90 minutes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        deadlinePicker.isHidden = true
        deadlinePicker.delegate = self
        deadlinePicker.dataSource = self
        
        pomodoroDurationPicker.delegate = self
        pomodoroDurationPicker.dataSource = self
    }

    @IBAction func deadlineTapped(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.deadlinePicker.isHidden = !self.deadlinePicker.isHidden
        }
    }
    
    @IBAction func durationTapped(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.pomodoroDurationPicker.isHidden = !self.pomodoroDurationPicker.isHidden
        }
    }
}

// MARK: UIPickerView Delegate
extension TaskViewController : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if (pickerView == deadlinePicker) {
            return 1
        } else if (pickerView == pomodoroDurationPicker) {
            return 1
        }
        fatalError("Unkown UIPickerView")
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == deadlinePicker) {
            return deadlineDateNum
        } else if (pickerView == pomodoroDurationPicker) {
            return durationNum
        }
        fatalError("Unkown UIPickerView")
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == deadlinePicker) {
            switch row {
            case 0:
                return "No Deadline"
            case 1:
                return "Today"
            case 2:
                return "Tomorrow"
            default:
                let today = Date()
                let deadline = today + TimeInterval((row - 1) * 24 * 3600)
                let todayDate = userCalendar.dateComponents([.year, .month, .day, .weekday], from: today)
                let deadlineDate = userCalendar.dateComponents([.year, .month, .day, .weekday], from: deadline)
                if (deadlineDate.year != todayDate.year) {
                    return "\(userCalendar.shortWeekdaySymbols[deadlineDate.weekday! - 1]), \(deadlineDate.day!) \(userCalendar.monthSymbols[deadlineDate.month! - 1]) \(deadlineDate.year!)"
                } else {
                    return "\(userCalendar.shortWeekdaySymbols[deadlineDate.weekday! - 1]), \(deadlineDate.day!) \(userCalendar.monthSymbols[deadlineDate.month! - 1])"
                }
            }
        } else if (pickerView == pomodoroDurationPicker) {
            switch row {
            case 0:
                return "Count Up"
            default:
                return "\(row * 5) min"
            }
        }
        fatalError("Unkown UIPickerView")
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (picker == deadlinePicker) {
            deadlineLabel.text = pickerView(picker, titleForRow: row, forComponent: 0)
        } else if (picker == pomodoroDurationPicker) {
            pomodoroDurationLabel.text = pickerView(picker, titleForRow: row, forComponent: 0)
        }
    }
}
