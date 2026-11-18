//
//  PlaySongTVC.swift
//  WEMU
//
//  Created by Arun Halder on 29/11/22.
//

import UIKit
import AVFoundation
import MarqueeLabel
import FaveButton

class PlaySongTVC: UITableViewCell {
    
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btnFavIcon: FaveButton!
    @IBOutlet weak var favIcon: UIImageView!
    @IBOutlet weak var lbl_CurrentTime: UILabel!
    @IBOutlet weak var lbl_OverallDuration: UILabel!
    @IBOutlet weak var slider_SongProgress: UISlider!
    
    @IBOutlet weak var imgVw_thumbnail: UIImageView!
   // @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Tags: UILabel!
    
    @IBOutlet weak var lbl_Title: MarqueeLabel!
    @IBOutlet weak var playButtonOutlet: UIButton!

    @IBOutlet weak var imgVw_Repeat: UIImageView!
    @IBOutlet weak var imgVw_Suffle: UIImageView!
    
    var playBtnPressed : (() -> ()) = {}
    var replayBtnPressed : (() -> ()) = {}
    var suffleBtnPressed : (() -> ()) = {}
    var nextBtnPressed : (() -> ()) = {}
    var previousBtnPressed : (() -> ()) = {}
    var addToFavouriteBtnPressed : (() -> ()) = {}
    var shareBtnPressed : (() -> ()) = {}
    var showPlayListPressed : (() -> ()) = {}



    @IBAction func playBtnAction(_ sender: UIButton) {
        //Call your closure here
        playBtnPressed()
    }
    
    @IBAction func replayBtnAction(_ sender: UIButton) {
        //Call your closure here
        playBtnPressed()
    }
    
    @IBAction func suffleBtnAction(_ sender: UIButton) {
        //Call your closure here
        suffleBtnPressed()
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        //Call your closure here
        nextBtnPressed()
    }
    
    @IBAction func previousBtnAction(_ sender: UIButton) {
        //Call your closure here
        previousBtnPressed()
    }
    
    @IBAction func addToFavBtnAction(_ sender: UIButton) {
        //Call your closure here
        addToFavouriteBtnPressed()
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        //Call your closure here
        shareBtnPressed()
    }
    
    @IBAction func showPlayListBtnAction(_ sender: UIButton) {
        //Call your closure here
        showPlayListPressed()
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
