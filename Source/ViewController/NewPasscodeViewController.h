//
//  NewPasscodeViewController.h
//  
//
//  Created by Anton Belousov on 11.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainPasscodeService.h"

@interface NewPasscodeViewController : UIViewController
@property (nonatomic) NSInteger passcodeRequiredLength;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, copy, nullable) void (^passcodeCompletionBlock)(void);
@property (nonatomic, strong) KeychainPasscodeService *passcodeService;
@end

