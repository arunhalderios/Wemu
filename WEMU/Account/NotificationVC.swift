//
//  NotificationVC.swift
//  WEMU
//
//  Created by Arun Halder on 14/11/22.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tbleVw_Notification: UITableView!
    @IBOutlet weak var lbl_NoNotificationFound: UILabel!
    @IBOutlet weak var vw_Background: UIView!
    @IBOutlet weak var imgVw_Back: UIImageView!
    @IBOutlet weak var lbl_Heading: UILabel!
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.NotificationAPICall()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.MyProfileAPICall()
        }
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Back.image = UIImage(named: "backBlack")
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Back.image = UIImage(named: "back")
        }
    }
    
    //MARK: API CALL
        
        func MyProfileAPICall(){
            AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
                if success{
                }else{
                }
            })
        }
    
    func NotificationAPICall(){
        HUD.show(to: self.view)
        AuthService.instance.notificationListAPI(completion: {(success, data, message) in
            if success{
                HUD.hide(to: self.view)
                if AuthService.instance.notificationListArray.count > 0{
                    self.tbleVw_Notification.reloadData()
                    self.tbleVw_Notification.isHidden = false
                    self.lbl_NoNotificationFound.isHidden = true
                }else{
                    self.tbleVw_Notification.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                }


            }else{
                self.tbleVw_Notification.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false

                HUD.hide(to: self.view)

                //print(message)
            }
        })
    }

}
extension NotificationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthService.instance.notificationListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath) as! NotificationTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if AuthService.instance.notificationListArray.count > 0{
            
        }
            return cell
        }
    

    
}
