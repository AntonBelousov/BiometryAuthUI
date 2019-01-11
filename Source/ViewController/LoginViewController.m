//
//  LoginViewController.m
//  
//
//  Created by Anton Belousov on 03/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

#import "LoginViewController.h"
#import "BiometryError.h"
#import "PasscodeNumberPad.h"
#import "PasscodeInputProgressView.h"
#import "BiometryUIModule.h"
#import "BiometryUIModule+private.h"

@interface LoginViewController () <PasscodeNumberPadDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet PasscodeNumberPad *passcodeNumberPad;
@property (nonatomic, weak) IBOutlet PasscodeInputProgressView *passcodeInputProgressView;
@property (nonatomic) NSInteger passcodeRequiredLength;
@property (nonatomic, strong) NSMutableString *passcode;
@end

@implementation LoginViewController

- (instancetype)init {
    if (self = [super initWithNibName:@"LoginViewController" bundle:[NSBundle bundleForClass:self.class]]) {
        _useBiometry = YES;
        _passcodeService = [KeychainPasscodeService new];
        _biometryService = [BiometryService new];
        _passcodeRequiredLength = 4;
        
        __weak typeof(self) wSelf = self;
        _failCompletionBlock = ^(NSError *error) {
            if (wSelf == nil) { return; }
            __strong typeof(wSelf) sSelf = wSelf;
            UIAlertController *alert;
            NSString *message = error.localizedDescription;
            NSString *recoverySuggestion = [BiometryError recoverySuggestionErrorKey:error];
           
            if (recoverySuggestion != nil) {
                message = [message stringByAppendingFormat:@"\n%@", recoverySuggestion];
            }
            
            alert = [UIAlertController alertControllerWithTitle:[BiometryUIModule.shared
                                                                 localizedStringWithKey:@"LoginViewController.Auth.Fail.Alert.Title"]
                                                        message:message
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:[BiometryUIModule.shared
                                                             localizedStringWithKey:@"LoginViewController.Auth.Fail.Alert.OK"]
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            
            [sSelf presentViewController:alert animated:YES completion:nil];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = [BiometryUIModule.shared
                        localizedStringWithKey:@"LoginViewController.Title"];
    _passcodeNumberPad.biometryType = _useBiometry ? _biometryService.biometryType : BiometryTypeNone;
    _passcodeNumberPad.delegate     = self;
    _passcode                       = [NSMutableString string];
    
    _passcodeNumberPad.tintColor = _tintColor;
    _passcodeInputProgressView.tintColor = _tintColor;
    _titleLabel.textColor = _tintColor;
    
    self.view.backgroundColor = _backgroundColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_shouldAskForBiometryOnDidAppear) {
        [self askForBiometry];
    }
}

#pragma mark -

- (void)refreshUI {
    if (_passcode.length == 0) {
        _passcodeNumberPad.deleteBackwardsButtonHidden = YES;
    }
    _passcodeInputProgressView.currentPasscodeLength = _passcode.length;
}

- (void)askForBiometry {
    _biometryService.callbackWhenCancel = NO;
    _biometryService.callbackWhenFallback = NO;
    
    if (self.didEnterBiometryCheckState) {
        self.didEnterBiometryCheckState();
    }
    __weak typeof(self) wSelf = self;
    [_biometryService evaluateBiometry:^(BOOL success, NSError * _Nullable error) {
        if (wSelf == nil) { return; }
        __strong typeof(wSelf) sSelf = wSelf;
        if (success) {
            sSelf.passcodeInputProgressView.currentPasscodeLength = sSelf.passcodeRequiredLength;
            if (sSelf.successCompletionBlock) {
                sSelf.successCompletionBlock();
            }
        } else  {
            if (sSelf.failCompletionBlock) {
                sSelf.failCompletionBlock(error);
            }
        }
        if (sSelf.didExitBiometryCheckState) {
            sSelf.didExitBiometryCheckState();
        }
    }];
}

#pragma mark -

- (void)setUseBiometry:(BOOL)useBiometry {
    _useBiometry = useBiometry;
    _passcodeNumberPad.biometryType = _useBiometry ? _biometryService.biometryType : BiometryTypeNone;
}

#pragma mark - PasscodeNumberPadDelegate

- (void)passcodeNumberPadDidSelectBiometry {
    [self askForBiometry];
}

- (void)passcodeNumberPadDidSelectNumber:(NSInteger)number {
    if (_passcode.length == _passcodeRequiredLength) {
        return;
    }
    
    [_passcode appendString:@(number).stringValue];
    _passcodeNumberPad.deleteBackwardsButtonHidden = NO;
    
    _passcodeInputProgressView.currentPasscodeLength = _passcode.length;
    
    if (self.passcode.length == self.passcodeRequiredLength) {
        if ([self.passcodeService checkPasscode:self.passcode]) {
            if (self.successCompletionBlock) {
                self.successCompletionBlock();
            }
        } else {
            [self.passcodeInputProgressView shake];
            self.passcode = [NSMutableString string];
            [self refreshUI];
        }
    }
}

- (void)passcodeNumberPadShouldDeleteBacwards {
    if (_passcode.length > 0) {
        [_passcode deleteCharactersInRange:NSMakeRange(_passcode.length - 1, 1)];
    }
    [self refreshUI];
}

@end
