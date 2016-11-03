import UIKit

// Taken from StackOverflow
// Title: "iOS UIImagePickerController result image orientation after upload"
// http://stackoverflow.com/a/33479054/78336
extension UIImage {
	
	func fixOrientation() -> UIImage {
		
		// No-op if the orientation is already correct
		if ( self.imageOrientation == UIImageOrientation.up ) {
			return self;
		}
		
		// We need to calculate the proper transformation to make the image upright.
		// We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
		var transform: CGAffineTransform = CGAffineTransform.identity
		
		if ( self.imageOrientation == UIImageOrientation.down || self.imageOrientation == UIImageOrientation.downMirrored ) {
			transform = transform.translatedBy(x: self.size.width, y: self.size.height)
			transform = transform.rotated(by: CGFloat(M_PI))
		}
		
		if ( self.imageOrientation == UIImageOrientation.left || self.imageOrientation == UIImageOrientation.leftMirrored ) {
			transform = transform.translatedBy(x: self.size.width, y: 0)
			transform = transform.rotated(by: CGFloat(M_PI_2))
		}
		
		if ( self.imageOrientation == UIImageOrientation.right || self.imageOrientation == UIImageOrientation.rightMirrored ) {
			transform = transform.translatedBy(x: 0, y: self.size.height);
			transform = transform.rotated(by: CGFloat(-M_PI_2));
		}
		
		if ( self.imageOrientation == UIImageOrientation.upMirrored || self.imageOrientation == UIImageOrientation.downMirrored ) {
			transform = transform.translatedBy(x: self.size.width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
		}
		
		if ( self.imageOrientation == UIImageOrientation.leftMirrored || self.imageOrientation == UIImageOrientation.rightMirrored ) {
			transform = transform.translatedBy(x: self.size.height, y: 0);
			transform = transform.scaledBy(x: -1, y: 1);
		}
		
		// Now we draw the underlying CGImage into a new context, applying the transform
		// calculated above.
		let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
		                               bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
		                               space: self.cgImage!.colorSpace!,
		                               bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
		
		ctx.concatenate(transform)
		
		if ( self.imageOrientation == UIImageOrientation.left ||
			self.imageOrientation == UIImageOrientation.leftMirrored ||
			self.imageOrientation == UIImageOrientation.right ||
			self.imageOrientation == UIImageOrientation.rightMirrored ) {
			ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
		} else {
			ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
		}
		
		// And now we just create a new UIImage from the drawing context and return it
		return UIImage(cgImage: ctx.makeImage()!)
	}
}
