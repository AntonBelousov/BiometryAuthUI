//
//  PasscodeInputProgressView.h
//  
//
//  Created by Anton Belousov on 12.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface PasscodeInputProgressView : UIView
@property (nonatomic) IBInspectable NSInteger requiredPasscodeLength;
@property (nonatomic) IBInspectable NSInteger currentPasscodeLength;
- (void)shake;
@end
