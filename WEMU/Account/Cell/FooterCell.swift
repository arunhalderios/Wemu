//
//  FooterCell.swift
//  WEMU
//
//  Created by Arun Halder on 28/11/22.
//

import UIKit

class FooterCell: UITableViewCell {
    
    var viewAllBtnPressed : (() -> ()) = {}

    @IBAction func viewAllBtnAction(_ sender: UIButton) {
        //Call your closure here
        viewAllBtnPressed()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
