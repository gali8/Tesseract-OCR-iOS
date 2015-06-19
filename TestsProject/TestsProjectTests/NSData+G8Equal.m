//
//  NSData+G8Equal.m
//  TestsProject
//
//  Created by Kirill Makankov on 19.06.15.
//  Copyright (c) 2015 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "NSData+G8Equal.h"

static float const kG8MinimalSimilarity = 0.99;

@implementation NSData (G8Equal)

- (float)g8_similarityWithData:(NSData *)data {
  
  NSUInteger numDifferences = 0;
  NSUInteger totalCompares = self.length;
  
  char *selfBytes = (char*)self.bytes;
  char *otherBytes = (char*)data.bytes;
  for (unsigned int i = 0; i < totalCompares; i++) {
    if (selfBytes[i] != otherBytes[i]) {
      numDifferences++;
    }
  }
  
  return 1.0 - (float)numDifferences / totalCompares;
}

- (BOOL)g8_isEqualToData:(NSData *)data {
  
  if (self == data) {
    return YES;
  }
  
  float similarity = [self g8_similarityWithData:data];
  return similarity > kG8MinimalSimilarity;
}

@end
