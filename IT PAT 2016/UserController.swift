//
//  UserController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/19.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//
import UIKit
import Firebase

class UserController {
	var currentUser: FIRUser?
	var loginViewController: UIViewController?
	
	func logout() {
		try! FIRAuth.auth()?.signOut()
		print("logged out")
		updateLocalLogin(email: nil, password: nil)
	}
	
	func updateLocalLogin(email: String?, password: String?) {
		UserDefaults.standard.set(email, forKey: "currentUserEmail")
		UserDefaults.standard.set(password, forKey: "currentUserPassword")
	}
	
	func handleLogin(email: String, password: String) {
		FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
			if error != nil {
				print("Error: \(error.debugDescription)")
				alertUser(viewController: self.loginViewController!)
			} else {
				self.currentUser = user
				if self.currentUser?.displayName == nil {
					// Continue registration if necessary
					self.loginViewController?.performSegue(withIdentifier: "LoginToRegister", sender: self.loginViewController)
				} else {
					// Remeber user login cridentials
					self.updateLocalLogin(email: email, password: password)
					// Take user to main menu
					self.loginViewController?.performSegue(withIdentifier: "LoginToMenu", sender: self.loginViewController)
				}
			}
		}
		
	}
	
	func handleRegister(email: String, password: String) {
		FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
			if error != nil {
				if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
					switch errCode {
					case .errorCodeEmailAlreadyInUse:
						alertUser(viewController: self.loginViewController!, message: "Email already in use.")
					default:
						alertUser(viewController: self.loginViewController!)
						
					}
				}
			} else {
				// Remeber user login cridentials
				uc.currentUser = user
				uc.updateLocalLogin(email: email, password: password)
				self.loginViewController?.performSegue(withIdentifier: "LoginToRegister", sender: self.loginViewController)
			}
		}
	}
}

