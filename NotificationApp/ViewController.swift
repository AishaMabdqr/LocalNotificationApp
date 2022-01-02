//
//  ViewController.swift
//  NotificationApp
//
//  Created by A Ab. on 26/05/1443 AH.
//

import UIKit

struct LocalNotification{
    var isActive: Bool
    var length: Int
    var dateItEnds: Date
    var dateItStarted = Date()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var hoursAndMin: UILabel!
    @IBOutlet weak var timerSet: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var workUntil: UILabel!
    
    
    let timeArr:[Int] = [5,10,20,30]
    var runningNotifications: [LocalNotification] = []
    
    var selectedTime: Int = 5
    var hours: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.delegate = self
       timePicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func createNotification(time: Int)-> String{
        
     
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Timer is done!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "You studied \(time) minutes good job!", arguments: nil)
        content.sound = UNNotificationSound.default
        
        
        let currentDate = Date(timeIntervalSinceNow: Double(time * 60))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let currentTime = formatter.string(from: currentDate)
        
        let localNotification = LocalNotification(isActive: true, length: time, dateItEnds: currentDate)
        runningNotifications.append(localNotification)

        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        //create the request
        let request = UNNotificationRequest(identifier: "Timer Alert ", content: content, trigger: trigger)
        //permission
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
            
        }
        return currentTime
    }
    
    
    @IBAction func startBut(_ sender: UIButton) {
        let currentTime = createNotification(time: selectedTime)
       showAlert(title: "\(selectedTime)min countdown", message: "After \(selectedTime)minutes, you'll be notified")
        
        totalTime.text = "Total time: \(selectedTime)"
        hoursAndMin.text = "\(hours) hours, \(selectedTime) min"
        workUntil.text = "Work until \(currentTime)"
        timerSet.text = "\(selectedTime) minute timer set"
    }
    
    
    @IBAction func cancelBut(_ sender: UIButton) {
        print(UIApplication.shared.scheduledLocalNotifications)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        timerSet.textColor = .systemGray
        timerSet.font = .preferredFont(forTextStyle: .title2)
        timerSet.text = "\(selectedTime) minute timer cancelled"
    }
    
    @IBAction func listBut(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TableVC") as! TableViewController
        
        vc.modalPresentationStyle = .formSheet
        vc.allNotifications = runningNotifications
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(timeArr[row]) Minutes"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected minutes \(timeArr[row])")
        selectedTime = timeArr[row]
    }
    
    
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // notification arrived
        showAlert(title: "Timer is done!", message: "You studied \(selectedTime) minutes good job!")
        timerSet.textColor = .systemGray
        timerSet.font = .preferredFont(forTextStyle: .title2)
        timerSet.text = "\(selectedTime) minute timer done"
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

 



