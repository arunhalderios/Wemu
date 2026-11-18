//
//  SearchTVC.swift
//  WEMU
//
//  Created by Arun Halder on 17/11/22.
//

import UIKit

class SearchTVC: UITableViewCell {
    
    @IBOutlet weak var imgVw_Albam: UIImageView!
    
    @IBOutlet weak var lbl_AlbamName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
