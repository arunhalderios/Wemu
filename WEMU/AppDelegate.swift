//
//  AppDelegate.swift
//  WEMU
//
//  Created by Arun Halder on 05/09/22.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import AVKit
import InAppPurchase

//extension InAppPurchase {
//    static let custom = InAppPurchase(shouldCompleteImmediately: false)
//}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        // MARK: - INAPP SERVICE
//        InAppPurchase.default.addTransactionObserver { result in
//            switch result {
//            case .success(let response):
//                switch response.state {
//                case .purchased:
//                    print("[PURCHASED] \(response.transaction.transactionIdentifier ?? "nil")")
//                case .restored:
//                    print("[RESTORED] \(response.transaction.transactionIdentifier ?? "nil")")
//                case .deferred:
//                    print("[DEFERRED] \(response.transaction.transactionIdentifier ?? "nil")")
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        // MARK: -  AUDIO SERVICE.
        
        do {
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: AVAudioSession.Category.playback.rawValue))

            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        application.beginReceivingRemoteControlEvents()
        self.setupNotifications()
        
        // MARK: -  Use Firebase library to configure APIs.
        FirebaseApp.configure()
    
    if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
    } else {
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    Messaging.messaging().delegate = self
    
    Messaging.messaging().token { token, error in
        if let error = error {
            print("Error fetching FCM registration token: \(error)")
            AuthService.instance.firebaseToken = ""
        } else if let token = token {
            print("FCM registration token: \(token)")
            AuthService.instance.firebaseToken = token
        }
    }
        
        sleep(2);
        if AuthService.instance.isLoggedIn == true{
                    let storyboard = UIStoryboard(name: "Account", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
                    let nav = UINavigationController(rootViewController: vc)
                    nav.isNavigationBarHidden = true
                    self.window?.rootViewController = nav
                    self.window?.makeKeyAndVisible()
        }else{
            let storyboard = UIStoryboard.init(name: "Main", bundle:nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SliderMainVC")
                    let nav = UINavigationController(rootViewController: vc)
                    nav.isNavigationBarHidden = true
                    self.window?.rootViewController = nav
                    self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    func setupNotifications() {
        // Get the default notification center instance.
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleInterruption),
                       name: AVAudioSession.interruptionNotification,
                       object: AVAudioSession.sharedInstance())
    }

    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }

        // Switch over the interruption type.
        switch type {

        case .began: break
            // An interruption began. Update the UI as necessary.

        case .ended:
           // An interruption ended. Resume playback, if appropriate.

            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // An interruption ended. Resume playback.
                AudioService.instance.controller.player?.play()
            } else {
                // An interruption ended. Don't resume playback.
            }

        default: ()
        }
    }
    
    // MARK: -  [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        
        print("get push :  " , userInfo ,  UIApplication.shared.applicationState )
        print("didReceiveRemoteNotification Message ID: \(userInfo["gcm.message_id"]!)")
       // redirectToView(userInfo)
        completionHandler(.newData);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: \(error)")
    }
    
    
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print(error.localizedDescription)
    }
    // [END receive_message]

    // MARK: -  [START: Handle Notification]
    func handleNotification(userInfo:[AnyHashable:Any]){
        NotificationCenter.default.post(name: Notification.Name("NotificationRecieved"), object: nil)
    }
    // [END: Handle Notification]

     

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

func applicationDidEnterBackground(_ application: UIApplication) {

    // Disconnect the AVPlayer from the presentation when entering background

    // If presenting video with AVPlayerViewController
   // AudioService.instance.controller.player = nil
    AudioService.instance.controller.player = nil
    if #available(iOS 14, *), ((AudioService.instance.controller.player?.currentItem) != nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if ((AudioService.instance.controller.player?.currentItem) != nil){ AudioService.instance.controller.player!.play() }
                }
            }
}

func applicationWillEnterForeground(_ application: UIApplication) {
    // Reconnect the AVPlayer to the presentation when returning to foreground

    // If presenting video with AVPlayerViewController
    AudioService.instance.controller.player = AudioService.instance.player

}


func applicationDidBecomeActive(_ application: UIApplication){
    if AudioService.instance.controller.player?.rate == 0.0{
        AudioService.instance.controller.player?.play()
    }
}


// MARK: -  [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        debugPrint("%@", userInfo)
        

        
        //MARK: - - - - - Set data for Passing Data Post Notification - - - - -
        
//        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: objToBeSent)

        
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        debugPrint("%@", userInfo)
        
        completionHandler()

    }
    
}

extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("Firebase registration token: \(fcmToken)")
        
        
        let fcmTokenStr = "\(fcmToken!)"
        
        AuthService.instance.firebaseToken = fcmTokenStr

        
        UserDefaults.standard.set(fcmTokenStr, forKey: "gcm_token")
        UserDefaults.standard.synchronize()

            
            let dataDict:[String: String] = ["token": fcmTokenStr]
                        
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    
}

