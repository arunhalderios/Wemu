//
//  ResetPassword.swift
//  WEMU
//
//  Created by Arun Halder on 05/09/22.
//

import UIKit

class ResetPasswordVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    @IBOutlet weak var txtFld_Password: UITextField!
    @IBOutlet weak var txtFld_ConfirmPassword: UITextField!
    @IBOutlet weak var imgPwdEye: UIImageView!
    @IBOutlet weak var imgConfirmPwdEye: UIImageView!
    @IBOutlet weak var transparentVw: NSLayoutConstraint!
    var showPassword = false
    var showConfirmPassword = false
    
    var emailStr = ""
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: false)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @IBAction func pwdEyeBtnAction(_ sender: UIButton) {
        if showPassword == false{
            self.showPassword = true
            self.txtFld_Password.isSecureTextEntry = false
            self.imgPwdEye.image = UIImage(named: "eyePwd")
        }else{
            self.showPassword = false
            self.txtFld_Password.isSecureTextEntry = true
            self.imgPwdEye.image = UIImage(named: "openEye")

        }
    }
    
    @IBAction func confirmPwdEyeBtnAction(_ sender: UIButton) {
        if showConfirmPassword == false{
            self.showConfirmPassword = true
            self.txtFld_ConfirmPassword.isSecureTextEntry = false
            self.imgConfirmPwdEye.image = UIImage(named: "eyePwd")
        }else{
            self.showConfirmPassword = false
            self.txtFld_ConfirmPassword.isSecureTextEntry = true
            self.imgConfirmPwdEye.image = UIImage(named: "openEye")

        }
    }
    
    @IBAction func SaveBtnAction(_ sender: UIButton) {
        var passwordStr = ""
        var confirmPasswordStr = ""
        
        if (UITextField.validateAll(textFields: [txtFld_Password])) {
            if (txtFld_Password.text!.count > 7 && txtFld_Password.text!.count < 17) {
                passwordStr = txtFld_Password.text!
                if (UITextField.validateAll(textFields: [txtFld_ConfirmPassword])) {
                    confirmPasswordStr = txtFld_ConfirmPassword.text!
                    
                    if passwordStr == confirmPasswordStr{
                        
                        AuthService.instance.ResetPasswordAPI(emailStr: emailStr, passwordStr: passwordStr, password_confirmationStr: confirmPasswordStr, completion: {(success, data, message) in
                            if success{
                                
                                
                                let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)

                                alert.addAction(UIAlertAction(title: "Ok",style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
                                                                        
                                                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                    self.navigationController?.pushViewController(vc,animated: false)

                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                
                            }else{
                                //print(message)
                            }
                        })
                    }else{
                        //self.showAlert(message: "Password & Confirm Password field is empty")
                        let customAlert = RTCustomAlert()
                        customAlert.alertMessage = "Password & Confirm Password field is empty"
                        customAlert.delegate = self
                        customAlert.show()
                    }

                }
                else{
                    //self.showAlert(message: "Password field is empty")
                    let customAlert = RTCustomAlert()
                    customAlert.alertMessage = "Password field is empty"
                    customAlert.delegate = self
                    customAlert.show()
                }
                
            }
            else{
                //self.showAlert(message: "Password is less than 8")
                let customAlert = RTCustomAlert()
                customAlert.alertMessage = "Password is less than 8"
                customAlert.delegate = self
                customAlert.show()
            }
        }
        else{
            //self.showAlert(message: "Password field is empty")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Password field is empty"
            customAlert.delegate = self
            customAlert.show()
        }

   }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFld_Password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_ConfirmPassword.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
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
