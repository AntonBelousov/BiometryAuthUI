//
//  Tests.swift
//  Tests
//
//  Created by Anton Belousov on 01/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

import XCTest
@testable import BiometryExample

class Tests: XCTestCase {
    
    var service: KeychainPasscodeServiceSwift!
    
    override func setUp() {
        super.setUp()
        service = KeychainPasscodeServiceSwift()
    }
    
    override func tearDown() {
        super.tearDown()
        service.deletePasscode()
        service = nil
    }
    
    func test_passcodeIsSet_false() {
        XCTAssertFalse(service.passcodeIsSet())
    }
    
    func test_savePasscode_passcodeIsSet_true() {
        service.savePasscode("12345")
        XCTAssertTrue(service.passcodeIsSet())
    }
    
    func test_savePasscode_checkPasscode_success() {
        service.savePasscode("12345")
        XCTAssertTrue(service.checkPasscode("12345"))
    }
    
    func test_savePasscode_checkPasscode_fail() {
        service.savePasscode("12345")
        XCTAssertFalse(service.checkPasscode("54321"))
    }
    
    func test_savePasscode_deletePasscode_passcodeIsSet() {
        service.savePasscode("12345")
        service.deletePasscode()
        XCTAssertFalse(service.passcodeIsSet())
    }
    
    func test_savePasscode_deletePasscode_checkPasscode() {
        service.savePasscode("12345")
        service.deletePasscode()
        XCTAssertFalse(service.checkPasscode("12345"))
    }
}
