//
//  DashBoardVC.swift
//  WEMU
//
//  Created by Arun Halder on 05/09/22.
//

import UIKit
import ImageSlideshow
import Kingfisher
import MarqueeLabel
import MediaPlayer

class DashBoardVC: UIViewController,UITextFieldDelegate, RTCustomAlertDelegate {
    func okButtonPressed(_ alert: RTCustomAlert, alertTag: Int) {
        //
    }
    
    
    @IBOutlet weak var txtFld_SearchField: UITextField!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    @IBOutlet weak var popularSongsCollectionVw: UICollectionView!
    @IBOutlet weak var recentlyPlayedCollectionVw: UICollectionView!
    @IBOutlet weak var newReleasesCollectionVw: UICollectionView!
    @IBOutlet weak var trendingNowCollectionVw: UICollectionView!
    @IBOutlet weak var newAlbamsCollectionVw: UICollectionView!
    @IBOutlet weak var recommendedCollectionVw: UICollectionView!
    @IBOutlet weak var mostPopularThisWeekCollectionVw: UICollectionView!
    @IBOutlet var vw_Background: UIView!
    @IBOutlet weak var vw_HeadingBackground: UIView!
    @IBOutlet weak var vw_searchBackground: UIView!
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_Tagline: UILabel!
    @IBOutlet weak var lbl_Popular: UILabel!
    @IBOutlet weak var lbl_RecentlyPlayed: UILabel!
    @IBOutlet weak var lbl_NewRelease: UILabel!
    @IBOutlet weak var lbl_TrendingNow: UILabel!
    @IBOutlet weak var lbl_NewAlbam: UILabel!
    @IBOutlet weak var lbl_Recommend: UILabel!
    @IBOutlet weak var lbl_MostPopularThisWeek: UILabel!

    @IBOutlet weak var btnMorePopular: UIButton!
    @IBOutlet weak var btnMoreRecentlyPlayed: UIButton!
    @IBOutlet weak var btnMoreNewRealeases: UIButton!
    @IBOutlet weak var btnMoreTrendingNow: UIButton!
    @IBOutlet weak var btnMoreNewAlbams: UIButton!
    @IBOutlet weak var btnMoreRecommended: UIButton!
    @IBOutlet weak var btnMoreMostPopularThisWeek: UIButton!
    
    @IBOutlet weak var vw_SmallPlayer: UIView!
    
    @IBOutlet weak var lbl_SmallTitle: MarqueeLabel!
    @IBOutlet weak var lbl_SmallTag: MarqueeLabel!
    @IBOutlet weak var imgvw_SmallImage: UIImageView!
    
    @IBOutlet weak var imgvw_PlayPause: UIImageView!
    @IBOutlet weak var btn_SmallPlay: UIButton!
    
    @IBOutlet weak var imgVw_Bell: UIImageView!
    @IBOutlet weak var vw_PlayListBack: RoundView!
    @IBOutlet weak var playListCollectionVw: UICollectionView!
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    var imageSDWebImageSrc = [SDWebImageSource]()
    var pagePosition = 0
    var showHide = false
    var nowPlayingInfo = [String: Any]()
    var count = 0
    var randomInt = 0
    var tripleDotActiveIndex = 9999999
    var trackIdStr = ""
    
    //MARK: BUTTON ACTIONS
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC
        navigationController?.pushViewController(vc,animated: false)
    }
    @IBAction func NotificationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(vc,animated: true)
    }
    @IBAction func GenresBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GenresVC") as! GenresVC
        navigationController?.pushViewController(vc,animated: false)
    }
    
    @IBAction func SearchBtnAction(_ sender: UIButton) {
        
        if self.txtFld_SearchField.text != ""{
            if self.txtFld_SearchField.text!.count >= 3{
                let searchKey = self.txtFld_SearchField.text
                HUD.show(to: self.view)
                AuthService.instance.SearchAPI(searchKey: searchKey!,completion: {(success, data, message) in
                    if success{
                        HUD.hide(to: self.view)
                        let storyboard = UIStoryboard(name: "Account", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC//MoreVC
                        vc.searchKey = "\(self.txtFld_SearchField.text!)"
                        self.navigationController?.pushViewController(vc,animated: true)
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
    
    
    
    @IBAction func morePopularSongAction(_ sender: UIButton){
        if AuthService.instance.popularArray.count > 0{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "popularSong"
            navigationController?.pushViewController(vc,animated: true)
        }
        else{
            self.showAlert(message: "Albam has no data right now.")
        }

    }
    @IBAction func moreRecentlyPlayedAction(_ sender: UIButton){
        if AuthService.instance.recentlyPlayedArray.count > 0{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "moreRecently"
            navigationController?.pushViewController(vc,animated: true)
        }
        else{
            self.showAlert(message: "Albam has no data right now.")
        }
    }
    @IBAction func moreNewReleasesAction(_ sender: UIButton){
        if AuthService.instance.newReleaseArray.count > 0{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "moreNewReleases"
            navigationController?.pushViewController(vc,animated: true)
        }
        else{
            //self.showAlert(message: "Albam has no data right now.")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Albam has no data right now."
            customAlert.delegate = self
            customAlert.show()
        }
    }
    @IBAction func moreTrendingNowAction(_ sender: UIButton){
        if AuthService.instance.trendingNowArray.count > 0{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "moreTrendingNow"
            navigationController?.pushViewController(vc,animated: true)
        }
        else{
            //self.showAlert(message: "Albam has no data right now.")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Albam has no data right now."
            customAlert.delegate = self
            customAlert.show()
        }
    }
    @IBAction func moreNewAlbamsAction(_ sender: UIButton){
        if AuthService.instance.newAlbamArray.count > 0{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "moreNewAlbams"
            navigationController?.pushViewController(vc,animated: true)
        }
        else{
            //self.showAlert(message: "Albam has no data right now.")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Albam has no data right now."
            customAlert.delegate = self
            customAlert.show()
        }
    }
    @IBAction func moreRecommendedAction(_ sender: UIButton){
        if AuthService.instance.recomendedArray.count > 0{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "moreRecommended"
            navigationController?.pushViewController(vc,animated: true)
        }
        else{
            //self.showAlert(message: "Albam has no data right now.")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Albam has no data right now."
            customAlert.delegate = self
            customAlert.show()
        }
    }
    @IBAction func moreMostPopularThisWeekAction(_ sender: UIButton){
        if AuthService.instance.popularWeekArray.count > 0{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "moreMostPopularThisWeek"
            navigationController?.pushViewController(vc,animated: true)
        }
        else{
            //self.showAlert(message: "Albam has no data right now.")
            let customAlert = RTCustomAlert()
            customAlert.alertMessage = "Albam has no data right now."
            customAlert.delegate = self
            customAlert.show()
        }
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
    
    @IBAction func action_PlayPrevious(_ sender: UIButton) {
        AudioService.instance.previousSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
    }
    
    
    @IBAction func action_PlayNext(_ sender: UIButton) {
        AudioService.instance.nextSong()

        self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
    }

    
    @IBAction func action_SmallPlayPause(_ sender: UIButton) {
        self.playPause()
    }
    
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.vw_PlayListBack.isHidden = true
    }

    
    
    @IBAction func action_Small_T0_FullScreenPlayer(_ sender: UIButton) {
        view.endEditing(true)
        let storyboard = UIStoryboard(name: "Albam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlaySongVC") as! PlaySongVC
        navigationController?.pushViewController(vc,animated: false)
    }

    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
       
        txtFld_SearchField.delegate = self
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(
         target: self,
         action: #selector(dismissMyKeyboard))
         //Add this tap gesture recognizer to the parent view
        self.vw_searchBackground.addGestureRecognizer(tap)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
       self.vw_HeadingBackground.addGestureRecognizer(tap2)
        
        txtFld_SearchField.attributedPlaceholder = NSAttributedString(
            string: "Looking for...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        // *******************SlideShow Coding Start****************************
        
       // let localSource = [BundleImageSource(imageString: "slider"), BundleImageSource(imageString: "slider"), BundleImageSource(imageString: "slider"), BundleImageSource(imageString: "slider")]
        
                    
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill

       // slideshow.pageIndicator = UIPageControl.withSlideshowColors()

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
       // slideshow.setImageInputs(localSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DashBoardVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
        // *******************SlideShow Coding End****************************

        

        popularSongsCollectionVw.delegate = self
        popularSongsCollectionVw.dataSource = self
        
        recentlyPlayedCollectionVw.delegate = self
        recentlyPlayedCollectionVw.dataSource = self

        newReleasesCollectionVw.delegate = self
        newReleasesCollectionVw.dataSource = self

        trendingNowCollectionVw.delegate = self
        trendingNowCollectionVw.dataSource = self

        newAlbamsCollectionVw.delegate = self
        newAlbamsCollectionVw.dataSource = self

        recommendedCollectionVw.delegate = self
        recommendedCollectionVw.dataSource = self

        mostPopularThisWeekCollectionVw.delegate = self
        mostPopularThisWeekCollectionVw.dataSource = self

    }
    @objc func functionName (notification: NSNotification){
        lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
        if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        }
        else{
            nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

        }
        //lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
        let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
        let url = URL(string:"\(imageurl)")
        imgvw_SmallImage.kf.setImage(with: url)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("NewFunctionName"), object: nil)
        DispatchQueue.main.async {
            self.DashBoardAPICall()
            self.myPlayListAPICall()
            self.MyProfileAPICall()
            AuthService.instance.genericListArray.removeAll()
            //AudioService.instance.setupNowPlayingInfoCenter()
        }

        
        if AuthService.instance.whiteTheam == true{
            print("UISwitch state is now ON")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.vw_searchBackground.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.vw_HeadingBackground.backgroundColor  = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Tagline.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Popular.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_RecentlyPlayed.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_NewRelease.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_TrendingNow.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_NewAlbam.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Recommend.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_MostPopularThisWeek.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            self.imgVw_Bell.image = UIImage(named: "bellBlack")
            
            self.btnMorePopular.setTitleColor(UIColor.black, for: .normal)
            self.btnMoreRecentlyPlayed.setTitleColor(UIColor.black, for: .normal)
            self.btnMoreNewRealeases.setTitleColor(UIColor.black, for: .normal)
            self.btnMoreTrendingNow.setTitleColor(UIColor.black, for: .normal)
            self.btnMoreNewAlbams.setTitleColor(UIColor.black, for: .normal)
            self.btnMoreRecommended.setTitleColor(UIColor.black, for: .normal)
            self.btnMoreMostPopularThisWeek.setTitleColor(UIColor.black, for: .normal)
        }
        else{
            print("UISwitch state is now Off")
            self.vw_Background.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.vw_searchBackground.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.vw_HeadingBackground.backgroundColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.lbl_Heading.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Tagline.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Popular.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_RecentlyPlayed.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_NewRelease.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_TrendingNow.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_NewAlbam.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_Recommend.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.lbl_MostPopularThisWeek.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.imgVw_Bell.image = UIImage(named: "bell")
            
            self.btnMorePopular.setTitleColor(UIColor.white, for: .normal)
            self.btnMoreRecentlyPlayed.setTitleColor(UIColor.white, for: .normal)
            self.btnMoreNewRealeases.setTitleColor(UIColor.white, for: .normal)
            self.btnMoreTrendingNow.setTitleColor(UIColor.white, for: .normal)
            self.btnMoreNewAlbams.setTitleColor(UIColor.white, for: .normal)
            self.btnMoreRecommended.setTitleColor(UIColor.white, for: .normal)
            self.btnMoreMostPopularThisWeek.setTitleColor(UIColor.white, for: .normal)
        }
        
       // NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("playerminimize"), object: nil)
        
        if AudioService.instance.isPlayerOn == true{
            bottomConstant.constant = 100.0
            self.vw_SmallPlayer.isHidden = false
                lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
            if AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue != ""{
                nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
            }
            else{
                nowPlayingInfo[MPMediaItemPropertyArtist] = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["artists_name"][0].stringValue

            }
               // lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
                let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                imgvw_SmallImage.kf.setImage(with: url)
            
        }
        else{
            self.vw_SmallPlayer.isHidden = true
            bottomConstant.constant = 0.0
        }

    }

    //UITextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
            if self.txtFld_SearchField.text != ""{
                let searchKey = self.txtFld_SearchField.text
                HUD.show(to: self.view)
                AuthService.instance.SearchAPI(searchKey: searchKey!,completion: {(success, data, message) in
                    if success{
                        HUD.hide(to: self.view)
                        let storyboard = UIStoryboard(name: "Account", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC//MoreVC
                        vc.searchKey = "\(self.txtFld_SearchField.text!)"
                        self.navigationController?.pushViewController(vc,animated: true)
                    }else{
                        //print(message)
                        HUD.hide(to: self.view)
                    }
                })
            }else{
                //self.showAlert(message: "Please enter something for search")
            }

        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//            if textField == txtFld_SearchField {
//                print("You edit myTextField")
//                let storyboard = UIStoryboard(name: "Account", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC//MoreVC
//                self.navigationController?.pushViewController(vc,animated: true)
//            }
//        }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
     }
    
    @objc func didTap() {
        
        if AuthService.instance.bannerArray[self.pagePosition]["song_id"].stringValue != ""{
            
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "song"
            vc.searchKey = "\(AuthService.instance.bannerArray[self.pagePosition]["song_id"].stringValue)"
            navigationController?.pushViewController(vc,animated: true)
            
        }
        else if AuthService.instance.bannerArray[self.pagePosition]["album_id"].stringValue != ""{
            
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.collectionNameStr = "albam"
            vc.searchKey = "\(AuthService.instance.bannerArray[self.pagePosition]["album_id"].stringValue)"
            navigationController?.pushViewController(vc,animated: true)
            
        }
        else if AuthService.instance.bannerArray[self.pagePosition]["url"].stringValue != ""{
            
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "webvwVC") as! webvwVC
            vc.urlStr = "\(AuthService.instance.bannerArray[self.pagePosition]["url"].stringValue)"
            navigationController?.pushViewController(vc,animated: true)
        }

    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func songPlayProgressDB(){
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
                      //  DispatchQueue.main.async {
                            self.songPlayProgressDB()
                       // }
                    }
                    else{
                        AudioService.instance.nowPlayingIndex = 0
                      //  DispatchQueue.main.async {
                            self.songPlayProgressDB()
                       // }
                    }
            }
            else{
                randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                AudioService.instance.nowPlayingIndex = randomInt
               // DispatchQueue.main.async {
                    self.songPlayProgressDB()
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
                         //   DispatchQueue.main.async {
                                self.songPlayProgressDB()
                          //  }
                        }
                        else{
                            AudioService.instance.nowPlayingIndex = 0
                          //  DispatchQueue.main.async {
                                self.songPlayProgressDB()
                           // }
                        }
                }
                else{
                    randomInt = Int.random(in: 0...AudioService.instance.nowPlayingListArray.count - 1)
                    AudioService.instance.nowPlayingIndex = randomInt
                   // DispatchQueue.main.async {
                        self.songPlayProgressDB()
                   // }
                }
            }
        }
        AudioService.instance.nowPlayingSongId = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue
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
       // self.view.insertSubview(AudioService.instance.controller.view, at: 0)
        AudioService.instance.controller.allowsPictureInPicturePlayback = true
        // true - Repeat On, false - repeat off
        AudioService.instance.controller.showsPlaybackControls = true
        
        //for closing when video ends
        NotificationCenter.default.addObserver(self, selector: #selector(closePlayer), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: AudioService.instance.controller.player?.currentItem)

        //for closing on tap
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closePlayer))
        AudioService.instance.controller.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func closePlayer() {
        dismiss(animated: true)
        //if you go notification route, don't forget to remove observer
        NotificationCenter.default.removeObserver(self)
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

    func DashBoardAPICall(){
        HUD.show(to: self.view)
        AuthService.instance.DashBoardAPI(completion: {(success, data, message) in
            if success{
                if AuthService.instance.popularArray.count > 0{
                    self.popularSongsCollectionVw.reloadData()
                }
                 if AuthService.instance.recentlyPlayedArray.count > 0{
                    self.recentlyPlayedCollectionVw.reloadData()
                }
                 if AuthService.instance.newReleaseArray.count > 0{
                    self.newReleasesCollectionVw.reloadData()
                }
                 if AuthService.instance.trendingNowArray.count > 0{
                    self.trendingNowCollectionVw.reloadData()
                }
                 if AuthService.instance.newAlbamArray.count > 0{
                    self.newAlbamsCollectionVw.reloadData()
                }
                 if AuthService.instance.recomendedArray.count > 0{
                    self.recommendedCollectionVw.reloadData()
                }
                 if AuthService.instance.popularWeekArray.count > 0{
                    self.mostPopularThisWeekCollectionVw.reloadData()
                }
                
                if AuthService.instance.bannerArray.count > 0{
                    for i in 0...AuthService.instance.bannerArray.count-1{
                        let image = SDWebImageSource(urlString: AuthService.instance.bannerArray[i]["banner_image"].stringValue)
                                       if let sdURL = image{
                                           self.imageSDWebImageSrc.append(sdURL)
                                       }
                                   }
                                  self.slideshow.setImageInputs(self.imageSDWebImageSrc)
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
                
                HUD.hide(to: self.view)
            }else{
                //print(message)
                HUD.hide(to: self.view)
            }
        })
    }

    
}

//MARK: ImageSlideshowDelegate
extension DashBoardVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        self.pagePosition = page
    }
}

//MARK: CollectionView

extension DashBoardVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.playListCollectionVw{
            if AuthService.instance.myPlaySongListAlbamArray.count > 0{
                return AuthService.instance.myPlaySongListAlbamArray.count
            }
            else{
                return 0
            }
        }
        else if collectionView == self.popularSongsCollectionVw{
            if AuthService.instance.popularArray.count > 0{
                return AuthService.instance.popularArray.count
            }
            else{
                return 0
            }
        }
        else if collectionView == self.recentlyPlayedCollectionVw{
            if AuthService.instance.recentlyPlayedArray.count > 0{
                return AuthService.instance.recentlyPlayedArray.count
            }
            else{
                return 0
            }
            
        }
        else if collectionView == self.newReleasesCollectionVw{
            if AuthService.instance.newReleaseArray.count > 0{
                return AuthService.instance.newReleaseArray.count
            }
            else{
                return 0
            }
            
        }
        else if collectionView == self.trendingNowCollectionVw{
            if AuthService.instance.trendingNowArray.count > 0{
                return AuthService.instance.trendingNowArray.count
            }
            else{
                return 0
            }
            
        }
        else if collectionView == self.newAlbamsCollectionVw{
            if AuthService.instance.newAlbamArray.count > 0{
                return AuthService.instance.newAlbamArray.count
            }
            else{
                return 0
            }
            
        }
        else if collectionView == self.recommendedCollectionVw{
            if AuthService.instance.recomendedArray.count > 0{
                return AuthService.instance.recomendedArray.count
            }
            else{
                return 0
            }
            
        }
        else if collectionView == self.mostPopularThisWeekCollectionVw{
            if AuthService.instance.popularWeekArray.count > 0{
                return AuthService.instance.popularWeekArray.count
            }
            else{
                return 0
            }
            
        }
        else {
            return 0
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
        }
        
        else if collectionView == self.popularSongsCollectionVw{
            if AuthService.instance.popularArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.popularArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.popularArray[indexPath.row]["thumbnail"].stringValue
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
            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.popularSongsCollectionVw.reloadData()
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
                    if AuthService.instance.popularArray.count > 0{
                        self.trackIdStr = AuthService.instance.popularArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.popularArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.popularArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true

            }

            
        }
        else if collectionView == self.recentlyPlayedCollectionVw{
            if AuthService.instance.recentlyPlayedArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.recentlyPlayedArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.recentlyPlayedArray[indexPath.row]["thumbnail"].stringValue
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
            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.recentlyPlayedCollectionVw.reloadData()
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
                    if AuthService.instance.recentlyPlayedArray.count > 0{
                        self.trackIdStr = AuthService.instance.recentlyPlayedArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.recentlyPlayedArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.recentlyPlayedArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true

            }
            
        }
        else if collectionView == self.newReleasesCollectionVw{
            if AuthService.instance.newReleaseArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.newReleaseArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.newReleaseArray[indexPath.row]["thumbnail"].stringValue
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
            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.newReleasesCollectionVw.reloadData()
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
                    if AuthService.instance.newReleaseArray.count > 0{
                        self.trackIdStr = AuthService.instance.newReleaseArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.newReleaseArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.newReleaseArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true

            }
            
            
            
        }
        else if collectionView == self.trendingNowCollectionVw{
            if AuthService.instance.trendingNowArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.trendingNowArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.trendingNowArray[indexPath.row]["thumbnail"].stringValue
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
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.trendingNowCollectionVw.reloadData()
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
                    if AuthService.instance.trendingNowArray.count > 0{
                        self.trackIdStr = AuthService.instance.trendingNowArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.trendingNowArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.trendingNowArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true

            }
            
        }
        else if collectionView == self.newAlbamsCollectionVw{
            if AuthService.instance.newAlbamArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.newAlbamArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.newAlbamArray[indexPath.row]["thumbnail"].stringValue
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
        else if collectionView == self.recommendedCollectionVw{
            if AuthService.instance.recomendedArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.recomendedArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.recomendedArray[indexPath.row]["thumbnail"].stringValue
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
            
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.recommendedCollectionVw.reloadData()
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
                    if AuthService.instance.recomendedArray.count > 0{
                        self.trackIdStr = AuthService.instance.recomendedArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.recomendedArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.recomendedArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true

            }
            
        }
        else if collectionView == self.mostPopularThisWeekCollectionVw{
            if AuthService.instance.popularWeekArray.count > 0{
                cell.lbl_AlbamName.text = AuthService.instance.popularWeekArray[indexPath.row]["title"].stringValue
                
                let imageurl = AuthService.instance.popularWeekArray[indexPath.row]["thumbnail"].stringValue
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
            cell.dotsBtnPressed = {
                self.tripleDotActiveIndex = indexPath.row
                self.mostPopularThisWeekCollectionVw.reloadData()
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
                    if AuthService.instance.popularWeekArray.count > 0{
                        self.trackIdStr = AuthService.instance.popularWeekArray[indexPath.row]["category"]["id"].stringValue
                        self.vw_PlayListBack.isHidden = false
                    }
                    else{
                        self.showAlert(message: "Please create a playlist first")
                    }
                }
             
        }
            
            cell.shareBtnPressed = {
                let textToShare = "Hey! Friend Listen this song - \(AuthService.instance.popularWeekArray[indexPath.row]["title"].stringValue).Available only in wemo."

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
                self.songLikeAPICall(songIdStr: "\(AuthService.instance.popularWeekArray[indexPath.row]["song_id"].stringValue)")
                cell.vw_SHare.isHidden = true

            }
            
        }
        else{
            
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
        else if collectionView == self.popularSongsCollectionVw{
            width_collView = 150.0
            hight_collView = 193.0

        }else if collectionView == self.recentlyPlayedCollectionVw{
            width_collView = 127.0
            hight_collView = 139.0
            
        }
        else if collectionView == self.newReleasesCollectionVw{
            width_collView = 127.0
            hight_collView = 139.0
            
        }
        else if collectionView == self.trendingNowCollectionVw{
            width_collView = 150.0
            hight_collView = 193.0
        }
        else if collectionView == self.newAlbamsCollectionVw{
            width_collView = 127.0
            hight_collView = 139.0
            
        }
        else if collectionView == self.recommendedCollectionVw{
            width_collView = 127.0
            hight_collView = 139.0
            
        }
        else if collectionView == self.mostPopularThisWeekCollectionVw{
            width_collView = 150.0
            hight_collView = 193.0
            
        }
        else{
            
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

        }
        
        else if collectionView == self.newAlbamsCollectionVw{
           // AudioService.instance.nowPlayingListArray = AuthService.instance.newAlbamArray
            let storyboard = UIStoryboard(name: "Albam", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbamDetailsVC") as! AlbamDetailsVC
            vc.playSelectedIndex = indexPath.row
            vc.collectionNameStr = "albam"
            vc.albumID = AuthService.instance.newAlbamArray[indexPath.row]["palbum_id"].stringValue
            vc.strAlbumURL = AuthService.instance.newAlbamArray[indexPath.row]["thumbnail"].stringValue
            self.navigationController?.pushViewController(vc,animated: false)
        }
        else{
            AudioService.instance.nowPlayingIndex = indexPath.row
            self.vw_SmallPlayer.isHidden = false
            AudioService.instance.isPlayerOn = true
            bottomConstant.constant = 100.0
            if collectionView == self.popularSongsCollectionVw{
                AudioService.instance.nowPlayingListArray = AuthService.instance.popularArray
            }else if collectionView == self.recentlyPlayedCollectionVw{
                AudioService.instance.nowPlayingListArray = AuthService.instance.recentlyPlayedArray
            }
            else if collectionView == self.newReleasesCollectionVw{
                AudioService.instance.nowPlayingListArray = AuthService.instance.newReleaseArray
            }
            else if collectionView == self.trendingNowCollectionVw{
                AudioService.instance.nowPlayingListArray = AuthService.instance.trendingNowArray
            }
            else if collectionView == self.recommendedCollectionVw{
                AudioService.instance.nowPlayingListArray = AuthService.instance.recomendedArray
            }
            else if collectionView == self.mostPopularThisWeekCollectionVw{
                AudioService.instance.nowPlayingListArray = AuthService.instance.popularWeekArray
            }
            else{
                
            }

            
            let songString = "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["audio_location"].stringValue)"
            if songString == ""{
                let customAlert = RTCustomAlert()
                customAlert.alertMessage = "There is no song left."
                customAlert.delegate = self
                customAlert.show()
            
            }else{
              //  DispatchQueue.main.async {
                    AudioService.instance.playSong(SongURL: songString)
              //  }
                
                lbl_SmallTitle.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["title"].stringValue
                lbl_SmallTag.text = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["description"].stringValue
                let imageurl = AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["thumbnail"].stringValue
                let url = URL(string:"\(imageurl)")
                imgvw_SmallImage.kf.setImage(with: url)
                
                self.songViewAPICall(songIdStr: "\(AudioService.instance.nowPlayingListArray[AudioService.instance.nowPlayingIndex]["song_id"].stringValue)")
                
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
        view.endEditing(true)
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
                self.songPlayProgressDB()
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
                self.songPlayProgressDB()
            }
          return .success
        }
      }
}
