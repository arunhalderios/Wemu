//
//  NotificationTVC.swift
//  WEMU
//
//  Created by Arun Halder on 15/11/22.
//

import UIKit

class NotificationTVC: UITableViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_Message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
