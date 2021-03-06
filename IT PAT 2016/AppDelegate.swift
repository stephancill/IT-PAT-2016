//
//  AppDelegate.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/17.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import HNKWordLookup

let uc = UserController()
let dbc = DatabaseController()
let gc = GameController()
var topScores: NSDictionary?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FIRApp.configure()
		dbc.configure()
		gc.configure()
		
		if (UserDefaults.standard.object(forKey: "speakingSpeed") == nil){
			UserDefaults.standard.set(0.4, forKey: "speakingSpeed")
		}
		
		if (UserDefaults.standard.object(forKey: "startingDifficulty") == nil){
			UserDefaults.standard.set(1, forKey: "startingDifficulty")
		}
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

// Set up alert controller
let defaultAlertMessage = "Something isn't quite right, try again."

let alertController: UIAlertController = {
	let alert: UIAlertController = UIAlertController(title: "Oops...", message: defaultAlertMessage, preferredStyle: .alert)
	alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {(alertAction: UIAlertAction!) in
		resetAlertMessage()
	}))
	return alert
}()

func alertUser(viewController: UIViewController, message: String?=alertController.message!) {
	alertController.message = message
	viewController.present(alertController, animated: true, completion: nil)
}
func resetAlertMessage() {
	alertController.message = defaultAlertMessage
}

