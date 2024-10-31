//
//  MessageViewController.swift
//  GreetSnap Inspire
//
//  Created by Farrukh UCF on 17/10/2024.
//

import UIKit

class MessageViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, MessageCellDelegate {
    
    func didTapShareButton(withText text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                present(activityVC, animated: true, completion: nil)
    }
    
    func didTapCopyButton(withText text: String) {
        UIPasteboard.general.string = text
                let alert = UIAlertController(title: "Copied!", message: "The text has been copied to your clipboard.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
    }
    
  
    @IBOutlet weak var TableV: UITableView!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        TableV.delegate = self
        TableV.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
          cell.mesgLabel.text = messages[indexPath.row]
          cell.delegate = self // Set the delegate to handle button actions
          return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
