//
//  ForgetPasswordVC.swift
//  WEMU
//
//  Created by Arun Halder on 05/09/22.
//

import UIKit

class ForgetPasswordVC: UIViewController,UITextFieldDelegate, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    
    @IBOutlet weak var txtfld_Email: UITextField!
    @IBOutlet weak var transparentVw: NSLayoutConstraint!

    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: false)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @IBAction func SendOtpBtnAction(_ sender: UIButton) {
        
        var emailStr = ""
        
        if (UITextField.validateAll(textFields: [txtfld_Email])){
            
            if txtfld_Email.text!.isValidEmail{
                emailStr = txtfld_Email.text!
                    
                    if (NetworkState().isInternetAvailable) {
                        HUD.show(to: self.view)
                        AuthService.instance.ForgetPasswordAPI(emailStr: emailStr, completion: {(success, data, message) in
                            if success{
                                HUD.hide(to: self.view)
                                let alert = UIAlertController(title: "WEMO", message: "\(message!)", preferredStyle: UIAlertController.Style.alert)

                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                      print("Handle Ok logic here")
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "OtpValificationVC") as! OtpValificationVC
                                    vc.emailStr = emailStr
                                    vc.navFrom = "forgetPwd"
                                    self.navigationController?.pushViewController(vc,animated: false)
                                }))
                                self.present(alert, animated: true, completion: nil)
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
                        HUD.hide(to: self.view)
                        //self.showAlert(message: "No Active Internet")
                        let customAlert = RTCustomAlert()
                        customAlert.alertMessage = "No Active Internet"
                        customAlert.delegate = self
                        customAlert.show()
                    }
                    
            }
            else{
                //self.showAlert(message: "Please enter a valid email address")
                let customAlert = RTCustomAlert()
                customAlert.alertMessage = "Please enter a valid email address"
                customAlert.delegate = self
                customAlert.show()
            }
        }
        else{
            //self.showAlert(message: "Email field is empty")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Email field is empty"
            customAlert.delegate = self
            customAlert.show()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        txtfld_Email.attributedPlaceholder = NSAttributedString(
            string: "Email Id",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            view.addGestureRecognizer(tap)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 0) {
            self.transparentVw.constant = 200.0
            }
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.transparentVw.constant = 0.0
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
}
