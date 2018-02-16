//
//  ViewController.swift
//  Example Swift
//
//  Created by Eduardo Irias on 2/16/18.
//  Copyright © 2018 Daniele Galiotto - www.g8production.com. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController {

    let operationQueue = OperationQueue()
    
    @IBOutlet weak var imageToRecognize: UIImageView!
    @IBOutlet weak var activityIndicator :UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func recognizeImageWithTesseract(image: UIImage) {
        // Animate a progress activity indicator
        //[self.activityIndicator startAnimating];
        
        // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
        // It is assumed that there is a .traineddata file for the language pack
        // you want Tesseract to use in the "tessdata" folder in the root of the
        // project AND that the "tessdata" folder is a referenced folder and NOT
        // a symbolic group in your project
        
        guard let operation = G8RecognitionOperation(language: "eng") else { return }

        // Use the original Tesseract engine mode in performing the recognition
        // (see G8Constants.h) for other engine mode options
        operation.tesseract.engineMode = .tesseractOnly

        // Let Tesseract automatically segment the page into blocks of text
        // based on its analysis (see G8Constants.h) for other page segmentation
        // mode options
        operation.tesseract.pageSegmentationMode = .autoOnly
        
        // Optionally limit the time Tesseract should spend performing the
        // recognition
        //operation.tesseract.maximumRecognitionTime = 1.0
        
        // Set the delegate for the recognition to be this class
        // (see `progressImageRecognitionForTesseract` and
        // `shouldCancelImageRecognitionForTesseract` methods below)
        //operation.delegate = self
        
        // Optionally limit Tesseract's recognition to the following whitelist
        // and blacklist of characters
        //operation.tesseract.charWhitelist = "01234"
        //operation.tesseract.charBlacklist = "56789"
        
        // Set the image on which Tesseract should perform recognition
        operation.tesseract.image = image;
        
        // Optionally limit the region in the image on which Tesseract should
        // perform recognition to a rectangle
        //operation.tesseract.rect = CGRect(x: 20, y: 20, width: 100, height: 140)
        
        // Specify the function block that should be executed when Tesseract
        // finishes performing recognition on the image
        operation.recognitionCompleteBlock =  { (tesseract : G8Tesseract?) in
            
            // Fetch the recognized text
            let recognizedText = tesseract?.recognizedText
            
            // Remove the animated progress activity indicator
            self.activityIndicator.stopAnimating()
            
            let alertController = UIAlertController(title: "OCR Result", message: recognizedText, preferredStyle: .alert)
            
            
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true)
        };
        
        // Display the image to be recognized in the view
        self.imageToRecognize.image = operation.tesseract.thresholdedImage
        
        // Finally, add the recognition operation to the queue
        self.operationQueue.addOperation(operation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openCamera(sender: Any) {
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        
        imgPickerController.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        
        self.present(imgPickerController, animated: true)
    }
    
    @IBAction func recognizeSampleImage(sender: Any) {
        self.recognizeImageWithTesseract(image: #imageLiteral(resourceName: "image_sample"))
    }
    
    @IBAction func clearCache(sender: Any) {
        G8Tesseract.clearCache()
    }

}

extension ViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        self.recognizeImageWithTesseract(image: image)
    }
}
