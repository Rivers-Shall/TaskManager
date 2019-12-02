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
    var model : TaskManagerModel = TaskManagerModel.getInstance()
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
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
    
    fileprivate func load(_ task: Task) {
        // load data
        taskNameTextField.text = task.name
        projectPickerLabel.text = task.project
        deadlineLabel.text = Utility.dateString(from: task.deadline)
        pomodoroDurationLabel.text = Utility.durationString(for: task.pomodoroDuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let task = task {
            load(task)
        } else {
            task = Task(name: "", deadline: nil, pomodoroDuration: nil, project: "Stand Alone")
            load(task!)
        }
        updateSaveButtonState()
        
        // delegate assignment
        deadlinePicker.isHidden = true
        deadlinePicker.delegate = self
        deadlinePicker.dataSource = self
        
        pomodoroDurationPicker.isHidden = true
        pomodoroDurationPicker.delegate = self
        pomodoroDurationPicker.dataSource = self
        
        projectPicker.isHidden = true
        projectPicker.delegate = self
        projectPicker.dataSource = self
        
        taskNameTextField.delegate = self
    }

    @IBAction func deadlineTapped(_ sender: UITapGestureRecognizer) {
        toggle(picker: deadlinePicker)
        hide(picker: projectPicker)
        hide(picker: pomodoroDurationPicker)
    }
    
    @IBAction func durationTapped(_ sender: UITapGestureRecognizer) {
        toggle(picker: pomodoroDurationPicker)
        hide(picker: projectPicker)
        hide(picker: deadlinePicker)
    }
    
    @IBAction func projectTapped(_ sender: UITapGestureRecognizer) {
        toggle(picker: projectPicker)
        hide(picker: pomodoroDurationPicker)
        hide(picker: deadlinePicker)
    }
    
    @IBAction func sceneTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.projectPicker.isHidden = true
            self.deadlinePicker.isHidden = true
            self.pomodoroDurationPicker.isHidden = true
        }
    }
    
    private func toggle(picker : UIPickerView) {
        UIView.animate(withDuration: 0.3) {
            picker.isHidden = !picker.isHidden
        }
    }
    
    private func hide(picker : UIPickerView) {
        if !picker.isHidden {
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                picker.isHidden = true
            }, completion: nil)
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
        } else if (pickerView == projectPicker) {
            return 1
        }
        fatalError("Unkown UIPickerView")
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == deadlinePicker) {
            return deadlineDateNum
        } else if (pickerView == pomodoroDurationPicker) {
            return durationNum
        } else if (pickerView == projectPicker) {
            return model.getProjects().count
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
                let deadline = Date() + TimeInterval((row - 1) * 24 * 3600)
                return Utility.dateString(from : deadline)
            }
        } else if (pickerView == pomodoroDurationPicker) {
            switch row {
            case 0:
                return "Count Up"
            case 1:
                return "No Time Devoted"
            default:
                return "\((row - 1) * 5) min"
            }
        } else if (pickerView == projectPicker) {
            return model.getProjects()[row]
        }
        fatalError("Unkown UIPickerView")
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (picker == deadlinePicker) {
            deadlineLabel.text = pickerView(picker, titleForRow: row, forComponent: 0)
            task?.deadline = Date() + TimeInterval(24 * 3600 * (row - 1))
        } else if (picker == pomodoroDurationPicker) {
            pomodoroDurationLabel.text = pickerView(picker, titleForRow: row, forComponent: 0)
            if row == 0 {
                task?.pomodoroDuration = nil
            } else {
                task?.pomodoroDuration = TimeInterval((row - 1) * 5 * 60)
            }
        } else if (picker == projectPicker) {
            projectPickerLabel.text = pickerView(picker, titleForRow: row, forComponent: 0)
            task?.project = projectPickerLabel.text!
        }
    }
}


extension TaskViewController : UITextFieldDelegate {
    
    fileprivate func updateSaveButtonState() {
        saveButton.isEnabled = !(taskNameTextField.text ?? "").isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskNameTextField.resignFirstResponder()
        return false
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        updateSaveButtonState()
        task?.name = taskNameTextField.text ?? ""
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        saveButton.isEnabled = false
        return true
    }
}
