//
//  OtpValificationvc.swift
//  WEMU
//
//  Created by Arun Halder on 05/09/22.
//

import UIKit
import SVPinView


class OtpValificationVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    
    // connect the textfields outlets
    @IBOutlet weak var firstDigitField: SingleDigitField!
    @IBOutlet weak var secondDigitField: SingleDigitField!
    @IBOutlet weak var thirdDigitField: SingleDigitField!
    @IBOutlet weak var fourthDigitField: SingleDigitField!
    @IBOutlet weak var transparentVw: NSLayoutConstraint!

    var emailStr = ""
    var pinStr = ""
    var navFrom = ""
    var subcriptionValue = ""
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: false)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @IBAction func ResendOtpBtnAction(_ sender: UIButton) {
        if (NetworkState().isInternetAvailable) {
            HUD.show(to: self.view)
            AuthService.instance.ForgetPasswordAPI(emailStr: emailStr, completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)
                    //self.showAlert(message: message!)
                    let customAlert = RTCustomAlert()
                    customAlert.alertMessage = "\(message!)"
                    customAlert.delegate = self
                    customAlert.show()
                }
                else{
                    HUD.hide(to: self.view)
                    //self.showAlert(message: message!)
                    let customAlert = RTCustomAlert()
                    customAlert.alertMessage = "\(message!)"
                    customAlert.delegate = self
                    customAlert.show()
                }
        })
        }
        else{
           // self.showAlert(message: "No Active Internet")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "No Active Internet"
            customAlert.delegate = self
            customAlert.show()
        }

    }
    @IBAction func SubmitBtnAction(_ sender: UIButton) {
        
        if self.pinStr != ""{
            
            HUD.show(to: self.view)
            AuthService.instance.VerifyOtpAPI(emailStr: emailStr, otpStr: pinStr,completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)
                    let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:{(_: UIAlertAction!) in
                                                    
                        if self.navFrom == "reg"{
                            if self.subcriptionValue == "0"{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                self.navigationController?.pushViewController(vc,animated: false)
                            }
                            else{
                                let storyboard = UIStoryboard(name: "Albam", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
                                vc.navFrom = "otp"
                                self.navigationController?.pushViewController(vc,animated: false)
                            }
                        }
                        else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                            vc.emailStr = self.emailStr
                            self.navigationController?.pushViewController(vc,animated: false)
                        }
                    } ))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else{
                    HUD.hide(to: self.view)
                    print(message!)
                    //self.showAlert(message: message!)
                    let customAlert = RTCustomAlert()
                    customAlert.alertMessage = "\(message!)"
                    customAlert.delegate = self
                    customAlert.show()
                    
                }
            })
        }
        else{
            //self.showAlert(message: "Pin entry incomplete")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Pin entry incomplete"
            customAlert.delegate = self
            customAlert.show()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.configurePinView()
       // self.dismissKeyboard()
        
        // add a target for editing changed for each field
                [firstDigitField,secondDigitField,thirdDigitField,fourthDigitField].forEach {
                    $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
                }
                // make the firsDigitField the first responder
                firstDigitField.isUserInteractionEnabled = true
                firstDigitField.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            view.addGestureRecognizer(tap)

            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
    }
    
            // here you control what happens to each change that occurs to the fields
    @objc func editingChanged(_ textField: SingleDigitField) {
                // check if the deleteBackwards key was pressed
        print("Editing Change")
                self.transparentVw.constant = 200.0
                if textField.pressedDelete {
                    // reset its state
                    textField.pressedDelete = false
                    // if the field has text empty its content
                    if textField.hasText {
                        textField.text = ""
                    } else {
                        // otherwise switch the field, resign the first responder and activate the previous field and empty its contents
                        switch textField {
                        case secondDigitField, thirdDigitField, fourthDigitField:
                            textField.resignFirstResponder()
                            textField.isUserInteractionEnabled = false
                            switch textField {
                            case secondDigitField:
                                firstDigitField.isUserInteractionEnabled = true
                                firstDigitField.becomeFirstResponder()
                                firstDigitField.text = ""
                            case thirdDigitField:
                                secondDigitField.isUserInteractionEnabled = true
                                secondDigitField.becomeFirstResponder()
                                secondDigitField.text = ""
                            case fourthDigitField:
                                thirdDigitField.isUserInteractionEnabled = true
                                thirdDigitField.becomeFirstResponder()
                                thirdDigitField.text = ""
                            default:
                                break
                            }
                        default: break
                        }
                    }
                }
                // make sure there is only one character and it is a number otherwise delete its contents
                guard textField.text?.count == 1, textField.text?.last?.isWholeNumber == true else {
                    textField.text = ""
                    return
                }
                // switch the textField, resign the first responder and make the next field active
                switch textField {
                case firstDigitField, secondDigitField, thirdDigitField:
                    textField.resignFirstResponder()
                   // textField.isUserInteractionEnabled = false
                    switch textField {
                    case firstDigitField:
                        secondDigitField.isUserInteractionEnabled = true
                        secondDigitField.becomeFirstResponder()
                    case secondDigitField:
                        thirdDigitField.isUserInteractionEnabled = true
                        thirdDigitField.becomeFirstResponder()
                    case thirdDigitField:
                        fourthDigitField.isUserInteractionEnabled = true
                        fourthDigitField.becomeFirstResponder()
                    default: break
                    }
                case fourthDigitField:
                    fourthDigitField.resignFirstResponder()
                   let pin = " \(firstDigitField.text!)\(secondDigitField.text!)\(thirdDigitField.text!)\(fourthDigitField.text!)"
                    print(pin)
                    self.pinStr = pin
                    self.transparentVw.constant = 0.0

                default: break
                }
            }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("text Field Did Begin Editing")

        if (textField.tag == 1) {
            self.transparentVw.constant = 200.0
            }
        else if (textField.tag == 2) {
                self.transparentVw.constant = 200.0
        }
        else if (textField.tag == 3) {
                self.transparentVw.constant = 200.0
        }
        else if (textField.tag == 4) {
                self.transparentVw.constant = 200.0
        }
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.transparentVw.constant = 0.0
    }
    
//    func configurePinView() {
//        pinView.pinLength = 4
//        pinView.secureCharacter = "\u{25CF}"
//        pinView.interSpace = 10
//        pinView.textColor = UIColor.black
//        pinView.borderLineColor = UIColor.black
//        pinView.activeBorderLineColor = UIColor.black
//        pinView.borderLineThickness = 1
//        pinView.shouldSecureText = true
//        pinView.allowsWhitespaces = false
//        pinView.style = .underline
//        pinView.fieldBackgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
//        pinView.activeFieldBackgroundColor = UIColor.systemGreen.withAlphaComponent(0.4)
//        pinView.fieldCornerRadius = 15
//        pinView.activeFieldCornerRadius = 15
//       // pinView.placeholder = "******"
//        pinView.deleteButtonAction = .deleteCurrentAndMoveToPrevious
//        pinView.keyboardAppearance = .default
//        pinView.tintColor = .black
//        pinView.becomeFirstResponderAtIndex = 0
//        pinView.shouldDismissKeyboardOnEmptyFirstField = false
//
//
//        pinView.font = UIFont.systemFont(ofSize: 20)
//        pinView.keyboardType = .phonePad
//        pinView.pinInputAccessoryView = { () -> UIView in
//            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
//            doneToolbar.barStyle = UIBarStyle.black
//            doneToolbar.tintColor = UIColor.black
//            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//            let done: UIBarButtonItem  = UIBarButtonItem(title: "DONE", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
//            done.tintColor = .white
//
//            var items = [UIBarButtonItem]()
//            items.append(flexSpace)
//            items.append(done)
//
//            doneToolbar.items = items
//            doneToolbar.sizeToFit()
//            return doneToolbar
//        }()
//
//       // pinView.didFinishCallback = didFinishEnteringPin(pin:)
//        pinView.didChangeCallback = { pin in
//            print("The entered pin is \(pin)")
//        }
//    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    

}


class SingleDigitField: UITextField {
    // create a boolean property to hold the deleteBackward info
    var pressedDelete = false
    // customize the text field as you wish
    override func willMove(toSuperview newSuperview: UIView?) {
        keyboardType = .numberPad
        textAlignment = .center
        backgroundColor = .clear
        isSecureTextEntry = false
        isUserInteractionEnabled = true
    }
    // hide cursor
    override func caretRect(for position: UITextPosition) -> CGRect { .zero }
    // hide selection
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { [] }
    // disable copy paste
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool { false }
    // override deleteBackward method, set the property value to true and send an action for editingChanged
    override func deleteBackward() {
        pressedDelete = true
        sendActions(for: .editingChanged)
    }
}

