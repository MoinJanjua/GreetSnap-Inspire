//
//  SettingsViewController.swift
//  InspireNature Wall
//
//  Created by Farrukh UCF on 11/10/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var versionLb: UILabel!
    
    let NotificationIdentifier = "DailyQuoteReminder"
    var PositiveQuotesList = ["p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "p16", "p17", "p18", "p19", "p20", "p21", "p22", "p23", "p24", "p25", "p26", "p27", "p28", "p29", "p30", "p31", "p32", "p33", "p34", "p35", "p36", "p37", "p38", "p39", "p40", "p41", "p42", "p43", "p44", "p45", "p46", "p47", "p48", "p49", "p50"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //switchButton.isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        versionLb.text = "Version \(version) (\(build))"
    }

    @IBAction func notificationbtnPressed(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "notificationsEnabled")
            checkAndScheduleNotification()
        } else {
            UserDefaults.standard.set(false, forKey: "notificationsEnabled")
            cancelDailyNotification()
        }
    }

    private func checkAndScheduleNotification() {
        scheduleNotification()
    }

    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Quote of the Day"

        // Randomly select a quote from the list
        if let randomQuote = PositiveQuotesList.randomElement() {
            content.body = randomQuote
        } else {
            content.body = "Stay positive and have a great day!"
        }

        content.sound = UNNotificationSound.default

        // Optionally, add a random image to the notification (if you have image names/URLs)
        if let randomImageName = PositiveQuotesList.randomElement() {
            if let imageURL = Bundle.main.url(forResource: randomImageName, withExtension: "jpg") {
                do {
                    let attachment = try UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("Error attaching image to notification: \(error)")
                }
            }
        }

        // Create a trigger to fire daily at a specific time
        var dateComponents = DateComponents()
        dateComponents.hour = 9 // Notification will be sent at 9 AM daily
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: NotificationIdentifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }

    func cancelDailyNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationIdentifier])
        print("Notification canceled successfully!")
        
        DispatchQueue.main.async {
            let confirmationAlert = UIAlertController(title: "Notification Disabled", message: "Please enable notifications in your app settings before setting a reminder.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
            confirmationAlert.addAction(okAction)
            
            self.present(confirmationAlert, animated: true, completion: nil)
        }
    }
    @IBAction func BackButon(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func Homebtn(_ sender: UIButton) {
        
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true)
    }
   // @IBAction func historybtnbtn(_ sender: UIButton)
   // {
      //  let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
       // let newViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
       // newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
      // newViewController.modalTransitionStyle = .crossDissolve
       // self.present(newViewController, animated: true)
   // }
    @IBAction func Aboutusbtn(_ sender: UIButton) {
        
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AboutusViewController") as! AboutusViewController
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true)
    }
    @IBAction func Feedbackbtn(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }
    @IBAction func Sharebtn(_ sender: UIButton) {
        let appID = "GreetSnapInspire"
           let appStoreURL = URL(string: "https://apps.apple.com/app/id\(appID)")!
           
           let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
           
           // For iPads
           if let popoverController = activityViewController.popoverPresentationController {
               popoverController.barButtonItem = sender as? UIBarButtonItem
           }
           
           present(activityViewController, animated: true, completion: nil)
    }
    
}
