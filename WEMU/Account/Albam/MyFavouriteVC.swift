//
//  MyFavouriteVC.swift
//  WEMU
//
//  Created by Arun Halder on 13/09/22.
//

import UIKit
import AVFoundation
import MarqueeLabel
import MediaPlayer


class MyFavouriteVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    @IBOutlet weak var imgVw_Bell: UIImageView!
    @IBOutlet weak var imgVw_Back: UIImageView!
    @IBOutlet var vw_Background: UIView!
    
    @IBOutlet weak var vw_SmallPlayer: UIView!
    
    @IBOutlet weak var lbl_SmallTitle: MarqueeLabel!
    @IBOutlet weak var lbl_SmallTag: MarqueeLabel!
    @IBOutlet weak var imgvw_SmallImage: UIImageView!
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btn_SmallPlay: UIButton!
    
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_SongCount: UILabel!
    @IBOutlet weak var tblevw_MyFavourite: UITableView!
    @IBOutlet weak var lbl_NoNotificationFound: UILabel!

    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    var nowPlayingInfo = [String: Any]()
    var count = 0
    var randomInt = 0

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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tblevw_MyFavourite.delegate = self
        tblevw_MyFavourite.dataSource = self
                
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
            self.favouriteAPICall()
            self.MyProfileAPICall()
            AudioService.instance.setupNowPlayingInfoCenter()
        }
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_SongCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
            self.imgVw_Back.image = UIImage(named: "backBlack")
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_SongCount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
    
    @IBAction func action_PlayPrevious(_ sender: UIButton) {
        AudioService.instance.previousSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
        self.tblevw_MyFavourite.reloadData()
    }
    
    @IBAction func action_PlayNext(_ sender: UIButton) {
        AudioService.instance.nextSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
        self.tblevw_MyFavourite.reloadData()
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
        self.tblevw_MyFavourite.reloadData()
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
                       // DispatchQueue.main.async {
                            self.songPlayProgress()
                       // }
                    }
                    else{
                        AudioService.instance.nowPlayingIndex = 0
                       // DispatchQueue.main.async {
                            self.songPlayProgress()
                      //  }
                    }
            }
            else{
                randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                AudioService.instance.nowPlayingIndex = randomInt
              //  DispatchQueue.main.async {
                    self.songPlayProgress()
               // }
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
                  //  DispatchQueue.main.async {
                        self.songPlayProgress()
                  //  }
                }
            }
        }
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        self.tblevw_MyFavourite.reloadData()
    }


    
    @IBAction func action_SmallPlayPause(_ sender: UIButton) {
        self.playPause()
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
    
    @IBAction func openPlayBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlaySongVC") as! PlaySongVC
        navigationController?.pushViewController(vc,animated: false)
        //self.present(vc, animated: true, completion: nil)
    }

    
    //MARK: API CALL
        
        func MyProfileAPICall(){
            AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
                if success{
                }else{
                }
            })
        }
    
    func favouriteAPICall(){
        HUD.show(to: self.view)
        AuthService.instance.favouriteListAPI(completion: {(success, data, message) in
            if success{
                HUD.hide(to: self.view)
                if AuthService.instance.favouriteListArray.count > 0{
                    HUD.hide(to: self.view)
                    self.lbl_SongCount.text = "\(AuthService.instance.favouriteListArray.count) Songs"
                    self.tblevw_MyFavourite.reloadData()
                    self.tblevw_MyFavourite.isHidden = false
                    self.lbl_NoNotificationFound.isHidden = true
                }else{
                    HUD.hide(to: self.view)
                    self.tblevw_MyFavourite.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                }
            }else{
                HUD.hide(to: self.view)
                self.tblevw_MyFavourite.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false

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
extension MyFavouriteVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AuthService.instance.favouriteListArray.count > 0{
            return AuthService.instance.favouriteListArray.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavouriteTVC", for: indexPath) as! MyFavouriteTVC
            //cell.lbl_Number.text = "\(indexPath.row + 1)"
            cell.lb_SongName.text = AuthService.instance.favouriteListArray[indexPath.row]["title"].stringValue
            cell.lbl_AuthorName.text = AuthService.instance.favouriteListArray[indexPath.row]["description"].stringValue
        
        
            let viewStr = AuthService.instance.favouriteListArray[indexPath.row]["views_count"].stringValue
            let playStr = AuthService.instance.favouriteListArray[indexPath.row]["play_count"].stringValue
            let likeStr = AuthService.instance.favouriteListArray[indexPath.row]["like_count"].stringValue
        
            cell.lbl_ViewsLikesPlays.text = " \(viewStr) Views, \(playStr) Likes, \(likeStr) Plays "
        
            let imageurl = AuthService.instance.favouriteListArray[indexPath.row]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            cell.imgvw_Albam.kf.setImage(with: url)
        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lbl_AuthorName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lbl_ViewsLikesPlays.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else{
            print("UISwitch state is now Off")
            cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lbl_AuthorName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lbl_ViewsLikesPlays.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if AuthService.instance.favouriteListArray[indexPath.row]["song_id"].stringValue == AudioService.instance.nowPlayingSongId{
            // cell.imgVw_IsPlaying.isHidden = false
             cell.imgVw_IsPlaying.isHidden = false
             cell.imgVw_IsPlaying.loadGif(name: "sound_bar_animation_final")
         }
         else{
 //            cell.imgVw_IsPlaying.isHidden = true
 //            cell.imgVw_IsPlaying.image = UIImage.gifImageWithName("sound_bar_animation_final")
             cell.imgVw_IsPlaying.isHidden = true
             cell.imgVw_IsPlaying.loadGif(name: "sound_bar_animation_final")
         }
        
                
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioService.instance.nowPlayingIndex = indexPath.row
        self.vw_SmallPlayer.isHidden = false
        AudioService.instance.isPlayerOn = true
        bottomConstant.constant = 120.0
        
        AudioService.instance.nowPlayingListArray = AuthService.instance.favouriteListArray
        
        lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
        imgvw_SmallImage.kf.setImage(with: url)
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        
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
          //  }
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
        self.tblevw_MyFavourite.reloadData()
        
    }
    


}


extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    func removeSpecialCharacters() -> String {
        let okayChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 ")
        return String(self.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
    }
}
