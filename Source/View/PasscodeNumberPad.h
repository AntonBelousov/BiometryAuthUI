//
//  PasscodeNumberPad.h
//  
//
//  Created by Anton Belousov on 12.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiometryType.h"

@protocol PasscodeNumberPadDelegate;

IB_DESIGNABLE
@interface PasscodeNumberPad: UIView
@property (nonatomic, weak) id<PasscodeNumberPadDelegate> delegate;
@property (nonatomic) IBInspectable BiometryType biometryType;
@property (nonatomic) IBInspectable BOOL deleteBackwardsButtonHidden;
@end

@protocol PasscodeNumberPadDelegate
- (void)passcodeNumberPadDidSelectNumber:(NSInteger)number;
- (void)passcodeNumberPadDidSelectBiometry;
- (void)passcodeNumberPadShouldDeleteBacwards;
@end
