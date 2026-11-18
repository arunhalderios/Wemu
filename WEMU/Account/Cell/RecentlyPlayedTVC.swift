//
//  RecentlyPlayedTVC.swift
//  WEMU
//
//  Created by Arun Halder on 13/09/22.
//

import UIKit

class RecentlyPlayedTVC: UITableViewCell {
    
    @IBOutlet weak var lbl_Number: UILabel!
    @IBOutlet weak var imgvw_Albam: UIImageView!
    @IBOutlet weak var lb_SongName: UILabel!
    @IBOutlet weak var lbl_AuthorName: UILabel!
    @IBOutlet weak var lbl_ViewsLikesPlays: UILabel!
    @IBOutlet weak var vw_background: RoundView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var vw_SHare: UIView!
    @IBOutlet weak var imgVw_IsPlaying: UIImageView!


    var dotsBtnPressed : (() -> ()) = {}
    var addToPlayListBtnPressed : (() -> ()) = {}
    var shareBtnPressed : (() -> ()) = {}
    var likeBtnPressed : (() -> ()) = {}

    @IBAction func dotsBtnAction(_ sender: UIButton) {
        //Call your closure here
        dotsBtnPressed()
    }
    
    @IBAction func addToPlayListBtnAction(_ sender: UIButton) {
        //Call your closure here
        addToPlayListBtnPressed()
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        //Call your closure here
        shareBtnPressed()
    }

    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        //Call your closure here
        likeBtnPressed()
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
