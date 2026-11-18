//
//  AlbamDetailsVC.swift
//  WEMU
//
//  Created by Arun Halder on 14/09/22.
//

import UIKit
import MarqueeLabel
import MediaPlayer

class AlbamDetailsVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
  
    @IBOutlet weak var tblBtnCons: NSLayoutConstraint!
    @IBOutlet weak var lbl_NoNotificationFound: UILabel!
    @IBOutlet var vw_Background: UIView!
    @IBOutlet weak var lblAlbumSubTitle: UILabel!
    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var tblevw_AlbamDetails: UITableView!
    @IBOutlet weak var lblAlbumTitle: UILabel!
    
    @IBOutlet weak var vw_SmallPlayer: UIView!
    
    @IBOutlet weak var lbl_SmallTitle: MarqueeLabel!
    @IBOutlet weak var lbl_SmallTag: MarqueeLabel!
    @IBOutlet weak var imgvw_SmallImage: UIImageView!
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btn_SmallPlay: UIButton!
    
    @IBOutlet weak var lbl_AlbamsYouMayLike: UILabel!
    @IBOutlet weak var albamListCollectionVw: UICollectionView!
    
    @IBOutlet weak var vw_PlayListBack: RoundView!
    @IBOutlet weak var playListCollectionVw: UICollectionView!
    
    @IBOutlet weak var imgVw_Bell: UIImageView!
    @IBOutlet weak var imgVw_Back: UIImageView!
    @IBOutlet weak var heightAlbamViewConstant: NSLayoutConstraint!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    var showHide = false
    var nowPlayingInfo = [String: Any]()
    var count = 0
    var randomInt = 0
    
    var playShowBool = false
    var pauseBool    = false
    var playSelectedIndex = 0
    var collectionNameStr = ""
    var strPageNo = 1
    var albumID = ""
    var categoryId = ""
    var strAlbumURL = ""
    var artistID = ""
    var tripleDotActiveIndex = 9999999
    var trackIdStr = ""

    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.vw_PlayListBack.isHidden = true
    }
    
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func action_PlayPrevious(_ sender: UIButton) {
        AudioService.instance.previousSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
        self.tblevw_AlbamDetails.reloadData()
    }
    
    
    @IBAction func action_PlayNext(_ sender: UIButton) {
        AudioService.instance.nextSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
        self.tblevw_AlbamDetails.reloadData()
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
        self.tblevw_AlbamDetails.reloadData()
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
        
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
       // nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
                

        
    
        
        
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
            if AudioService.instance.repeatSongBool == true{
                AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex
              //  DispatchQueue.main.async {
                    self.songPlayProgress()
               // }
            }
            else{
                if AudioService.instance.randomSongBool == true{
                    randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                    AudioService.instance.nowPlayingIndex = randomInt
                   // DispatchQueue.main.async {
                        self.songPlayProgress()
                   // }

                }
                else{
                    if AudioService.instance.nowPlayingIndex < AudioService.instance.nowPlayingListArray.count - 1{
                        AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex + 1
                       // DispatchQueue.main.async {
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
                if AudioService.instance.repeatSongBool == true{
                    AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex
                    self.songPlayProgress()
                }
                else{
                    if AudioService.instance.randomSongBool == true{
                        randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                        AudioService.instance.nowPlayingIndex = randomInt
                        self.songPlayProgress()

                    }
                    else{
                        if AudioService.instance.nowPlayingIndex < AudioService.instance.nowPlayingListArray.count - 1{
                            AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex + 1
                            self.songPlayProgress()

                        }
                        else{
                            AudioService.instance.nowPlayingIndex = 0
                            self.songPlayProgress()
                        }
                    }
                }
            }
        }
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        self.tblevw_AlbamDetails.reloadData()
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
    
    @IBAction func btnPlayAllAction(_ sender: UIButton) {
        AudioService.instance.playAllBool = true
        self.playSelectedIndex = 0
        AudioService.instance.nowPlayingIndex = self.playSelectedIndex
        
        if collectionNameStr == "genres" {
            AudioService.instance.nowPlayingListArray = AuthService.instance.genericDetailListArray
        }else if collectionNameStr == "albam"{
            AudioService.instance.nowPlayingListArray = AuthService.instance.albumSongsListArray
        }else if collectionNameStr == "searchAlbams"{
            AudioService.instance.nowPlayingListArray = AuthService.instance.albumSongsListArray
        }else if collectionNameStr == "searchArtists"{
            AudioService.instance.nowPlayingListArray = AuthService.instance.artistSongsListArray
        }else if collectionNameStr == "myPlayList"{
            AudioService.instance.nowPlayingListArray = AuthService.instance.myPlayListDetailsArray
        }
        else{
            AudioService.instance.nowPlayingListArray = AuthService.instance.artistSongsListArray
        }

        if AudioService.instance.nowPlayingListArray.count > 0{
            self.vw_SmallPlayer.isHidden = false
            AudioService.instance.isPlayerOn = true
            bottomConstant.constant = -120.0
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
               // }
            }

        }
        else{
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "There is no song to play."
            customAlert.delegate = self
            customAlert.show()
        }
        
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        
        self.tblevw_AlbamDetails.reloadData()
    }
    
    @IBAction func openPlayBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlaySongVC") as! PlaySongVC
        self.navigationController?.pushViewController(vc,animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            let url = URL(string:"\(self.strAlbumURL)")
            self.imgAlbum.kf.setImage(with: url)
        }
        
        
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
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("NewFunctionName"), object: nil)
        DispatchQueue.main.async {
            self.setupNowPlayingInfoCenter()
            AuthService.instance.albumSongsListArray.removeAll()
            AuthService.instance.myPlayListDetailsArray.removeAll()
        }
        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_AlbamsYouMayLike.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_AlbamsYouMayLike.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if AudioService.instance.isPlayerOn == true{
            bottomConstant.constant = -120.0
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
           // tblBtnCons.constant = 300.0
        }
        else{
            self.vw_SmallPlayer.isHidden = true
           // tblBtnCons.constant = 300.0
            bottomConstant.constant = 0.0
        }

        DispatchQueue.main.async {
            if self.collectionNameStr == "genres" {
                self.GenresAPICall(self.albumID)
                self.heightAlbamViewConstant.constant = 0.0
            }else if self.collectionNameStr == "albam" {
                self.albamListAPICall(songIdStr: self.albumID, pageNoStr: self.strPageNo)
                self.categoryAlbamAPICall()
                self.heightAlbamViewConstant.constant = 150.0
            }else if self.collectionNameStr == "searchAlbams" {
                self.albamListAPICall(songIdStr: self.albumID, pageNoStr: self.strPageNo)
                self.categoryAlbamAPICall()
                self.heightAlbamViewConstant.constant = 150.0
            }else if self.collectionNameStr == "artist"{
                self.artistListAPICall(artistID: self.artistID)
                self.heightAlbamViewConstant.constant = 0.0
            }else if self.collectionNameStr == "searchArtists"{
                self.artistListAPICall(artistID: self.artistID)
                self.heightAlbamViewConstant.constant = 0.0
            }else if self.collectionNameStr == "myPlayList"{
                self.heightAlbamViewConstant.constant = 0.0
                self.myPlayListAPICall(self.albumID, self.strPageNo)
            }
            else{
            }
            
          //  self.MyProfileAPICall()
        }
        self.tblevw_AlbamDetails.reloadData()

    }
    
    //MARK: API CALL
        
        func MyProfileAPICall(){
            AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
                if success{
                }else{
                }
            })
        }
    
    func GenresAPICall(_ songIdStr:String){
        HUD.show(to: self.view)
        AuthService.instance.GenresAPICall(songIdStr:albumID, completion: {(success, data, message) in
            if success{
                if AuthService.instance.genericDetailListArray.count > 0{
                    self.tblevw_AlbamDetails.reloadData()
                    self.tblevw_AlbamDetails.isHidden = false
                    self.lbl_NoNotificationFound.isHidden = true
                }
                else{
                    self.tblevw_AlbamDetails.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false

                }
                HUD.hide(to: self.view)
            }else{
                self.tblevw_AlbamDetails.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false
                HUD.hide(to: self.view)
            }
        })
        
    }
    
    func albamListAPICall(songIdStr:String,pageNoStr:Int){
        HUD.show(to: self.view)
      //  AuthService.instance.albumSongsListArray.removeAll()
        AuthService.instance.AlbamSongsAPI(songIdStr:songIdStr,pageNoStr:"\(pageNoStr)", completion: {(success, data, message) in
            if success{
                if AuthService.instance.albumSongsListArray.count > 0{
                    self.tblevw_AlbamDetails.reloadData()
                    self.tblevw_AlbamDetails.isHidden = false
                    self.lbl_NoNotificationFound.isHidden = true
                }
                else{
                    self.tblevw_AlbamDetails.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false

                }
                HUD.hide(to: self.view)
            }else{
                self.tblevw_AlbamDetails.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false
                HUD.hide(to: self.view)
            }
        })
    }
    
    func artistListAPICall(artistID:String){
        HUD.show(to: self.view)
        AuthService.instance.ArtistSongsAPI(artistUserIdStr: "\(artistID)", completion: {(success, data, message) in
            if success{
                if AuthService.instance.artistSongsListArray.count > 0{
                    self.tblevw_AlbamDetails.reloadData()
                    self.tblevw_AlbamDetails.isHidden = false
                    self.lbl_NoNotificationFound.isHidden = true
                }
                else{
                    self.tblevw_AlbamDetails.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false

                }
                HUD.hide(to: self.view)
            }else{
                self.tblevw_AlbamDetails.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false
                HUD.hide(to: self.view)
            }
        })
    }
    
    func categoryAlbamAPICall(){
        HUD.show(to: self.view)
        AuthService.instance.CategoryAlbamAPI(catIdStr: "\(categoryId)", completion: {(success, data, message) in
            if success{
                if AuthService.instance.categoryAlbamListArray.count > 0{
                    self.albamListCollectionVw.reloadData()
                }
            
                HUD.hide(to: self.view)
            }else{
                HUD.hide(to: self.view)
            }
        })
    }
    
    func myPlayListAPICall(_ albumID:String, _ pageNoStr:Int){
        HUD.show(to: self.view)
        AuthService.instance.MyPlayListDetailsAPI(playListIdStr:albumID,pageNoStr:"\(pageNoStr)", completion: {(success, data, message) in
            if success{
                if AuthService.instance.myPlayListDetailsArray.count > 0{
                    self.tblevw_AlbamDetails.reloadData()
                    self.tblevw_AlbamDetails.isHidden = false
                    self.lbl_NoNotificationFound.isHidden = true
                }
                else{
                    self.tblevw_AlbamDetails.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false

                }
                HUD.hide(to: self.view)
            }else{
                self.tblevw_AlbamDetails.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false
                HUD.hide(to: self.view)
            }
        })
    }
    
    func songLikeAPICall(songIdStr:String){
        HUD.show(to: self.view)
        AuthService.instance.songLikeAPI(songIdStr: "\(songIdStr)",completion: {(success, data, message) in
            if success{
                self.tblevw_AlbamDetails.reloadData()
                
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
                self.tblevw_AlbamDetails.reloadData()
            }else{
            }
        })
        
        AuthService.instance.PlaySongsAPI(songIdStr: "\(songIdStr)",completion: {(success, data, message) in
            if success{
                self.tblevw_AlbamDetails.reloadData()
            }else{
            }
        })
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension AlbamDetailsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if collectionNameStr == "genres" {
            rowCount = AuthService.instance.genericDetailListArray.count
        }else if collectionNameStr == "albam"{
            rowCount = AuthService.instance.albumSongsListArray.count
        }else if collectionNameStr == "searchAlbams"{
            rowCount = AuthService.instance.albumSongsListArray.count
        }else if collectionNameStr == "searchArtists"{
            rowCount = AuthService.instance.artistSongsListArray.count
        }else if collectionNameStr == "myPlayList"{
            rowCount = AuthService.instance.myPlayListDetailsArray.count
        }
        else{
            rowCount = AuthService.instance.artistSongsListArray.count
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbamDetailsTVC", for: indexPath) as! AlbamDetailsTVC
        
        if collectionNameStr == "genres" {
            
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
               // cell.lbl_Number.text = "\(indexPath.row + 1)"
            cell.lb_SongName.text = AuthService.instance.genericDetailListArray[indexPath.row]["title"].stringValue
            if AuthService.instance.genericDetailListArray[indexPath.row]["description"].stringValue != ""{
                cell.lbl_AuthorName.text = AuthService.instance.genericDetailListArray[indexPath.row]["description"].stringValue
            }
            else{
                cell.lbl_AuthorName.text = AuthService.instance.genericDetailListArray[indexPath.row]["artists_name"][0].stringValue

            }
            //cell.lbl_AuthorName.text = AuthService.instance.genericDetailListArray[indexPath.row]["description"].stringValue
                        
            let viewStr = AuthService.instance.genericDetailListArray[indexPath.row]["views_count"].stringValue
            let playStr = AuthService.instance.genericDetailListArray[indexPath.row]["play_count"].stringValue
            let likeStr = AuthService.instance.genericDetailListArray[indexPath.row]["like_count"].stringValue
            
            cell.lbl_ViewLikePlay.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
            
            let imageurl = AuthService.instance.genericDetailListArray[indexPath.row]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            cell.imgvw_Albam.kf.setImage(with: url)
            
            if AuthService.instance.whiteTheam == true{
                print("UISwitch state is now ON")
                cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            else{
                print("UISwitch state is now Off")
                cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }

            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.tblevw_AlbamDetails.reloadData()
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
                    if AuthService.instance.genericDetailListArray.count > 0{
                        self.trackIdStr = AuthService.instance.genericDetailListArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.genericDetailListArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.genericDetailListArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true
                self.tblevw_AlbamDetails.reloadData()

            }
            
            if AuthService.instance.genericDetailListArray[indexPath.row]["song_id"].stringValue == AudioService.instance.nowPlayingSongId{
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
            
            
        }
        else if collectionNameStr == "albam"{
            
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                //cell.lbl_Number.text = "\(indexPath.row + 1)"

            cell.lb_SongName.text = AuthService.instance.albumSongsListArray[indexPath.row]["title"].stringValue
            
            if AuthService.instance.albumSongsListArray[indexPath.row]["description"].stringValue != ""{
                cell.lbl_AuthorName.text = AuthService.instance.albumSongsListArray[indexPath.row]["description"].stringValue
            }
            else{
                cell.lbl_AuthorName.text = AuthService.instance.albumSongsListArray[indexPath.row]["artists_name"][0].stringValue

            }
            
           // cell.lbl_AuthorName.text = AuthService.instance.albumSongsListArray[indexPath.row]["description"].stringValue

                        
            let viewStr = AuthService.instance.albumSongsListArray[indexPath.row]["views_count"].stringValue
            let playStr = AuthService.instance.albumSongsListArray[indexPath.row]["play_count"].stringValue
            let likeStr = AuthService.instance.albumSongsListArray[indexPath.row]["like_count"].stringValue
            
            cell.lbl_ViewLikePlay.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
            
            let imageurl = AuthService.instance.albumSongsListArray[indexPath.row]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            cell.imgvw_Albam.kf.setImage(with: url)
            
            if AuthService.instance.whiteTheam == true{
                print("UISwitch state is now ON")
                cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            else{
                print("UISwitch state is now Off")
                cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.tblevw_AlbamDetails.reloadData()
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
                    if AuthService.instance.albumSongsListArray.count > 0{
                        self.trackIdStr = AuthService.instance.albumSongsListArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.albumSongsListArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.albumSongsListArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true
                self.tblevw_AlbamDetails.reloadData()

            }
            
            if AuthService.instance.albumSongsListArray[indexPath.row]["song_id"].stringValue == AudioService.instance.nowPlayingSongId{
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
        }
        else if collectionNameStr == "searchAlbams"{
            
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                //cell.lbl_Number.text = "\(indexPath.row + 1)"

            cell.lb_SongName.text = AuthService.instance.albumSongsListArray[indexPath.row]["title"].stringValue
            
            if AuthService.instance.albumSongsListArray[indexPath.row]["description"].stringValue != ""{
                cell.lbl_AuthorName.text = AuthService.instance.albumSongsListArray[indexPath.row]["description"].stringValue
            }
            else{
                cell.lbl_AuthorName.text = AuthService.instance.albumSongsListArray[indexPath.row]["artists_name"][0].stringValue

            }
            
            //cell.lbl_AuthorName.text = AuthService.instance.albumSongsListArray[indexPath.row]["description"].stringValue
    
                        
            let viewStr = AuthService.instance.albumSongsListArray[indexPath.row]["views_count"].stringValue
            let playStr = AuthService.instance.albumSongsListArray[indexPath.row]["play_count"].stringValue
            let likeStr = AuthService.instance.albumSongsListArray[indexPath.row]["like_count"].stringValue
            
            cell.lbl_ViewLikePlay.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
            
            if AuthService.instance.whiteTheam == true{
                print("UISwitch state is now ON")
                cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            else{
                print("UISwitch state is now Off")
                cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            let imageurl = AuthService.instance.albumSongsListArray[indexPath.row]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            cell.imgvw_Albam.kf.setImage(with: url)

            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.tblevw_AlbamDetails.reloadData()
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
                    if AuthService.instance.albumSongsListArray.count > 0{
                        self.trackIdStr = AuthService.instance.albumSongsListArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.albumSongsListArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.albumSongsListArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true
                self.tblevw_AlbamDetails.reloadData()

            }
            
            if AuthService.instance.albumSongsListArray[indexPath.row]["song_id"].stringValue == AudioService.instance.nowPlayingSongId{
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
            
        }
        else if collectionNameStr == "searchArtists"{
            
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                //cell.lbl_Number.text = "\(indexPath.row + 1)"

            cell.lb_SongName.text = AuthService.instance.artistSongsListArray[indexPath.row]["title"].stringValue
            
            if AuthService.instance.artistSongsListArray[indexPath.row]["description"].stringValue != ""{
                cell.lbl_AuthorName.text = AuthService.instance.artistSongsListArray[indexPath.row]["description"].stringValue
            }
            else{
                cell.lbl_AuthorName.text = AuthService.instance.artistSongsListArray[indexPath.row]["artists_name"][0].stringValue

            }
            //cell.lbl_AuthorName.text = AuthService.instance.artistSongsListArray[indexPath.row]["description"].stringValue
                        
            let viewStr = AuthService.instance.artistSongsListArray[indexPath.row]["views_count"].stringValue
            let playStr = AuthService.instance.artistSongsListArray[indexPath.row]["play_count"].stringValue
            let likeStr = AuthService.instance.artistSongsListArray[indexPath.row]["like_count"].stringValue
            
            cell.lbl_ViewLikePlay.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
            
            if AuthService.instance.whiteTheam == true{
                print("UISwitch state is now ON")
                cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            else{
                print("UISwitch state is now Off")
                cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            let imageurl = AuthService.instance.artistSongsListArray[indexPath.row]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            cell.imgvw_Albam.kf.setImage(with: url)
            
           // strPageNo = strPageNo+1
           // albamListAPICall(songIdStr: albumID, pageNoStr: strPageNo)
           
            
//            let totalRows = tableView.numberOfRows(inSection: indexPath.section)
//            //first get total rows in that section by current indexPath.
//            if indexPath.row == totalRows - 1 {
//                //this is the last row in section.
//                print(indexPath.row)
//                if AuthService.instance.artistListLastPage >= AuthService.instance.artistListCurrentPage{
//                    strPageNo = strPageNo+1
//                  //  albamListAPICall(songIdStr: albumID, pageNoStr: strPageNo)
//                    albamListAPICall(songIdStr: albumID, pageNoStr: strPageNo)
//
//                }
//
//            }
            
            //
            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.tblevw_AlbamDetails.reloadData()
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
                    if AuthService.instance.artistSongsListArray.count > 0{
                        self.trackIdStr = AuthService.instance.artistSongsListArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.artistSongsListArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.artistSongsListArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true
                self.tblevw_AlbamDetails.reloadData()

            }
            
            if AuthService.instance.artistSongsListArray[indexPath.row]["song_id"].stringValue == AudioService.instance.nowPlayingSongId{
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
            
        }
        else if collectionNameStr == "artist"{
            
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                //cell.lbl_Number.text = "\(indexPath.row + 1)"

            cell.lb_SongName.text = AuthService.instance.artistSongsListArray[indexPath.row]["title"].stringValue
            
            if AuthService.instance.artistSongsListArray[indexPath.row]["description"].stringValue != ""{
                cell.lbl_AuthorName.text = AuthService.instance.artistSongsListArray[indexPath.row]["description"].stringValue
            }
            else{
                cell.lbl_AuthorName.text = AuthService.instance.artistSongsListArray[indexPath.row]["artists_name"][0].stringValue

            }
            
            //cell.lbl_AuthorName.text = AuthService.instance.artistSongsListArray[indexPath.row]["description"].stringValue
                        
            let viewStr = AuthService.instance.artistSongsListArray[indexPath.row]["views_count"].stringValue
            let playStr = AuthService.instance.artistSongsListArray[indexPath.row]["play_count"].stringValue
            let likeStr = AuthService.instance.artistSongsListArray[indexPath.row]["like_count"].stringValue
            
            cell.lbl_ViewLikePlay.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
            
            if AuthService.instance.whiteTheam == true{
                print("UISwitch state is now ON")
                cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            else{
                print("UISwitch state is now Off")
                cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            let imageurl = AuthService.instance.artistSongsListArray[indexPath.row]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            cell.imgvw_Albam.kf.setImage(with: url)
    
            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.tblevw_AlbamDetails.reloadData()
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
                    if AuthService.instance.artistSongsListArray.count > 0{
                        self.trackIdStr = AuthService.instance.artistSongsListArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.artistSongsListArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.artistSongsListArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true
                self.tblevw_AlbamDetails.reloadData()

            }
            
            if AuthService.instance.artistSongsListArray[indexPath.row]["song_id"].stringValue == AudioService.instance.nowPlayingSongId{
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
        }
        
        else if collectionNameStr == "myPlayList"{
            
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                //cell.lbl_Number.text = "\(indexPath.row + 1)"

            if AuthService.instance.myPlayListDetailsArray.count > 0 {
                
            
            cell.lb_SongName.text = AuthService.instance.myPlayListDetailsArray[indexPath.row]["title"].stringValue
                if AuthService.instance.myPlayListDetailsArray[indexPath.row]["description"].stringValue != ""{
                    cell.lbl_AuthorName.text = AuthService.instance.myPlayListDetailsArray[indexPath.row]["description"].stringValue
                }
                else{
                    cell.lbl_AuthorName.text = AuthService.instance.myPlayListDetailsArray[indexPath.row]["artists_name"][0].stringValue

                }
            //cell.lbl_AuthorName.text = AuthService.instance.myPlayListDetailsArray[indexPath.row]["description"].stringValue
                        
            let viewStr = AuthService.instance.myPlayListDetailsArray[indexPath.row]["views_count"].stringValue
            let playStr = AuthService.instance.myPlayListDetailsArray[indexPath.row]["play_count"].stringValue
            let likeStr = AuthService.instance.myPlayListDetailsArray[indexPath.row]["like_count"].stringValue
            
            cell.lbl_ViewLikePlay.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
            
            if AuthService.instance.whiteTheam == true{
                print("UISwitch state is now ON")
                cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            else{
                print("UISwitch state is now Off")
                cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_AuthorName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lbl_ViewLikePlay.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            let imageurl = AuthService.instance.myPlayListDetailsArray[indexPath.row]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            cell.imgvw_Albam.kf.setImage(with: url)
            
            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.tblevw_AlbamDetails.reloadData()
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
                    if AuthService.instance.myPlayListDetailsArray.count > 0{
                        self.trackIdStr = AuthService.instance.myPlayListDetailsArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.myPlayListDetailsArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.myPlayListDetailsArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true
                self.tblevw_AlbamDetails.reloadData()
            }
            
            if AuthService.instance.myPlayListDetailsArray[indexPath.row]["song_id"].stringValue == AudioService.instance.nowPlayingSongId{
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
                
            }
            
        }
        
        else{
            
        }
        

    return cell
}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if collectionNameStr == "genres" {
            if (indexPath.row == AuthService.instance.genericDetailListArray.count - 1 ) { //it's your last cell
              //Load more data & reload your collection view
                print("========================LAST INDEX=================================")
                if AuthService.instance.albumCurrentPage > AuthService.instance.albumLastPage{
                    GenresAPICall(albumID)
                }
            }
        }else if collectionNameStr == "albam"{
            if (indexPath.row == AuthService.instance.albumSongsListArray.count - 1 ){
                //this is the last row in section.
                print(indexPath.row)
                if AuthService.instance.albumLastPage > AuthService.instance.albumCurrentPage{
                   // strPageNo = strPageNo+1
                    albamListAPICall(songIdStr: albumID, pageNoStr: AuthService.instance.albumLastPage)
                }
                
            }
        }else if collectionNameStr == "searchAlbams"{
            if (indexPath.row == AuthService.instance.albumSongsListArray.count - 1 ){
                //this is the last row in section.
                print(indexPath.row)
                if AuthService.instance.albumLastPage > AuthService.instance.albumCurrentPage{
                  //  strPageNo = strPageNo+1
                    albamListAPICall(songIdStr: albumID, pageNoStr: AuthService.instance.albumLastPage)
                }
                
            }
        }else{
            if (indexPath.row == AuthService.instance.albumSongsListArray.count - 1 ){
                //this is the last row in section.
                print(indexPath.row)
                if AuthService.instance.albumLastPage > AuthService.instance.albumCurrentPage{
                   // strPageNo = strPageNo+1
                    albamListAPICall(songIdStr: albumID, pageNoStr: AuthService.instance.albumLastPage)
                }
                
            }
        }

   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
            if let cell = tblevw_AlbamDetails.cellForRow(at: selectedIndexPath) as? AlbamDetailsTVC{
                cell.vw_SHare.isHidden = true
            }
        
        self.vw_SmallPlayer.isHidden = false
        self.playSelectedIndex = indexPath.row
        AudioService.instance.nowPlayingIndex = self.playSelectedIndex
        AudioService.instance.isPlayerOn = true
        bottomConstant.constant = -120.0
        if collectionNameStr == "genres" {
            AudioService.instance.nowPlayingListArray = AuthService.instance.genericDetailListArray
        }else if collectionNameStr == "albam"{
            AudioService.instance.nowPlayingListArray = AuthService.instance.albumSongsListArray
        }else if collectionNameStr == "searchAlbams"{
            AudioService.instance.nowPlayingListArray = AuthService.instance.albumSongsListArray
        }else if collectionNameStr == "myPlayList"{
            AudioService.instance.nowPlayingListArray = AuthService.instance.myPlayListDetailsArray
        }
        else{
            AudioService.instance.nowPlayingListArray = AuthService.instance.artistSongsListArray
        }

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
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        
        let songString = "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["audio_location"].stringValue)"
        if songString == ""{
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "There is no song left."
            customAlert.delegate = self
            customAlert.show()
        
        }else{
          //  DispatchQueue.main.async {
                AudioService.instance.playSong(SongURL: songString)
                self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
           // }
            
            // prepare title and subtitle
            nowPlayingInfo[MPMediaItemPropertyTitle] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
            
            if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
                nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
            }
            else{
                nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

            }
            
          //  nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
                    
            // asynchronously download album art image.
            // here, for simplicity, an image from asset catalog is loaded
//            if let albumArt = UIImage(named: "AppIcon") {
//                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumArt.size, requestHandler: { imageSize in
//                    return albumArt
//                })
//            }
            
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
        self.tripleDotActiveIndex = 9999999
        self.tblevw_AlbamDetails.reloadData()
        
    }
}

extension AlbamDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.playListCollectionVw{
            if AuthService.instance.myPlaySongListAlbamArray.count > 0{
                return AuthService.instance.myPlaySongListAlbamArray.count
            }
            else{
                return 0
            }
        }
        else{
            if AuthService.instance.categoryAlbamListArray.count > 0{
                return AuthService.instance.categoryAlbamListArray.count
            }
            else{
                return 0
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCVC", for: indexPath) as! DashBoardCVC
        
        if collectionView == self.playListCollectionVw {

            if AuthService.instance.myPlaySongListAlbamArray.count > 0{
                
                cell.lb_SongName.text = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["name"].stringValue
                
                let imageurl = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgvw_Albam.kf.setImage(with: url)
                
                if AuthService.instance.whiteTheam == true{
                    print("UISwitch state is now ON")
                    cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                else{
                    print("UISwitch state is now Off")
                    cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }else{
            if AuthService.instance.categoryAlbamListArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.categoryAlbamListArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.categoryAlbamListArray[indexPath.row]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgVw_Albam.kf.setImage(with: url)
                
                if AuthService.instance.whiteTheam == true{
                    print("UISwitch state is now ON")
                    cell.lbl_AlbamName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                else{
                    print("UISwitch state is now Off")
                    cell.lbl_AlbamName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
        
            
        return cell

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        
        var width_collView = 0.0
        var hight_collView = 0.0

        if collectionView == self.playListCollectionVw{
            width_collView = Double((UIScreen.main.bounds.width-40)/2)
            hight_collView = 190.0
        }
        else{
            width_collView = 99.0
            hight_collView = 130.0
        }

        return CGSize(width: width_collView, height: hight_collView)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.playListCollectionVw{
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

        }else{
            self.collectionNameStr = "albam"
            self.albumID = AuthService.instance.categoryAlbamListArray[indexPath.row]["palbum_id"].stringValue
            self.categoryId = AuthService.instance.categoryAlbamListArray[indexPath.row]["category_id"].stringValue
            self.strAlbumURL = AuthService.instance.categoryAlbamListArray[indexPath.row]["thumbnail"].stringValue
            AuthService.instance.albumSongsListArray.removeAll()
            albamListAPICall(songIdStr: self.albumID, pageNoStr: strPageNo)
            categoryAlbamAPICall()
        }
        

    }
    
    
    
}
