//
//  SearchResultVC.swift
//  WEMU
//
//  Created by Arun Halder on 17/11/22.
//

import UIKit
import Kingfisher
import MarqueeLabel
import MediaPlayer

class SearchResultVC: UIViewController,UITextFieldDelegate, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    
    @IBOutlet weak var imgVw_Back: UIImageView!
    @IBOutlet weak var imgVw_Bell: UIImageView!
    @IBOutlet weak var vw_SmallPlayer: UIView!
    
    @IBOutlet weak var lbl_SmallTitle: MarqueeLabel!
    @IBOutlet weak var lbl_SmallTag: MarqueeLabel!
    @IBOutlet weak var imgvw_SmallImage: UIImageView!
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btn_SmallPlay: UIButton!
    @IBOutlet weak var lbl_Heading: UILabel!
    
    @IBOutlet var vw_Background: UIView!
    
 //   @IBOutlet weak var typeCollectionVw: UICollectionView!
    @IBOutlet weak var songTblevw: UITableView!
    
    @IBOutlet weak var vw_PlayListBack: RoundView!
    @IBOutlet weak var playListCollectionVw: UICollectionView!
    
    @IBOutlet weak var txtfld_Search: UITextField!
  //  var typeArray = ["Artists","Albams","Songs"]
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    var searchKey = ""
    var pagePosition = 0
    var tripleDotActiveIndex = 9999999
    var nowPlayingInfo = [String: Any]()
    var count = 0
    var randomInt = 0
    var showHide = false
    var trackIdStr = ""
    
    //MARK: BUTTON ACTIONS
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.vw_PlayListBack.isHidden = true
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @IBAction func action_PlayPrevious(_ sender: UIButton) {
        AudioService.instance.previousSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
        self.songTblevw.reloadData()
    }
    
    @IBAction func action_PlayNext(_ sender: UIButton) {
        AudioService.instance.nextSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
        self.songTblevw.reloadData()
    }
    
    @IBAction func action_SmallPlayPause(_ sender: UIButton) {
        self.playPause()
    }
    
    @IBAction func openPlayBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlaySongVC") as! PlaySongVC
        navigationController?.pushViewController(vc,animated: false)
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func SearchBtnAction(_ sender: UIButton) {
        self.dismissMyKeyboard()

        if self.txtfld_Search.text != ""{
            if self.txtfld_Search.text!.count >= 3{
                searchKey = self.txtfld_Search.text!
                HUD.show(to: self.view)
                AuthService.instance.SearchAPI(searchKey: searchKey,completion: {(success, data, message) in
                    if success{
                        HUD.hide(to: self.view)
                        self.songTblevw.reloadData()
                    }else{
                        //print(message)
                        HUD.hide(to: self.view)
                    }
                })
            }
            
        }else{
            self.showAlert(message: "Please enter something for search")
        }
        
    }
    



    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if AuthService.instance.searchSongListArray.count > 0{
            DispatchQueue.main.async {
                self.songTblevw.reloadData()
            }
       }
    }
    
    @objc func functionName (notification: NSNotification){
        lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
        imgvw_SmallImage.kf.setImage(with: url)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("NewFunctionName"), object: nil)
        DispatchQueue.main.async {
            self.myPlayListAPICall()
            self.MyProfileAPICall()
            AudioService.instance.setupNowPlayingInfoCenter()
        }
        AuthService.instance.genericListArray.removeAll()
        if AuthService.instance.searchSongListArray.count > 0{
           self.songTblevw.reloadData()
       }
        
        self.txtfld_Search.text = "\(searchKey)"
        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
            self.imgVw_Back.image = UIImage(named: "backBlack")
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bell")
            self.imgVw_Back.image = UIImage(named: "back")
        }

        
        if AudioService.instance.isPlayerOn == true{
            bottomConstant.constant = 120.0
            self.vw_SmallPlayer.isHidden = false
            lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
            lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
            let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            imgvw_SmallImage.kf.setImage(with: url)
            
        }
        else{
            self.vw_SmallPlayer.isHidden = true
            bottomConstant.constant = 0.0
        }
    }
    

    func setupNowPlayingInfoCenter(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        MediaPlayer.MPRemoteCommandCenter.shared().playCommand.addTarget {event in
            AudioService.instance.play()
          return .success
        }
        MediaPlayer.MPRemoteCommandCenter.shared().pauseCommand.addTarget {event in
            AudioService.instance.pause()
          return .success
        }
        
        MediaPlayer.MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = true
        
        
        MediaPlayer.MPRemoteCommandCenter.shared().nextTrackCommand.addTarget {event in
                if AuthService.instance.subcription == true{
                    if AudioService.instance.randomSongBool == false{
                            if AudioService.instance.nowPlayingIndex < AudioService.instance.nowPlayingListArray.count-1{
                                AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex + 1
                               // self.songPlayProgress()
                            }
                            else{
                                AudioService.instance.nowPlayingIndex = 0
                                //self.songPlayProgress()
                            }
                    }
                    else{
                        self.randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                        AudioService.instance.nowPlayingIndex = self.randomInt
                        //self.songPlayProgress()
                    }
                }
                else{
                    AudioService.instance.songPlayingCount =  AudioService.instance.songPlayingCount + 1
                    
                    if AudioService.instance.songPlayingCount >= 8 {
                        let customAlert = RTCustomAlert()
                        customAlert.alertMessage = "You need to subcribe first."
                        customAlert.delegate = self
                        customAlert.show()
                    }
                    else{
                        if AudioService.instance.randomSongBool == false{
                                if AudioService.instance.nowPlayingIndex < AudioService.instance.nowPlayingListArray.count - 1{
                                    AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex + 1
                                    //self.songPlayProgress()
                                }
                                else{
                                    AudioService.instance.nowPlayingIndex = 0
                                    //self.songPlayProgress()
                                }
                        }
                        else{
                            self.randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                            AudioService.instance.nowPlayingIndex = self.randomInt
                            
                        }
                    }
                }
            if AudioService.instance.controller.player?.currentItem?.status == .readyToPlay {
                self.songPlayProgress()
            }
          return .success
        }
        
        
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {event in
                
                if AuthService.instance.subcription == true{
                    if AudioService.instance.randomSongBool == false{
                            if AudioService.instance.nowPlayingIndex > 0{
                                AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex - 1
                                //self.songPlayProgress()

                            }
                            else{
                                AudioService.instance.nowPlayingIndex = 0
                                //self.songPlayProgress()
                            }
                    }
                    else{
                        self.randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                        AudioService.instance.nowPlayingIndex = self.randomInt
                        //self.songPlayProgress()
                    }
                }
                else{
                    AudioService.instance.songPlayingCount =  AudioService.instance.songPlayingCount + 1
                    
                    if AudioService.instance.songPlayingCount >= 8 {
                        let customAlert = RTCustomAlert()
                        customAlert.alertMessage = "You need to subcribe first."
                        customAlert.delegate = self
                        customAlert.show()

                    }
                    else{
                        if AudioService.instance.randomSongBool == false{
                                if AudioService.instance.nowPlayingIndex > 0{
                                    AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex - 1
                                    //self.songPlayProgress()

                                }
                                else{
                                    AudioService.instance.nowPlayingIndex = 0
                                    //self.songPlayProgress()
                                }
                        }
                        else{
                            self.randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                            AudioService.instance.nowPlayingIndex = self.randomInt
                            //self.songPlayProgress()
                        }
                    }
                }
            if AudioService.instance.controller.player?.currentItem?.status == .readyToPlay {
                self.songPlayProgress()
            }
          return .success
        }
      }
    
    func songPlayProgress(){
        self.songTblevw.reloadData()
        lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
        imgvw_SmallImage.kf.setImage(with: url)
        
        AudioService.instance.pause()
        let songUrl = "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["audio_location"].stringValue)"
        print("============================SONG URL===============================")
        print(songUrl)
        if songUrl != ""{
          //  DispatchQueue.main.async {
                AudioService.instance.playSong(SongURL: "\(songUrl)")
                self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
          //  }
        }
        else{
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Invalid song url"
            customAlert.delegate = self
            customAlert.show()
        }
        
        //check player has completed playing audio
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: AudioService.instance.playerSharedItem)
        
        // prepare title and subtitle
        nowPlayingInfo[MPMediaItemPropertyTitle] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
                

    
        
        
        // if playing item is a live stream. Default is false
       // nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        
        // Get asset duration from AVPlayerItem's AVAsset
        // Duration is accurate only when AVPlayerItem.status == .readyToPlay.
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = AudioService.instance.playerSharedItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = AudioService.instance.player.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = AudioService.instance.playerSharedItem?.currentTime().seconds
        
        // final step is to assign our dictionary to
        // MPNowPlayingInfoCenter singleton
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

    }

    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        
        if AuthService.instance.subcription == true{
            if AudioService.instance.randomSongBool == false{
                    if AudioService.instance.nowPlayingIndex < AudioService.instance.nowPlayingListArray.count-1{
                        AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex + 1
                     //   DispatchQueue.main.async {
                            self.songPlayProgress()
                       // }
                    }
                    else{
                        AudioService.instance.nowPlayingIndex = 0
                       // DispatchQueue.main.async {
                            self.songPlayProgress()
                       // }
                    }
            }
            else{
                randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                AudioService.instance.nowPlayingIndex = randomInt
              //  DispatchQueue.main.async {
                    self.songPlayProgress()
              //  }
            }
        }
        else{
            AudioService.instance.songPlayingCount =  AudioService.instance.songPlayingCount + 1
            
            if AudioService.instance.songPlayingCount >= 8 {
                let customAlert = RTCustomAlert()
                customAlert.alertMessage = "You need to subcribe first."
                customAlert.delegate = self
                customAlert.show()
            }
            else{
                if AudioService.instance.randomSongBool == false{
                        if AudioService.instance.nowPlayingIndex < AudioService.instance.nowPlayingListArray.count - 1{
                            AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex + 1
                          //  DispatchQueue.main.async {
                                self.songPlayProgress()
                          //  }
                        }
                        else{
                            AudioService.instance.nowPlayingIndex = 0
                          //  DispatchQueue.main.async {
                                self.songPlayProgress()
                          //  }
                        }
                }
                else{
                    randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                    AudioService.instance.nowPlayingIndex = randomInt
                   // DispatchQueue.main.async {
                        self.songPlayProgress()
                   // }
                }
            }
        }
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        self.songTblevw.reloadData()
    }

    

    
    func playPause(){
        if AudioService.instance.player.rate == 0.0
        {
            AudioService.instance.player.play()
            print("Song is playing")
            self.imgvw_PlayPause.image = UIImage(named: "pause")
            //btn_SmallPlay.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        } else {
            AudioService.instance.player.pause()
            print("Song is paused now")
            self.imgvw_PlayPause.image = UIImage(named: "play")
            //btn_SmallPlay.setBackgroundImage(UIImage(named: "play"), for: .normal)

        }
       // self.view.insertSubview(AudioService.instance.controller.view, at: 0)
        AudioService.instance.controller.allowsPictureInPicturePlayback = true
    }
    
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //UITextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
            if self.txtfld_Search.text != ""{
                if self.txtfld_Search.text!.count >= 3{
                    searchKey = self.txtfld_Search.text!
                    HUD.show(to: self.view)
                    AuthService.instance.SearchAPI(searchKey: searchKey,completion: {(success, data, message) in
                        if success{
                            HUD.hide(to: self.view)
                            self.songTblevw.reloadData()
                        }else{
                            //print(message)
                            HUD.hide(to: self.view)
                        }
                    })
                }
                
            }else{

            }

        return true
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if self.txtfld_Search.text != ""{
            if self.txtfld_Search.text!.count >= 3{
                searchKey = self.txtfld_Search.text!
                HUD.show(to: self.view)
                AuthService.instance.SearchAPI(searchKey: searchKey,completion: {(success, data, message) in
                    if success{
                        HUD.hide(to: self.view)
                        self.songTblevw.reloadData()
                    }else{
                        //print(message)
                        HUD.hide(to: self.view)
                    }
                })
            }
            
        }
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
     }
    
    //MARK: API CALL

    func MyProfileAPICall(){
        AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
            if success{
            }else{
            }
        })
    }
    
    func myPlayListAPICall(){
        HUD.show(to: self.view)
        AuthService.instance.myPlaySongListAPI(completion: {(success, data, message) in
            if success{
                if AuthService.instance.myPlaySongListAlbamArray.count > 0{
                    self.playListCollectionVw.reloadData()
                }
                HUD.hide(to: self.view)
            }else{
                //print(message)
                HUD.hide(to: self.view)
            }
        })
    }
    
    func songLikeAPICall(songIdStr:String){
        HUD.show(to: self.view)
        AuthService.instance.songLikeAPI(songIdStr: "\(songIdStr)",completion: {(success, data, message) in
            if success{
                let customAlert = RTCustomAlert()
                customAlert.alertMessage = "You have successfully \(message!)"
                customAlert.delegate = self
                customAlert.show()
                self.tripleDotActiveIndex = 9999999
                AuthService.instance.SearchAPI(searchKey: self.searchKey,completion: {(success, data, message) in
                    if success{
                        HUD.hide(to: self.view)
                        self.songTblevw.reloadData()
                    }else{
                        //print(message)
                        HUD.hide(to: self.view)
                    }
                })
                HUD.hide(to: self.view)
            }else{
                //print(message)
                HUD.hide(to: self.view)
            }
        })
    }
    
    func songViewAPICall(songIdStr:String){
        AuthService.instance.songViewAPI(songIdStr: "\(songIdStr)",completion: {(success, data, message) in
            if success{
                
            }else{
            }
        })
        
        AuthService.instance.PlaySongsAPI(songIdStr: "\(songIdStr)",completion: {(success, data, message) in
            if success{
            }else{
            }
        })
    }

    

    
}


extension SearchResultVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    // Header Cell
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        headerCell.backgroundColor = UIColor.clear
        
        switch (section) {
        case 0:
            headerCell.title.text = "Artists";
        case 1:
            headerCell.title.text = "Albums";
        case 2:
            headerCell.title.text = "Songs";
        default:
            headerCell.title.text = "";
        }
         if AuthService.instance.whiteTheam == true{
             print("UISwitch state is now ON")
             headerCell.title.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

         }
         else{
             print("UISwitch state is now Off")
             headerCell.title.textColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

         }
        
        return headerCell
    }
    
    // Footer Cell
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footerCell = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! FooterCell
         footerCell.backgroundColor = UIColor.clear
        
         switch (section) {
         case 0:
             if AuthService.instance.searchArtistListArray.count > 0{
                 footerCell.isHidden = false
             }
             else{
                 footerCell.isHidden = true
             }
             footerCell.viewAllBtnPressed = {
                 self.searchKey = self.txtfld_Search.text!
                 HUD.show(to: self.view)
                 AuthService.instance.searchArtistListAPI(albamIdStr:self.searchKey,completion: {(success, data, message) in
                     if success{
                         HUD.hide(to: self.view)
                         if AuthService.instance.searchArtistListArray.count > 0{
                             let storyboard = UIStoryboard(name: "Account", bundle: nil)
                             let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                             vc.collectionNameStr = "searchArtists"
                             self.navigationController?.pushViewController(vc,animated: true)
                         }
                         else{
                             self.showAlert(message: "Search Artist has no data right now.")
                         }
                     }else{
                         //print(message)
                         HUD.hide(to: self.view)
                     }
                 })
             }
     
         case 1:
             if AuthService.instance.searchAlbamListArray.count > 0{
                 footerCell.isHidden = false
             }
             else{
                 footerCell.isHidden = true
             }
             footerCell.viewAllBtnPressed = {
                 self.searchKey = self.txtfld_Search.text!
                 HUD.show(to: self.view)
                 AuthService.instance.searchAlbamListAPI(albamIdStr:self.searchKey,completion: {(success, data, message) in
                     if success{
                         HUD.hide(to: self.view)
                         if AuthService.instance.searchAlbamListArray.count > 0{
                             let storyboard = UIStoryboard(name: "Account", bundle: nil)
                             let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                             vc.collectionNameStr = "searchAlbams"
                             self.navigationController?.pushViewController(vc,animated: true)
                         }
                         else{
                             self.showAlert(message: "Search Albam has no data right now.")
                         }
                     }else{
                         //print(message)
                         HUD.hide(to: self.view)
                     }
                 })
             }
         case 2:
             if AuthService.instance.searchSongListArray.count > 0{
                 footerCell.isHidden = false
             }
             else{
                 footerCell.isHidden = true
             }
             footerCell.viewAllBtnPressed = {
                 self.searchKey = self.txtfld_Search.text!
                 HUD.show(to: self.view)
                 AuthService.instance.searchSongsListAPI(songIdStr:self.searchKey,completion: {(success, data, message) in
                     if success{
                         HUD.hide(to: self.view)
                         if AuthService.instance.searchSongListArray.count > 0{
                             let storyboard = UIStoryboard(name: "Account", bundle: nil)
                             let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                             vc.collectionNameStr = "searchSongs"
                             self.navigationController?.pushViewController(vc,animated: true)
                         }
                         else{
                             self.showAlert(message: "Search Songs has no data right now.")
                         }
                     }else{
                         //print(message)
                         HUD.hide(to: self.view)
                     }
                 })
             }
         default: break
             
         }
        
        return footerCell
    }
    
    //header height
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    // footer height
     func tableView(_ : UITableView, heightForFooterInSection section: Int) -> CGFloat {
         var footerHeight = 50.0
         switch (section) {
         case 0:
             if AuthService.instance.searchArtistListArray.count > 0{
                 footerHeight = 50.0
             }
             else{
                 footerHeight = 0.0
             }
     
         case 1:
             if AuthService.instance.searchAlbamListArray.count > 0{
                 footerHeight = 50.0
             }
             else{
                 footerHeight = 0.0
             }
             
         case 2:
             
             if AuthService.instance.searchAlbamListArray.count > 0{
                 footerHeight = 50.0
             }
             else{
                 footerHeight = 0.0
             }
         default:
             break
         }
         return footerHeight

     }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionInt = 0
        if section == 0{
            if AuthService.instance.searchArtistListArray.count >= 5{
                sectionInt = 5
            }
            else{
                sectionInt = AuthService.instance.searchArtistListArray.count
            }
        }
        else if section == 1{
            if AuthService.instance.searchAlbamListArray.count >= 5{
                sectionInt = 5
            }
            else{
                sectionInt = AuthService.instance.searchAlbamListArray.count
            }
        }
        else if section == 2{
            if AuthService.instance.searchSongListArray.count >= 5{
                sectionInt = 5
            }
            else{
                sectionInt = AuthService.instance.searchSongListArray.count
            }
        }
        return sectionInt
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMusicTVC", for: indexPath) as! NewMusicTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if indexPath.section == 0{
            if AuthService.instance.searchArtistListArray.count > 0{
                
                cell.lb_SongName.setHighlighted(AuthService.instance.searchArtistListArray[indexPath.row]["name"].stringValue, with: searchKey)
                cell.lbl_AuthorName.setHighlighted(AuthService.instance.searchArtistListArray[indexPath.row]["email"].stringValue, with: searchKey)

                let imageurl = AuthService.instance.searchArtistListArray[indexPath.row]["avatar"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgvw_Albam.kf.setImage(with: url)
                let isLike  = AuthService.instance.searchArtistListArray[indexPath.row]["is_liked"].stringValue
                if isLike == "0"{
                    cell.btnLike.setTitle("Like", for: .normal)
                }
                else{
                    cell.btnLike.setTitle("Unlike", for: .normal)
                }
                
                
                

                
                cell.vw_TripleDot.isHidden = true
                
           }

        }
        else if indexPath.section == 1{
            if AuthService.instance.searchAlbamListArray.count > 0{

                cell.lbl_AuthorName.setHighlighted(AuthService.instance.searchAlbamListArray[indexPath.row]["description"].stringValue, with: searchKey)
                cell.lb_SongName.setHighlighted(AuthService.instance.searchAlbamListArray[indexPath.row]["title"].stringValue, with: searchKey)

                let imageurl = AuthService.instance.searchAlbamListArray[indexPath.row]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgvw_Albam.kf.setImage(with: url)
                //cell.lbl_Number.text = "\(indexPath.row + 1)"
                cell.vw_TripleDot.isHidden = true
                
                let isLike  = AuthService.instance.searchAlbamListArray[indexPath.row]["is_liked"].stringValue
                if isLike == "0"{
                    cell.btnLike.setTitle("Like", for: .normal)
                }
                else{
                    cell.btnLike.setTitle("Unlike", for: .normal)
                }
                
                

           }
        }else{
            if AuthService.instance.searchSongListArray.count > 0{

                cell.lbl_AuthorName.setHighlighted(AuthService.instance.searchSongListArray[indexPath.row]["description"].stringValue, with: searchKey)
                cell.lb_SongName.setHighlighted(AuthService.instance.searchSongListArray[indexPath.row]["title"].stringValue, with: searchKey)

//                let imageurl = AuthService.instance.searchSongListArray[indexPath.row]["thumbnail"].stringValue
//                let url = URL(string:"\(imageurl)")
//                cell.imgvw_Albam.kf.setImage(with: url)
//                //cell.lbl_Number.text = "\(indexPath.row + 1)"
                cell.vw_TripleDot.isHidden = false
                
                let isLike  = AuthService.instance.searchSongListArray[indexPath.row]["is_liked"].stringValue
                if isLike == "0"{
                    cell.btnLike.setTitle("Like", for: .normal)
                }
                else{
                    cell.btnLike.setTitle("Unlike", for: .normal)
                }
                
                let viewStr = AuthService.instance.searchSongListArray[indexPath.row]["views_count"].stringValue
                let playStr = AuthService.instance.searchSongListArray[indexPath.row]["play_count"].stringValue
                let likeStr = AuthService.instance.searchSongListArray[indexPath.row]["like_count"].stringValue
                
                cell.lbl_ViewsLikesPlays.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
                
                let imageurl = AuthService.instance.searchSongListArray[indexPath.row]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgvw_Albam.kf.setImage(with: url)
                
                cell.dotsBtnPressed = {
                    self.tripleDotActiveIndex = indexPath.row
                    self.songTblevw.reloadData()
                }
                
                if indexPath.row == self.tripleDotActiveIndex{
                        cell.vw_SHare.isHidden = false
                        self.showHide = true
                    }
                    else{
                        cell.vw_SHare.isHidden = true
                        self.showHide = false
                    }
                
                cell.addToPlayListBtnPressed = {
                    cell.vw_SHare.isHidden = true
                    if AuthService.instance.subcription == false{
                        self.showAlert(message: "Please subcribe first")
                    }
                    else{
                        if AuthService.instance.searchSongListArray.count > 0{
                            self.trackIdStr = AuthService.instance.searchSongListArray[indexPath.row]["category"]["id"].stringValue
                            self.vw_PlayListBack.isHidden = false
                        }
                        else{
                            self.showAlert(message: "Please create a playlist first")
                        }
                    }
                 
            }
                
                cell.shareBtnPressed = {
                    let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.searchSongListArray[indexPath.row]["title"].stringValue).Available only in wemo."

                        if let myWebsite = NSURL(string: "") {
                            let objectsToShare = [textToShare, myWebsite] as [Any]
                            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                            //New Excluded Activities Code
                            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                            //

                            self.present(activityVC, animated: true, completion: nil)
                            cell.vw_SHare.isHidden = true
                        }
                }
                
                cell.likeBtnPressed = {
                    self.songLikeAPICall(songIdStr: "\(AuthService.instance.searchSongListArray[indexPath.row]["song_id"].stringValue)")
                    cell.vw_SHare.isHidden = true

                }
                
                
//                if AuthService.instance.searchSongListArray[indexPath.row]["song_id"].stringValue == AudioService.instance.nowPlayingSongId{
//                    cell.imgVw_IsPlaying.isHidden = false
//
//                }
//                else{
//                    cell.imgVw_IsPlaying.isHidden = true
//                    cell.imgVw_IsPlaying.image = UIImage.gifImageWithName("sound_bar_animation_final")
//                }
//

           }
        }
        
        

            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbamDetailsVC") as! AlbamDetailsVC
            vc.playSelectedIndex = indexPath.row
            vc.collectionNameStr = "searchArtists"
            vc.artistID = AuthService.instance.searchArtistListArray[indexPath.row]["id"].stringValue
            vc.strAlbumURL = AuthService.instance.searchArtistListArray[indexPath.row]["avatar"].stringValue
            self.navigationController?.pushViewController(vc,animated: false)
        }
        else if indexPath.section == 1{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbamDetailsVC") as! AlbamDetailsVC
            vc.playSelectedIndex = indexPath.row
            vc.collectionNameStr = "searchAlbams"
            vc.albumID = AuthService.instance.searchAlbamListArray[indexPath.row]["palbum_id"].stringValue
            vc.categoryId = AuthService.instance.searchAlbamListArray[indexPath.row]["category_id"].stringValue
            vc.strAlbumURL = AuthService.instance.searchAlbamListArray[indexPath.row]["thumbnail"].stringValue
            self.navigationController?.pushViewController(vc,animated: false)
        }
        else if indexPath.section == 2{
            AudioService.instance.nowPlayingIndex = indexPath.row
            self.vw_SmallPlayer.isHidden = false
            AudioService.instance.isPlayerOn = true
            bottomConstant.constant = 120.0
            
            AudioService.instance.nowPlayingListArray = AuthService.instance.searchSongListArray
            
            lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
            lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
            let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            imgvw_SmallImage.kf.setImage(with: url)
            
            let songString = "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["audio_location"].stringValue)"
            if songString == ""{
                let customAlert = RTCustomAlert()
                customAlert.alertMessage = "There is no song left."
                customAlert.delegate = self
                customAlert.show()
            
            }else{
               // DispatchQueue.main.async {
                    AudioService.instance.playSong(SongURL: songString)
                    self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
             //   }
            }
            
            self.tripleDotActiveIndex = 9999999
            self.songTblevw.reloadData()
            
        }
    }
    
}

extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AuthService.instance.myPlaySongListAlbamArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCVC", for: indexPath) as! PlaylistCVC
        
        if AuthService.instance.myPlaySongListAlbamArray.count > 0{
            
            cell.lb_SongName.text = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["name"].stringValue
            
            let imageurl = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            cell.imgvw_Albam.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width_collView = Double((UIScreen.main.bounds.width-40)/2)
        let hight_collView = 190.0

        return CGSize(width: width_collView, height: hight_collView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let playListID = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["id"].stringValue
        
        HUD.show(to: self.view)
        AuthService.instance.addToPlayListAPI(trackIDStr: trackIdStr, playListIDStr: playListID,completion: {(success, data, message) in
            if success{
                    HUD.hide(to: self.view)
                    self.showAlert(message: message!)
                    }else{
                    //print(message)
                    HUD.hide(to: self.view)
                    }
                })
        self.vw_PlayListBack.isHidden = true

    }
}

extension UILabel {
    func setHighlighted(_ text: String, with search: String) {
        let attributedText = NSMutableAttributedString(string: text) // 1
        let range = NSString(string: text).range(of: search, options: .caseInsensitive) // 2
        let highlightColor = traitCollection.userInterfaceStyle == .light ? UIColor.systemBlue : UIColor.systemOrange // 3
        let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.backgroundColor: highlightColor] // 4
        
        attributedText.addAttributes(highlightedAttributes, range: range) // 5
        self.attributedText = attributedText // 6
    }
}
