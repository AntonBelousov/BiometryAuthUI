//
//  BiometryUIModule.m
//
//
//  Created by Anton Belousov on 03/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

#import "BiometryUIModule.h"
#import "BiometryUIModule+private.h"

@implementation BiometryUIModule
+ (instancetype)shared {
    static BiometryUIModule *sharedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[BiometryUIModule alloc] init];
    });
    return sharedHelper;
}

- (NSString *)localizedStringWithKey:(NSString *)key {
    return NSLocalizedStringFromTable(key, self.localizationTable, @"");
}

@end
