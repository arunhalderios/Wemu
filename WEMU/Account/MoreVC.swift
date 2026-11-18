//
//  MoreVC.swift
//  WEMU
//
//  Created by Arun Halder on 28/09/22.
//

import UIKit
import MarqueeLabel
import MediaPlayer
import SwiftGifOrigin


class MoreVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    @IBOutlet weak var imgVw_Back: UIImageView!
    @IBOutlet weak var imgVw_Bell: UIImageView!
    @IBOutlet var vw_Background: UIView!

    @IBOutlet weak var vw_SmallPlayer: UIView!
    
    @IBOutlet weak var lbl_SmallTitle: MarqueeLabel!
    @IBOutlet weak var lbl_SmallTag: MarqueeLabel!
    @IBOutlet weak var imgvw_SmallImage: UIImageView!
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btn_SmallPlay: UIButton!
    
    @IBOutlet weak var lbl_CollectionTitle: UILabel!
    @IBOutlet weak var lbl_SongsCount: UILabel!
    @IBOutlet weak var tblevw_NewMusic: UITableView!
    
    @IBOutlet weak var lbl_NoNotificationFound: UILabel!
    
    @IBOutlet weak var vw_PlayListBack: RoundView!
    @IBOutlet weak var playListCollectionVw: UICollectionView!
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    var showHide = false
    
    var collectionNameStr = ""
    var searchKey = ""
    var selectedIndex = 0
    var tripleDotActiveIndex = 9999999
    var trackIdStr = ""
    
    var nowPlayingInfo = [String: Any]()
    var count = 0
    var randomInt = 0
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.vw_PlayListBack.isHidden = true
    }
    
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(vc,animated: true)
    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tblevw_NewMusic.delegate = self
        tblevw_NewMusic.dataSource = self
        
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
            AudioService.instance.setupNowPlayingInfoCenter()
            self.APICAll()
            self.myPlayListAPICall()
        }
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_CollectionTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_SongsCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
            self.imgVw_Back.image = UIImage(named: "backBlack")
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_CollectionTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_SongsCount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
    
    func APICAll(){
        if collectionNameStr == "searchArtists"{
            self.lbl_CollectionTitle.text = "Artists"
            if AuthService.instance.searchArtistListArray.count > 0{
                self.tblevw_NewMusic.reloadData()
                self.tblevw_NewMusic.isHidden = false
                self.lbl_NoNotificationFound.isHidden = true
            }else{
                self.tblevw_NewMusic.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false
            }
        }
        else if collectionNameStr == "searchAlbams"{
            self.lbl_CollectionTitle.text = "Albams"
            if AuthService.instance.searchAlbamListArray.count > 0{
                self.tblevw_NewMusic.reloadData()
                self.tblevw_NewMusic.isHidden = false
                self.lbl_NoNotificationFound.isHidden = true
            }else{
                self.tblevw_NewMusic.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false
            }
        }
        else if collectionNameStr == "searchSongs"{
            self.lbl_CollectionTitle.text = "Songs"
            if AuthService.instance.searchSongListArray.count > 0{
                self.tblevw_NewMusic.reloadData()
                self.tblevw_NewMusic.isHidden = false
                self.lbl_NoNotificationFound.isHidden = true
            }else{
                self.tblevw_NewMusic.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false
            }
        }
        else if collectionNameStr == "popularSong"{
           // HUD.show(to: self.view)
            self.lbl_CollectionTitle.text = "Popular Songs"
           // HUD.show(to: self.view)
            AuthService.instance.SongListAPI(keyStr: "popular", completion: {(success, data, message) in
                if success{
                    if AuthService.instance.songListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }


                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false

                }
        })
             
        }
        else if collectionNameStr == "moreRecently"{
            self.lbl_CollectionTitle.text = "Recently Played"
            HUD.show(to: self.view)

            AuthService.instance.RecentPlayedAPI( completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)
                    if AuthService.instance.songListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }


                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                    HUD.hide(to: self.view)

                }
        })
            
        }
        else if collectionNameStr == "moreNewReleases"{
            self.lbl_CollectionTitle.text = "New Releases"
          //  HUD.show(to: self.view)
            AuthService.instance.SongListAPI(keyStr: "new", completion: {(success, data, message) in
                if success{
                    if AuthService.instance.songListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }


                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                    HUD.hide(to: self.view)
                }
        })
            
        }
        else if collectionNameStr == "moreTrendingNow"{
            self.lbl_CollectionTitle.text = "Trending Now"
            HUD.show(to: self.view)
            AuthService.instance.SongListAPI(keyStr: "trending", completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)

                    if AuthService.instance.songListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }

                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                    HUD.hide(to: self.view)

                }
        })
            
        }
        else if collectionNameStr == "moreNewAlbams"{
            self.lbl_CollectionTitle.text = "New Albams"
            HUD.show(to: self.view)
            AuthService.instance.SongListAPI(keyStr: "new", completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)

                    if AuthService.instance.songListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }


                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                    HUD.hide(to: self.view)

                }
        })
            
        }
        else if collectionNameStr == "moreRecommended"{
            self.lbl_CollectionTitle.text = "Recommended"
            HUD.show(to: self.view)
            AuthService.instance.SongListAPI(keyStr: "recomended", completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)

                    if AuthService.instance.songListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }


                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                    HUD.hide(to: self.view)

                }
        })
            
        }
        else if collectionNameStr == "moreMostPopularThisWeek"{
            self.lbl_CollectionTitle.text = "Most Popular This Week"
            HUD.show(to: self.view)
            AuthService.instance.SongListAPI(keyStr: "most_popular", completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)

                    if AuthService.instance.songListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }


                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                    HUD.hide(to: self.view)

                }
        })
        }
        else if collectionNameStr == "song"{
            self.lbl_CollectionTitle.text = "Songs"
            HUD.show(to: self.view)
            AuthService.instance.searchSongsListAPI(songIdStr: "\(searchKey)", completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)

                    if AuthService.instance.searchSongListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }


                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                    HUD.hide(to: self.view)

                }
        })
        }
        else if collectionNameStr == "albam"{
            self.lbl_CollectionTitle.text = "Albams"
            HUD.show(to: self.view)
            AuthService.instance.artistAlbamListAPI(songIdStr: "\(searchKey)", completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)

                    if AuthService.instance.artistAlbamListArray.count > 0{
                        self.tblevw_NewMusic.reloadData()
                        self.tblevw_NewMusic.isHidden = false
                        self.lbl_NoNotificationFound.isHidden = true
                    }else{
                        self.tblevw_NewMusic.isHidden = true
                        self.lbl_NoNotificationFound.isHidden = false
                    }


                }else{
                    self.tblevw_NewMusic.isHidden = true
                    self.lbl_NoNotificationFound.isHidden = false
                    HUD.hide(to: self.view)

                }
        })
        }
        else if collectionNameStr == "search"{
            AudioService.instance.pause()
            AudioService.instance.isPlayerOn = false
            self.vw_SmallPlayer.isHidden = true
            self.lbl_CollectionTitle.text = "Search Result"
            if AuthService.instance.searchSongListArray.count > 0{
               self.tblevw_NewMusic.reloadData()
                self.tblevw_NewMusic.isHidden = false
                self.lbl_NoNotificationFound.isHidden = true
            }else{
                self.tblevw_NewMusic.isHidden = true
                self.lbl_NoNotificationFound.isHidden = false
            }


        }else{
            self.tblevw_NewMusic.isHidden = true
            self.lbl_NoNotificationFound.isHidden = false
            
        }

    }
    
    @IBAction func action_PlayPrevious(_ sender: UIButton) {
        AudioService.instance.previousSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
        self.tblevw_NewMusic.reloadData()

    }
    
    @IBAction func action_PlayNext(_ sender: UIButton) {
        AudioService.instance.nextSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
        self.tblevw_NewMusic.reloadData()
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
        self.tblevw_NewMusic.reloadData()
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
           // DispatchQueue.main.async {
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
        self.tblevw_NewMusic.reloadData()

    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        
        if AuthService.instance.subcription == true{
            if AudioService.instance.randomSongBool == false{
                    if AudioService.instance.nowPlayingIndex < AudioService.instance.nowPlayingListArray.count-1{
                        AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex + 1
                      //  DispatchQueue.main.async {
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
                           // DispatchQueue.main.async {
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
                   // }
                }
            }
        }
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        self.tblevw_NewMusic.reloadData()
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
        //self.view.insertSubview(AudioService.instance.controller.view, at: 0)
        AudioService.instance.controller.allowsPictureInPicturePlayback = true
    }
    
    @IBAction func openPlayBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlaySongVC") as! PlaySongVC
        navigationController?.pushViewController(vc,animated: false)
        //self.present(vc, animated: true, completion: nil)
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
                self.APICAll()
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
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
}

extension MoreVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if collectionNameStr == "searchArtists"{
            if AuthService.instance.searchArtistListArray.count > 0{
                count = AuthService.instance.searchArtistListArray.count
           }
        }
        else if collectionNameStr == "searchAlbams"{
            if AuthService.instance.searchAlbamListArray.count > 0{
                count = AuthService.instance.searchAlbamListArray.count
           }
        }

        else if collectionNameStr == "searchSongs"{
            if AuthService.instance.searchSongListArray.count > 0{
                count = AuthService.instance.searchSongListArray.count
           }
        }
        else if collectionNameStr == "song"{
            if AuthService.instance.searchSongListArray.count > 0{
                count = AuthService.instance.searchSongListArray.count
            }
        }
        else if collectionNameStr == "albam"{
            if AuthService.instance.artistAlbamListArray.count > 0{
                count = AuthService.instance.artistAlbamListArray.count
            }
        }
        else{
            if AuthService.instance.songListArray.count > 0{
                count = AuthService.instance.songListArray.count
           }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMusicTVC", for: indexPath) as! NewMusicTVC
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if collectionNameStr == "searchArtists"{
            cell.widthConstraint.constant = 0.0
            
            if AuthService.instance.searchArtistListArray.count > 0{
                cell.lb_SongName.text = AuthService.instance.searchArtistListArray[indexPath.row]["name"].stringValue
                cell.lbl_AuthorName.text = AuthService.instance.searchArtistListArray[indexPath.row]["email"].stringValue

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
                
                let viewStr = AuthService.instance.searchArtistListArray[indexPath.row]["views_count"].stringValue
                let playStr = AuthService.instance.searchArtistListArray[indexPath.row]["play_count"].stringValue
                let likeStr = AuthService.instance.searchArtistListArray[indexPath.row]["like_count"].stringValue
                
                cell.lbl_ViewsLikesPlays.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
                
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
                

                cell.lbl_ViewsLikesPlays.isHidden = true
                cell.lbl_AuthorName.isHidden = true


            }
        
            self.lbl_SongsCount.text = "\(AuthService.instance.searchArtistListArray.count) Artist"

        }
        else if collectionNameStr == "searchAlbams"{
            cell.widthConstraint.constant = 0.0
            if AuthService.instance.searchAlbamListArray.count > 0{
                cell.lb_SongName.text = AuthService.instance.searchAlbamListArray[indexPath.row]["title"].stringValue

                let imageurl = AuthService.instance.searchAlbamListArray[indexPath.row]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgvw_Albam.kf.setImage(with: url)
                
                let isLike  = AuthService.instance.searchAlbamListArray[indexPath.row]["is_liked"].stringValue
                if isLike == "0"{
                    cell.btnLike.setTitle("Like", for: .normal)
                }
                else{
                    cell.btnLike.setTitle("Unlike", for: .normal)
                }
                let viewStr = AuthService.instance.searchAlbamListArray[indexPath.row]["views_count"].stringValue
                let playStr = AuthService.instance.searchAlbamListArray[indexPath.row]["play_count"].stringValue
                let likeStr = AuthService.instance.searchAlbamListArray[indexPath.row]["like_count"].stringValue
                
                cell.lbl_ViewsLikesPlays.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
                
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

                cell.lbl_ViewsLikesPlays.isHidden = true
                cell.lbl_AuthorName.isHidden = true
            }
            self.lbl_SongsCount.text = "\(AuthService.instance.searchAlbamListArray.count) Albams"

        }

        else if collectionNameStr == "searchSongs"{
            cell.widthConstraint.constant = 30.0
           if AuthService.instance.searchSongListArray.count > 0{
               cell.lbl_AuthorName.text = AuthService.instance.searchSongListArray[indexPath.row]["description"].stringValue
               
               cell.lb_SongName.text = AuthService.instance.searchSongListArray[indexPath.row]["title"].stringValue
               
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

               let imageurl = AuthService.instance.searchSongListArray[indexPath.row]["thumbnail"].stringValue
               let url = URL(string:"\(imageurl)")
               cell.imgvw_Albam.kf.setImage(with: url)
               //cell.lbl_Number.text = "\(indexPath.row + 1)"
               
               cell.addToPlayListBtnPressed = {
                   cell.vw_SHare.isHidden = true
                   if AuthService.instance.subcription == false{
                       self.showAlert(message: "Please subcribe first")
                   }
                   else{
                       if AuthService.instance.songListArray.count > 0{
                           self.trackIdStr = AuthService.instance.songListArray[indexPath.row]["category"]["id"].stringValue
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
          }
           self.lbl_SongsCount.text = "\(AuthService.instance.searchSongListArray.count) songs"

       }
        else if collectionNameStr == "song"{
            cell.widthConstraint.constant = 30.0

           if AuthService.instance.searchSongListArray.count > 0{
               cell.lbl_AuthorName.text = AuthService.instance.searchSongListArray[indexPath.row]["description"].stringValue
               
               cell.lb_SongName.text = AuthService.instance.searchSongListArray[indexPath.row]["title"].stringValue
               
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
               
               cell.lbl_ViewsLikesPlays.text = " \(viewStr) Views, \(playStr) Likes, \(likeStr) Plays "
               
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

               let imageurl = AuthService.instance.searchSongListArray[indexPath.row]["thumbnail"].stringValue
               let url = URL(string:"\(imageurl)")
               cell.imgvw_Albam.kf.setImage(with: url)
               //cell.lbl_Number.text = "\(indexPath.row + 1)"
               
               cell.addToPlayListBtnPressed = {
                   cell.vw_SHare.isHidden = true
                   if AuthService.instance.subcription == false{
                       self.showAlert(message: "Please subcribe first")
                   }
                   else{
                       if AuthService.instance.songListArray.count > 0{
                           self.trackIdStr = AuthService.instance.songListArray[indexPath.row]["category"]["id"].stringValue
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
          }
           self.lbl_SongsCount.text = "\(AuthService.instance.searchSongListArray.count) songs"

       }
        else if collectionNameStr == "albam"{
            cell.widthConstraint.constant = 0.0

           if AuthService.instance.artistAlbamListArray.count > 0{
               cell.lbl_AuthorName.text = AuthService.instance.artistAlbamListArray[indexPath.row]["description"].stringValue
               
               cell.lb_SongName.text = AuthService.instance.artistAlbamListArray[indexPath.row]["title"].stringValue
               
               let isLike  = AuthService.instance.artistAlbamListArray[indexPath.row]["is_liked"].stringValue
               if isLike == "0"{
                   cell.btnLike.setTitle("Like", for: .normal)
               }
               else{
                   cell.btnLike.setTitle("Unlike", for: .normal)
               }
               
               
               let viewStr = AuthService.instance.artistAlbamListArray[indexPath.row]["views_count"].stringValue
               let playStr = AuthService.instance.artistAlbamListArray[indexPath.row]["play_count"].stringValue
               let likeStr = AuthService.instance.artistAlbamListArray[indexPath.row]["like_count"].stringValue
               
               cell.lbl_ViewsLikesPlays.text = " \(viewStr) Views, \(likeStr) Likes, \(playStr) Plays "
               
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

               let imageurl = AuthService.instance.artistAlbamListArray[indexPath.row]["thumbnail"].stringValue
               let url = URL(string:"\(imageurl)")
               cell.imgvw_Albam.kf.setImage(with: url)
               //cell.lbl_Number.text = "\(indexPath.row + 1)"
               
               cell.addToPlayListBtnPressed = {
                   cell.vw_SHare.isHidden = true
                   if AuthService.instance.subcription == false{
                       self.showAlert(message: "Please subcribe first")
                   }
                   else{
                       if AuthService.instance.songListArray.count > 0{
                           self.trackIdStr = AuthService.instance.songListArray[indexPath.row]["category"]["id"].stringValue
                           self.vw_PlayListBack.isHidden = false
                       }
                       else{
                           self.showAlert(message: "Please create a playlist first")
                       }
                   }
                
           }
               
               cell.shareBtnPressed = {
                   let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.artistAlbamListArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                   self.songLikeAPICall(songIdStr: "\(AuthService.instance.artistAlbamListArray[indexPath.row]["song_id"].stringValue)")
                   cell.vw_SHare.isHidden = true

               }
          }
           self.lbl_SongsCount.text = "\(AuthService.instance.artistAlbamListArray.count) songs"

        }
        else{
            cell.widthConstraint.constant = 30.0

           if AuthService.instance.songListArray.count > 0{
               cell.lbl_AuthorName.text = AuthService.instance.songListArray[indexPath.row]["description"].stringValue
               
               cell.lb_SongName.text = AuthService.instance.songListArray[indexPath.row]["title"].stringValue
               let imageurl = AuthService.instance.songListArray[indexPath.row]["thumbnail"].stringValue
               
               let isLike  = AuthService.instance.songListArray[indexPath.row]["is_liked"].stringValue
               if isLike == "0"{
                   cell.btnLike.setTitle("Like", for: .normal)
               }
               else{
                   cell.btnLike.setTitle("Unlike", for: .normal)
               }
               
               let viewStr = AuthService.instance.songListArray[indexPath.row]["views_count"].stringValue
               let playStr = AuthService.instance.songListArray[indexPath.row]["play_count"].stringValue
               let likeStr = AuthService.instance.songListArray[indexPath.row]["like_count"].stringValue
               
               cell.lbl_ViewsLikesPlays.text = " \(viewStr) Views, \(playStr) Likes, \(likeStr) Plays "
               
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
               
               let url = URL(string:"\(imageurl)")
               cell.imgvw_Albam.kf.setImage(with: url)
               
               if AuthService.instance.songListArray[indexPath.row]["song_id"].intValue == Int(AudioService.instance.nowPlayingSongId){
                   cell.imgVw_IsPlaying.isHidden = false
                   cell.imgVw_IsPlaying.loadGif(name: "sound_bar_animation_final")
               }
               else{
                  
                   cell.imgVw_IsPlaying.isHidden = true
                   cell.imgVw_IsPlaying.loadGif(name: "sound_bar_animation_final")
               }
               
               cell.addToPlayListBtnPressed = {
                   cell.vw_SHare.isHidden = true
                   if AuthService.instance.subcription == false{
                       self.showAlert(message: "Please subcribe first")
                   }
                   else{
                       if AuthService.instance.songListArray.count > 0{
                           self.trackIdStr = AuthService.instance.songListArray[indexPath.row]["category"]["id"].stringValue
                           self.vw_PlayListBack.isHidden = false
                       }
                       else{
                           self.showAlert(message: "Please create a playlist first")
                       }
                   }
           }
               
               cell.shareBtnPressed = {
                   let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.songListArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                   self.songLikeAPICall(songIdStr: "\(AuthService.instance.songListArray[indexPath.row]["song_id"].stringValue)")
                   cell.vw_SHare.isHidden = true

               }
           }
           self.lbl_SongsCount.text = "\(AuthService.instance.songListArray.count) songs"

            
       }
        
        cell.dotsBtnPressed = {
            self.tripleDotActiveIndex = indexPath.row
            self.tblevw_NewMusic.reloadData()
        }
        
        if indexPath.row == self.tripleDotActiveIndex{
                cell.vw_SHare.isHidden = false
                self.showHide = true
            }
            else{
                cell.vw_SHare.isHidden = true
                self.showHide = false
            }
        


            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if collectionNameStr == "searchArtists"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbamDetailsVC") as! AlbamDetailsVC
            vc.playSelectedIndex = indexPath.row
            vc.collectionNameStr = "searchArtists"
            vc.artistID = AuthService.instance.searchArtistListArray[indexPath.row]["id"].stringValue
            vc.strAlbumURL = AuthService.instance.searchArtistListArray[indexPath.row]["avatar"].stringValue
            self.navigationController?.pushViewController(vc,animated: false)
        }else if collectionNameStr == "searchAlbams"{
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbamDetailsVC") as! AlbamDetailsVC
            vc.playSelectedIndex = indexPath.row
            vc.collectionNameStr = "searchAlbams"
            vc.albumID = AuthService.instance.searchAlbamListArray[indexPath.row]["palbum_id"].stringValue
            vc.categoryId = AuthService.instance.searchAlbamListArray[indexPath.row]["category_id"].stringValue
            vc.strAlbumURL = AuthService.instance.searchAlbamListArray[indexPath.row]["thumbnail"].stringValue
            self.navigationController?.pushViewController(vc,animated: false)
        }else{
            AudioService.instance.nowPlayingIndex = indexPath.row
            self.vw_SmallPlayer.isHidden = false
            AudioService.instance.isPlayerOn = true
            bottomConstant.constant = 120.0
            if collectionNameStr == "searchSongs"{
                AudioService.instance.nowPlayingListArray = AuthService.instance.searchSongListArray
            }else if collectionNameStr == "song"{
                AudioService.instance.nowPlayingListArray = AuthService.instance.searchSongListArray
            }else if collectionNameStr == "albam"{
                AudioService.instance.nowPlayingListArray = AuthService.instance.searchAlbamListArray
            }else if collectionNameStr == "albam"{
                AudioService.instance.nowPlayingListArray = AuthService.instance.artistAlbamListArray
            }
            else{
                AudioService.instance.nowPlayingListArray = AuthService.instance.songListArray
            }
            
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
               // }
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
            
        }
        
        
        self.tblevw_NewMusic.reloadData()
    }
}

extension MoreVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.playListCollectionVw{
            if AuthService.instance.myPlaySongListAlbamArray.count > 0{
                return AuthService.instance.myPlaySongListAlbamArray.count
            }
            else{
                return 0
            }
        }
        else if collectionNameStr == "search"{
            if AuthService.instance.searchSongListArray.count > 0{
                count = AuthService.instance.searchSongListArray.count
           }
        }
        else{
            if AuthService.instance.songListArray.count > 0{
                count = AuthService.instance.songListArray.count
           }
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCVC", for: indexPath) as! MoreCVC
        
        if collectionView == self.playListCollectionVw {

            if AuthService.instance.myPlaySongListAlbamArray.count > 0{
                
                cell.lb_SongName.text = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["name"].stringValue
                
                let imageurl = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgvw_Albam.kf.setImage(with: url)
            }
        }
        
        else if collectionNameStr == "search"{
            if AuthService.instance.searchSongListArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.searchSongListArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.searchSongListArray[indexPath.row]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgVw_Albam.kf.setImage(with: url)
           }
            self.lbl_SongsCount.text = "\(AuthService.instance.searchSongListArray.count) songs"

        }else{
            if AuthService.instance.songListArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.songListArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.songListArray[indexPath.row]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgVw_Albam.kf.setImage(with: url)
            }
            self.lbl_SongsCount.text = "\(AuthService.instance.songListArray.count) songs"

             
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width_collView = Double((UIScreen.main.bounds.width-40)/2)
        let hight_collView = 190.0

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

        }
        
        else if collectionNameStr == "search"{
            AudioService.instance.nowPlayingIndex = indexPath.row
            self.vw_SmallPlayer.isHidden = false
            AudioService.instance.isPlayerOn = true
            bottomConstant.constant = 120.0
            AudioService.instance.nowPlayingListArray = AuthService.instance.popularArray
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
              //  DispatchQueue.main.async {
                    AudioService.instance.playSong(SongURL: songString)
                    self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
              //  }
            }
        }else{
            AudioService.instance.nowPlayingIndex = indexPath.row
            self.vw_SmallPlayer.isHidden = false
            AudioService.instance.isPlayerOn = true
            bottomConstant.constant = 120.0
            AudioService.instance.nowPlayingListArray = AuthService.instance.recentlyPlayedArray
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
               // }
            }
        }
        
        
        
    }
    
}

