//
//  FilterImageViewController.swift
//  GreetSnap Inspire
//
//  Created by Farrukh UCF on 17/10/2024.
//

import UIKit
import CoreImage

class FilterImageViewController: UIViewController {
    var selectedImage: UIImage!
    var selectedFilter: CIFilter?
    var placeHolderImage = UIImage(named: "placeholder")
    //var imageView: UIImageView!
        //var filterScrollView: UIScrollView!
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var filterScrollView:UIScrollView!
    @IBOutlet weak var downloadbtn:UIButton!
    
    
    // CIFilterNames shuffled
    let CIFilterNames = [
        "CIPhotoEffectProcess",   // Photo effect process
        "CISharpenLuminance",
        "CISepiaTone",
        "CIPhotoEffectFade",
        "CIDotScreen",
        "CIVignette",
        "CIMaximumComponent",
        "CIPhotoEffectTransfer",
        "CIPhotoEffectTonal",
        "CIColorMonochrome",
        "CIPhotoEffectProcess",
        "CIFalseColor",
        "CIMinimumComponent",
        "CIColorInvert", // Invert colors
        "CIHueAdjust",   // Adjust the hue
        "CILinearToSRGBToneCurve", // Linear to sRGB tone curve
        "CIVibrance",    // Adjusts the saturation of an image while keeping pleasing
        "CIBloom",                // Bloom effect
        "CIGloom", 
        "CIColorControls", // Adjusts saturation, brightness, and contrast
        "CIPhotoEffectMono",
        "CIPhotoEffectChrome",
        "CIPhotoEffectNoir",
        "CIColorPosterize",
        "CIPhotoEffectInstant",
    ]

    // FilterNamesLb shuffled

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        placeHolderImage = selectedImage
        configureFilterScrollView()
        loadFilters()
        roundCorner(button: downloadbtn)
        imageView.image = selectedImage
       
        //imageView.addSubview(downloadbtn)
       // intensitySlider.isHidden = true // Hide slider initially
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadbtn.setTitle("", for: .normal)
      //  downloadbtn.tintColor = .black
      //  downloadbtn.setImage(UIImage(systemName: "arrowshape.down"), for: .normal)
    }
    
  
    
    func configureFilterScrollView() {
        filterScrollView.showsVerticalScrollIndicator = false
        filterScrollView.showsHorizontalScrollIndicator = false
        
    }
    
    @objc func filterButtonTapped(sender: UIButton)
    {
        guard let image = selectedImage else { return }
            
            let filterIndex = sender.tag
            let ciContext = CIContext(options: nil)
            
            // Ensure the image is correctly oriented
            let coreImage = CIImage(image: image)?.oriented(.up)
            
            guard let coreImage = coreImage, let filter = CIFilter(name: "\(CIFilterNames[filterIndex])") else { return }
            
            filter.setDefaults()
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            
            guard let filteredImageData = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return }
            guard let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent) else { return }
            
            let imageForButton = UIImage(cgImage: filteredImageRef)
            imageView.image = imageForButton
            selectedFilter = filter // Store the selected filter
         
    }
    

    
    @objc func rotateImage()
    {
        guard var rotatedImage = imageView.image else { return }

            // Check and correct the orientation of the image
            if rotatedImage.imageOrientation != .up {
                UIGraphicsBeginImageContextWithOptions(rotatedImage.size, false, rotatedImage.scale)
                rotatedImage.draw(in: CGRect(origin: .zero, size: rotatedImage.size))
                rotatedImage = UIGraphicsGetImageFromCurrentImageContext() ?? rotatedImage
                UIGraphicsEndImageContext()
            }

            // Rotate the image
            rotatedImage = rotatedImage.rotate(radians: .pi / 2) ?? rotatedImage
            imageView.image = rotatedImage
            selectedImage = rotatedImage
    }
    
    
    @IBAction func rotatebtn(_ sender:UIButton)
    {
        rotateImage()
    }
    
    @IBAction func savebtn(_ sender:UIButton)
    {
        saveButtonPressed()
    }
    
    @IBAction func backbtn(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
    
    func saveButtonPressed()
    {
        
        if let selectedFilter = selectedFilter {
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: selectedImage)
            selectedFilter.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = selectedFilter.value(forKey: kCIOutputImageKey) as? CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData!, from: filteredImageData!.extent)
            let finalImage = UIImage(cgImage: filteredImageRef!)
            
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            
            let alert = UIAlertController(title: "Saved!", message: "Your edited image has been successfully saved.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }
        else
        {
            // If no filter is selected, save the original image
            UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
            
            let alert = UIAlertController(title: "Filters", message: "Your original image has been saved to Photo Library", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    fileprivate func loadFilters() {
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth: CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        let labelHeight: CGFloat = 20 // Height for filter names
        
        for i in 0..<CIFilterNames.count {
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(origin: CGPoint(x: xCoord, y: yCoord), size: CGSize(width: buttonWidth, height: buttonHeight))
            filterButton.tag = i
            filterButton.showsTouchWhenHighlighted = true
            filterButton.addTarget(self, action: #selector(self.filterButtonTapped(sender:)), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            // Set background images for buttons
            if let coreImage = CIImage(image: placeHolderImage!),
               let filter = CIFilter(name: "\(CIFilterNames[i])") {
                filter.setDefaults()
                filter.setValue(coreImage, forKey: kCIInputImageKey)
                if let filteredImageData = filter.value(forKey: kCIOutputImageKey) as? CIImage,
                   let filteredImageRef = CIContext().createCGImage(filteredImageData, from: filteredImageData.extent) {
                    let imageForButton = UIImage(cgImage: filteredImageRef)
                    filterButton.setBackgroundImage(imageForButton, for: .normal)
                    filterScrollView.addSubview(filterButton)
                    
                    // Create label for filter name
                } else {
                    print("Failed to create filtered image for button \(i)")
                }
            } else {
                print("Failed to create CIImage or CIFilter for filter \(i)")
            }
            
            xCoord += buttonWidth + gapBetweenButtons
        }
        
        filterScrollView.contentSize = CGSize(width: xCoord, height: buttonHeight + labelHeight + 2 * yCoord)
    }
}


extension UIImage {
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate around middle
        context.rotate(by: radians)
        
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
