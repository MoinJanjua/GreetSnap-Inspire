//
//  ShareandDownldViewController.swift
//  GreetSnap Inspire
//
//  Created by Farrukh UCF on 17/10/2024.
//

import UIKit
import Photos
class ShareandDownldViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var Downloadimg: UIButton!
    @IBOutlet weak var Shareimgbtn: UIButton!
    
    var selectedimage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.img.image = self.selectedimage
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backbutton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func Downloadimg(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                self.saveImageToPhotoLibrary()
            } else {
                DispatchQueue.main.async {
                    self.showAccessDeniedAlert()
                }
            }
        }
    }
    private func saveImageToPhotoLibrary() {
        DispatchQueue.main.async {
            guard let imageToSave = self.img.image else { return }
            UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(self.imageSavedToPhotosAlbum(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    private func showAccessDeniedAlert() {
        let alert = UIAlertController(title: "Access Denied", message: "Please allow access to Photos in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    @objc func imageSavedToPhotosAlbum(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully to Photo Library")
            DispatchQueue.main.async {
                self.showSaveSuccessAlert()
            }
        }
    }
    private func showSaveSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Image saved to Photo Library.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func Shareimage(_ sender: UIButton) {
        guard let imageToShare = img.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .print
        ]
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }

}
