//
//  ProfileVC.swift
//  WEMU
//
//  Created by Arun Halder on 06/09/22.
//

import UIKit
import MarqueeLabel
import MediaPlayer

class ProfileVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    @IBOutlet weak var imgVw_Bell: UIImageView!
    
    @IBOutlet weak var vw_SmallPlayer: UIView!
    @IBOutlet weak var lbl_SmallTitle: MarqueeLabel!
    @IBOutlet weak var lbl_SmallTag: MarqueeLabel!
    @IBOutlet weak var imgvw_SmallImage: UIImageView!
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btn_SmallPlay: UIButton!
    
    @IBOutlet weak var switch_DayMode: UISwitch!
    @IBOutlet weak var lbl_OffValue: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Subcription: UILabel!
    @IBOutlet weak var lbl_Settings: UILabel!
    @IBOutlet weak var lbl_Logout: UILabel!
    @IBOutlet weak var lbl_DayMode: UILabel!
    @IBOutlet weak var lbl_OnOff: UILabel!
    @IBOutlet var vw_Background: UIView!
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_MyProfile: UILabel!
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    var nowPlayingInfo = [String: Any]()
    var count = 0
    var randomInt = 0
    
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
    
    @IBAction func LibraryBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LibraryVC") as! LibraryVC
        navigationController?.pushViewController(vc,animated: false)
    }
    
    @IBAction func ProfileBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
        navigationController?.pushViewController(vc,animated: false)
    }

    @IBAction func SubcriptionBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        vc.navFrom = "profile"
        navigationController?.pushViewController(vc,animated: false)
    }
    
    @IBAction func SettingsBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        navigationController?.pushViewController(vc,animated: false)
    }
    @IBAction func LogoutBtnAction(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "WEMU", message: "Are you confirm to logout?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            AuthService.instance.logoutAPI(completion: {(success, data, message) in
                if success{
                    AudioService.instance.isPlayerOn = false
                    AuthService.instance.isLoggedIn = false
                    AudioService.instance.pause()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc,animated: false)
                }
                else{
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc,animated: false)
                    
                }
                })

          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)

    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if (sender.isOn == true){
            
                    print("UISwitch state is now ON")
                    lbl_OffValue.text = "ON"
                    AuthService.instance.whiteTheam = true
                    self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.lbl_MyProfile.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.lbl_Name.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.lbl_Subcription.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.lbl_Settings.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.lbl_Logout.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.lbl_DayMode.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.lbl_OnOff.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.imgVw_Bell.image = UIImage(named: "bellBlack")

                }
                else{
                    print("UISwitch state is now Off")
                    lbl_OffValue.text = "OFF"
                    AuthService.instance.whiteTheam = false
                    self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.lbl_MyProfile.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.lbl_Name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.lbl_Subcription.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.lbl_Settings.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.lbl_Logout.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.lbl_DayMode.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.lbl_OnOff.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.imgVw_Bell.image = UIImage(named: "bell")
                }
        
    }
    
    @IBAction func DeleteAccountBtnAction(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "WEMU", message: "Are you confirm to delete account?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            AuthService.instance.deleteAccountAPI(completion: {(success, data, message) in
                if success{
                    AudioService.instance.isPlayerOn = false
                    AuthService.instance.isLoggedIn = false
                    AudioService.instance.pause()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc,animated: false)
                }
                else{
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc,animated: false)
                    
                }
                })

          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    @objc func functionName (notification: NSNotification){
        lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
        //lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
        imgvw_SmallImage.kf.setImage(with: url)
        
        
        // prepare title and subtitle
        nowPlayingInfo[MPMediaItemPropertyTitle] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
        //nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = AudioService.instance.playerSharedItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = AudioService.instance.player.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = AudioService.instance.playerSharedItem?.currentTime().seconds
        
        // final step is to assign our dictionary to
        // MPNowPlayingInfoCenter singleton
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("NewFunctionName"), object: nil)
        DispatchQueue.main.async {
            AudioService.instance.setupNowPlayingInfoCenter()
            self.MyProfileAPICall()
        }
        AuthService.instance.genericListArray.removeAll()
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            lbl_OffValue.text = "ON"
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_MyProfile.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Name.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Subcription.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Settings.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Logout.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_DayMode.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_OnOff.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.switch_DayMode.setOn(true, animated: false)
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
        }
        else{
            print("UISwitch state is now Off")
            lbl_OffValue.text = "OFF"
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_MyProfile.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Subcription.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Settings.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Logout.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_DayMode.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_OnOff.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.switch_DayMode.setOn(false, animated: false)
            self.imgVw_Bell.image = UIImage(named: "bell")
        }
        
        
        if AudioService.instance.isPlayerOn == true{
            bottomConstant.constant = 120.0
            self.vw_SmallPlayer.isHidden = false
            lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
            
            if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
                lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
            }
            else{
                lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

            }
            
            //lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
            let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            imgvw_SmallImage.kf.setImage(with: url)
            
        }
        else{
            bottomConstant.constant = 0.0
            self.vw_SmallPlayer.isHidden = true

        }
    }
    
    @IBAction func action_PlayPrevious(_ sender: UIButton) {
        AudioService.instance.previousSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
    }
    
    @IBAction func action_PlayNext(_ sender: UIButton) {
        AudioService.instance.nextSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
    }
    
    func songPlayProgress(){
        lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
        //lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
        imgvw_SmallImage.kf.setImage(with: url)
        
        AudioService.instance.pause()
        let songUrl = "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["audio_location"].stringValue)"
        print("============================SONG URL===============================")
        print(songUrl)
        if songUrl != ""{
            DispatchQueue.main.async {
                AudioService.instance.playSong(SongURL: "\(songUrl)")
                self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
            }
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
        
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
        
        //nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
                

        
    
        
        
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
                        self.songPlayProgress()
                    }
                    else{
                        AudioService.instance.nowPlayingIndex = 0
                        self.songPlayProgress()
                    }
            }
            else{
                randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                AudioService.instance.nowPlayingIndex = randomInt
                self.songPlayProgress()
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
                            self.songPlayProgress()
                        }
                        else{
                            AudioService.instance.nowPlayingIndex = 0
                            self.songPlayProgress()
                        }
                }
                else{
                    randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                    AudioService.instance.nowPlayingIndex = randomInt
                    self.songPlayProgress()
                }
            }
        }
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
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

    
    @IBAction func action_SmallPlayPause(_ sender: UIButton) {
        self.playPause()
    }

    
    func playPause(){
        if AudioService.instance.player.rate == 0
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
      //  self.view.insertSubview(AudioService.instance.controller.view, at: 0)
        AudioService.instance.controller.allowsPictureInPicturePlayback = true
    }
    
    @IBAction func openPlayBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlaySongVC") as! PlaySongVC
        navigationController?.pushViewController(vc,animated: false)
        //self.present(vc, animated: true, completion: nil)
    }
    

    
    func MyProfileAPICall(){
        AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
            if success{
                self.lbl_Name.text = "\(AuthService.instance.username!)"

            }else{
                //print(message)
            }
        })
    }

}
