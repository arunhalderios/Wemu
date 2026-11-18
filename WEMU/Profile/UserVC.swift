//
//  UserVC.swift
//  WEMU
//
//  Created by Arun Halder on 09/09/22.
//

import UIKit
import Kingfisher
import Photos // To fetch those asset and converted into images


class UserVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    

    
    
    @IBOutlet weak var imgVw_Back: UIImageView!
    @IBOutlet weak var imgVw_Bell: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Info: UILabel!
    @IBOutlet weak var lbl_Gender: UILabel!
    @IBOutlet weak var imgVw_UserImage: UIImageView!
    @IBOutlet weak var imgVw_BgImage: UIImageView!
    
    @IBOutlet weak var imgvw_ProMemberBatch: UIImageView!
    @IBOutlet weak var lbl_Member: UILabel!
    //image picker
    let imagePicker = UIImagePickerController()
    var capturedImageData = Data()
    var imageLocType = ""
    
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
    
    @IBAction func imageSelectionBtnAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "WEMU", message: "you going to choose image for?", preferredStyle: .actionSheet)

                alert.addAction(UIAlertAction(title: "AVATAR", style: .default, handler: { (_) in
                    print("AVATOR")
                    self.imageLocType = "avatar"
                    self.openImageSelection()

                }))

                alert.addAction(UIAlertAction(title: "COVER", style: .default, handler: { (_) in
                    print("COVER")
                    self.imageLocType = "cover"
                    self.openImageSelection()

                }))

                alert.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: { (_) in
                    print("CANCEL")
                }))
                self.present(alert, animated: true, completion: nil)
    }
    
    func openImageSelection(){
     
     let alert = UIAlertController(title: "WEMU", message: "Choose option for image selection", preferredStyle: .actionSheet)

             alert.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { (_) in
                 print("CAMERA")
                 self.openCamera()

             }))

             alert.addAction(UIAlertAction(title: "GALLERY", style: .default, handler: { (_) in
                 print("GALLERY")
                 self.openGallary()

             }))

             alert.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: { (_) in
                 print("CANCEL")
             }))
             self.present(alert, animated: true, completion: nil)
        }
    
    //MARK: Camera Function
    func openCamera()  {
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            //self.showAlert(message: "You don't have camera")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "You don't have camera"
            customAlert.delegate = self
            customAlert.show()
        }
    }
    
    func openGallary() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            if self.imageLocType == "cover"{
                self.imgVw_BgImage.image = editedImage
            }else{
                self.imgVw_UserImage.image = editedImage
            }
            
            self.capturedImageData = editedImage.jpegData(compressionQuality: 0.2)!
            
        }
        self.imageuploadAPI(capturedImage: self.capturedImageData)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageuploadAPI(capturedImage:Data){
        
        if (NetworkState().isInternetAvailable) {
            HUD.show(to: self.view)
                        
            AuthService.instance.uploadImageAPI(imgData:capturedImage, imageTypeStr: "\(self.imageLocType)" , completion:{(success, data, message) in
                if success{
                    HUD.hide(to: self.view)
                    
                    let imageurl = "\(AuthService.instance.baseImageUrl)" + "/\(AuthService.instance.coverUrl)"
                    print(imageurl)
                    let url = URL(string:"\(imageurl)")
                    self.imgVw_BgImage.kf.setImage(with: url)
                    
                    let imageurl2 = "\(AuthService.instance.baseImageUrl)" + "/\(AuthService.instance.avatarUrl)"
                    print(imageurl2)
                    let url2 = URL(string:"\(imageurl2)")
                    self.imgVw_UserImage.kf.setImage(with: url2)
                }
                else{
                    HUD.hide(to: self.view)
                   // self.showAlert(message: message!)
                }
        })
        }
        else{
            HUD.hide(to: self.view)
            //showAlert(message:"No Active Internet")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "No Active Internet"
            customAlert.delegate = self
            customAlert.show()
        }
        
    }
    

    @IBAction func editProfileBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(vc,animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.MyProfileAPICall()
        }
    }
    
    
    

    
    func MyProfileAPICall(){
        HUD.show(to: self.view)
        AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
            if success{
                HUD.hide(to: self.view)

                let imageurl = "\(AuthService.instance.baseImageUrl)" + "/\(AuthService.instance.coverUrl)"
                print(imageurl)
                let url = URL(string:"\(imageurl)")
                self.imgVw_BgImage.kf.setImage(with: url)
                
                let imageurl2 = "\(AuthService.instance.baseImageUrl)" + "/\(AuthService.instance.avatarUrl)"
                print(imageurl2)
                let url2 = URL(string:"\(imageurl2)")
                self.imgVw_UserImage.kf.setImage(with: url2)
                
                self.lbl_Info.text = "\(AuthService.instance.email!)"
               // self.lbl_SocialLink.text = "\(AuthService.instance.facebook)"
                self.lbl_Gender.text = "\(AuthService.instance.gender!)"
                self.lbl_Name.text = "\(AuthService.instance.username!)"
            }else{
                HUD.hide(to: self.view)

                //print(message)
            }
            
            if AuthService.instance.subcription == true{
                self.lbl_Member.text = "PRO Member"
                self.imgvw_ProMemberBatch.isHidden =  false
            }else{
                self.lbl_Member.text = "Free Member"
                self.imgvw_ProMemberBatch.isHidden =  true
            }
        })
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    


}
