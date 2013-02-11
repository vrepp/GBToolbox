//
//  NSString+GBToolbox.m
//  GBToolbox
//
//  Created by Luka Mirosevic on 05/02/2013.
//  Copyright (c) 2013 Luka Mirosevic. All rights reserved.
//

#import "NSString+GBToolbox.h"

@implementation NSString (GBToolbox)

//check if string is an integer
-(BOOL)isInteger {
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    
    return [alphaNums isSupersetOfSet:stringSet];
}

//check if it contains a substring
-(BOOL)containsSubstring:(NSString *)substring {
    return [self containsSubstring:substring caseSensitive:YES];
}

-(BOOL)containsSubstring:(NSString *)substring caseSensitive:(BOOL)isCaseSensitive {
    return [self rangeOfString:substring options:(isCaseSensitive ? 0 : NSCaseInsensitiveSearch)].location != NSNotFound;
}

//best attempt to get int out of string
-(int)attemptConversionToInt {
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    // Result.
    return [numberString intValue];
}

-(NSString *)stringByDeletingDNSSuffix {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(([0-9a-zA-Z]+[0-9a-zA-Z-]*[0-9a-zA-Z]+|[0-9a-zA-Z]+)[.][a-zA-Z]+)$" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSRange dotRange = [self rangeOfString:@"."];
        return [self substringToIndex:dotRange.location];
    }
    else {
        return self;
    }
}

-(BOOL)isIp {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])[.]([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])[.]([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])[.]([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$" options:0 error:NULL];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        return YES;
    }
    else {
        return NO;
    }
}

@end