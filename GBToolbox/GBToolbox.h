//
//  GBToolbox.h
//  GBToolbox
//
//  Created by Luka Mirosevic on 28/09/2012.
//  Copyright (c) 2012 Luka Mirosevic. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

//#import <Foundation/Foundation.h>
//#import <CoreGraphics/CoreGraphics.h>


/* Common imports */

#import "GBMacros_Common.h"
#import "GBUtility_Common.h"
#import "NSObject+GBToolbox.h"
#import "NSTimer+GBToolbox.h"
#import "NSData+GBToolbox.h"
#import "NSString+GBToolbox.h"
#import "CALayer+GBToolbox.h"


/* iOS imports */

#if TARGET_OS_IPHONE

#import "GBMacros_iOS.h"
#import "GBUtility_iOS.h"
#import "UITableView+GBToolbox.h"
#import "UIViewController+GBToolbox.h"
#import "UIImage+GBToolbox.h"

#endif


/* OS X imports */

#if !TARGET_OS_IPHONE

#import "GBMacros_OSX.h"
#import "GBUtility_OSX.h"
#import "GBResizableImageView.h"
#import "NSImage+GBToolbox.h"
#import "NSView+GBToolbox.h"

#endif


/* Notes */


//distill the press and hold guy from GBPingInitiatorViewController, look at the following methods:
//
//-(void)touchUp:(id)sender tapHandler:(void(^)(void))tapHandler;
//-(void)touchDown:(id)sender pressAndHoldHandler:(void(^)(void))pressAndHoldHandler;