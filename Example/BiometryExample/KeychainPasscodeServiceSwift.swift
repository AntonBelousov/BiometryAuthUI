//
//  _KeychainPasscodeService.swift
//  BiometryExample
//
//  Created by Anton Belousov on 01/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

import UIKit
import BiometryAuthUI

enum KeychainResult {
    case success
    case fail(Int)
    var success: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    var fail: Bool {
        if case .fail = self {
            return true
        }
        return false
    }
}


internal
class KeychainPasscodeServiceSwift: KeychainPasscodeService {
    
    let serviceName: String
    override init!(serviceName: String! = "KeychainPasscodeService") {
        self.serviceName = serviceName
        super.init(serviceName: serviceName)
    }
    
    func _passcodeIsSet() -> KeychainResult {
        let getAttributes: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: "password",
            kSecReturnData: true
        ]
        
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(getAttributes, &extractedData)
        if status == errSecSuccess {
            let resData = extractedData as? Data
            return resData != nil ? .success : .fail(-1)
        }
        return .fail(Int(status))
    }
    
    func _passcodeIsSet() -> Bool {
        return _passcodeIsSet().success
    }
    
    override func savePasscode(_ password: String!) {
        super.savePasscode(password)
    }
    
    override func deletePasscode() {
        super.deletePasscode()
    }
    
    override func checkPasscode(_ password: String!) -> Bool {
        return super.checkPasscode(password)
    }
}
