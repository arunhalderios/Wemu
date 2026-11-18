//
//  SignUpVC.swift
//  WEMU
//
//  Created by Arun Halder on 05/09/22.
//

import UIKit

class SignUpVC: UIViewController,UITextFieldDelegate, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    
    @IBOutlet weak var txtFld_Name: UITextField!
    @IBOutlet weak var txtFld_EmailAddress: UITextField!
    @IBOutlet weak var txtFld_DOB: UITextField!
    
    @IBOutlet weak var txtFld_UserName: UITextField!
    @IBOutlet weak var txtFld_Password: UITextField!
    @IBOutlet weak var txtFld_ConfirmPassword: UITextField!
    
    @IBOutlet weak var imgMaleTick: UIImageView!
    @IBOutlet weak var imgFemaleTick: UIImageView!
    @IBOutlet weak var imgNonBinaryTick: UIImageView!
    
    @IBOutlet weak var imgVwBasicSubTick: UIImageView!
    @IBOutlet weak var imgVwPremiumSubTick: UIImageView!
    @IBOutlet weak var imgVwTermConTick: UIImageView!
    
    @IBOutlet weak var imgPwdEye: UIImageView!
    @IBOutlet weak var imgConfirmPwdEye: UIImageView!
    var showPassword = false
    var showConfirmPassword = false
    var subscriptionStr = ""
    var termAndConditions = false
    var gender = ""
    var date = ""

    @IBAction func dateSelectAction(_ sender: UIButton) {
        RPicker.selectDate(title: "Select date of birth", cancelText: "Cancel", datePickerMode: .date, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self!.date = selectedDate.dateString("dd-MM-YYYY")
            print(selectedDate.dateString("dd-MM-YYYY"))
            self!.txtFld_DOB.text = self!.date
        })
    }
    
    @IBAction func maleBtnAction(_ sender: UIButton) {
        self.imgMaleTick.isHidden = false
        self.imgFemaleTick.isHidden = true
        self.imgNonBinaryTick.isHidden = true
        self.gender = "Male"
    }
    @IBAction func femaleBtnAction(_ sender: UIButton) {
        self.imgMaleTick.isHidden = true
        self.imgFemaleTick.isHidden = false
        self.imgNonBinaryTick.isHidden = true
        self.gender = "Female"
    }
    
    @IBAction func nonBinaryBtnAction(_ sender: UIButton) {
        self.imgMaleTick.isHidden = true
        self.imgFemaleTick.isHidden = true
        self.imgNonBinaryTick.isHidden = false
        self.gender = "Non-Binary"
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
    
    @IBAction func basicSubscritionBtnAction(_ sender: UIButton) {
        self.imgVwBasicSubTick.isHidden = false
        self.imgVwPremiumSubTick.isHidden = true
        self.subscriptionStr = "0"
        AuthService.instance.isSubcriptionApply = false
    }
    
    @IBAction func premiumSubcriptionBtnAction(_ sender: UIButton) {
        self.imgVwBasicSubTick.isHidden = true
        self.imgVwPremiumSubTick.isHidden = false
        self.subscriptionStr = "1"
        AuthService.instance.isSubcriptionApply = true

    }
    
    @IBAction func termConBtnAction(_ sender: UIButton) {
        if termAndConditions == false{
            self.termAndConditions = true
            self.imgVwTermConTick.isHidden = false
        }else{
            self.termAndConditions = false
            self.imgVwTermConTick.isHidden = true
        }
    }
    
    @IBAction func termandConBtnAction(_ sender: UIButton) {
        guard let url = URL(string: "https://wemu.online/terms/terms") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    

    
    @IBAction func SignUpBtnAction(_ sender: UIButton) {
        
        var nameStr = ""
        var emailStr = ""
        var dob = ""
        var userNameStr = ""
        var passwordStr = ""
        var confirmPasswordStr = ""

        if ((txtFld_Name.text?.count) != nil) {
            nameStr = txtFld_Name.text!
            
            if (UITextField.validateAll(textFields: [txtFld_UserName])){
                userNameStr = txtFld_UserName.text!
                
                if txtFld_EmailAddress.text!.isValidEmail{
                    emailStr = txtFld_EmailAddress.text!
                    
                    //if (UITextField.validateAll(textFields: [txtFld_DOB])) {
                        dob = txtFld_DOB.text!
                        
                        if (UITextField.validateAll(textFields: [txtFld_Password])) {
                            if (txtFld_Password.text!.count > 7 && txtFld_Password.text!.count < 17) {
                                passwordStr = txtFld_Password.text!
                                
                                if (UITextField.validateAll(textFields: [txtFld_ConfirmPassword])) {
                                    confirmPasswordStr = txtFld_ConfirmPassword.text!
                                    
                                    if passwordStr == confirmPasswordStr{
                                        
                                        if self.termAndConditions == true{
                                            
                                            HUD.show(to: self.view)
                                            AuthService.instance.RegistrationAPI(nameStr: nameStr, emailStr: emailStr, passwordStr: passwordStr, dobStr: dob,genderStr:self.gender , usernameStr: userNameStr, password_confirmationStr: confirmPasswordStr, subscriptionStr: "0", completion: {(success, data, message) in
                                                if success{
                                                    HUD.hide(to: self.view)
                                                    let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)

                                                
                                                    alert.addAction(UIAlertAction(title: "Ok",
                                                                                  style: UIAlertAction.Style.default,
                                                                                          handler: {(_: UIAlertAction!) in
                                                                                            //Sign out action
                                                                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                                                            let vc = storyboard.instantiateViewController(withIdentifier: "OtpValificationVC") as! OtpValificationVC
                                                                                            vc.emailStr = emailStr
                                                                                            vc.navFrom = "reg"
                                                                                            vc.subcriptionValue = self.subscriptionStr
                                                                                            self.navigationController?.pushViewController(vc,animated: true)

                                                            }))
                                                            self.present(alert, animated: true, completion: nil)
                                                    
                                                }else{
                                                    HUD.hide(to: self.view)
                                                    let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)

                                                
                                                    alert.addAction(UIAlertAction(title: "Ok",
                                                                                  style: UIAlertAction.Style.default,
                                                                                          handler: nil))
                                                    self.present(alert, animated: true, completion: nil)
                                                }
                                            })
                                            
                                        }
                                        else{
                                            let customAlert = RTCustomAlert()
                                            customAlert.alertMessage = "Please select the check box"
                                            customAlert.delegate = self
                                            customAlert.show()
                                        }

                                    }else{
                                        //self.showAlert(message: "Password & Confirm Password field is empty")
                                        let customAlert = RTCustomAlert()
                                        customAlert.alertMessage = "Password & Confirm Password field is empty"
                                        customAlert.delegate = self
                                        customAlert.show()
                                        
                                    }
                                }
                                else{
                                    //self.showAlert(message: "Confirm Password field is empty")
                                    let customAlert = RTCustomAlert()
                                    customAlert.alertMessage = "Confirm Password field is empty"
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
                        
//                    }
//                    else{
//                        //self.showAlert(message: "Select the Date of Birth field")
//                        let customAlert = RTCustomAlert()
//                        customAlert.alertMessage = "Select the Date of Birth field"
//                        customAlert.delegate = self
//                        customAlert.show()
//                    }
                }
                else{
                    //self.showAlert(message: "Enter a valid email address")
                    let customAlert = RTCustomAlert()
                    customAlert.alertMessage = "Enter a valid email address"
                    customAlert.delegate = self
                    customAlert.show()
                }
            }
            
             else{
                //self.showAlert(message: "User name field is empty")
                 let customAlert = RTCustomAlert()
                 customAlert.alertMessage = "User name field is empty"
                 customAlert.delegate = self
                 customAlert.show()
            }
        }
        else{
            //self.showAlert(message: "Name field is empty")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Name field is empty"
            customAlert.delegate = self
            customAlert.show()

        }
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc,animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtFld_Name.attributedPlaceholder = NSAttributedString(
            string: "Full Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_EmailAddress.attributedPlaceholder = NSAttributedString(
            string: "Email Address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_DOB.attributedPlaceholder = NSAttributedString(
            string: "Date Of Birth",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_UserName.attributedPlaceholder = NSAttributedString(
            string: "User Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_Password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_ConfirmPassword.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //UITextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    

    

}
