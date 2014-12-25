//
//  UIImage+G8Equal.h
//  TestsProject
//
//  Created by Nikolay Volosatov on 17.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (G8Equal)

- (BOOL)g8_isEqualToImage:(UIImage *)image;
- (BOOL)g8_isFilledWithColor:(UIColor *)color;
+ (UIImage *)g8_imageFilledWithColor:(UIColor *)color ofSize:(CGSize)size;

@end
