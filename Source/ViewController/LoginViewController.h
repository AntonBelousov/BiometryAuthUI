//
//  LoginViewController.h
//  
//
//  Created by Anton Belousov on 03/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiometryService.h"
#import "KeychainPasscodeService.h"

@interface LoginViewController : UIViewController
@property (nonatomic, copy, nullable) void (^successCompletionBlock)(void);
@property (nonatomic, copy, nullable) void (^failCompletionBlock)(NSError *);
@property (nonatomic, copy, nullable) void (^didExitBiometryCheckState)(void);
@property (nonatomic, copy, nullable) void (^didEnterBiometryCheckState)(void);
@property (nonatomic) BOOL useBiometry;
@property (nonatomic) BOOL shouldAskForBiometryOnDidAppear;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) KeychainPasscodeService *passcodeService;
@property (nonatomic, strong) BiometryService *biometryService;
- (instancetype _Nonnull)init;
@end
