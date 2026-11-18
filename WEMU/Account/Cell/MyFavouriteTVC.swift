//
//  MyFavouriteTVC.swift
//  WEMU
//
//  Created by Arun Halder on 13/09/22.
//

import UIKit

class MyFavouriteTVC: UITableViewCell {
    
    @IBOutlet weak var lbl_Number: UILabel!
    @IBOutlet weak var imgvw_Albam: UIImageView!
    @IBOutlet weak var lb_SongName: UILabel!
    @IBOutlet weak var lbl_AuthorName: UILabel!
    @IBOutlet weak var lbl_ViewsLikesPlays: UILabel!
    @IBOutlet weak var vw_background: RoundView!
    @IBOutlet weak var imgVw_IsPlaying: UIImageView!

    
    var favBtnPressed : (() -> ()) = {}

    @IBAction func favBtnAction(_ sender: UIButton) {
        //Call your closure here
        favBtnPressed()
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
