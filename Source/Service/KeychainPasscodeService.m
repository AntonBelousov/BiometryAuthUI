//
//  KeychainPasscodeService.m
//  
//
//  Created by Anton Belousov on 01/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

#import "KeychainPasscodeService.h"

@implementation KeychainPasscodeService {
    NSString *_serviceName;
}

- (instancetype)init {
    if (self = [self initWithServiceName:@"KeychainPasscodeService"]) {}
    return self;
}

- (instancetype)initWithServiceName:(NSString *)serviceName {
    if (self = [super init]) {
        _serviceName = serviceName;
    }
    return self;
}

- (void)savePasscode:(NSString *)password {
    
    [self deletePasscode];
    
    CFErrorRef error = NULL;
    SecAccessControlRef sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                    kSecAttrAccessibleWhenUnlocked,
                                                                    kSecAccessControlApplicationPassword, &error);
    if (sacObject == NULL || error != NULL) {
        NSString *errorString = [NSString stringWithFormat:@"SecItemAdd can't create sacObject: %@", error];
        NSLog(@"%s[%d], %@", __PRETTY_FUNCTION__, __LINE__, errorString);
        return;
    }
    
    
    NSData *secretPasswordTextData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *attributes = @{
                                 (id)kSecClass: (id)kSecClassGenericPassword,
                                 (id)kSecAttrService: _serviceName,
                                 (id)kSecAttrAccount: @"password",
                                 (id)kSecValueData: secretPasswordTextData,
                                 };
    
    OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
    NSLog(@"%s[%d], %@", __PRETTY_FUNCTION__, __LINE__, status == errSecSuccess ? @"success" : @"fail");
}

- (BOOL)checkPasscode:(NSString *)password {
    NSDictionary *getAttributes = @{
                                    (id)kSecClass: (id)kSecClassGenericPassword,
                                    (id)kSecAttrService: _serviceName,
                                    (id)kSecAttrAccount: @"password",
                                    (id)kSecReturnData: @YES,
                                    };
    
    CFTypeRef extractedData;
    
    OSStatus getStatus = SecItemCopyMatching((__bridge CFDictionaryRef)getAttributes,&extractedData);
    if (getStatus == errSecSuccess){
        NSData * resData = (__bridge NSData *)(extractedData);
        if (resData != nil){
            NSString *result = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(extractedData) encoding:NSUTF8StringEncoding];
            NSLog(@"%s[%d], result: %@", __PRETTY_FUNCTION__, __LINE__,  result);
            return [result isEqualToString:password];
        }
        return NO;
    }
    if (getStatus == errSecItemNotFound) {
        NSLog(@"%s[%d], item not found", __PRETTY_FUNCTION__, __LINE__);
        return NO;
    }
    NSLog(@"%s[%d], fail, status: %d", __PRETTY_FUNCTION__, __LINE__, (int)getStatus);
    return NO;
}

- (void)deletePasscode{
    
    NSDictionary *deleteAttributes = @{
                                       (id)kSecClass: (id)kSecClassGenericPassword,
                                       (id)kSecAttrService: _serviceName,
                                       (id)kSecAttrAccount: @"password",
                                       (id)kSecReturnData: @NO,
                                       };
    
    OSStatus delete_status =  SecItemDelete((__bridge CFDictionaryRef)deleteAttributes);
    
    if (delete_status == errSecSuccess || delete_status == errSecItemNotFound) {
        return; //YES;
    }
    return;// NO;
}

- (BOOL)passcodeIsSet {
    NSDictionary *getAttributes = @{
                                    (id)kSecClass: (id)kSecClassGenericPassword,
                                    (id)kSecAttrService: _serviceName,
                                    (id)kSecAttrAccount: @"password",
                                    (id)kSecReturnData: @YES,
                                    };
    CFTypeRef extractedData;
    
    OSStatus getStatus = SecItemCopyMatching((__bridge CFDictionaryRef)getAttributes,&extractedData);
    if (getStatus == errSecSuccess){
        NSData * resData = (__bridge NSData *)(extractedData);
        return resData != nil;
    }
    if (getStatus == errSecItemNotFound) {
        return NO;
    }
    return NO;
}
@end
