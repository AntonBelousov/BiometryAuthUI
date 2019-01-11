//
//  NewPasscodeViewController.m
//  
//
//  Created by Anton Belousov on 11.03.2018.
//  Copyright © 2018 ab. All rights reserved.
//

#import "NewPasscodeViewController.h"
#import "BiometryService.h"
#import "BiometryError.h"
#import "PasscodeNumberPad.h"
#import "PasscodeInputProgressView.h"
#import "BiometryUIModule.h"
#import "BiometryUIModule+private.h"

@interface NewPasscodeViewController () <PasscodeNumberPadDelegate>
@property (nonatomic, weak) IBOutlet UILabel                   *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel                   *passcodesDoNotMatchLabel;
@property (nonatomic, weak) IBOutlet PasscodeNumberPad         *passcodeNumberPad;
@property (nonatomic, weak) IBOutlet PasscodeInputProgressView *passcodeInputProgressView;
@property (nonatomic, weak) IBOutlet PasscodeInputProgressView *passcodeConfirmationInputProgressView;
@property (nonatomic) NSInteger         step;
@property (nonatomic) NSMutableString   *passcode;
@property (nonatomic) NSMutableString   *passcodeComfirmation;
@end

@implementation NewPasscodeViewController

- (instancetype)init {
    if (self = [super initWithNibName:@"NewPasscodeViewController" bundle:[NSBundle bundleForClass:self.class]]) {
        _passcodeRequiredLength = 4;
        _passcodeService = [KeychainPasscodeService new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _passcodeNumberPad.biometryType = BiometryTypeNone;
    _passcodeNumberPad.delegate     = self;
    
    [UIView performWithoutAnimation:^{
        self.passcodesDoNotMatchLabel.hidden = YES;
        self.step = 0;
    }];
    self.view.clipsToBounds = YES;
    
    _titleLabel.textColor = _tintColor;
    _passcodeNumberPad.tintColor = _tintColor;
    _passcodeInputProgressView.tintColor = _tintColor;
    _passcodeConfirmationInputProgressView.tintColor = _tintColor;
    self.view.backgroundColor = _backgroundColor;
    _passcodesDoNotMatchLabel.text = [BiometryUIModule.shared localizedStringWithKey:@"NewPasscodeViewController.DoesNotMatch.Title"];
}

- (void)setStep:(NSInteger)step {

    _step = step;
 
    if (step == 0) { // Input passcode
        _passcode = [NSMutableString string];
        _passcodeNumberPad.deleteBackwardsButtonHidden = YES;
        _passcodeInputProgressView.currentPasscodeLength = 0;
        _titleLabel.text = [BiometryUIModule.shared localizedStringWithKey:@"NewPasscodeViewController.Title.Default"];// @"Create access code";
        [UIView animateWithDuration:0.3 delay:0.3 options:kNilOptions animations:^{
            self.passcodeInputProgressView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.passcodeConfirmationInputProgressView.transform = CGAffineTransformMakeTranslation(300, 0);
        } completion:nil];
    } else { // Input passcode confirmation
        _passcodesDoNotMatchLabel.hidden = YES;
        _passcodeComfirmation = [NSMutableString string];
        _passcodeNumberPad.deleteBackwardsButtonHidden = YES;
        _passcodeConfirmationInputProgressView.currentPasscodeLength = 0;
        _titleLabel.text = [BiometryUIModule.shared localizedStringWithKey:@"NewPasscodeViewController.Title.Confirmation"];
        
        [UIView animateWithDuration:0.3 delay:0.3 options:kNilOptions animations:^{
            self.passcodeInputProgressView.transform = CGAffineTransformMakeTranslation(-300, 0);
            self.passcodeConfirmationInputProgressView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
    }
}

#pragma mark -
#pragma mark - PasscodeNumberPadDelegate

- (void)passcodeNumberPadDidSelectBiometry {
    return;
}

- (void)passcodeNumberPadDidSelectNumber:(NSInteger)number {
    if (self.step == 0) {
        [self addToPasscode:number];
    } else {
        [self addToConfirmationPasscode:number];
    }
}

- (void)passcodeNumberPadShouldDeleteBacwards {
    if (self.step == 0) {
        [self deletePasswordBackwards];
    } else {
        [self deletePasswordConfirmationBackwards];
    }
}

#pragma mark -

- (void)addToPasscode:(NSInteger)number {
    if (_passcode.length == _passcodeRequiredLength) {
        return;
    }

    [_passcode appendString:@(number).stringValue];
    _passcodeNumberPad.deleteBackwardsButtonHidden = NO;
    
    _passcodeInputProgressView.currentPasscodeLength = _passcode.length;
    if (_passcode.length == _passcodeRequiredLength) {
        self.step = 1;
    }
}

- (void)addToConfirmationPasscode:(NSInteger)number {
    if (_passcodeComfirmation.length == _passcodeRequiredLength) {
        return;
    }
    
    [_passcodeComfirmation appendString:@(number).stringValue];
    _passcodeNumberPad.deleteBackwardsButtonHidden = NO;
    
    _passcodeConfirmationInputProgressView.currentPasscodeLength = _passcodeComfirmation.length;

    if (_passcodeComfirmation.length == _passcodeRequiredLength) {
        if ([_passcodeComfirmation isEqualToString:_passcode]) {
            [self.passcodeService savePasscode:_passcode];
            if (self.passcodeCompletionBlock) {
                self.passcodeCompletionBlock();
            }
        } else {
            _passcodesDoNotMatchLabel.hidden = NO;
            self.step = 0;
        }
    }
}

- (void)deletePasswordBackwards {
    if (_passcode.length > 0) {
        [_passcode deleteCharactersInRange:NSMakeRange(_passcode.length - 1, 1)];
    }
    if (_passcode.length == 0) {
        _passcodeNumberPad.deleteBackwardsButtonHidden = YES;
    }
    _passcodeInputProgressView.currentPasscodeLength = _passcode.length;
}

- (void)deletePasswordConfirmationBackwards {
    if (_passcodeComfirmation.length > 0) {
        [_passcodeComfirmation deleteCharactersInRange:NSMakeRange(_passcodeComfirmation.length - 1, 1)];
    }
    if (_passcodeComfirmation.length == 0) {
        _passcodeNumberPad.deleteBackwardsButtonHidden = YES;
    }
    _passcodeConfirmationInputProgressView.currentPasscodeLength = _passcodeComfirmation.length;
}

@end
