import UIKit
import AVFoundation
import Photos
import ZLImageEditor

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var Quoteofdaylbl: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var backgroundRemover = false
    var imageEditor = false
    var resultImageEditModel: ZLEditImageModel?
    let imagesList = ["m79","message","gallary","camera","imageEditor","backgroundrm","settings"]
    
    let titleList = [
        "AI Wallpapers",
        "New Year Quotes",
        "Apply filters from Gallary",
        "Apply filters from Camera",
        "Image Editor",
        "BackGround Remover",
        "Settings"
        ]

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false // You can set this to true if you want to allow editing
        
        // Set the quote of the day
        displayQuoteOfTheDay()
    }

    // Function to select and display the quote of the day
    func displayQuoteOfTheDay() {
        let userDefaults = UserDefaults.standard
        
        // Get today's date in string format (to use for comparison)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: Date())
        
        // Check if there's already a saved quote for today
        if let savedDate = userDefaults.string(forKey: "savedDate"),
           savedDate == todayDateString,
           let savedQuote = userDefaults.string(forKey: "quoteOfTheDay") {
            // If the date is the same as today, display the saved quote
            Quoteofdaylbl.text = savedQuote
        } else {
            // If it's a new day, select a new random quote
            let randomQuote = messages.randomElement() ?? "Happy New Year!"
            
            // Save the new quote and today's date in UserDefaults
            userDefaults.set(todayDateString, forKey: "savedDate")
            userDefaults.set(randomQuote, forKey: "quoteOfTheDay")
            
            // Display the new random quote
            Quoteofdaylbl.text = randomQuote
        }
    }

    // Other functions remain unchanged
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage 
        {
            
            if backgroundRemover 
            {
                // Dismiss the UIImagePickerController first
                self.dismiss(animated: true)
                {
                    // Once dismissed, present the new view controller
                    let bgView = BackgroundremoverVC()
                    bgView.selectedImage = selectedImage
                    let navigationController = UINavigationController(rootViewController: bgView)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
            else if imageEditor == true
            {
                picker.dismiss(animated: true) { [weak self] in
                       if let selectedImage = info[.originalImage] as? UIImage {
                           self?.editImage(selectedImage, editModel: nil)
                       }
                   }
            }
            else
            {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let filterVC = storyBoard.instantiateViewController(withIdentifier: "FilterImageViewController") as! FilterImageViewController
                filterVC.selectedImage = selectedImage
                filterVC.modalPresentationStyle = .fullScreen
                self.dismiss(animated: true) {
                    self.present(filterVC, animated: true, completion: nil)
                }
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    
    func showStyleSheet()
    {
        let styleSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Capture from Camera", style: .default) { [weak self] _ in
            self?.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Select from Gallery", style: .default) { [weak self] _ in
            self?.chooseImageFromGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        styleSheet.addAction(cameraAction)
        styleSheet.addAction(galleryAction)
        styleSheet.addAction(cancelAction)
        
        present(styleSheet, animated: true, completion: nil)
    }
    
    func openCamera()
   {
       let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
       
       switch cameraAuthorizationStatus {
       case .authorized:
        DispatchQueue.main.async { [weak self] in
               self?.presentCamera()
        }
       case .notDetermined:
           AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
               DispatchQueue.main.async {
                   if granted {
                       self?.presentCamera()
                   } else {
                       self?.redirectToSettings()
                   }
               }
           }
       case .denied, .restricted:
           redirectToSettings()
       @unknown default:
           break
       }
   }
    private func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    @objc func chooseImageFromGallery() {
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
           activityIndicator.center = view.center
           activityIndicator.startAnimating()
           view.addSubview(activityIndicator)
        
        let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoLibraryAuthorizationStatus {
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                self?.presentImagePicker(with: activityIndicator)
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async
                {
                    if status == .authorized
                    {
                        self?.presentImagePicker(with: activityIndicator)
                    } else {
                        self?.redirectToSettings()
                    }
                }
            }
        case .denied, .restricted:
            redirectToSettings()
        case .limited:
            // Handle limited photo library access if needed
            break
        @unknown default:
            break
        }
    }
    
    private func presentImagePicker(with activityIndicator: UIActivityIndicatorView) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true) {
            // Dismiss the activity indicator once the gallery is presented
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    private func redirectToSettings()
    {
        let alertController = UIAlertController(title: "Permission Required", message: "Please enable access to the camera or photo library in Settings.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        
        cell.imag.image = UIImage(named: imagesList[indexPath.row])
        cell.namelbl
            .text = titleList[indexPath.row]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.clipsToBounds = true
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let availableWidth = collectionViewWidth - (spacing * 3)
        let width = availableWidth / 2
        return CGSize(width: width - 20, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            imageEditor = false
            backgroundRemover = false
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GreetingsDetailViewController") as! GreetingsDetailViewController
            //newViewController.isFromHomeName = "Mountain Wallpaper"
           // newViewController.titlestr = titleList[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
        else if indexPath.row == 1
        {
            imageEditor = false
            backgroundRemover = false
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
           // newViewController.isFromHomeName = "Ocean Wallpaper"
           // newViewController.titlestr = titleList[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
        else if indexPath.row == 2
        {
            self.chooseImageFromGallery()
            backgroundRemover = false
            imageEditor = false
        }
        else if indexPath.row == 3
        {
            
            self.openCamera()
            backgroundRemover = false
            imageEditor = false
        }
        else if indexPath.row == 4
        {
            backgroundRemover = false
            imageEditor = true
            showStyleSheet()
        }
        else if indexPath.row == 5
        {
            backgroundRemover = true
            imageEditor = false
            showStyleSheet()
        }
        else if indexPath.row == 6
        {
            backgroundRemover = false
            imageEditor = false
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
           // newViewController.isFromHomeName = "Ocean Wallpaper"
           // newViewController.titlestr = titleList[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }

    }
    
    
    func editImage(_ image: UIImage, editModel: ZLEditImageModel?) {
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: editModel) { [weak self] editedImage, editModel in
            if editedImage != nil {
                self?.resultImageEditModel = editModel

                // Save the edited image to the photo library
                UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil)

                // Optionally, display an alert to inform the user that the image has been saved
                let alert = UIAlertController(title: "Saved!", message: "Your edited image has been successfully saved.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self?.present(alert, animated: true, completion: nil)
            } else {
                // Handle the case where editedImage is nil
            }
        }
    }

    
    @IBAction func Camerabtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available.")
        }
    }
    @IBAction func Settingsbtn(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
