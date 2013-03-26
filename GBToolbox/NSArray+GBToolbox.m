//
//  NSArray+GBToolbox.m
//  GBToolbox
//
//  Created by Luka Mirosevic on 20/03/2013.
//  Copyright (c) 2013 Luka Mirosevic. All rights reserved.
//

#import "NSArray+GBToolbox.h"

@implementation NSArray (GBToolbox)

//returns a random object from the array
-(id)randomObject {
    NSUInteger count = self.count;
    
    if (count > 0) {
        return self[arc4random_uniform(count)];
    }
    else {
        return nil;
    }
}

//map function from functional programming
-(NSArray *)map:(id(^)(id object))function {
    NSUInteger count = self.count;
    
    // creates a results array in which to store results, sets the capacity for faster writes
    NSMutableArray *resultsArray = [[NSMutableArray alloc] initWithCapacity:count];
    
    // applies the function to each item and stores the result in the new array
    for (NSUInteger i=0; i<count; i++) {
        resultsArray[i] = function(self[i]);
    }
    
    // returns an immutable copy
    return [resultsArray copy];
}

@end