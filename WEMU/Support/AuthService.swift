
import Foundation
//import Reachability
import Alamofire
import SwiftyJSON

struct NetworkState {

    var isInternetAvailable:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}



class AuthService {
    static let instance = AuthService()//creating a instance
    typealias CompletionHandler = (_ success: Bool, _ data: Any?, _ message: String?)-> Void
    //let baseUrl = "https://developer.shyamfuture.in/wemuonline/public/api/"
    let baseUrl = "https://wemu.online/webadmin/public/api/"
     
    //MARK: API END POINTS
    let SplashScreen = "splash-screen-text"
    let Registration = "register"
    let Login = "login"
    let ForgetPassword = "forgot-password"
    let VerifyOtp = "verify-otp"
    let ResendOtp = "resend-otp"
    let ResetPassword = "reset-password"
    
    let DashBoard = "dashboard"
    let Search = "search/"
    let PlaySongs = "play-songs/"
    let SongList = "song-list/"
    let RecentPlyed = "recent-play"
   // let ListAlbam = "album-songs/null?page=0"
    let Myplaylist = "my-playlist/"


    let FavSong = "fav-songs"

    let CategoryAlbam = "category-album/"
    
    
    let GenreList = "genre_list?page="
    let GenreDetails = "genre-details/"
    
    let AddRemoveFav = "add-remove-favouirite/"
    let AddRemoveMyPlayList = "add-remove-playlist"
    
    var MyPlaySongList = "my-playlist"
    var MyPlayListDetails = "playlist-details/"
    var CreatePlayList = "create-playlist"
    
    var Notification = "notification-get/"
    
//    var ArtistAlbamList = "search-album-lists/"
    let AlbamList = "list-albums/0?page=" //To get Albam List
    let ArtistList = "artist-list?page=" //"To get Artist List
    
    let AlbamSongs = "album-songs/" //25?page=2 //To get (Albam + Artist) Song list


    var ArtistAlbamList = "artist-album-lists?page=" // More To get Artist Song list
    let ArtistSongs = "artists-songs/" // To get Search Artist Song List
    

    var SearchSongLists = "search-song-lists/" // To get Search Song List (view All)
    var SearchAlbamLists = "search-album-lists/"  // To get Search Albam list(view All)
    var SearchArtistLists = "search-artist-lists/"  // To get Search Artist list(view All)


    var SongView = "song-view/"
    var SongLike = "song-like/"
    
    
    
    let MyProfile = "my-profile"
    let CountryList = "country-list"
    let UpdateProfile = "update-profile"
    let UploadImage = "upload-image"
    let Logout = "logout"
    let SubcriptionPro = "update-pro"
    
    var baseImageUrl = ""
    var coverUrl = ""
    var avatarUrl = ""
    var userInfo = ""
    var age = ""
    var aboutMe = ""
  //  var facebook = ""
    var countryName = ""
    var countryId = ""
    var website = ""
    
    var lastPlayingSongName = ""
    var lastPlayingSongTag = ""
    
    var lastPlayingSongUrl = ""
    var lastPlayingSecond = ""
    var lastPlayingProgressTime = ""
    var albumCurrentPage = 0
    var albumLastPage = 0
    
    var artistListCurrentPage = 0
    var artistListLastPage = 0
    
    var artistCurrentPage = 0
    var artistLastPage = 0
    
    var playListDetailsCurrentPage = 0
    var playListDetailsLastPage = 0
    
    
    var ProfileData = JSON()

    var isSubcriptionApply = false
    
    //MARK: USER DEFAULTS
    let defaults = UserDefaults.standard
    
    let FIREBASE_TOKEN = "Firebase_token"

    let USERID = "userId"
    let NAME = "name"
    let DOB = "dob"
    let GENDER = "gender"
    let AVATAR = "avatar"
    let COVER = "cover"
    let USERNAME = "userName"
    let EMAIL = "email"
    let ACCESSTOKEN = "accessToken"
    let TOKENTYPE = "accessType"
    let REFRESHTOKEN = "refreshToken"
    let DELETEACCOUNT = "delete-account"
    let IS_LOGGED_IN = "isloggedin"
    let IMAGE_URL = "iamgeUrl"
    let WHITETHEAM = "WhiteTheam"
    let SUBCRIPTION = "subcription"
    

    
    var bannerArray = [JSON]()
    var popularArray = [JSON]()
    var trendingNowArray = [JSON]()
    var newReleaseArray = [JSON]()
    var recomendedArray = [JSON]()
    var recentlyPlayedArray = [JSON]()
    var popularWeekArray = [JSON]()
    var newAlbamArray = [JSON]()
    
    var searchListArray = [JSON]()
    var searchSongListArray = [JSON]()
    var searchAlbamListArray = [JSON]()
    var searchArtistListArray = [JSON]()
    var artistAlbamListArray = [JSON]()
    var categoryAlbamListArray = [JSON]()


    var countryListArray = [JSON]()
    var favouriteListArray = [JSON]()
    var myPlayListArray = [JSON]()
    var myPlayListDetailsArray = [JSON]()
    var artistListArray = [JSON]()
    
    var albamListArray = [JSON]()
    var songListArray = [JSON]()
    var genericListArray = [JSON]()
    var albumSongsListArray = [JSON]()
    var genericDetailListArray = [JSON]()
    var artistSongsListArray = [JSON]()
    var myPlaySongListAlbamArray = [JSON]()
    var notificationListArray = [JSON]()
    
    
    //MARK: Set and get the value
    var firebaseToken:String?{
        get{
            return (defaults.value(forKey: FIREBASE_TOKEN) as? String)
        }set{
            defaults.set(newValue, forKey: FIREBASE_TOKEN)
        }
    }

    var subcription:Bool?{
        get{
            return (defaults.value(forKey: WHITETHEAM) as? Bool)
        }set{
            defaults.set(newValue, forKey: WHITETHEAM)
        }
    }
    
    
        
    var whiteTheam:Bool?{
        get{
            return (defaults.value(forKey: WHITETHEAM) as? Bool)
        }set{
            defaults.set(newValue, forKey: WHITETHEAM)
        }
    }
    
    
    var userId:String?{
        get{
            return (defaults.value(forKey: USERID) as? String)
        }set{
            defaults.set(newValue, forKey: USERID)
        }
    }
    
    var name:String?{
        get{
            return (defaults.value(forKey: NAME) as? String)
        }set{
            defaults.set(newValue, forKey: NAME)
        }
    }
    
    var dob:String?{
        get{
            return (defaults.value(forKey: DOB) as? String)
        }set{
            defaults.set(newValue, forKey: DOB)
        }
    }
    
    var gender:String?{
        get{
            return (defaults.value(forKey: GENDER) as? String)
        }set{
            defaults.set(newValue, forKey: GENDER)
        }
    }
    
    var avatar:String?{
        get{
            return (defaults.value(forKey: AVATAR) as? String)
        }set{
            defaults.set(newValue, forKey: AVATAR)
        }
    }
    
    var cover:String?{
        get{
            return (defaults.value(forKey: COVER) as? String)
        }set{
            defaults.set(newValue, forKey: COVER)
        }
    }
    
    var token:String?{
        get{
            return (defaults.value(forKey: ACCESSTOKEN) as? String)
        }set{
            defaults.set(newValue, forKey: ACCESSTOKEN)
        }
    }
    
    var tokenType:String?{
        get{
            return (defaults.value(forKey: TOKENTYPE) as? String)
        }set{
            defaults.set(newValue, forKey: TOKENTYPE)
        }
    }
    
    var username:String?{
        get{
            return (defaults.value(forKey: USERNAME) as? String)
        }set{
            defaults.set(newValue, forKey: USERNAME)
        }
    }
    
    var email:String?{
        get{
            return (defaults.value(forKey: EMAIL) as? String)
        }set{
            defaults.set(newValue, forKey: EMAIL)
        }
    }
    
    var accessToken:String?{
        get{
            return (defaults.value(forKey: ACCESSTOKEN) as? String)
        }set{
            defaults.set(newValue, forKey: ACCESSTOKEN)
        }
    }
    
    var refreshToken:String?{
        get{
            return (defaults.value(forKey: REFRESHTOKEN) as? String)
        }set{
            defaults.set(newValue, forKey: ACCESSTOKEN)
        }
    }

    var isLoggedIn:Bool?{
        get{
            return (defaults.value(forKey: IS_LOGGED_IN) as? Bool)
        }set{
            defaults.set(newValue, forKey: IS_LOGGED_IN)
        }
    }
    
    var imageUrl:String?{
        get{
            return (defaults.value(forKey: IMAGE_URL) as? String)
        }set{
            defaults.set(newValue, forKey: IMAGE_URL)
        }
    }
    
    //MARK: API CALLING
    
    func splashScreenAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        

        let url = baseUrl + SplashScreen
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }

    
    func RegistrationAPI(nameStr:String,emailStr:String,passwordStr:String,dobStr:String,genderStr: String,usernameStr:String,password_confirmationStr:String,subscriptionStr:String, completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
            "Accept" : "application/json"]
        let params : [String:Any]  = ["name":nameStr,"email":emailStr,"password":passwordStr,"dob":dobStr,"gender":genderStr,"username":usernameStr,"password_confirmation":password_confirmationStr,"subscription":subscriptionStr]
        let url = baseUrl + Registration
        
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)

        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)
                
                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.tokenType = resultValue["data"]["token_type"].stringValue
                    self.token = "\(resultValue["data"]["token_type"].stringValue)" + " \( resultValue["data"]["access_token"].stringValue)"
                    completion(true, nil, message)
                }
                else if statusStr == false{
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
      }
    

    
    func LoginAPI(emailStr: String,passwordStr: String, completion: @escaping CompletionHandler){
        
        guard let fcmtokenStr = AuthService.instance.firebaseToken else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["email":emailStr,"password":passwordStr,"device_type":"ios","udid":"\(fcmtokenStr)"]
        let url = baseUrl + Login
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.tokenType = resultValue["data"]["tokens"]["token_type"].stringValue
                    self.token = "\(resultValue["data"]["tokens"]["token_type"].stringValue)" + " \( resultValue["data"]["tokens"]["access_token"].stringValue)"
                    self.dob = resultValue["data"]["dob"].stringValue
                    self.gender = resultValue["data"]["gender"].stringValue
                    self.userId = resultValue["data"]["id"].stringValue
                    self.email = resultValue["data"]["email"].stringValue
                    self.cover = resultValue["data"]["cover"].stringValue
                    self.username = resultValue["data"]["username"].stringValue
                    self.avatar = resultValue["data"]["avatar"].stringValue
                    self.name = resultValue["data"]["name"].stringValue
                    self.imageUrl = resultValue["data"]["image_url"].stringValue
                    let subVal = resultValue["data"]["subscription"].stringValue
                    
                    if subVal == "1"{
                        self.subcription = true
                    }
                    else{
                        self.subcription = false
                    }

                    AuthService.instance.isLoggedIn = true

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func ForgetPasswordAPI(emailStr: String, completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["email":emailStr]
        let url = baseUrl + ForgetPassword
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func VerifyOtpAPI(emailStr: String,otpStr:String, completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["email":emailStr,"otp":otpStr]
        let url = baseUrl + VerifyOtp
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func ResendOtpAPI(emailStr: String, completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["email":emailStr]
        let url = baseUrl + ResendOtp
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func ResetPasswordAPI(emailStr: String,passwordStr:String,password_confirmationStr:String, completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["email":emailStr,"password":passwordStr,"password_confirmation":password_confirmationStr]
        let url = baseUrl + ResetPassword
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func DashBoardAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + DashBoard
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.bannerArray = resultValue["data"]["newBanner"].arrayValue
                    self.newAlbamArray = resultValue["data"]["new_album"].arrayValue
                    self.newReleaseArray = resultValue["data"]["new_release"].arrayValue
                    self.popularArray = resultValue["data"]["popular"].arrayValue
                    self.popularWeekArray = resultValue["data"]["popular_week"].arrayValue
                    self.recentlyPlayedArray = resultValue["data"]["recently_played"].arrayValue
                    self.recomendedArray = resultValue["data"]["recomended"].arrayValue
                    self.trendingNowArray = resultValue["data"]["trending_now"].arrayValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func SearchAPI(searchKey:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + Search + "\(searchKey)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.searchAlbamListArray = resultValue["data"]["albums"].arrayValue
                    self.searchArtistListArray = resultValue["data"]["artists"].arrayValue
                    self.searchSongListArray = resultValue["data"]["songs"]["data"].arrayValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func searchSongsListAPI(songIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + SearchSongLists + "\(songIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.searchSongListArray = resultValue["data"]["data"].arrayValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func searchAlbamListAPI(albamIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + SearchAlbamLists + "\(albamIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.searchAlbamListArray = resultValue["data"]["data"].arrayValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func searchArtistListAPI(albamIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + SearchArtistLists + "\(albamIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.searchArtistListArray = resultValue["data"]["data"].arrayValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }

    
    func PlaySongsAPI(songIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + PlaySongs + "\(songIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue

                    completion(true, self.ProfileData, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func SongListAPI(keyStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + SongList + "\(keyStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    if keyStr == "new"{
                        
                        self.songListArray.removeAll()
                        
                        let arrAlbum = resultValue["data"]["data"].arrayValue
                        for i in 0..<arrAlbum.count {
                            print(i)
                            self.songListArray.append(arrAlbum[i])
                            
                        }
                    }
                    
                    else{
                        
                        self.songListArray.removeAll()
                        
                        let arrAlbum = resultValue["data"]["data"].arrayValue
                        for i in 0..<arrAlbum.count {
                            print(i)
                            self.songListArray.append(arrAlbum[i])
                            
                        }

                    }
                    
                    

                    
                 //   self.songListArray = resultValue["data"]["data"].arrayValue

                    completion(true, self.songListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func RecentPlayedAPI( completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + RecentPlyed //+ "\(keyStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                   // if keyStr == "new"{
                        
                        self.songListArray.removeAll()
                        
                        let arrAlbum = resultValue["data"].arrayValue
                        for i in 0..<arrAlbum.count {
                            print(i)
                            self.songListArray.append(arrAlbum[i])
                            
                        }
                   // }
                    
//                    else{
//
//                        self.songListArray.removeAll()
//
//                        let arrAlbum = resultValue["data"]["data"].arrayValue
//                        for i in 0..<arrAlbum.count {
//                            print(i)
//                            self.songListArray.append(arrAlbum[i])
//
//                        }
//
//                    }
                    
                 //   self.songListArray = resultValue["data"]["data"].arrayValue

                    completion(true, self.songListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func ListAlbamAPI(intPageNumber:Int, completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        let trimmedString = tokenStr.trimmingCharacters(in: .whitespaces)
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": trimmedString]
                        
        let url = baseUrl + AlbamList + "\(intPageNumber)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.albumCurrentPage = Int(resultValue["data"]["current_page"].stringValue) ?? 0
                    self.albumLastPage = Int(resultValue["data"]["last_page"].stringValue) ?? 0
                    let arrAlbum = resultValue["data"]["data"].arrayValue
                    for i in 0..<arrAlbum.count {
                        print(i)
                        self.albamListArray.append(arrAlbum[i])
                        
                    }


                    completion(true, self.albamListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
//                    self.albamListArray = resultValue["trace"].arrayValue
//                    completion(true, self.albamListArray, "")
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    //********//
    
    func GenericListAPI(intPageNumber:Int, completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        let trimmedString = tokenStr.trimmingCharacters(in: .whitespaces)
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": trimmedString]
                        
        let url = baseUrl + GenreList + "\(intPageNumber)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.albumCurrentPage = Int(resultValue["data"]["current_page"].stringValue) ?? 0
                    self.albumLastPage = Int(resultValue["data"]["last_page"].stringValue) ?? 0
                    let arrAlbum = resultValue["data"]["data"].arrayValue
                    for i in 0..<arrAlbum.count {
                        print(i)
                        self.genericListArray.append(arrAlbum[i])
                        
                    }


                    completion(true, self.genericListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
//                    self.albamListArray = resultValue["trace"].arrayValue
//                    completion(true, self.albamListArray, "")
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    /*
    func GenericListAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + GenreList
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.genericListArray = resultValue["data"]["data"].arrayValue


                    completion(true, self.albamListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    */
    
    
    func GenresAPICall(songIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + GenreDetails + "\(songIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)
                self.genericDetailListArray.removeAll()

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.albumCurrentPage = Int(resultValue["data"]["current_page"].stringValue) ?? 0
                    self.albumLastPage = Int(resultValue["data"]["last_page"].stringValue) ?? 0
                    let arrAlbum = resultValue["data"]["songs"].arrayValue
                    for i in 0..<arrAlbum.count {
                        print(i)
                        self.genericDetailListArray.append(arrAlbum[i])
                        
                    }
                    
                    completion(true, self.genericDetailListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func AlbamSongsAPI(songIdStr:String,pageNoStr:String,completion: @escaping CompletionHandler){
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + AlbamSongs + "\(songIdStr)?page=\(pageNoStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

               
                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.albumCurrentPage = Int(resultValue["data"]["current_page"].stringValue) ?? 0
                    self.albumLastPage = Int(resultValue["data"]["last_page"].stringValue) ?? 0
                    let arrAlbum = resultValue["data"]["data"].arrayValue
                   
                    for i in 0..<arrAlbum.count {
                        print(i)
                        self.albumSongsListArray.append(arrAlbum[i])
                        
                    }
                    
                    completion(true, self.albumSongsListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func CreatePlayListAPI(imgData: Data,playListTitle:String, completion: @escaping CompletionHandler){
          
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        
        let parameters: Parameters  = ["title": "\(playListTitle)"]
        let url = baseUrl + CreatePlayList

         print("============HEADERS=================")
         print(headers)
         print("============PARAMETERS=================")
         print(parameters)
         print("============URL=================")
         print(url)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "playlist.jpg", mimeType: "image/jpg");
            // add parameters
            for (key, value) in parameters {
                        multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                    }
            },
        to:url, usingThreshold: UInt64.init(), method: .post, headers: headers).validate(statusCode: 200..<600).responseJSON{ (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
      }
    
    func MyPlayListAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + Myplaylist
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .post, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.myPlayListArray = resultValue["data"]["data"].arrayValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func MyPlayListDetailsAPI(playListIdStr:String,pageNoStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + MyPlayListDetails + "\(playListIdStr)?page=\(pageNoStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.playListDetailsCurrentPage = Int(resultValue["data"]["current_page"].stringValue) ?? 0
                    self.playListDetailsLastPage = Int(resultValue["data"]["last_page"].stringValue) ?? 0
                    let listData = resultValue["data"]["data"].arrayValue
                    for i in 0..<listData.count {
                        print(i)
                        self.myPlayListDetailsArray.append(listData[i])

                    }
                    
                    completion(true, self.artistSongsListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func ArtistListAPI(intPageNumber:Int, completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
       // let url = baseUrl + ArtistList
        let url = baseUrl + ArtistList + "\(intPageNumber)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    //self.artistListArray = resultValue["data"]["data"].arrayValue
                    self.artistListCurrentPage = Int(resultValue["data"]["current_page"].stringValue) ?? 0
                    self.artistListLastPage = Int(resultValue["data"]["last_page"].stringValue) ?? 0
                    let arrAlbum = resultValue["data"]["data"].arrayValue
                    for i in 0..<arrAlbum.count {
                        print(i)
                        self.artistListArray.append(arrAlbum[i])
                    }
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func ArtistSongsAPI(artistUserIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + ArtistSongs + "\(artistUserIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.artistCurrentPage = Int(resultValue["data"]["current_page"].stringValue) ?? 0
                    self.artistLastPage = Int(resultValue["data"]["last_page"].stringValue) ?? 0
                    self.artistSongsListArray = resultValue["data"]["data"].arrayValue
//                    for i in 0..<arrArtist.count {
//                        print(i)
//                        self.artistSongsListArray.append(arrArtist[i])
//
//                    }
                    
                    completion(true, self.artistSongsListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func CategoryAlbamAPI(catIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + CategoryAlbam + "\(catIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.categoryAlbamListArray = resultValue["data"]["data"].arrayValue
                    completion(true, self.categoryAlbamListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    

    
    func MyProfileAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
            "Authorization": tokenStr]
                        
        let url = baseUrl + MyProfile
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("============TOKEN=================")
        print(tokenStr)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)


                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.baseImageUrl = resultValue["image_url"].stringValue
                    self.coverUrl = resultValue["data"]["cover"].stringValue
                    self.avatarUrl = resultValue["data"]["avatar"].stringValue
                    self.userInfo = resultValue["data"]["about"].stringValue
                    self.age = resultValue["data"]["age"].stringValue
                    self.aboutMe = resultValue["data"]["about"].stringValue
                   // self.facebook = resultValue["data"]["facebook"].stringValue
                    self.countryName = resultValue["data"]["country"]["name"].stringValue
                    self.countryId = resultValue["data"]["country_id"].stringValue
                    self.website = resultValue["data"]["website"].stringValue
                    
                    let subVal = resultValue["data"]["subscription"].stringValue
                    
                    if subVal == "1"{
                        self.subcription = true
                    }
                    else{
                        self.subcription = false
                    }
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    

    
    func UpdateGeneralSettingAPI(country_idStr:String,genderStr:String,ageStr:String,nameStr:String,aboutStr:String,websiteStr:String,completion: @escaping CompletionHandler){

        guard let tokenStr = AuthService.instance.token else {
                return
        }

        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        
        let params : [String:Any]  = ["country_id":country_idStr,"gender":genderStr,"age":ageStr,"name":nameStr,"about":aboutStr,"website":websiteStr]

        let url = baseUrl + UpdateProfile

        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):

                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }

            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func changePasswordAPI(passwordStr:String,password_confirmationStr:String,old_passwordStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        
        let params : [String:Any]  = ["password":passwordStr,"password_confirmation":password_confirmationStr,"old_password":old_passwordStr]

        let url = baseUrl + UpdateProfile
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }

    
    func uploadImageAPI(imgData: Data,imageTypeStr:String, completion: @escaping CompletionHandler){
          
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        
        let parameters: Parameters  = ["type": "\(imageTypeStr)"]
        let url = baseUrl + UploadImage

         print("============HEADERS=================")
         print(headers)
         print("============PARAMETERS=================")
         print(parameters)
         print("============URL=================")
         print(url)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "avatar.jpg", mimeType: "image/jpg");
            // add parameters
            for (key, value) in parameters {
                        multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                    }
            },
        to:url, usingThreshold: UInt64.init(), method: .post, headers: headers).validate(statusCode: 200..<600).responseJSON{ (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.baseImageUrl = resultValue["image_url"].stringValue
                    AuthService.instance.coverUrl = resultValue["data"]["cover"].stringValue
                    AuthService.instance.avatarUrl = resultValue["data"]["avatar"].stringValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
      }
    

    
    func addRemoveFavouriteAPI(trackID:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + AddRemoveFav + "\(trackID)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func songViewAPI(songIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + SongView + "\(songIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func songLikeAPI(songIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + SongLike + "\(songIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    
    func artistAlbamListAPI(songIdStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + ArtistAlbamList + "\(songIdStr)"
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.artistAlbamListArray = resultValue["data"]["data"].arrayValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func addToPlayListAPI(trackIDStr:String,playListIDStr:String,completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        let params : [String:Any]  = ["track_id":trackIDStr,"playlist_id":playListIDStr]


        let url = baseUrl + AddRemoveMyPlayList
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        print("================PARAMS===============")
        print(params)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func myPlaySongListAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + MyPlaySongList
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.myPlaySongListAlbamArray = resultValue["data"]["data"].arrayValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func favouriteListAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + FavSong
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.favouriteListArray = resultValue["data"]["data"].arrayValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func countryListAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + CountryList
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.countryListArray = resultValue["data"].arrayValue

                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func notificationListAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]

        let url = baseUrl + Notification
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    self.notificationListArray = resultValue["data"]["data"].arrayValue

                    completion(true, self.notificationListArray, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func logoutAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        

        let url = baseUrl + Logout
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["success"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    AuthService.instance.isLoggedIn = false
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func subcriptionAPI(transactionId:String, completion: @escaping CompletionHandler){
          
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        
        let parameters: Parameters  = ["amount":"5.99","type": "PRO","via": "INAPP","stripe_customer_id":"\(transactionId)","customer_response":"PURCHASED","stripe_subscription_id":"\(transactionId)"]
        let url = baseUrl + SubcriptionPro

         print("============HEADERS=================")
         print(headers)
         print("============PARAMETERS=================")
         print(parameters)
         print("============URL=================")
         print(url)
        AF.upload(multipartFormData: { multipartFormData in
            
            // add parameters
            for (key, value) in parameters {
                        multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                
                    }
            },
        to:url, usingThreshold: UInt64.init(), method: .post, headers: headers).validate(statusCode: 200..<600).responseJSON{ (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
      }
    
    func removeSubcriptionAPI(completion: @escaping CompletionHandler){
          
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        
        let parameters: Parameters  = ["amount":"0.00","type": "FREE","via": "","stripe_customer_id":"","customer_response":"","stripe_subscription_id":""]
        let url = baseUrl + SubcriptionPro

         print("============HEADERS=================")
         print(headers)
         print("============PARAMETERS=================")
         print(parameters)
         print("============URL=================")
         print(url)
        AF.upload(multipartFormData: { multipartFormData in
            
            // add parameters
            for (key, value) in parameters {
                        multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                
                    }
            },
        to:url, usingThreshold: UInt64.init(), method: .post, headers: headers).validate(statusCode: 200..<600).responseJSON{ (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
      }
    
    
    func deleteAccountAPI(completion: @escaping CompletionHandler){
        
        guard let tokenStr = AuthService.instance.token else {
                return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Authorization": tokenStr]
        
        let url = baseUrl + DELETEACCOUNT
       
        print("============HEADERS=================")
        print(headers)
        print("============URL=================")
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"].boolValue
                if statusStr == true{
                    let message = resultValue["message"].stringValue
                    completion(true, nil, message)
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    completion(false, nil, message
                    )
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
}

