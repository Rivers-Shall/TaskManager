//
//  ProjectViewController.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/9.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {

    var project : Project?
    var toggleViews = [UIView]()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var projectNameTextField: UITextField!
    // MARK: PomodoroDurationPicker Properties
    @IBOutlet weak var pomodoroDurationPicker: UIPickerView!
    @IBOutlet weak var pomodoroDurationLabel: UILabel!
    private let durationNum = 1 + 90 / 5 // 1 for counting up and others for counting down less than 90 minutes
    
    // MARK: DeadlinePicker Properties
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var deadlinePicker: UIPickerView!
    private let deadlineDateNum = 100_000
    private let userCalendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 新建项目或者加载传入的项目
        if project == nil {
            project = Project(name: "", defaultPomodoroDuration: nil, defaultDeadline: Date())
        }
        load(project!)
        
        // 改变save按钮状态
        updateSaveButtonState()
            
        // 初始化
        toggleViews += [pomodoroDurationPicker, deadlinePicker]
        
        // assign delegate
        pomodoroDurationPicker.delegate = self
        pomodoroDurationPicker.dataSource = self
        
        deadlinePicker.delegate = self
        deadlinePicker.dataSource = self
        
        projectNameTextField.delegate = self
    }
    
    private func load(_ project: Project) {
        pomodoroDurationLabel.text = Utility.durationString(for: project.defaultPomodoroDuration)
        deadlineLabel.text = Utility.dateString(from: project.defaultDeadline)
        projectNameTextField.text = project.name
        navigationItem.title = (project.name == "") ? "New Project" : project.name
    }
    

    @IBAction func pomodoroTapped(_ sender: UITapGestureRecognizer) {
        toggle(view: pomodoroDurationPicker)
        hide(except: pomodoroDurationPicker)
    }
    
    @IBAction func deadlineTapped(_ sender: Any) {
        toggle(view: deadlinePicker)
        hide(except: deadlinePicker)
    }
    
    // 两个private的动画方法，用于在隐藏和显示之间切换，
    private func toggle(view : UIView) {
        UIView.animate(withDuration: 0.3) {
            view.isHidden = !view.isHidden
        }
    }
    
    // 用于隐藏
    private func hide(except view : UIView) {
        for toggleView in toggleViews {
            if toggleView != view && !toggleView.isHidden {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    toggleView.isHidden = true
                }, completion: nil)
            }
        }
    }
    

    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelAddNewProject(_ sender: UIBarButtonItem) {
        let presentedAsAdd = presentingViewController is UINavigationController
        if presentedAsAdd {
            dismiss(animated: true, completion: nil)
        } else if let ownNavigationController = navigationController {
            ownNavigationController.popViewController(animated: true)
        } else {
            fatalError()
        }
    }
    
}

// MARK: UIPickerView Delegate
extension ProjectViewController : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pomodoroDurationPicker {
            return 1
        } else if pickerView == deadlinePicker {
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
        }
        fatalError("Unkown UIPickerView")
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (picker == deadlinePicker) {
            deadlineLabel.text = pickerView(picker, titleForRow: row, forComponent: 0)
            project?.defaultDeadline = Date() + TimeInterval(24 * 3600 * (row - 1))
        } else if (picker == pomodoroDurationPicker) {
            pomodoroDurationLabel.text = pickerView(picker, titleForRow: row, forComponent: 0)
            if row == 0 {
                project?.defaultPomodoroDuration = nil
            } else {
                project?.defaultPomodoroDuration = TimeInterval((row - 1) * 5 * 60)
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension ProjectViewController : UITextFieldDelegate {
    
    // 只有填写了名称，才可以保存
    fileprivate func updateSaveButtonState() {
        saveButton.isEnabled = !(projectNameTextField.text ?? "").isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameTextField.resignFirstResponder()
        return false
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        updateSaveButtonState()
        project?.name = projectNameTextField.text ?? ""
        navigationItem.title = project?.name == "" ? "New Project" : project?.name
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        saveButton.isEnabled = false
        return true
    }
}
