//
//  UIImage+G8FixOrientation.h
//  Tesseract OCR iOS
//
//  Thanks to `binnyb` for answer from
//  http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
//
//  Created by Nikolay Volosatov on 09/01/15.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (G8FixOrientation)

- (CGAffineTransform)transformForOrientationFix;
- (CGSize)sizeForOrientationFix;

- (UIImage *)fixOrientation;

@end
