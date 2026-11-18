//
//  PlaylistVC.swift
//  WEMU
//
//  Created by Arun Halder on 09/09/22.
//

import UIKit
import MarqueeLabel
import MediaPlayer


class PlaylistVC: UIViewController, RTCustomAlertDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
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
    
    @IBOutlet weak var lbl_NoSongsFound: UILabel!
        
    @IBOutlet weak var lbl_SelectedImageName: UILabel!
    @IBOutlet weak var playListCollectionVw: UICollectionView!
    @IBOutlet weak var vw_AddPlayList: UIView!
    
    @IBOutlet weak var constaint_Vw_AddButton: NSLayoutConstraint!
    @IBOutlet weak var constaint_Vw_AddPlaylist: NSLayoutConstraint!
    
    @IBOutlet weak var txtFld_PlayListName: UITextField!
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_SongAlbamCount: UILabel!
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    //image picker
    let imagePicker = UIImagePickerController()
    var capturedImageData = Data()
    var imageLocType = ""
    var showHide = false

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
    
    
    @IBAction func addPlayListBtnAction(_ sender: UIButton) {
        self.vw_AddPlayList.isHidden = false
        self.vw_AddPlayList.bringSubviewToFront(self.playListCollectionVw)

    }
    
    @IBAction func closeBtnVwAction(_ sender: UIButton) {
        txtFld_PlayListName.resignFirstResponder()
        self.constaint_Vw_AddPlaylist.constant = 0.0
        self.vw_AddPlayList.isHidden = true
        self.playListCollectionVw.bringSubviewToFront(self.vw_AddPlayList)
    }
    
    @IBAction func addImageBtnAction(_ sender: UIButton) {
        
     let alert = UIAlertController(title: "WEMU", message: "Choose image for albam", preferredStyle: .actionSheet)

             alert.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { (_) in
                 print("CAMERA")
                 self.openCamera()

             }))

             alert.addAction(UIAlertAction(title: "GALLERY", style: .default, handler: { (_) in
                 print("GALLERY")
                 self.openGallary()

             }))

             alert.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: { (_) in
                 print("CANCEL")
             }))
             self.present(alert, animated: true, completion: nil)
        }
    
    //MARK: Camera Function
    func openCamera()  {
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            //self.showAlert(message: "You don't have camera")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "You don't have camera"
            customAlert.delegate = self
            customAlert.show()
        }
    }
    
    func openGallary() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print(info)
            self.capturedImageData = editedImage.jpegData(compressionQuality: 0.2)!
            self.lbl_SelectedImageName.text = "Image Selected."
            
        }
        self.imageuploadAPI(capturedImage: self.capturedImageData)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SubmitBtnAction(_ sender: UIButton) {
        print(capturedImageData)
        
        let namePlayList = txtFld_PlayListName.text
        
        if namePlayList != ""{
            if capturedImageData.description != "0 bytes"{
                
                if (NetworkState().isInternetAvailable) {
                    HUD.show(to: self.view)
                                
                    AuthService.instance.CreatePlayListAPI(imgData: capturedImageData, playListTitle: namePlayList!, completion:{(success, data, message) in
                        if success{
                            HUD.hide(to: self.view)
                            //showAlert(message:"No Active Internet")
                            let customAlert = RTCustomAlert()
                            customAlert.alertMessage = message!
                            customAlert.delegate = self
                            customAlert.show()
                            self.vw_AddPlayList.isHidden = true
                            self.myPlayListAPICall()
                        }
                        else{
                            HUD.hide(to: self.view)

                        }
                })
                }
                else{
                    HUD.hide(to: self.view)
                    //showAlert(message:"No Active Internet")
                    let customAlert = RTCustomAlert()
                    customAlert.alertMessage = "No Active Internet"
                    customAlert.delegate = self
                    customAlert.show()
                }
                
            }
            else{
                HUD.hide(to: self.view)
                let customAlert = RTCustomAlert()
                customAlert.alertMessage = "Please select a image"
                customAlert.delegate = self
                customAlert.show()
            }
        }
        else{
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Please set a playlist name"
            customAlert.delegate = self
            customAlert.show()
        }

        
    }
    
    func imageuploadAPI(capturedImage:Data){
        
        if (NetworkState().isInternetAvailable) {
            HUD.show(to: self.view)
                        
            AuthService.instance.uploadImageAPI(imgData:capturedImage, imageTypeStr: "\(self.imageLocType)" , completion:{(success, data, message) in
                if success{
                }
                else{
                    HUD.hide(to: self.view)
                   // self.showAlert(message: message!)
                }
        })
        }
        else{
            HUD.hide(to: self.view)
            //showAlert(message:"No Active Internet")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "No Active Internet"
            customAlert.delegate = self
            customAlert.show()
        }
        
    }

    
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(vc,animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        txtFld_PlayListName.addTarget(self, action: #selector(tapped), for: UIControl.Event.touchDown)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        self.vw_AddPlayList.addGestureRecognizer(tap)
        
        // Subscribe to Keyboard Will Show notifications
              NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(keyboardWillShow(_:)),
                  name: UIResponder.keyboardWillShowNotification,
                  object: nil
              )
    }
    
    @objc func tapped(){
            self.constaint_Vw_AddPlaylist.constant = 170.0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txtFld_PlayListName.resignFirstResponder()
        return true
    }
    
    
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.constaint_Vw_AddPlaylist.constant = 0.0
    }
    
    @objc
       dynamic func keyboardWillShow(
          _ notification: NSNotification
       ) { }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
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
            self.setupNowPlayingInfoCenter()
        }
        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_SongAlbamCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
            self.imgVw_Back.image = UIImage(named: "backBlack")
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_SongAlbamCount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.imgVw_Bell.image = UIImage(named: "bell")
            self.imgVw_Back.image = UIImage(named: "back")
        }
        
        
        if AudioService.instance.isPlayerOn == true{
            bottomConstant.constant = 120.0
            self.constaint_Vw_AddButton.constant = 150.0
            self.constaint_Vw_AddPlaylist.constant = 150.0
            self.vw_SmallPlayer.isHidden = false
            lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
            lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
            let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
            let url = URL(string:"\(imageurl)")
            imgvw_SmallImage.kf.setImage(with: url)
            
        }
        else{
            bottomConstant.constant = 0.0
            self.vw_SmallPlayer.isHidden = true
            self.constaint_Vw_AddButton.constant = 0.0
            self.constaint_Vw_AddPlaylist.constant = 0.0

        }
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
                    self.lbl_SongAlbamCount.text = "\(AuthService.instance.myPlaySongListAlbamArray.count) Folders"
                    self.playListCollectionVw.reloadData()
                }
                HUD.hide(to: self.view)
            }else{
                //print(message)
                HUD.hide(to: self.view)
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
           // DispatchQueue.main.async {
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
                       // DispatchQueue.main.async {
                            self.songPlayProgress()
                       // }
                    }
                    else{
                        AudioService.instance.nowPlayingIndex = 0
                      //  DispatchQueue.main.async {
                            self.songPlayProgress()
                     //   }
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
                           // DispatchQueue.main.async {
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
    
    func songLikeAPICall(songIdStr:String){
        HUD.show(to: self.view)
        AuthService.instance.songLikeAPI(songIdStr: "\(songIdStr)",completion: {(success, data, message) in
            if success{
                
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

extension PlaylistVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
            
            if AuthService.instance.whiteTheam == true{
                print("UISwitch state is now ON")
                cell.lb_SongName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

            }
            else{
                print("UISwitch state is now Off")
                cell.lb_SongName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            }
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
        vc.collectionNameStr = "myPlayList"
        vc.albumID = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["id"].stringValue
        vc.strAlbumURL = AuthService.instance.myPlaySongListAlbamArray[indexPath.row]["thumbnail"].stringValue
        self.navigationController?.pushViewController(vc,animated: false)
    
    }
}

