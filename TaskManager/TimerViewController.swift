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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            if !self.countUp {
                self.time -= 1
            } else {
                self.time += 1
            }
            self.duration += 1
            self.updateTimerLabel(Timer)
        }
        startTime = Date()
        self.timer = timer
        timerLabel.text = "\(String(format: "%02d", time / 60)):\(String(format: "%02d", time % 60))"
        //timer.fire()
        
        // Do any additional setup after loading the view.
    }
    
    func updateTimerLabel(_ timer: Timer) {
        timerLabel.text = "\(String(format: "%02d", time / 60)):\(String(format: "%02d", time % 60))"
        if time <= 0 {
            quit(timer)
        }
    }
    
    func quit(_ timer : Timer) {
        timer.invalidate()
        task?.pomodoroUsed += 1
        task?.timeUsed += TimeInterval(duration)
        endTime = Date()
        self.performSegue(withIdentifier: "unwindToTaskTable", sender: self)
    }

    @IBAction func quitButtonTapped(_ sender: UIButton) {
        quit(self.timer!)
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
