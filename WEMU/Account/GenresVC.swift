//
//  GenresVC.swift
//  WEMU
//
//  Created by Arun Halder on 06/09/22.
//

import UIKit
import MarqueeLabel
import MediaPlayer


class GenresVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    @IBOutlet weak var imgVw_Bell: UIImageView!
    @IBOutlet var vw_Background: UIView!
    @IBOutlet weak var vw_SmallPlayer: UIView!
    
    @IBOutlet weak var lbl_SmallTitle: MarqueeLabel!
    @IBOutlet weak var lbl_SmallTag: MarqueeLabel!
    @IBOutlet weak var imgvw_SmallImage: UIImageView!
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btn_SmallPlay: UIButton!
    
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var genresSongsCollectionVw: UICollectionView!
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    var nowPlayingInfo = [String: Any]()
    var count = 0
    var randomInt = 0
    var intPageNumber = 1

    
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
    
    @IBAction func LibraryBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LibraryVC") as! LibraryVC
        navigationController?.pushViewController(vc,animated: false)
    }
    
    @IBAction func ProfileBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        navigationController?.pushViewController(vc,animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        genresSongsCollectionVw.delegate   = self
        genresSongsCollectionVw.dataSource = self
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
            if self.intPageNumber == 1{
                AuthService.instance.genericListArray.removeAll()
                self.GenericListAPICall(self.intPageNumber)
            }
            AudioService.instance.setupNowPlayingInfoCenter()
            self.MyProfileAPICall()
            
        }
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Title.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Heading.textColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Title.textColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
           // }
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
                         //   DispatchQueue.main.async {
                                self.songPlayProgress()
                         //   }
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
    
    
    
    
    func GenericListAPICall(_ intPageNumber:Int){
        HUD.show(to: self.view)
        AuthService.instance.GenericListAPI(intPageNumber:intPageNumber, completion: {(success, data, message) in
            if success{
                if AuthService.instance.genericListArray.count > 0{
               //     self.lblTotalAlbum.text = "\(AuthService.instance.albamListArray.count) Albums"
                    self.genresSongsCollectionVw.reloadData()
                }
                HUD.hide(to: self.view)
            }else{
                //print(message)
                HUD.hide(to: self.view)
            }
        })
    }
    
    func MyProfileAPICall(){
        AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
            if success{
            }else{
            }
        })
    }
    
}

extension GenresVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if AuthService.instance.genericListArray.count > 0{
            return AuthService.instance.genericListArray.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCVC", for: indexPath) as! GenresCVC
        
            if AuthService.instance.genericListArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.genericListArray[indexPath.row]["cateogry_name"].stringValue
                
                let imageurl = AuthService.instance.genericListArray[indexPath.row]["background_thumb"].stringValue
                let url = URL(string:"\(imageurl)")
                cell.imgVw_Albam.kf.setImage(with: url)
            }
                    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width_collView = Double((UIScreen.main.bounds.width-40)/2)
        let hight_collView = 190.0

        return CGSize(width: width_collView, height: hight_collView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlbamDetailsVC") as! AlbamDetailsVC
        vc.playSelectedIndex = indexPath.row
        vc.collectionNameStr = "genres"
        vc.albumID = AuthService.instance.genericListArray[indexPath.row]["id"].stringValue
        vc.strAlbumURL = AuthService.instance.genericListArray[indexPath.row]["background_thumb"].stringValue
        
        self.navigationController?.pushViewController(vc,animated: false)

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if (indexPath.row == AuthService.instance.genericListArray.count - 1 ) { //it's your last cell
           //Load more data & reload your collection view
             print("========================LAST INDEX=================================")
             if AuthService.instance.albumLastPage > AuthService.instance.albumCurrentPage{
                 //intPageNumber = intPageNumber+1
                 GenericListAPICall(AuthService.instance.albumLastPage)
             }
         }
    }
    
}

