//
//  LoginVC.swift
//  WEMU
//
//  Created by Arun Halder on 05/09/22.
//

import UIKit

class LoginVC: UIViewController,UITextFieldDelegate, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    

    @IBOutlet weak var txtfld_Email: UITextField!
    @IBOutlet weak var txtfld_Password: UITextField!
    @IBOutlet weak var imgvw_eye: UIImageView!
    
    @IBOutlet weak var vw_Loading: RoundView!
    var showPassword = false
    
    @IBOutlet weak var transparentVw: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtfld_Email.attributedPlaceholder = NSAttributedString(
            string: "Email Id",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtfld_Password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
    
//        self.txtfld_Email.text = "raj.chat1991@gmail.com"//"carlos@gmail.com"//"arunhalder.leo@gmail.com"
//        self.txtfld_Password.text = "1234567890"//"carlos123"//"1234567890"

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            view.addGestureRecognizer(tap)
        
        // Subscribe to Keyboard Will Show notifications
              NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(keyboardWillShow(_:)),
                  name: UIResponder.keyboardWillShowNotification,
                  object: nil
              )

              // Subscribe to Keyboard Will Hide notifications
              NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(keyboardWillHide(_:)),
                  name: UIResponder.keyboardWillHideNotification,
                  object: nil
              )
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 1) {
            self.transparentVw.constant = 170.0
            }
        else if (textField.tag == 2) {
                self.transparentVw.constant = 200.0
        }
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.transparentVw.constant = 0.0
    }
    
    @objc
       dynamic func keyboardWillShow(
          _ notification: NSNotification
       ) { }
       
       @objc
       dynamic func keyboardWillHide(
           _ notification: NSNotification
       ) { }
    
    
    
    @IBAction func pwdShowAction(_ sender: UIButton) {
        if showPassword == false{
            self.showPassword = true
            self.txtfld_Password.isSecureTextEntry = false
            self.imgvw_eye.image = UIImage(named: "openEye")
        }else{
            self.showPassword = false
            self.txtfld_Password.isSecureTextEntry = true
            self.imgvw_eye.image = UIImage(named: "eyePwd")

        }
        
    }
    
    
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
                
                var emailStr = ""
                var passwordStr = ""
                
                if (UITextField.validateAll(textFields: [txtfld_Email])){
                    
                    if txtfld_Email.text!.isValidEmail{
                        emailStr = txtfld_Email.text!
                        if (UITextField.validateAll(textFields: [txtfld_Password])){
                            passwordStr = txtfld_Password.text!
                            
                            if (NetworkState().isInternetAvailable) {
                                self.vw_Loading.isHidden = false
                                AuthService.instance.LoginAPI(emailStr: emailStr, passwordStr: passwordStr,completion: {(success, data, message) in
                                    if success{
                                        //HUD.hide(to: self.view)
                                        self.vw_Loading.isHidden = true
                                        //if AuthService.instance.isSubcriptionApply == false{
                                            let storyboard = UIStoryboard(name: "Account", bundle: nil)
                                            let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
                                            self.navigationController?.pushViewController(vc,animated: true)
//                                        }
//                                        else{//SubscriptionVC
//                                            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
//                                            let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
//                                            self.navigationController?.pushViewController(vc,animated: true)
//                                        }
                                    }
                                    else{
                                        //HUD.hide(to: self.view)
                                        self.vw_Loading.isHidden = true
                                        //self.showAlert(message: message!)
                                        let customAlert = RTCustomAlert()
                                        customAlert.alertMessage = "\(message!)"
                                        customAlert.delegate = self
                                        customAlert.show()
                                    }
                            })
                            }
                            else{
                                HUD.hide(to: self.view)
                                //self.showAlert(message: "No Active Internet")
                                let customAlert = RTCustomAlert()
                                customAlert.alertMessage = "No Active Internet"
                                customAlert.delegate = self
                                customAlert.show()
                                HUD.hide(to: self.view)
                            }
                            
                        }
                        else{
                            //self.showAlert(message: "Password field is empty")
                            let customAlert = RTCustomAlert()
                            customAlert.alertMessage = "Password field is empty"
                            customAlert.delegate = self
                            customAlert.show()
                            HUD.hide(to: self.view)
                        }
                        
                    }
                    else{
                        //self.showAlert(message: "Please enter a valid email address")
                        let customAlert = RTCustomAlert()
                        customAlert.alertMessage = "Please enter a valid email address"
                        customAlert.delegate = self
                        customAlert.show()
                        HUD.hide(to: self.view)
                    }
                }
                else{
                    //self.showAlert(message: "Email field is empty")
                    let customAlert = RTCustomAlert()
                    customAlert.alertMessage = "Email field is empty"
                    customAlert.delegate = self
                    customAlert.show()
                    HUD.hide(to: self.view)
                }
            }
    @IBAction func forgetPasswordBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        navigationController?.pushViewController(vc,animated: false)
    }
    

    
    
    @IBAction func signUpBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        navigationController?.pushViewController(vc,animated: true)
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension LoginVC {
    func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect) -> Void)?
    ) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!

        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        
        // Start the animation
        animator.startAnimation()
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension UITextField {

    /// Validates all text field are non-nil and non-empty, Returns true if all fields pass.
    /// - Returns: Bool
    static func validateAll(textFields:[UITextField]) -> Bool {
        // Check each field for nil and not empty.
        for field in textFields {
            // Remove space and new lines while unwrapping.
            guard let fieldText = field.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return false
            }
            // Are there no other charaters?
            if (fieldText.isEmpty) {
                return false
            }

        }
        // All fields passed.
        return true
    }



    func validateUserName(field: UITextField) -> Bool {

        guard let text:String = field.text else {
            return false
        }

        /* 3 to 12 characters, no numbers or special characters */
        let RegEx = "^[^\\d!@#£$%^&*<>()/\\\\~\\[\\]\\{\\}\\?\\_\\.\\`\\'\\,\\:\\;|\"+=-]+$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let isValid = Test.evaluate(with: text)

        if (isValid) {
            return true
        }

        return true
    }

    /*6 to 16 Characters */
    func validatePassword(field: UITextField) -> Bool{
        guard let text:String = field.text else {
            return false
        }
        /*6-16 charaters, and at least one number*/
        let RegEx = "^(?=.*\\d)(.+){6,16}$"
        let Test = NSPredicate(format:"SELF MATCHES%@", RegEx)
        let isValid = Test.evaluate(with: text)

        if (isValid) {
            return true
        }

        return true

    }
}
