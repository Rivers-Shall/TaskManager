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
    var defaultProject = "Stand Alone"
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
    
    // MARK: ColorCollection Properties

    @IBOutlet weak var ColorCollectionView: UICollectionView!
    @IBOutlet weak var ColorLabel: UILabel!
    
    var toggleViews = [UIView]()
    
    fileprivate func load(_ task: Task) {
        // load data
        taskNameTextField.text = task.name
        projectPickerLabel.text = task.project
        deadlineLabel.text = Utility.dateString(from: task.deadline)
        pomodoroDurationLabel.text = Utility.durationString(for: task.pomodoroDuration)
        ColorLabel.backgroundColor = task.idColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let task = task {
            load(task)
        } else {
            task = Task(name: "", deadline: nil, pomodoroDuration: nil, project: defaultProject)
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
        
        ColorCollectionView.delegate = self
        ColorCollectionView.dataSource = self
        
        toggleViews += [deadlinePicker, projectPicker, pomodoroDurationPicker, ColorCollectionView]
    }

    // 三个按钮，只要打开其中一个就会关闭其他两个
    @IBAction func deadlineTapped(_ sender: UITapGestureRecognizer) {
        toggle(picker: deadlinePicker)
        hide(except: deadlinePicker)
    }
    
    @IBAction func durationTapped(_ sender: UITapGestureRecognizer) {
        toggle(picker: pomodoroDurationPicker)
        hide(except: pomodoroDurationPicker)
    }
    
    @IBAction func projectTapped(_ sender: UITapGestureRecognizer) {
        toggle(picker: projectPicker)
        hide(except: projectPicker)
    }
    
    @IBAction func colorTapped(_ sender: UITapGestureRecognizer) {
        toggle(picker: ColorCollectionView)
        hide(except: ColorCollectionView)
    }
    
    // 两个private的动画方法，用于在隐藏和显示之间切换，
    private func toggle(picker : UIView) {
        UIView.animate(withDuration: 0.3) {
            picker.isHidden = !picker.isHidden
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
    
    // MARK: Navigation
    
    @IBAction func cancelAddNewTask(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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

// MARK: UITextFieldDelegate
extension TaskViewController : UITextFieldDelegate {
    
    // 只有填写了名称，才可以保存
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

extension TaskViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TaskManagerModel.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as? ColorCollectionViewCell
        cell?.backgroundColor = TaskManagerModel.colors[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
        ColorLabel.backgroundColor = cell?.backgroundColor
        task?.idColor = ColorLabel.backgroundColor! 
    }
}
