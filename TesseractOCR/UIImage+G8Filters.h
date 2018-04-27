////
////  UIImage+G8Filters.h
////  Tesseract OCR iOS
////
////  Created by Daniele on 31/07/14.
////  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
////  All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
//#import <UIKit/UIKit.h>
//#elif TARGET_OS_MAC
//#import <AppKit/AppKit.h>
//#endif
//
//#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
//
///**
// *  Convenience methods for preprocessing images before performing recognition.
// */
//@interface UIImage (G8Filters)
//
///**
// *  A convenience method for using CoreImage filters to preprocess an image by
// *  1) setting the saturation to 0 to achieve grayscale, 2) increasing the
// *  contrast by 10% to make black parts blacker, and 3) reducing the exposure
// *  by 30% to reduce the amount of "light" in the image.
// *
// *  @return The filtered image.
// */
//- (UIImage *)g8_blackAndWhite __attribute__((deprecated("This method is no longer supported as a part of Tesseract-OCR-iOS")));
//
///**
// *  A convenience method for converting an image to grayscale by manually
// *  iterating over each of the pixels in the image and applying the following
// *  formula to each pixel: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
// *
// *  @return The grayscale image.
// */
//- (UIImage *)g8_grayScale  __attribute__((deprecated("This method is no longer supported as a part of Tesseract-OCR-iOS")));
//
//@end
//
//#elif TARGET_OS_MAC
//
///**
// *  Convenience methods for preprocessing images before performing recognition.
// */
//@interface NSImage (G8Filters)
//
///**
// *  A convenience method for using CoreImage filters to preprocess an image by
// *  1) setting the saturation to 0 to achieve grayscale, 2) increasing the
// *  contrast by 10% to make black parts blacker, and 3) reducing the exposure
// *  by 30% to reduce the amount of "light" in the image.
// *
// *  @return The filtered image.
// */
//- (NSImage *)g8_blackAndWhite __attribute__((deprecated("This method is no longer supported as a part of Tesseract-OCR-iOS")));
//
///**
// *  A convenience method for converting an image to grayscale by manually
// *  iterating over each of the pixels in the image and applying the following
// *  formula to each pixel: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
// *
// *  @return The grayscale image.
// */
//- (NSImage *)g8_grayScale  __attribute__((deprecated("This method is no longer supported as a part of Tesseract-OCR-iOS")));
//
//@end
//
//
//
//#endif
