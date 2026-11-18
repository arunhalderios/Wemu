//
//  DashBoardCVC.swift
//  WEMU
//
//  Created by Arun Halder on 07/09/22.
//

import UIKit

class DashBoardCVC: UICollectionViewCell {
    @IBOutlet weak var imgVw_Albam: UIImageView!
    @IBOutlet weak var lbl_AlbamName: UILabel!
    @IBOutlet weak var vw_TripleDot: UIView!
    @IBOutlet weak var vw_SHare: UIView!
    
    @IBOutlet weak var imgvw_Albam: UIImageView!
    @IBOutlet weak var lb_SongName: UILabel!
    
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
}
