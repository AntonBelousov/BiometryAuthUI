//
//  PasscodeInputProgressView.m
//  
//
//  Created by Anton Belousov on 12.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import "PasscodeInputProgressView.h"

@implementation PasscodeInputProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tintColor =  [UIColor colorWithRed:51.0/255 green:153.0/255 blue:255.0/255 alpha:1.0];

    _currentPasscodeLength = 0;
    _requiredPasscodeLength = 4;
    [self reload];
    
}

- (void)prepareForInterfaceBuilder {
    [self reload];
}

- (CGSize)intrinsicContentSize {
    CGSize atomicSize = self.atomicSize;
    CGFloat distance  = self.distance;
    return CGSizeMake(distance * (_requiredPasscodeLength - 1) + atomicSize.width * _requiredPasscodeLength, atomicSize.height * 2);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reload];
}

- (void)setRequiredPasscodeLength:(NSInteger)requiredPasscodeLength {
    _requiredPasscodeLength = requiredPasscodeLength;
    [self reload];
}

- (void)setCurrentPasscodeLength:(NSInteger)currentPasscodeLength {
    _currentPasscodeLength = currentPasscodeLength;
    [self reload];
}

// Size of single pin
- (CGSize)atomicSize {
    CGFloat atomicWidth  = 10;
    CGFloat atomicHeight = 10;
    return CGSizeMake(atomicWidth, atomicHeight);
}

- (CGFloat)distance {
    return 17;
}

- (void)reload {
    // Calculate size
    CGSize atomicSize = self.atomicSize;
    CGFloat distance  = self.distance;
    
    // clean
    for (UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    
    for (NSInteger index = 0; index < _requiredPasscodeLength; index += 1) {
        
        UIImageView *imageView = [self createImageView];
        
        if (index < _currentPasscodeLength) {
            imageView.backgroundColor = self.tintColor;
        } else {
            imageView.backgroundColor = UIColor.clearColor;
        }
        
        imageView.frame = CGRectMake(index * (distance + atomicSize.width),
                                     (self.frame.size.height - atomicSize.height)/2,
                                     atomicSize.width,
                                     atomicSize.height);
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
    }
}

- (UIImageView *)createImageView {
    CGSize  atomicSize = self.atomicSize;
    
    UIImageView *imageView       = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = atomicSize.width/2;
    imageView.layer.borderColor  = self.tintColor.CGColor;
    imageView.layer.borderWidth  = 1;
    imageView.clipsToBounds      = YES;
    return imageView;
}

- (void)shake {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5, 0, 0)]
                         ];
    animation.autoreverses = true;
    animation.repeatCount  = 2;
    animation.duration     = 0.07;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self reload];
}

@end
