//
//  AppDelegate.swift
//  Health Cube
//
//  Created by Mustafa Yusuf on 28/10/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		FirebaseApp.configure()
		
		if #available(iOS 10.0, *) {
			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: {_, _ in })
			
			// For iOS 10 display notification (sent via APNS)
			UNUserNotificationCenter.current().delegate = self
			// For iOS 10 data message (sent via FCM)
			// FIRMessaging.messaging().remoteMessageDelegate = self
			
		} else {
			let settings: UIUserNotificationSettings =
				UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		
		application.registerForRemoteNotifications()
		
		return true
	}
	
	func tokenRefreshNotification(_ notification: Notification) {
		if let _ = InstanceID.instanceID().token() {
			//			print("InstanceID token: \(refreshedToken)")
		}
		
		// Connect to FCM since connection may have failed when attempted before having a token.
		connectToFcm()
	}
	
	func connectToFcm() {
		// Won't connect since there is no token
		guard InstanceID.instanceID().token() != nil else {
			return;
		}
		
		// Disconnect previous FCM connection if it exists.
		Messaging.messaging().disconnect()
		
		Messaging.messaging().connect { (error) in
			if error != nil {
				print("Unable to connect with FCM. \(String(describing: error))")
			} else {
				print("Connected to FCM.")
			}
		}
	}
	
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
		InstanceID.instanceID().setAPNSToken(deviceToken as Data, type: InstanceIDAPNSTokenType.sandbox)
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		Messaging.messaging().disconnect()
		print("Disconnected from FCM.")
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
		// If you are receiving a notification message while your app is in the background,
		// this callback will not be fired till the user taps on the notification launching the application.
		// TODO: Handle data of notification
		
		// Print message ID.
		if let _ = userInfo["gcmMessageIDKey"] {
			//			print("Message ID: \(messageID)")
		}
		
		// Print full message.
		//		print(userInfo)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		// If you are receiving a notification message while your app is in the background,
		// this callback will not be fired till the user taps on the notification launching the application.
		// TODO: Handle data of notification
		
		// Print message ID.
		if let _ = userInfo["gcmMessageIDKey"] {
			//			print("Message ID: \(messageID)")
		}
		
		// Print full message.
		//		print(userInfo)
		
		completionHandler(UIBackgroundFetchResult.newData)
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		// Let FCM know about the message for analytics etc.
		Messaging.messaging().appDidReceiveMessage(userInfo)
		// handle your message
	}


	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

