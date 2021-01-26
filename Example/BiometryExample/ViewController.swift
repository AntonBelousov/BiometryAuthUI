//
//  ViewController.swift
//  Localization
//
//  Created by Anton Belousov on 01/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

import UIKit
import BiometryAuthUI

class ViewController: UIViewController {
    
    @IBAction func showLoginUI(_ sender: Any) {
    
        BiometryUIModule.shared().localizationTable = "Localization"
        
        let vc = LoginViewController()
        vc.tintColor = UIColor.white
        vc.backgroundColor = UIColor.black
        vc.shouldAskForBiometryOnDidAppear = true
        vc.successCompletionBlock = {
            [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.dismiss(animated: true, completion: {
                    [weak self] in
                    let alert = UIAlertController(title: "Success auth", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                })
            })
        }
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func showNewPasscodeUI(_ sender: Any) {
        let service = KeychainPasscodeService()
        service?.deletePasscode()
        
        BiometryUIModule.shared().localizationTable = "Localization"
        
        let vc = NewPasscodeViewController()
        vc.tintColor = UIColor.red
        vc.backgroundColor = UIColor.white
        vc.passcodeCompletionBlock = {
            [weak self] in
            self?.dismiss(animated: true, completion: {
                [weak self] in
                let alert = UIAlertController(title: "Passcode created", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            })
        }
        self.present(vc, animated: true, completion: nil)
    }
}

