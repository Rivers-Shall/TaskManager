//
//  TimerViewController.swift
//  TaskManager
//
//  Created by 肖江 on 2019/12/2.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    var task : Task?
    var time : Int = 0
    var duration : Int = 0
    var timer : Timer?
    var pomodoroTime : TimeInterval {
        get {
            return TimeInterval(time)
        }
        set (newValue) {
            time = Int(newValue)
        }
    }
    var countUp = false
    var startTime : Date?
    var endTime : Date?
    var currentTaskModel = CurrentTaskModel.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTaskModel.start(task: task!)
        if let task = task {
            taskNameLabel.text = task.name
        }
        if startTime == nil {
            startTime = Date()
        } else {
            duration = Int(Date().timeIntervalSince(startTime!))
        }
        
        if !countUp && task!.pomodoroDuration! > 0 {
            prepareNotification()
        }
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            if !self.countUp {
                self.time = Int(self.task!.pomodoroDuration!) - self.duration
            } else {
                self.time = self.duration
            }
            self.duration = Int(Date().timeIntervalSince(self.startTime!))
            self.updateTimerLabel(Timer)
        }
        self.timer = timer
        timerLabel.text = "\(String(format: "%02d", time / 60)):\(String(format: "%02d", time % 60))"
        //timer.fire()
        
        // Do any additional setup after loading the view.
    }
    
    func updateTimerLabel(_ timer: Timer) {
        timerLabel.text = "\(String(format: "%02d", time / 60)):\(String(format: "%02d", time % 60))"
        if time < 0 {
            quit(timer)
        }
    }
    
    func quit(_ timer : Timer) {
        timer.invalidate()
        endTime = Date()
        currentTaskModel.complete()
        if time >= 0 {
            cancelNotification()
        }
        self.performSegue(withIdentifier: "unwindToTaskTable", sender: self)
    }

    @IBAction func quitButtonTapped(_ sender: UIButton) {
        quit(self.timer!)
    }
    
    func prepareNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: task!.pomodoroDuration!, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "\(task!.name) Completed"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "\(task!.name)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
