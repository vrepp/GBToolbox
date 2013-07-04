//
//  NSString+GBToolbox.h
//  GBToolbox
//
//  Created by Luka Mirosevic on 05/02/2013.
//  Copyright (c) 2013 Luka Mirosevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GBToolbox)

#define GBStringUtilsLocalDNSSuffixes @{@"local", @"lan", @"group"}

//check if string is integer
-(BOOL)isInteger;

//check if it contains a substring
-(BOOL)containsSubstring:(NSString *)substring; //this is case sensitive
-(BOOL)containsSubstring:(NSString *)substring caseSensitive:(BOOL)isCaseSensitive;

//returns yes if the receiver equals any of the strings in the strings array
-(BOOL)isEqualToOneOf:(NSArray *)strings;

//deletes DNS suffix in a string. requires 10.7+
-(NSString *)stringByDeletingDNSSuffix;

//checks to see if a string is an IP. requires 10.7+
-(BOOL)isIp;

//best attempt to get int out of string
-(int)attemptConversionToInt;

@end
