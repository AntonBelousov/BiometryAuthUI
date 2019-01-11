//
//  BiometryService.m
//  
//
//  Created by Anton Belousov on 13.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import "BiometryService.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "BiometryError.h"
#import "BiometryUIModule+private.h"
#import "BiometryUIModule.h"

@interface BiometryService ()
@property (nonatomic, strong) LAContext *context;
@property (nonatomic, strong) NSString  *localizedReason;
@end

@implementation BiometryService

- (instancetype)init {
    if (self = [self initWithLocalizedReason:[BiometryUIModule.shared localizedStringWithKey:@"Biometry.LocalizedReason.Default"]]) {
        // Custom init
    }
    return self;
}

- (instancetype)initWithLocalizedReason:(NSString *)localizedReason {
    if (self = [super init]) {
        self.reuseDuration = 0;
        [self resetState];
        _localizedReason = localizedReason;
        _fallbackButtonTitle = @""; // No fallback button by default;
    }
    return self;
}

- (void)resetState {
    _context = [[LAContext alloc] init];
    _context.touchIDAuthenticationAllowableReuseDuration = self.reuseDuration;
}

- (BiometryType)biometryType {
    NSError *error;
    BOOL canEvaluate = [self canEvaluateBiometry:&error];
    if (@available(iOS 11.0, *)) {
        switch (_context.biometryType) {
            case LABiometryTypeNone:
                return BiometryTypeNone;
            case LABiometryTypeTouchID:
                return BiometryTypeTouchID;
            case LABiometryTypeFaceID:
                return BiometryTypeFaceID;
        }
    } else {
        if (canEvaluate) {
            return BiometryTypeTouchID;
        }
        return BiometryTypeNone;
    }
}

- (BOOL)canEvaluateBiometry:(NSError **)error {
    return [_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics  error:error];
}

- (void)evaluateBiometry:(void(^)(BOOL success, NSError * __nullable error))reply {
    
    void (^replyInMain)(BOOL, NSError *) = ^(BOOL success, NSError * __nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            reply(success, error);
        });
    };
    
    _context.localizedFallbackTitle = _fallbackButtonTitle;
    [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
             localizedReason:_localizedReason
                       reply:^(BOOL success, NSError * _Nullable error) {
                           
                           if ([BiometryError biometryIsLockout:error] && self.allowDevicePasswordWhenBiometryLockout) {
                               [self evaluateDevicePasscode:replyInMain];
                           } else if ([BiometryError processCancelled:error]) {
                               if (self.callbackWhenCancel) {
                                   replyInMain(success, error);
                               }
                           } else if ([BiometryError userFalledBack:error]) {
                               if (self.callbackWhenFallback){
                                   replyInMain(success, error);
                               }
                           } else {
                               replyInMain(success, error);
                           }
                       }];
}

- (void)evaluateDevicePasscode:(void(^)(BOOL success, NSError * __nullable error))reply {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"" reply:reply];
    });
}

@end
