//
//  AboutusViewController.swift
//  InspireNature Wall
//
//  Created by Farrukh UCF on 11/10/2024.
//

import UIKit

class AboutusViewController: UIViewController {

    @IBOutlet weak var feedbackTV:UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTV.layer.borderWidth = 1.0
        feedbackTV.layer.borderColor = UIColor.white.cgColor
        feedbackTV.layer.cornerRadius = 10.0
        feedbackTV.clipsToBounds = true
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
}