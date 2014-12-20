//
//  UIImage+G8Equal.m
//  TestsProject
//
//  Created by Nikolay Volosatov on 17.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "UIImage+G8Equal.h"

@implementation UIImage (G8Equal)

- (BOOL)g8_isEqualToImage:(UIImage *)image
{
    if (self == image) {
        return YES;
    }
    NSData *data = [image g8_normalizedData];
    NSData *originalData = [self g8_normalizedData];
    return [originalData isEqualToData:data];
}

- (NSData*)g8_normalizedData
{
    const CGSize pixelSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    UIGraphicsBeginImageContext(pixelSize);
    [self drawInRect:CGRectMake(0, 0, pixelSize.width, pixelSize.height)];
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(drawnImage);
}

@end
