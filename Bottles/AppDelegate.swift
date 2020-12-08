//
//  AppDelegate.swift
//  Bottles
//
//  Created by Alek Matthiessen on 6/21/20.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseDatabase
import FirebaseStorage
import Purchases
import FBSDKCoreKit
import AppsFlyerLib
import IQKeyboardManagerSwift
import FirebaseMessaging
import MBProgressHUD
import FirebaseFirestore
var slimeybool = Bool()

var UserId:String?
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 0
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        AppsFlyerTracker.shared().appsFlyerDevKey = "GSfLvX3FDxH58hR3yDZzZe"
//              AppsFlyerTracker.shared().appleAppID = "1520062033"
//              AppsFlyerTracker.shared().delegate = self
//              AppsFlyerTracker.shared().isDebug = true
        
      FirebaseApp.configure()
               
               AppEvents.activateApp()

               refer = "On Open"
            
               let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let tabBarBuyer : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "Explore") as! UIViewController
               
               uid = UIDevice.current.identifierForVendor?.uuidString ?? "x"

            

        AppsFlyerLib.shared().appsFlyerDevKey = "GSfLvX3FDxH58hR3yDZzZe"
              AppsFlyerLib.shared().appleAppID = "1534830313"
              AppsFlyerLib.shared().delegate = self
              AppsFlyerLib.shared().isDebug = true
               
               
//               self.window = UIWindow(frame: UIScreen.main.bounds)
//               self.window?.rootViewController = tabBarBuyer
//               
//               self.window?.makeKeyAndVisible()
               
               let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                 
                 if launchedBefore {
                     
//                     tabBarBuyer.selectedIndex = 0
                     
                 } else {
                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = vc
                    
                    self.window?.makeKeyAndVisible()
//                     tabBarBuyer.selectedIndex = 0
                     
                     
                 }
               
               queryforpaywall()
               

               Purchases.debugLogsEnabled = true
               Purchases.configure(withAPIKey: "iwmKCkKDKtJKbrYKdDAumktwIbKqLVJm", appUserID: nil)
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        ref = Database.database().reference()
        db = Firestore.firestore()
        return true
    }
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//         
//         AppsFlyerTracker.shared().trackAppLaunch()
//
//     }
//
    func getPrefrences(){
        db.collection("profile").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
           
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    UserId = document.documentID
                    UserDefaults.standard.setValue(UserId, forKey: "UserId")
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
           // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
           AppsFlyerLib.shared().start()
       }
       // Open Univerasal Links
       // For Swift version < 4.2 replace function signature with the commented out code:
       // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
       func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
           print(" user info \(userInfo)")
           AppsFlyerLib.shared().handlePushNotification(userInfo)
       }
       // Open Deeplinks
       // Open URI-scheme for iOS 8 and below
       private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
           AppsFlyerLib.shared().continue(userActivity, restorationHandler: restorationHandler)
           return true
       }
       // Open URI-scheme for iOS 9 and above
       func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
           AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
           return true
       }
       // Report Push Notification attribution data for re-engagements
       func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           AppsFlyerLib.shared().handleOpen(url, options: options)
           return true
       }
       func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           AppsFlyerLib.shared().handlePushNotification(userInfo)
       }
       // Reports app open from deep link for iOS 10 or later
       func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
           AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
           return true
       }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
         print("Firebase registration token: \(fcmToken)")

         let dataDict:[String: String] = ["token": fcmToken]
         NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        db.collection("profile").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    UserId = document.documentID
                    UserDefaults.standard.setValue(UserId, forKey: "UserId")
                    print("\(document.documentID) => \(document.data())")
                }
                if querySnapshot!.documents.count == 0{
                    var ref: DocumentReference? = nil
                    ref = db.collection("profile").addDocument(data: [
                        "brands": [""],
                        "notificationEnable": true,
                        "token": fcmToken,
                        "uid":uid
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            self.getPrefrences()
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
                }else{
                    let updateReference = db.collection("profile").document(querySnapshot!.documents.first?.documentID ?? "")
                    updateReference.getDocument { (document, err) in
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        else {
                            document?.reference.updateData([
                                "token": fcmToken
                                ])
                        }
                    }

                }
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
         // TODO: If necessary send token to application server.
         // Note: This callback is fired at each app startup and whenever a new token is generated.
     }
    func queryforpaywall() {
                
        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
     
            
            if let slimey = value?["Slimey"] as? String {

                slimeybool = true
                
            } else {
                
                slimeybool = false

            }
            
            if let discountcode = value?["DiscountCode"] as? String {
                
                
            } else {
                
                
            }
        })
        
    }

    // MARK: UISceneSession Lifecycle


}

extension AppDelegate: AppsFlyerLibDelegate{
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
               is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
    //Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        //Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
}

