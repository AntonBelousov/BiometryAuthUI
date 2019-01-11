//
//  KeychainPasscodeService.h
//  
//
//  Created by Anton Belousov on 01/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainPasscodeService : NSObject
- (instancetype)init;
- (instancetype)initWithServiceName:(NSString *)serviceName;
- (void)savePasscode:(NSString *)password;
- (BOOL)checkPasscode:(NSString *)password;
- (void)deletePasscode;
- (BOOL)passcodeIsSet;
@end
