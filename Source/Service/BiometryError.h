//
//  BiometryError.h
//  
//
//  Created by Anton Belousov on 13.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiometryError : NSObject
+ (BOOL)biometryIsLockout:(NSError *)error;
+ (BOOL)processCancelled:(NSError *)error;
+ (BOOL)userFalledBack:(NSError *)error;
+ (BOOL)biometryIsNotAvailable:(NSError *)error;
+ (NSString *)recoverySuggestionErrorKey:(NSError *)error;
@end
