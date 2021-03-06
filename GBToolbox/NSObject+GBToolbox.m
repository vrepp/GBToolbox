//
//  NSObject+GBToolbox.m
//  GBToolbox
//
//  Created by Luka Mirosevic on 05/02/2013.
//  Copyright (c) 2013 Luka Mirosevic. All rights reserved.
//

#import "NSObject+GBToolbox.h"

#import "GBMacros_Common.h"

@interface NSObject ()

@property (strong, nonatomic, readwrite) NSMapTable *GBPayloadMap_storage;

@end

@implementation NSObject (GBToolbox)

_associatedObject(strong, nonatomic, id, GBPayload, setGBPayload)

_associatedObject(strong, nonatomic, NSMapTable *, GBPayloadMap_storage, setGBPayloadMap_storage)

- (NSMapTable *)GBPayloadMap {
    if (!self.GBPayloadMap_storage) {
        self.GBPayloadMap_storage = [NSMapTable strongToStrongObjectsMapTable];
    }
    
    return self.GBPayloadMap_storage;
}

- (NSString *)pointerAddress {
    return [NSString stringWithFormat:@"%p", self];
}

- (instancetype)tap:(void (^)(id object))block {
    if (block) block(self);
    
    return self;
}

// http://stackoverflow.com/a/38759825/399772
+ (SEL)getterForPropertyWithName:(NSString *)name {
    const char *propertyName = [name cStringUsingEncoding:NSASCIIStringEncoding];
    objc_property_t prop = class_getProperty(self, propertyName);
    
    const char *selectorName = property_copyAttributeValue(prop, "G");
    if (selectorName == NULL) {
        selectorName = [name cStringUsingEncoding:NSASCIIStringEncoding];
    }
    NSString *selectorString = [NSString stringWithCString:selectorName encoding:NSASCIIStringEncoding];
    return NSSelectorFromString(selectorString);
}

// http://stackoverflow.com/a/38759825/399772
+ (SEL)setterForPropertyWithName:(NSString *)name {
    const char *propertyName = [name cStringUsingEncoding:NSASCIIStringEncoding];
    objc_property_t prop = class_getProperty(self, propertyName);
    
    char *selectorName = property_copyAttributeValue(prop, "S");
    NSString *selectorString;
    if (selectorName == NULL) {
        char firstChar = (char)toupper(propertyName[0]);
        NSString *capitalLetter = [NSString stringWithFormat:@"%c", firstChar];
        NSString *reminder      = [NSString stringWithCString: propertyName+1
                                                     encoding: NSASCIIStringEncoding];
        selectorString = [@[@"set", capitalLetter, reminder, @":"] componentsJoinedByString:@""];
    } else {
        selectorString = [NSString stringWithCString:selectorName encoding:NSASCIIStringEncoding];
    }
    
    return NSSelectorFromString(selectorString);
}

@end
