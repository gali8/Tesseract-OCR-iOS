//
//  UIImage+G8Filters.h
//  Tesseract OCR iOS
//
//  Created by Daniele on 31/07/14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Convenience methods for preprocessing images before performing recognition.
 */
@interface UIImage (G8Filters)

/**
 *  A convenience method for using CoreImage filters to preprocess an image by
 *  1) setting the saturation to 0 to achieve grayscale, 2) increasing the 
 *  contrast by 10% to make black parts blacker, and 3) reducing the exposure 
 *  by 30% to reduce the amount of "light" in the image.
 *
 *  @return The filtered image.
 */
- (UIImage *)g8_blackAndWhite;

/**
 *  A convenience method for converting an image to grayscale by manually
 *  iterating over each of the pixels in the image and applying the following
 *  formula to each pixel: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
 *
 *  @return The grayscale image.
 */
- (UIImage *)g8_grayScale;

@end
