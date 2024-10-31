//
//  Helper.swift
//  InspireNature Wall
//
//  Created by Farrukh UCF on 10/10/2024.
//

import Foundation
import UIKit

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UILabel {

    @IBInspectable var borderWidth2: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius2: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor2: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UIView {

    @IBInspectable var borderWidth1: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius1: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor1: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

func roundCorner(button:UIButton)
{
    button.layer.cornerRadius = button.frame.size.height/2
    button.clipsToBounds = true
}

func roundCorneView(image:UIImageView)
{
    image.layer.cornerRadius = image.frame.size.height/2
    image.clipsToBounds = true
}
func roundCornerView(view:UIView)
{
    view.layer.cornerRadius = view.frame.size.height/2
    view.clipsToBounds = true
}
func roundCorneLabel(label:UILabel)
{
    label.layer.cornerRadius = label.frame.size.height/2
    label.clipsToBounds = true
}

struct Transaction: Codable,Equatable {
    var title: String
    var amount: String
    var type: String // "Income" or "Expense"
    var reason: String
    var dateTime: Date
    var budget:String
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
           return lhs.amount == rhs.amount &&
               lhs.type == rhs.type &&
                lhs.title == rhs.title &&
               lhs.reason == rhs.reason &&
               lhs.dateTime == rhs.dateTime &&
               lhs.budget == rhs.budget
       }
}

struct TransactionSection {
    let date: String
    var transactions: [Transaction]
}


var currency = ""

func formatAmount(_ amount: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    
    // Convert amount to a number
    if let number = formatter.number(from: amount) {
        return formatter.string(from: number) ?? amount
    } else {
        // If conversion fails, assume there's no dot and add two zeros after it
        let amountWithDot = amount + ".00"
        return formatter.string(from: formatter.number(from: amountWithDot)!) ?? amountWithDot
    }
}

struct Profiles: Codable{
    var name: String
    var date : Date
}

extension UIViewController
{
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
let pagination1 = ["img1","img2","img3","img4","img5","img6","img7","img8","img9","img10"]

let beardcategory = ["Full Beard","Goatee Styles","Stubble","Short Beard Styles","Long Beard Styles","Fade Beards",
                   "Beard and Mustache Combinations"
               ]


                  
let greetingswp = ["m1","m2","m3","m4","m5","m6",
                   "m7","m8","m9","m10","m11","m12","m13","m14","m15","m16","m17","m18","m19","m20","m21","m22","m23","m24","m25","m26","m27","m28","m29","m30","m31","m32","m33","m34","m35","m36","m37","m38","m39","m40","m41","m42","m43","m44","m45","m46","m47","m48","m49","m50","m51","m52","m53","m54","m55","m56","m57","m58","m59","m60","m61","m62","m63","m64","m65","m66","m67","m68","m69","m70","m71","m72","m73","m74","m75","m76","m77","m78","m79","m80","m81","m82","m83","m84","m85","m86","m87","m88","m89","m90","m91","m92","m93","m94","m95","m96","m97","m98","m99","m100"
                  ]

var messages = ["Wishing you a Happy New Year with the hope that you will have many blessings in the year to come.",
                "Out with the old, in with the new: may you be happy the whole year through. Happy New Year!",
                "Counting my blessings and wishing you more. Hope you enjoy the New Year in store.",
                "I resolve to stop wasting my resolutions on myself and use them to repay you for the warmth you’ve shown me.",
                "Nights will be dark but days will be light, wish your life to be always bright – Happy New Year.",
                "Let us look back at the past year with the warmest of memories. Happy New Year.",
                "Let the old year end and the New Year begin with the warmest of aspirations. Happy New Year!",
                "One more year loaded with sweet recollections and cheerful times has passed. You have made my year exceptionally uncommon.",
                "May the new year bring you warmth, love and light to guide your path to a positive destination.",
                "Here’s wishing you all the joy of the season. Have a Happy New Year!",
                "Cheers to a new year and another chance for us to get it right!",
                "May your troubles be less and your blessings be more in the new year.",
                "New year, new dreams, new adventures.",
                "A fresh start begins with a positive mindset.",
                "Let’s make this year unforgettable!",
                "Wishing you health, wealth, and endless joy in the coming year!",
                "Here’s to 365 days of new opportunities and happiness.",
                "May the best of this year be the worst of the next.",
                "Embrace the magic of new beginnings this year.",
                "May this year be full of happiness, laughter, and bright moments.",
                "Dream big, work hard, and make it happen this year!",
                "Wishing you 12 months of success, 52 weeks of laughter, and 365 days of joy.",
                "This is your year to sparkle and shine!",
                "Let this year be the chapter of growth, love, and happiness.",
                "May every day of this new year bring new opportunities.",
                "A new year means a new chapter. Make yours the best one yet!",
                "Here’s to a year full of adventure, excitement, and memories.",
                "The best is yet to come. Happy New Year!",
                "Leave behind what doesn’t serve you. This is your time to grow.",
                "365 new days, 365 new chances!",
                "Take a leap of faith and begin this year with a heart full of hope.",
                "Every end is a new beginning. Happy New Year!",
                "Let’s make this year better than the last one.",
                "New year, new adventures, new opportunities to be great!",
                "May this year bring you closer to your goals and dreams.",
                "The future belongs to those who believe in the beauty of their dreams.",
                "Life’s too short to wait for tomorrow. Start making every moment count this year.",
                "Success is not final, failure is not fatal: it is the courage to continue that counts.",
                "Believe you can and you're halfway there.",
                "Do what you can, with what you have, where you are.",
                "Start where you are. Use what you have. Do what you can.",
                "The only limit to our realization of tomorrow is our doubts of today.",
                "Don’t watch the clock; do what it does. Keep going.",
                "Action is the foundational key to all success.",
                "Don't wait for opportunity. Create it.",
                "Believe in yourself and all that you are.",
                "What we think, we become.",
                "The harder you work for something, the greater you'll feel when you achieve it.",
                "Don’t stop when you’re tired. Stop when you’re done.",
                "Your limitation—it’s only your imagination.",
                "Dream it. Wish it. Do it.",
                "Little by little, day by day, what is meant for you will find its way.",
                "Start each day with a positive thought and a grateful heart.",
                "If opportunity doesn’t knock, build a door.",
                "Great things never came from comfort zones.",
                "Your life does not get better by chance, it gets better by change.",
                "Success is the sum of small efforts, repeated day in and day out.",
                "A little progress each day adds up to big results.",
                "Push yourself, because no one else is going to do it for you.",
                "Success doesn’t just find you. You have to go out and get it.",
                "It’s not about being the best. It’s about being better than you were yesterday.",
                "Don’t limit your challenges. Challenge your limits.",
                "Dream big and dare to fail.",
                "Don’t be afraid to give up the good to go for the great.",
                "Believe in your infinite potential.",
                "What you get by achieving your goals is not as important as what you become by achieving your goals.",
                "The only place where success comes before work is in the dictionary.",
                "Success is walking from failure to failure with no loss of enthusiasm.",
                "Success is not how high you have climbed, but how you make a positive difference to the world.",
                "Success usually comes to those who are too busy to be looking for it.",
                "You don’t have to be great to start, but you have to start to be great.",
                "Don't be pushed by your problems. Be led by your dreams.",
                "Doubt kills more dreams than failure ever will.",
                "The key to success is to focus on goals, not obstacles.",
                "You don’t always get what you wish for, but you get what you work for.",
                "Work hard in silence, let your success be the noise.",
                "Hard work beats talent when talent doesn’t work hard.",
                "The way to get started is to quit talking and begin doing.",
                "The best way to predict the future is to create it.",
                "The secret to getting ahead is getting started.",
                "Dream bigger. Do bigger.",
                "Do something today that your future self will thank you for.",
                "It always seems impossible until it's done.",
                "When nothing goes right, go left.",
                "Success is not the key to happiness. Happiness is the key to success.",
                "To be successful, the first thing to do is fall in love with your work.",
                "I never dreamed about success. I worked for it.",
                "Success is where preparation and opportunity meet.",
                "Life begins at the end of your comfort zone.",
                "Whatever the mind of man can conceive and believe, it can achieve.",
                "Success is not in what you have, but who you are.",
                "Fall seven times, stand up eight.",
                "The road to success and the road to failure are almost exactly the same.",
                "Good things come to people who wait, but better things come to those who go out and get them.",
                "Success is liking yourself, liking what you do, and liking how you do it.",
                "Success is doing ordinary things extraordinarily well.",
                "Don’t aim for success if you want it; just do what you love and believe in, and it will come naturally.",
                "Success is not how much money you make, but the difference you make in people's lives.",
                "The secret of success is to do the common thing uncommonly well.",
                "Success is nothing more than a few simple disciplines, practiced every day.",
                "Success is the result of preparation, hard work, and learning from failure.",
                "The best revenge is massive success.",
                "Success is not measured by where you are in life, but the obstacles you’ve overcome.",
                "Success is the ability to go from one failure to another with no loss of enthusiasm.",
                "If you want to achieve greatness stop asking for permission.",
                "Success is not just about what you accomplish in your life, it’s about what you inspire others to do.",
                "The only way to achieve the impossible is to believe it is possible.",
                "Failure is not the opposite of success; it’s part of success.",
                "If you are not willing to risk the usual, you will have to settle for the ordinary.",
                "Don’t be afraid to give up the good to go for the great."]

