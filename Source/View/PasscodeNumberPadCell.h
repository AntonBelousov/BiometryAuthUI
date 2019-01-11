//
//  PasscodeInputViewCell.h
//  
//
//  Created by Anton Belousov on 12.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiometryType.h"

@interface PasscodeNumberPadCell : UICollectionViewCell
- (void)configureWithNumber:(NSInteger)number;
- (void)configureAsBiometryButtonForType:(BiometryType)biometryType;
- (void)configureAsBackspace;
- (void)configureAsHiddenCell;
@end
