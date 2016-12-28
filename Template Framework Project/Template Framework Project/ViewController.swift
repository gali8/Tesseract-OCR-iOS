/**
*  For more information about using `G8Tesseract`, visit the GitHub page at:
*  https://github.com/gali8/Tesseract-OCR-iOS
*/
import UIKit
import TesseractOCR

class ViewController: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	let operationQueue = OperationQueue()
	
	@IBOutlet weak var imageToRecognize: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	func recognizeImageWithTesseract(image: UIImage) {
		// Animate a progress activity indicator
		activityIndicator.startAnimating()
		
		// Create a new `G8RecognitionOperation` to perform the OCR asynchronously
		// It is assumed that there is a .traineddata file for the language pack
		// you want Tesseract to use in the "tessdata" folder in the root of the
		// project AND that the "tessdata" folder is a referenced folder and NOT
		// a symbolic group in your project
		guard let operation: G8RecognitionOperation = G8RecognitionOperation(language: "eng") else {
			fatalError("unable to init")
		}
		
		// Use the original Tesseract engine mode in performing the recognition
		// (see G8Constants.h) for other engine mode options
		operation.tesseract.engineMode = G8OCREngineMode.tesseractOnly
		
		// Let Tesseract automatically segment the page into blocks of text
		// based on its analysis (see G8Constants.h) for other page segmentation
		// mode options
		operation.tesseract.pageSegmentationMode = G8PageSegmentationMode.autoOnly
		
		// Optionally limit the time Tesseract should spend performing the
		// recognition
		//operation.tesseract.maximumRecognitionTime = 1.0
		
		// Set the delegate for the recognition to be this class
		// (see `progressImageRecognitionForTesseract` and
		// `shouldCancelImageRecognitionForTesseract` methods below)
		operation.delegate = self
		
		// Optionally limit Tesseract's recognition to the following whitelist
		// and blacklist of characters
		//operation.tesseract.charWhitelist = "01234"
		//operation.tesseract.charBlacklist = "56789"
		
		// Set the image on which Tesseract should perform recognition
		operation.tesseract.image = image
		
		// Optionally limit the region in the image on which Tesseract should
		// perform recognition to a rectangle
		//operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
		
		// Specify the function block that should be executed when Tesseract
		// finishes performing recognition on the image
		operation.recognitionCompleteBlock = { [weak self] (tesseract: G8Tesseract?) in
			// Fetch the recognized text
			let recognizedText: String = tesseract?.recognizedText ?? "N/A"
			
			print(recognizedText)
			
			// Remove the animated progress activity indicator
			self?.activityIndicator.stopAnimating()
			
			// Spawn an alert with the recognized text
			let alert = UIAlertController(title: "OCR Result", message: recognizedText, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			self?.present(alert, animated: true, completion: nil)
		}
		
		// Display the image to be recognized in the view
		imageToRecognize.image = operation.tesseract.thresholdedImage
		
		// Finally, add the recognition operation to the queue
		operationQueue.addOperation(operation)
	}
	
	/**
	 *  This function is part of Tesseract's delegate. It will be called
 	 *  periodically as the recognition happens so you can observe the progress.
 	 *
	 *  @param tesseract The `G8Tesseract` object performing the recognition.
 	 */
	func progressImageRecognition(for tesseract: G8Tesseract!) {
		print("progress: \(tesseract.progress)")
	}
	
	/**
	 *  This function is part of Tesseract's delegate. It will be called
 	 *  periodically as the recognition happens so you can cancel the recogntion
	 *  prematurely if necessary.
	 *
	 *  @param tesseract The `G8Tesseract` object performing the recognition.
	 *
	 *  @return Whether or not to cancel the recognition.
	 */
	func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
		return false // return true, if you need to cancel recognition prematurely
	}

	@IBAction func openCamera(_ sender: Any) {
		let imgPicker = UIImagePickerController()
		imgPicker.delegate = self
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			imgPicker.sourceType = .camera
			present(imgPicker, animated: true, completion: nil)
		}
	}

	@IBAction func recognizeSampleImage(_ sender: Any) {
		recognizeImageWithTesseract(image: UIImage(named: "image_sample.jpg")!)
	}
	
	@IBAction func clearCache(_ sender: Any) {
		G8Tesseract.clearCache()
	}
	
	// MARK - UIImagePickerControllerDelegate
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		let image = originalImage.fixOrientation()
		picker.dismiss(animated: true, completion: nil)
		recognizeImageWithTesseract(image: image)
	}
}
