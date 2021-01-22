# BiometryAuthUI
This is a ready-to-use UI for working with touchID/faceID/pincode auth

# Installation
pod 'BiometryAuthUI'

# Usage

NOTE. The app's Info.plist must contain an NSFaceIDUsageDescription key with a string value explaining to the user how the app uses this data
![plist](https://github.com/AntonBelousov/Assets/blob/master/biometry_info_plist.png)

## Set passcode

```

// delete current passcode if needed
// let service = KeychainPasscodeService()
// service?.deletePasscode()

// BiometryUIModule will use your localization (see Example/BiometryExample.xcworkspace)
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
```

![set passcode](https://github.com/AntonBelousov/Assets/blob/master/biomery_set_passcode.gif)

## Authorization

```
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
```
![auth_faceid](https://github.com/AntonBelousov/Assets/blob/master/biometry_check_faceId.gif)
![auth_passcode](https://github.com/AntonBelousov/Assets/blob/master/biometry_check_passcode.gif)
![auth_touchid](https://github.com/AntonBelousov/Assets/blob/master/biometry_check_touchID.gif)

