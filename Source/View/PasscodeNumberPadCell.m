//
//  PasscodeNumberPadCell.m
//  
//
//  Created by Anton Belousov on 12.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import "PasscodeNumberPadCell.h"

@interface PasscodeNumberPadCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation PasscodeNumberPadCell {
    BOOL _cellIsEmpty;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth   = 1;
    self.layer.masksToBounds = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.height/2;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
}
    
- (void)configureWithNumber:(NSInteger)number {
    _cellIsEmpty = NO;
    self.label.hidden       = NO;
    self.iconView.hidden    = YES;
    self.layer.borderWidth  = 1;
    self.label.text         = @(number).stringValue;
}

- (void)configureAsBiometryButtonForType:(BiometryType)biometryType {
    _cellIsEmpty = NO;
    self.label.hidden      = YES;
    self.layer.borderWidth = 0;

    if (biometryType == BiometryTypeNone) {
        self.iconView.hidden = YES;
    } else {
        self.iconView.hidden = NO;
        if (biometryType == BiometryTypeFaceID) {
            self.iconView.image = [UIImage imageNamed:@"faceID"
                                             inBundle:[NSBundle bundleForClass:self.class]
                        compatibleWithTraitCollection:nil];
        } else {
            self.iconView.image = [UIImage imageNamed:@"touchID"
                                             inBundle:[NSBundle bundleForClass:self.class]
                        compatibleWithTraitCollection:nil];
        }
    }
}

- (void)configureAsBackspace {
    _cellIsEmpty = NO;
    self.label.hidden      = YES;
    self.layer.borderWidth = 0;
    self.iconView.hidden   = NO;

    self.iconView.image = [UIImage imageNamed:@"deleteBackwards"
                                     inBundle:[NSBundle bundleForClass:self.class]
                compatibleWithTraitCollection:nil];
}

- (void)configureAsHiddenCell {
    _cellIsEmpty = YES;
    self.label.hidden      = YES;
    self.layer.borderWidth = 0;
    self.iconView.hidden   = YES;
}

#pragma mark - selection/deselection state

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_cellIsEmpty) {
        self.backgroundColor = [self.tintColor colorWithAlphaComponent:0.5];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_cellIsEmpty) {
        [UIView animateWithDuration:0.16
                              delay:0.016
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.backgroundColor = UIColor.clearColor;
                         } completion:nil];
    }
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_cellIsEmpty) {
        [UIView animateWithDuration:0.16
                              delay:0.016
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.backgroundColor = UIColor.clearColor;
                         } completion:nil];
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.layer.borderColor   = self.tintColor.CGColor;//[UIColor colorWithRed:51.0/255 green:153.0/255 blue:255.0/255 alpha:1.0].CGColor;
    self.iconView.tintColor  = self.tintColor;//[UIColor colorWithRed:51.0/255 green:153.0/255 blue:255.0/255 alpha:1.0];
    self.label.textColor     = self.tintColor;
}

@end
