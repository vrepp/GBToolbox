//
//  UIView+GBPopUp.m
//  GBToolbox
//
//  Created by Luka Mirosevic on 08/07/2013.
//  Copyright (c) 2013 Luka Mirosevic. All rights reserved.
//

#import "UIView+GBPopUp.h"

#import "GBMacros_Common.h"
#import "GBTypes_Common.h"

static CGFloat const kAnimationDuration =                       0.25;

//storage object to help us with memory management and so we don't have too many associative references
@interface GBPopUpStorage : NSObject

@property (assign, nonatomic) BOOL                              isPresentedAsPopUp;
@property (strong, nonatomic) UIView                            *curtainView;
@property (strong, nonatomic) UIView                            *containerView;

@end

@implementation GBPopUpStorage
@end


//the actual class
@interface UIView ()

@property (strong, nonatomic, readonly) GBPopUpStorage          *storage;
@property (assign, nonatomic, readwrite) BOOL                   isPresentedAsPopUp;
@property (strong, nonatomic, readonly) UIView                  *curtainView;
@property (strong, nonatomic, readonly) UIView                  *containerView;

@property (strong, nonatomic) GBPopUpStorage                    *internalStorage;

@end

@implementation UIView (GBPopUp)

_associatedObject(strong, nonatomic, GBPopUpStorage *, internalStorage, setInternalStorage);

#pragma mark - ca

-(GBPopUpStorage *)storage {
    if (!self.internalStorage) {
        self.internalStorage = [GBPopUpStorage new];
    }
    
    return self.internalStorage;
}

-(void)setIsPresentedAsPopUp:(BOOL)isPresentedAsPopUp {
    self.storage.isPresentedAsPopUp = isPresentedAsPopUp;
}

-(BOOL)isPresentedAsPopUp {
    return self.storage.isPresentedAsPopUp;
}

-(void)setPopUpBackgroundColor:(UIColor *)popUpBackgroundColor {
    self.curtainView.backgroundColor = popUpBackgroundColor;
}

-(UIColor *)popUpBackgroundColor {
    return self.curtainView.backgroundColor;
}

-(UIView *)curtainView {
    if (!self.storage.curtainView) {
        self.storage.curtainView = [UIView new];
        self.storage.curtainView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return self.storage.curtainView;
}

-(UIView *)containerView {
    if (!self.storage.containerView) {
        //style self
        self.storage.containerView = [UIView new];
        self.storage.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.storage.containerView.backgroundColor = [UIColor clearColor];
        self.storage.containerView.userInteractionEnabled = YES;
        
        //add curtain to container
        self.storage.curtainView.frame = self.storage.containerView.bounds;
        [self.storage.containerView addSubview:self.storage.curtainView];
    }
    
    return self.storage.containerView;
}

#pragma mark - API

-(void)presentAsPopUpOnWindowAnimated:(BOOL)animated {
    UIView *window = [[UIApplication sharedApplication] keyWindow];
    [self presentAsPopUpOnView:window animated:animated];
}

-(void)presentAsPopUpOnView:(UIView *)targetView animated:(BOOL)animated {
    if (!self.isPresentedAsPopUp) {
        //bail if bad arguments
        if (!targetView) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Must provide non nil targetView" userInfo:nil];
        
        //start keyboard listening
        [self _startListeningForKeyboardChanges];
        
        //add the container view
        self.containerView.alpha = 0;
        [targetView addSubview:self.containerView];
        
        //handle container view frame so it covers the target
        [self _handleContainerViewFrame];
        
        //update curtain view frame, so it matches the container
        [self _handleCurtainViewFrame];
        
        //handle our own frame
        [self _handleOwnFrame];
        
        //add ourselves
        [self.containerView addSubview:self];
        
        VoidBlock actionsBlock = ^{
            self.containerView.alpha = 1;
        };
        
        if (animated) {
            [UIView animateWithDuration:kAnimationDuration animations:actionsBlock completion:nil];
        }
        else {
            actionsBlock();
        }
        
        //set this immediately
        self.isPresentedAsPopUp = YES;
    }
}

-(void)dismissWithAnimation:(GBPopUpAnimation)animationType {
    [self dismissWithAnimation:animationType animated:YES];
}

-(void)dismissWithAnimation:(GBPopUpAnimation)animationType animated:(BOOL)animated {
    if (self.isPresentedAsPopUp) {
        //start keyboard listening
        [self _stopListeningForKeyboardChanges];
        
        VoidBlock actionsBlock;
        
        switch (animationType) {
            case GBPopUpAnimationFlyUp: {
                actionsBlock = ^{
                    self.frame = CGRectMake(self.frame.origin.x,
                                            0 - self.frame.size.height,
                                            self.frame.size.width,
                                            self.frame.size.height);
                    self.containerView.alpha = 0;
                };
            } break;
                
            case GBPopUpAnimationFadeAway: {
                actionsBlock = ^{
                    self.containerView.alpha = 0;
                };
            } break;
        }

        
        VoidBlock completionBlock = ^{
            //remove ourselves from the container
            [self removeFromSuperview];
            
            //remove the container view
            [self.containerView removeFromSuperview];
        };
        
        //perform the actual stuff
        if (animated) {
            [UIView animateWithDuration:kAnimationDuration animations:actionsBlock completion:^(BOOL finished) {completionBlock();}];
        }
        else {
            actionsBlock();
            completionBlock();
        }
        
        //no longer presented
        self.isPresentedAsPopUp = NO;
    }
}

-(void)dismissAsPopUpAnimated:(BOOL)animated {
    [self dismissWithAnimation:GBPopUpAnimationFadeAway animated:animated];
}

#pragma mark - keyboard util

-(void)_startListeningForKeyboardChanges {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_GBPopUp_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_GBPopUp_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)_stopListeningForKeyboardChanges {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)_GBPopUp_keyboardWillShow:(NSNotification *)notification {
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    CGPoint targetCenter = CGPointMake(self.containerView.center.x,
                                       self.containerView.center.y - (keyboardFrame.size.height * 0.5));
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        self.center = targetCenter;
    } completion:nil];
}

-(void)_GBPopUp_keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    CGPoint targetCenter = CGPointMake(self.containerView.center.x,
                                       self.containerView.center.y);
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        self.center = targetCenter;
    } completion:nil];
}

#pragma mark - util

-(void)_handleOwnFrame {
    //set our positioning mask
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    //just centers ourselves
    self.center = self.storage.containerView.center;
}

-(void)_handleContainerViewFrame {
    self.storage.containerView.frame = self.storage.containerView.superview.bounds;
}

-(void)_handleCurtainViewFrame {
    self.storage.curtainView.frame = self.storage.curtainView.superview.bounds;
}

@end