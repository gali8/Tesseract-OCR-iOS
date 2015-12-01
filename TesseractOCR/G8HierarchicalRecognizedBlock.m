//
//  G8HierarchicalRecognizedBlock.m
//  Tesseract OCR iOS
//
//  Created by Jürgen Mayer on 30.11.15.
//  Copyright © 2015 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8HierarchicalRecognizedBlock.h"

@implementation G8HierarchicalRecognizedBlock

- (instancetype)initWithBlock:(G8RecognizedBlock *)block {
	
	self = [super initWithText:block.text boundingBox:block.boundingBox confidence:block.confidence level:block.level];
	if(self) {
		
	}
	return self;
}


@end
