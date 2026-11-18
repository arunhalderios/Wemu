//
//  SettingsVC.swift
//  WEMU
//
//  Created by Arun Halder on 12/09/22.
//

import UIKit
import iOSDropDown


class SettingsVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    @IBOutlet var vw_Background: UIView!

    @IBOutlet weak var txtFld_UserName: UITextField!
    @IBOutlet weak var txtFld_Email: UITextField!
    @IBOutlet weak var txtFld_Country: DropDown!
    
    @IBOutlet weak var txtFld_Age: UITextField!
    @IBOutlet weak var txtFld_Gender: DropDown!
    
    @IBOutlet weak var txtFld_FullName: UITextField!

 //   @IBOutlet weak var txtFld_FaceBookUserName: UITextField!
    @IBOutlet weak var txtFld_Website: UITextField!
//    @IBOutlet weak var txtFld_CurrentPassword: UITextField!
//    @IBOutlet weak var txtFld_NewPassword: UITextField!
//    @IBOutlet weak var txtFld_RepeatNewPassword: UITextField!
//
//    @IBOutlet weak var txtFld_CurrentPasswordForDelectAccount: UITextField!
    
    let genderListArray = ["Male", "Female", "Non-Binary"]
    var localCountryListArray = [String]()
    var localCountryIDListArray = [Int]()
    var localCountryIdStr = ""
    
    var countryIDStr = ""
    var ageStr = ""
    var genderStr = ""
    var fullNameStr = ""
    var aboutMeStr = ""
   // var facebookStr = ""
    var websiteStr = ""
    

    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(vc,animated: true)
    }
    
    func validate(textView textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            // this will be reached if the text is nil (unlikely)
            // or if the text only contains white spaces
            // or no text at all
            return false
        }

        return true
    }

    @IBAction func saveDeleteAccountBtnAction(_ sender: UIButton) {


                if (UITextField.validateAll(textFields: [txtFld_Country])) {
//                    countryStr = "\(localCountryIdStr)"
                    if (UITextField.validateAll(textFields: [txtFld_Age])) {
                        ageStr = txtFld_Age.text!
                        if (UITextField.validateAll(textFields: [txtFld_Gender])) {
                            genderStr = txtFld_Gender.text!
                            if (UITextField.validateAll(textFields: [txtFld_FullName])) {
                                fullNameStr = txtFld_FullName.text!
                                //if validate(textView: txtVw_AboutMe) {
                                //    aboutMeStr = txtVw_AboutMe.text!
//                                    if (UITextField.validateAll(textFields: [txtFld_FaceBookUserName])) {
//                                        facebookStr = txtFld_FaceBookUserName.text!
                                        if (UITextField.validateAll(textFields: [txtFld_Website])) {
                                            websiteStr = txtFld_Website.text!
                                                HUD.show(to: self.view)
                                            AuthService.instance.UpdateGeneralSettingAPI(country_idStr: self.countryIDStr, genderStr: genderStr, ageStr: ageStr, nameStr: fullNameStr, aboutStr: "test", websiteStr: websiteStr,completion: {(success, data, message) in
                                                    if success{
                                                        HUD.hide(to: self.view)
                                                        //self.showAlert(message: message!)
                                                        let customAlert = RTCustomAlert()
                                                        customAlert.alertMessage = "\(message!)"
                                                        customAlert.delegate = self
                                                        customAlert.show()
                                                    }else{
                                                        //print(message)
                                                        HUD.hide(to: self.view)
                                                    }
                                                })

                                        }
                                        else{
                                           // self.showAlert(message: "Website field is empty")
                                            let customAlert = RTCustomAlert()
                                            customAlert.alertMessage = "Website field is empty"
                                            customAlert.delegate = self
                                            customAlert.show()

                                        }

//                                    }
//                                    else{
//                                        //self.showAlert(message: "Facebook field is empty")
//                                        let customAlert = RTCustomAlert()
//                                        customAlert.alertMessage = "Facebook field is empty"
//                                        customAlert.delegate = self
//                                        customAlert.show()
//
//                                    }

//                                }
//                                else{
//                                    self.showAlert(message: "About Me field is empty")
//
//                                }

                            }

                        }
                        else{
                            //self.showAlert(message: "Gender field is empty")
                            let customAlert = RTCustomAlert()
                            customAlert.alertMessage = "Gender field is empty"
                            customAlert.delegate = self
                            customAlert.show()

                        }

                    }
                    else{
                        //self.showAlert(message: "Age field is empty")
                        let customAlert = RTCustomAlert()
                        customAlert.alertMessage = "Age field is empty"
                        customAlert.delegate = self
                        customAlert.show()

                    }

                }
                else{
                    //self.showAlert(message: "Country field is empty")
                    let customAlert = RTCustomAlert()
                    customAlert.alertMessage = "Country field is empty"
                    customAlert.delegate = self
                    customAlert.show()

                }

            
    }
    
    //    @IBAction func saveGeneralSettingsBtnAction(_ sender: UIButton) {
    //        var countryStr = ""
    //        var ageStr = ""
    //        var genderStr = ""
    //
    //                if (UITextField.validateAll(textFields: [txtFld_Country])) {
    //                    countryStr = txtFld_Country.text!
    //                    if (UITextField.validateAll(textFields: [txtFld_Age])) {
    //                        ageStr = txtFld_Age.text!
    //                        if (UITextField.validateAll(textFields: [txtFld_Gender])) {
    //                            genderStr = txtFld_Gender.text!
    //                                                HUD.show(to: self.view)
    //                                                AuthService.instance.UpdateGeneralSettingAPI(country_idStr: countryStr, genderStr: genderStr, ageStr: ageStr,completion: {(success, data, message) in
    //                                                    if success{
    //                                                        HUD.hide(to: self.view)
    //                                                        self.showAlert(message: message!)
    //                                                    }else{
    //                                                        //print(message)
    //                                                        HUD.hide(to: self.view)
    //                                                    }
    //                                                })
    //
    //                        }
    //                        else{
    //                            self.showAlert(message: "User Name field is empty")
    //
    //                        }
    //
    //                    }
    //                    else{
    //                        self.showAlert(message: "Age field is empty")
    //
    //                    }
    //
    //                }
    //                else{
    //                    self.showAlert(message: "Country field is empty")
    //
    //                }
    //
    //
    //    }
    //
    //    @IBAction func saveProfileSettingsBtnAction(_ sender: UIButton) {
    //
    //        var fullNameStr = ""
    //        var aboutMeStr = ""
    //        var facebookStr = ""
    //        var websiteStr = ""
    //                            if (UITextField.validateAll(textFields: [txtFld_FullName])) {
    //                                fullNameStr = txtFld_FullName.text!
    //                                if (UITextField.validateAll(textFields: [txtFld_AboutMe])) {
    //                                    aboutMeStr = txtFld_AboutMe.text!
    //                                    if (UITextField.validateAll(textFields: [txtFld_FaceBookUserName])) {
    //                                        facebookStr = txtFld_FaceBookUserName.text!
    //                                        if (UITextField.validateAll(textFields: [txtFld_Website])) {
    //                                            websiteStr = txtFld_Website.text!
    //                                                HUD.show(to: self.view)
    //                                                AuthService.instance.UpdateProfileSettingAPI(nameStr: fullNameStr, aboutStr: aboutMeStr, facebookStr: facebookStr, websiteStr: websiteStr,completion: {(success, data, message) in
    //                                                    if success{
    //                                                        HUD.hide(to: self.view)
    //                                                        self.showAlert(message: message!)
    //                                                    }else{
    //                                                        //print(message)
    //                                                        HUD.hide(to: self.view)
    //                                                    }
    //                                                })
    //
    //                                        }
    //                                        else{
    //                                            self.showAlert(message: "Website field is empty")
    //
    //                                        }
    //
    //                                    }
    //                                    else{
    //                                        self.showAlert(message: "About Me field is empty")
    //
    //                                    }
    //
    //                                }
    //                                else{
    //                                    self.showAlert(message: "User Name field is empty")
    //
    //                                }
    //
    //                            }
    //
    //
    //
    //    }
    //    @IBAction func saveChangePasswordBtnAction(_ sender: UIButton) {
    //    }
    //    @IBAction func saveInterestSettingsBtnAction(_ sender: UIButton) {
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFld_UserName.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_Email.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_Country.attributedPlaceholder = NSAttributedString(
            string: "Country",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_Age.attributedPlaceholder = NSAttributedString(
            string: "Age",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_Gender.attributedPlaceholder = NSAttributedString(
            string: "Gender",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        txtFld_FullName.attributedPlaceholder = NSAttributedString(
            string: "Full Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )

//        txtFld_FaceBookUserName.attributedPlaceholder = NSAttributedString(
//            string: "Facebook Username",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
        txtFld_Website.attributedPlaceholder = NSAttributedString(
            string: "Website",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
//        txtFld_CurrentPassword.attributedPlaceholder = NSAttributedString(
//            string: "Current Password",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//        txtFld_NewPassword.attributedPlaceholder = NSAttributedString(
//            string: "New Password",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//        txtFld_RepeatNewPassword.attributedPlaceholder = NSAttributedString(
//            string: "Repeat New Password",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
//        txtFld_CurrentPasswordForDelectAccount.attributedPlaceholder = NSAttributedString(
//            string: "Current Password",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//        )
        
        
        self.MyProfileAPICall()
        self.CountryListAPICall()

        // Do any additional setup after loading the view.
        
        //On select from dropdown
       txtFld_Country.didSelect{(selectedText , index , id) in
           self.txtFld_Country.text = "\(selectedText)"
           self.countryIDStr = "\(id)"
       }
        txtFld_Country.arrowSize = 12
        
        
        txtFld_Gender.optionArray = genderListArray
         //On select from dropdown
        txtFld_Gender.didSelect{(selectedText , index , id) in
            self.txtFld_Gender.text = "\(selectedText)"
        }
        txtFld_Gender.arrowSize = 12
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        }
    }
        

    
    func MyProfileAPICall(){
        if (NetworkState().isInternetAvailable) {
        HUD.show(to: self.view)
        AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
            HUD.hide(to: self.view)

            if success{
                self.txtFld_UserName.text = "\(AuthService.instance.username!)"
                self.txtFld_Email.text = "\(AuthService.instance.email!)"
                self.txtFld_Gender.text = "\(AuthService.instance.gender!)"
                self.txtFld_FullName.text = "\(AuthService.instance.name!)"
                //self.txtVw_AboutMe.text = "\(AuthService.instance.aboutMe)"
                self.txtFld_Age.text = "\(AuthService.instance.age)"
               // self.txtFld_FaceBookUserName.text = "\(AuthService.instance.facebook)"
                self.txtFld_Website.text = "\(AuthService.instance.website)"
              //  let countryId = "\(AuthService.instance.countryId)".codingKey.intValue
                self.txtFld_Country.text = "\(AuthService.instance.countryName)"
                self.countryIDStr = "\(AuthService.instance.countryId)"
                HUD.hide(to: self.view)

            }else{
                //print(message)
                HUD.hide(to: self.view)

            }
        })
        }
        else{
            //self.showAlert(message: "No Active Internet")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "No Active Internet"
            customAlert.delegate = self
            customAlert.show()
            HUD.hide(to: self.view)

        }
    }
    
    func CountryListAPICall(){
        if (NetworkState().isInternetAvailable) {
        HUD.show(to: self.view)
        AuthService.instance.countryListAPI(completion: {(success, data, message) in
            HUD.hide(to: self.view)

            if success{
                let totalVal = AuthService.instance.countryListArray
                self.localCountryIDListArray.removeAll()
                self.localCountryIDListArray.removeAll()
                var i = 0
                while(i < totalVal.count){
                    self.localCountryListArray.append(AuthService.instance.countryListArray[i]["name"].stringValue)
                    self.localCountryIDListArray.append(AuthService.instance.countryListArray[i]["id"].intValue)
                    i += 1
                }
                self.txtFld_Country.optionArray = self.localCountryListArray
                self.txtFld_Country.optionIds = self.localCountryIDListArray
                HUD.hide(to: self.view)
            }else{
                //print(message)
                HUD.hide(to: self.view)

            }
        })
        }
        else{
            //self.showAlert(message: "No Active Internet")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "No Active Internet"
            customAlert.delegate = self
            customAlert.show()
            HUD.hide(to: self.view)

        }
    }
    

    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
