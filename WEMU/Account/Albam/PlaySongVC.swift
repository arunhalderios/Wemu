//
//  PlaySongVC.swift
//  WEMU
//
//  Created by Arun Halder on 13/09/22.
//

import UIKit
import AVFoundation
import MarqueeLabel
import FaveButton
import MediaPlayer

func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class PlaySongVC: UIViewController, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        
    }
    
    
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btnFavIcon: FaveButton!
    @IBOutlet weak var favIcon: UIImageView!
    @IBOutlet weak var lbl_CurrentTime: UILabel!
    @IBOutlet weak var lbl_OverallDuration: UILabel!
    @IBOutlet weak var slider_SongProgress: UISlider!
    
    @IBOutlet weak var imgVw_thumbnail: UIImageView!
   // @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Tags: UILabel!
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var playButtonOutlet: UIButton!

    @IBOutlet weak var imgVw_Repeat: UIImageView!
    @IBOutlet weak var imgVw_Suffle: UIImageView!
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var imgVw_Back: UIImageView!
    @IBOutlet weak var vw_TableVwBackground: UIView!
    @IBOutlet weak var tbleVw_PlaySong: UITableView!
    //    var player: AVPlayer?
//    var playerItem:AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    var collectionNameStr = ""
    var selectedIndex = 0
    var count = 0
    var showHide = false
    var tripleDotActiveIndex = 9999999
    var nowPlayingInfo = [String: Any]()

    
    var randomInt = 0
    
    let colors = [
            DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
            DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
            DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
            DotColors(first: color(0xE9A966), second: color(0xF8C852)),
            DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
        ]
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
    }
        
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        if( faveButton === btnFavIcon){
            return colors
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.lbl_Title.type = .continuous
//        self.lbl_Title.speed = .duration(10)
//        self.lbl_Title.animationCurve = .linear
        self.btnFavIcon?.setSelected(selected: true, animated: false)
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "rate", let player = object as? AVPlayer {
//            if player.rate == 1.0 {
//                print("Playing")
//                self.imgvw_PlayPause.image = UIImage(named: "pause")
//            } else {
//                print("Paused")
//                self.imgvw_PlayPause.image = UIImage(named: "play")
//            }
//        }
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tbleVw_PlaySong.reloadData()

        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_TableVwBackground.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.imgVw_Back.image = UIImage(named: "backBlack")
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else{
            print("UISwitch state is now Off")
            self.vw_TableVwBackground.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imgVw_Back.image = UIImage(named: "back")
            self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if AudioService.instance.player.rate == 1.0
        {
            self.imgvw_PlayPause.image = UIImage(named: "pause")
        }
        else {
            self.imgvw_PlayPause.image = UIImage(named: "play")
        }
                
        if AudioService.instance.repeatSongBool == true{
            self.imgVw_Repeat.image = UIImage(named: "PlaySongRepeatActive")
        }
        else{
            self.imgVw_Repeat.image = UIImage(named: "PlaySongRepeat")
        }
        
        if AudioService.instance.randomSongBool == true{
            self.imgVw_Suffle.image = UIImage(named: "PlaySongHammerActive")
        }
        else{
            self.imgVw_Suffle.image = UIImage(named: "PlaySongHammer")
        }
        self.valueChange()
        NotificationCenter.default.addObserver(self, selector: #selector(valueChange), name: Notification.Name("NewFunctionName"), object: nil)
    }
    
    @objc func functionName (notification: NSNotification){
        self.valueChange()
    }
    
    @objc func valueChange(){
        
        AudioService.instance.setupNowPlayingInfoCenter()

        lbl_Title.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            lbl_Tags.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            lbl_Tags.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
        //lbl_Tags.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
        imgVw_thumbnail.kf.setImage(with: url)
        downloadImage(from: url!)



        AudioService.instance.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if AudioService.instance.player.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(AudioService.instance.player.currentTime());
                self.slider_SongProgress.value = Float ( time );
                self.lbl_CurrentTime.text = self.stringFromTimeInterval(interval: time)
            }
            let playbackLikelyToKeepUp = AudioService.instance.player.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering"); //HUD.show(to: self.view)
                self.playButtonOutlet.isHidden = true
            } else {
                //stop the activity indicator
                print("Buffering completed"); //HUD.hide(to: self.view)
                self.playButtonOutlet.isHidden = false
            }
        }

        slider_SongProgress.minimumValue = 0

        //To get overAll duration of the audio
        let duration : CMTime = (AudioService.instance.playerSharedItem?.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration)
        lbl_OverallDuration.text = self.stringFromTimeInterval(interval: seconds)

        //To get the current duration of the audio
        let currentDuration : CMTime = (AudioService.instance.playerSharedItem?.currentTime())!
        let currentSeconds : Float64 = CMTimeGetSeconds(currentDuration)
        lbl_CurrentTime.text = self.stringFromTimeInterval(interval: currentSeconds)

        slider_SongProgress.maximumValue = Float(seconds)
        slider_SongProgress.isContinuous = true

        //change the progress value
        slider_SongProgress.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)

    }
    
    @IBAction func showSongListBtnAction(_ sender: UIButton) {
        self.vw_TableVwBackground.isHidden = false
    }
    
    @IBAction func hideSongListBtnAction(_ sender: UIButton) {
        self.vw_TableVwBackground.isHidden = true
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
      //  playButtonOutlet.setBackgroundImage(UIImage(named: "play"), for: .normal)
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        AudioService.instance.isPlayerOn = true
        NotificationCenter.default.post(name: Notification.Name("playerminimize"), object: nil)
    }
    
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        self.playPause()
    }
    
    func playPause(){
        if AudioService.instance.player.rate == 0.0
        {
            AudioService.instance.player.play()
            print("Song is playing")
            self.imgvw_PlayPause.image = UIImage(named: "pause")
        } else {
            AudioService.instance.player.pause()
            print("Song is paused now")
            self.imgvw_PlayPause.image = UIImage(named: "play")

        }
        
    }
    
    
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @IBAction func replayButtonClicked(_ sender: UIButton) {

        if AudioService.instance.repeatSongBool == false{
            AudioService.instance.repeatSongBool = true
            self.imgVw_Repeat.image = UIImage(named: "PlaySongRepeatActive")
        }
        else{
            AudioService.instance.repeatSongBool = false
            self.imgVw_Repeat.image = UIImage(named: "PlaySongRepeat")
        }
        print("AudioService.instance.repeatSongBool - \(AudioService.instance.repeatSongBool)")

    }

    @IBAction func suffleButtonClicked(_ sender: UIButton) {

        if AudioService.instance.randomSongBool == false{
            AudioService.instance.randomSongBool = true
            self.imgVw_Suffle.image = UIImage(named: "PlaySongHammerActive")
        }
        else{
            AudioService.instance.randomSongBool = false
            self.imgVw_Suffle.image = UIImage(named: "PlaySongHammer")
        }
        
        print("AudioService.instance.randomSongBool - \(AudioService.instance.randomSongBool)")

    }

    @IBAction func action_PlayPrevious(_ sender: UIButton) {
        AudioService.instance.previousSong()
        self.songPlayProgress()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
    }


    @IBAction func action_PlayNext(_ sender: UIButton) {
        AudioService.instance.nextSong()
        self.songPlayProgress()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
    }
    
    @IBAction func addToFavouriteButtonClicked(_ sender: UIButton) {
          //  HUD.show(to: self.view)
        let songID = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        AuthService.instance.songLikeAPI(songIdStr:"\(songID)",completion: {(success, data, message) in
                if success{
                    //HUD.hide(to: self.view)
                    self.showAlert(message: "Songs has been added in favourites")
//                    self.favIcon.setGIFImage(name: "loveBlinking.gif")
                }else{
                    //print(message)
                    //HUD.hide(to: self.view)
                }
            })
    }

    @IBAction func shareButtonClicked(_ sender: UIButton) {

            //Set the default sharing message.
            let message = "WEMU"
            let link = NSURL(string: "\(AuthService.instance.popularArray[AudioService.instance.nowPlayingIndex]["audio_location"].stringValue)")

            // Screenshot:
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
            self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            //Set the link, message, image to share.
            if let link = link, let img = img {
                let objectsToShare = [message,link,img] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
        }
    }
    

    

    func songPlayProgress(){
        lbl_Title.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            lbl_Tags.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            lbl_Tags.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
        //lbl_Tags.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
       
        print("URL link: \(String(describing: url))")
        imgVw_thumbnail.kf.setImage(with: url)
        

        AudioService.instance.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if AudioService.instance.player.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(AudioService.instance.player.currentTime());
                self.slider_SongProgress.value = Float ( time );
                self.lbl_CurrentTime.text = self.stringFromTimeInterval(interval: time)
            }
            let playbackLikelyToKeepUp = AudioService.instance.player.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering"); //HUD.show(to: self.view)
                self.playButtonOutlet.isHidden = true
            } else {
                //stop the activity indicator
                print("Buffering completed"); //HUD.hide(to: self.view)
                self.playButtonOutlet.isHidden = false
            }
        }

        slider_SongProgress.minimumValue = 0

        //To get overAll duration of the audio
        let duration : CMTime = (AudioService.instance.playerSharedItem?.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration)
        lbl_OverallDuration.text = self.stringFromTimeInterval(interval: seconds)

        //To get the current duration of the audio
        let currentDuration : CMTime = (AudioService.instance.playerSharedItem?.currentTime())!
        let currentSeconds : Float64 = CMTimeGetSeconds(currentDuration)
        lbl_CurrentTime.text = self.stringFromTimeInterval(interval: currentSeconds)

        slider_SongProgress.maximumValue = Float(seconds)
        slider_SongProgress.isContinuous = true

        //change the progress value
        slider_SongProgress.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)

    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL) {
        print("Download Started:\(url)")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
           // DispatchQueue.main.async() { [weak self] in
              //  self?.imageView.image = UIImage(data: data)
                if let albumArt = UIImage(data: data) {
                    self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumArt.size, requestHandler: { imageSize in
                        return albumArt
                    })
                }
                
                
           // }
        }
    }


    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        AudioService.instance.player.seek(to: targetTime)
        if AudioService.instance.player.rate == 0 {
            AudioService.instance.player.play()
        }
        
      //  AudioService.instance.playerSharedItem?.seek(to: CMTimeMakeWithSeconds(Float64(seconds), preferredTimescale: AudioService.instance.player.currentItem!.currentTime().timescale))
    }
    
    
    func songViewAPICall(songIdStr:String){
       // HUD.show(to: self.view)
        AuthService.instance.songViewAPI(songIdStr: "\(songIdStr)",completion: {(success, data, message) in
            if success{
                
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
                
                HUD.hide(to: self.view)
            }else{
                //print(message)
                HUD.hide(to: self.view)
            }
        })
    }
    
    
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    
}

extension PlaySongVC: UITableViewDelegate,UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return AudioService.instance.nowPlayingListArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMusicTVC", for: indexPath) as! NewMusicTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            //cell.lbl_Number.text = "\(indexPath.row + 1)"
            cell.lb_SongName.text = AudioService.instance.nowPlayingListArray[indexPath.row]["title"].stringValue
        
        if AudioService.instance.nowPlayingListArray[indexPath.row]["description"].stringValue != ""{
            cell.lbl_AuthorName.text = AudioService.instance.nowPlayingListArray[indexPath.row]["description"].stringValue
        }
        else{
            cell.lbl_AuthorName.text = AudioService.instance.nowPlayingListArray[indexPath.row]["artists_name"][0].stringValue

        }
            cell.lbl_AuthorName.text = AudioService.instance.nowPlayingListArray[indexPath.row]["description"].stringValue

            let viewStr = AudioService.instance.nowPlayingListArray[indexPath.row]["views_count"].stringValue
            let playStr = AudioService.instance.nowPlayingListArray[indexPath.row]["play_count"].stringValue
            let likeStr = AudioService.instance.nowPlayingListArray[indexPath.row]["like_count"].stringValue

            cell.lbl_ViewsLikesPlays.text = " \(viewStr) Views, \(playStr) Likes, \(likeStr) Plays "

            let imageurl = AudioService.instance.nowPlayingListArray[indexPath.row]["thumbnail"].stringValue
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

        cell.dotsBtnPressed = {
            self.tripleDotActiveIndex = indexPath.row
            self.tbleVw_PlaySong.reloadData()
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
                if AuthService.instance.subcription == false{
                    cell.vw_SHare.isHidden = true
                    self.showAlert(message: "Please subcribe first")
                }
                else{
                   // HUD.show(to: self.view)
//                   AuthService.instance.addToPlayListAPI(trackID: "\(AuthService.instance.songListArray[indexPath.row]["category"]["id"].stringValue)",completion: {(success, data, message) in
//                           if success{
//                               HUD.hide(to: self.view)
//                               self.showAlert(message: message!)
//                           }else{
//                               //print(message)
//                               HUD.hide(to: self.view)
//                           }
//                       })
                }

        }

            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AudioService.instance.nowPlayingListArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true

            }



                return cell

        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            AudioService.instance.nowPlayingIndex = indexPath.row
            AudioService.instance.isPlayerOn = true
            let songString = "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["audio_location"].stringValue)"
            if songString == ""{
                let customAlert = RTCustomAlert()
                customAlert.alertMessage = "There is no song left."
                customAlert.delegate = self
                customAlert.show()

            }else{
                AudioService.instance.playSong(SongURL: songString)
              //  DispatchQueue.main.async {
                    
                 self.songPlayProgress()
                    
              //  }

            }
            self.vw_TableVwBackground.isHidden = true
    }

}
extension UIViewController {

    func presentAlert(withTitle title: String, message : String, actions : [String: UIAlertAction.Style], completionHandler: ((UIAlertAction) -> ())? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for action in actions {

            let action = UIAlertAction(title: action.key, style: action.value) { action in

                if completionHandler != nil {
                    completionHandler!(action)
                }
            }

            alertController.addAction(action)
        }

        self.present(alertController, animated: true, completion: nil)
    }
}

