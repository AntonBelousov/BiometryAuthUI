//
//  BiometryError.m
//  
//
//  Created by Anton Belousov on 13.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import "BiometryError.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "BiometryService.h"
#import "BiometryUIModule.h"
#import "BiometryUIModule+private.h"

@implementation BiometryError

+ (BOOL)biometryIsLockout:(NSError *)error {
    BOOL biometryLockout = NO;
    
    if (@available(iOS 11.0, *)) {
        if (error.code == LAErrorBiometryLockout) {
            biometryLockout = YES;
        }
    } else if (error.code == LAErrorTouchIDLockout) {
        biometryLockout = YES;
    }
    return biometryLockout;
}

+ (BOOL)processCancelled:(NSError *)error {
    return error.code == LAErrorAppCancel ||
    error.code == LAErrorUserCancel ||
    error.code == LAErrorSystemCancel ||
    error.code == LAErrorUserFallback;
}

+ (BOOL)userFalledBack:(NSError *)error {
    return error.code == LAErrorUserFallback;
}

+ (BOOL)biometryNotEnrolled:(NSError *)error {
    if (@available(iOS 11.0, *)) {
        if (error.code == LAErrorBiometryNotEnrolled) {
            return YES;
        }
        return NO;
    } else {
        return error.code == LAErrorTouchIDNotEnrolled;
    }
}

+ (BOOL)biometryIsNotAvailable:(NSError *)error {
    if (@available(iOS 11.0, *)) {
        if (error.code == LAErrorBiometryNotAvailable) {
            return YES;
        }
        return NO;
    } else {
        return error.code == LAErrorTouchIDNotAvailable;
    }
}

+ (NSString *)recoverySuggestionErrorKey:(NSError *)error {
    BiometryService *service = [BiometryService new];
    
    if ([self biometryNotEnrolled:error]) {
        if (service.biometryType == BiometryTypeFaceID) {
            return [BiometryUIModule.shared localizedStringWithKey:@"BiometryError.FaceID.Disabled"];
//            return @"Go to Settings > FaceID and Passcode to enable the feature.";
        }
        return [BiometryUIModule.shared localizedStringWithKey:@"BiometryError.TouchID.Disabled"];
//        return @"Go to Settings > TouchID and Passcode to enable the feature.";
    }
    if (error.code == LAErrorPasscodeNotSet) {
        if (service.biometryType == BiometryTypeFaceID) {
            return [BiometryUIModule.shared localizedStringWithKey:@"BiometryError.FaceID.PasscodeNotSet"];
//            return @"Go to Settings > FaceID and Passcode to set passcode.";
        }
        return [BiometryUIModule.shared localizedStringWithKey:@"BiometryError.TouchID.PasscodeNotSet"];
//        return @"Go to Settings > TouchID and Passcode to enable the passcode.";
    }
    if ([self biometryIsLockout:error]) {
        return [BiometryUIModule.shared localizedStringWithKey:@"BiometryError.TooManyFailedAttempts"];
//        return @"There were too many failed biometry attempts, you could lock and unlock device and then try again";
    }
    return nil;
}

@end
