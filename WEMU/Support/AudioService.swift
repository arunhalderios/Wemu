import Foundation
import AVFoundation
import Alamofire
import SwiftyJSON
import AVKit
import MediaPlayer

class AudioService: RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    static let instance = AudioService()//creating a instance
    let controller = AVPlayerViewController()
    
    var layer = AVPlayerLayer()
        
    var player = AVPlayer()
    var playerSharedItem:AVPlayerItem?
    var hasBeenPaused = false
    
    var repeatSongBool:Bool = false
    var randomSongBool:Bool = false
    var playAllBool:Bool = false
    var songPlayingCount = 0
    
    var isPlayerOn:Bool = false
    var nowPlayingKey = ""
    var nowPlayingIndex = 0
    var nowPlayingSongId = ""
    var nowPlayingListArray = [JSON]()
    var nowPlayingInfo = [String: Any]()
    var randomInt = 0
    var seekTime = 0
    
    //MARK: MAIN  FUNCTIONS
    
    func play() {
        player.play()

    }
    
    func pause(){
        if player.rate != 0{
            player.pause()
            hasBeenPaused = true
        } else {
            hasBeenPaused = false
          
        }
    }
    
    func nextSong(){
        if AuthService.instance.subcription == true{
            if AudioService.instance.randomSongBool == false{
                    if AudioService.instance.nowPlayingIndex < AudioService.instance.nowPlayingListArray.count-1{
                        AudioService.instance.nowPlayingIndex = AudioService.instance.nowPlayingIndex + 1
                    }
                    else{
                        AudioService.instance.nowPlayingIndex = 0
                    }
            }
            else{
                self.randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                AudioService.instance.nowPlayingIndex = self.randomInt
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
                        }
                        else{
                            AudioService.instance.nowPlayingIndex = 0
                        }
                }
                else{
                    self.randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                    AudioService.instance.nowPlayingIndex = self.randomInt
                    
                }
            }
        }
    if AudioService.instance.controller.player?.currentItem?.status == .readyToPlay {
      //  DispatchQueue.main.async {
         self.songPlayProgress()
           // }
        }
    }
    
    func previousSong(){
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
       // DispatchQueue.main.async {
            
            self.songPlayProgress()
            
           // }
        }
    }
    
    func playSong(SongURL:String){
        player.pause()
        let url = URL(string:"\(SongURL)")
        if url != nil{
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            player.play()
            
            AudioService.instance.controller.player = player
            AudioService.instance.controller.showsPlaybackControls = false
            AudioService.instance.controller.allowsPictureInPicturePlayback = true
            self.playerSharedItem = playerItem
            self.setupAudioSession()
            self.setupNowPlayingInfoCenter()
            self.updateInfoCenter()
        }
        //check player status
        NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
        
        //check player has completed playing audio
        NotificationCenter.default.addObserver(self, selector: #selector(self.playingOnProgress), name: NSNotification.Name.AVAssetDurationDidChange, object: player.currentItem)
        
        //check player has completed playing audio
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

    }
    
    @objc func finishedPlaying() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        self.nextSong()
    }
    
    @objc func playingOnProgress(){
        self.updateInfoCenter()
    }
    
    func songPlayProgress(){
        //self.pause()
        let songUrl = "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["audio_location"].stringValue)"
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
        print("============================SONG URL===============================")
        print(songUrl)
        self.playSong(SongURL: songUrl)
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: AVAudioSession.Category.playback.rawValue))
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting the AVAudioSession:", error.localizedDescription)
        }
    }
    
    func setupNowPlayingInfoCenter(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        MediaPlayer.MPRemoteCommandCenter.shared().playCommand.isEnabled = true
        MediaPlayer.MPRemoteCommandCenter.shared().playCommand.addTarget {event in
            self.play()
            return .success
        }
        
        MediaPlayer.MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
        MediaPlayer.MPRemoteCommandCenter.shared().pauseCommand.addTarget {event in
            self.pause()
            return .success
        }
        
        MediaPlayer.MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = true
        
        MediaPlayer.MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = true
        MediaPlayer.MPRemoteCommandCenter.shared().nextTrackCommand.addTarget {event in
            self.nextSong()
            return .success
        }
        
        MediaPlayer.MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = true
        MediaPlayer.MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {event in
          self.previousSong()
          return .success
        }
        
        MediaPlayer.MPRemoteCommandCenter.shared().seekForwardCommand.isEnabled = false
        MediaPlayer.MPRemoteCommandCenter.shared().seekBackwardCommand.isEnabled = false
      }
    
    func updateInfoCenter() {
        
        // prepare title and subtitle
        nowPlayingInfo[MPMediaItemPropertyTitle] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
        //nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
        downloadImage(from: url!)
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = AudioService.instance.playerSharedItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = AudioService.instance.player.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = AudioService.instance.playerSharedItem?.currentTime().seconds
        
        // final step is to assign our dictionary to
        // MPNowPlayingInfoCenter singleton
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

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
         //   DispatchQueue.main.async() { [weak self] in
                if let albumArt = UIImage(data: data) {
                    self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumArt.size, requestHandler: { imageSize in
                        return albumArt
                    })
                }
                
                
          //  }
        }
    }
}
