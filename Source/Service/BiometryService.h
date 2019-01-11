//
//  BiometryService.h
//  
//
//  Created by Anton Belousov on 13.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BiometryType.h"

@interface BiometryService : NSObject
@property (nonatomic, readonly) BiometryType biometryType;
@property (nonatomic)           BOOL allowDevicePasswordWhenBiometryLockout;
@property (nonatomic)           BOOL callbackWhenCancel;
@property (nonatomic)           BOOL callbackWhenFallback;
@property (nonatomic, copy)     NSString *fallbackButtonTitle;
@property (nonatomic)           NSTimeInterval reuseDuration;

- (instancetype)init;
- (instancetype)initWithLocalizedReason:(NSString *)localizedReason;

- (void)resetState;
- (BOOL)canEvaluateBiometry:(NSError **)error;
- (void)evaluateBiometry:(void(^)(BOOL success, NSError * error))reply;

@end
