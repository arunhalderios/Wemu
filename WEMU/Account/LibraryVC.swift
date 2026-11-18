//
//  LibraryVC.swift
//  WEMU
//
//  Created by Arun Halder on 06/09/22.
//

import UIKit
import MarqueeLabel
import MediaPlayer


class LibraryVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    
    
    @IBOutlet weak var imgVw_Profile: UIImageView!
    @IBOutlet weak var vw_SmallPlayer: UIView!
    
    @IBOutlet weak var lbl_SmallTitle: MarqueeLabel!
    @IBOutlet weak var lbl_SmallTag: MarqueeLabel!
    @IBOutlet weak var imgvw_SmallImage: UIImageView!
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btn_SmallPlay: UIButton!
    

    @IBOutlet weak var tblevw_Library: UITableView!
    @IBOutlet var vw_Background: UIView!
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_Library: UILabel!
    @IBOutlet weak var imgVw_Bell: UIImageView!
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    var nowPlayingInfo = [String: Any]()
    var count = 0
    var randomInt = 0

    var localDataArray = ["New Music", "Top Music", "Albums", "Recently Played", "My Playlists", "My Favorites", "Artists"]
    
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(vc,animated: true)
    }
    
    
    @IBAction func DashBoardBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
        navigationController?.pushViewController(vc,animated: false)
    }
    
    @IBAction func GenresBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GenresVC") as! GenresVC
        navigationController?.pushViewController(vc,animated: false)
    }
    
    @IBAction func ProfileBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        navigationController?.pushViewController(vc,animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Library.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Library.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bell")
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
            self.MyProfileAPICall()
            AudioService.instance.setupNowPlayingInfoCenter()
            AuthService.instance.artistListArray.removeAll()
            AuthService.instance.albamListArray.removeAll()
            AuthService.instance.genericListArray.removeAll()
            
            
            
        }

        if AuthService.instance.subcription == false{
            self.localDataArray = ["New Music", "Top Music", "Albums", "Recently Played", "My Favorites", "Artists", "Partner Section"]
        }
        else{
            self.localDataArray = ["New Music", "Top Music", "Albums", "Recently Played", "My Playlists", "My Favorites", "Artists", "Partner Section"]
        }
        
        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Library.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Library.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bell")
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
    
    func MyProfileAPICall(){
        HUD.show(to: self.view)
        AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
            if success{
                HUD.hide(to: self.view)
                
                let imageurl2 = "\(AuthService.instance.baseImageUrl)" + "/\(AuthService.instance.avatarUrl)"
                print(imageurl2)
                let url2 = URL(string:"\(imageurl2)")
                self.imgVw_Profile.kf.setImage(with: url2)
                                
            }else{
                HUD.hide(to: self.view)

                //print(message)
            }
        })
    }
    
    @IBAction func action_PlayPrevious(_ sender: UIButton) {
        AudioService.instance.previousSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
    }
    
    @IBAction func action_PlayNext(_ sender: UIButton) {
        AudioService.instance.nextSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
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
                   // }
                }
            }
        }
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
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
//        self.present(vc, animated: true, completion: nil)
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

extension LibraryVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTVC", for: indexPath) as! LibraryTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.lbl_Name.text = localDataArray[indexPath.row]
        
        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            cell.lbl_Name.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else{
            print("UISwitch state is now Off")
            cell.lbl_Name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        }
        
        if cell.lbl_Name.text == "Partner Section" {
            
            cell.lbl_Name.text = "Partner Section \nArtist upload your music in this section"
            cell.lbl_Name.textColor = .purple
            
        }

            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexValue = localDataArray[indexPath.row]
        
        if indexValue == "New Music"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NewMusicVC") as! NewMusicVC
            vc.collectionNameStr = "New Music"

            navigationController?.pushViewController(vc,animated: true)
        }
        else if indexValue == "Top Music"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NewMusicVC") as! NewMusicVC
            vc.collectionNameStr = "Top Music"
            navigationController?.pushViewController(vc,animated: true)
        }
        else if indexValue == "Albums"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbamVC") as! AlbamVC
            vc.type = "albam"
            navigationController?.pushViewController(vc,animated: true)
        }
        else if indexValue == "Recently Played"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecentlyPlayedVC") as! RecentlyPlayedVC
            navigationController?.pushViewController(vc,animated: true)
        }
        else if indexValue == "My Playlists"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlaylistVC") as! PlaylistVC
            navigationController?.pushViewController(vc,animated: true)
        }
        else if indexValue == "My Favorites"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MyFavouriteVC") as! MyFavouriteVC
            navigationController?.pushViewController(vc,animated: true)
        }
        else if indexValue == "Artists"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbamVC") as! AlbamVC
            vc.type = "artist"
            navigationController?.pushViewController(vc,animated: true)

        }
        else{
        let urlSting = "https://developer.shyamfuture.in/wemuonline/public/partner"
            
            if let url = URL(string: urlSting), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        
    }
    
}
