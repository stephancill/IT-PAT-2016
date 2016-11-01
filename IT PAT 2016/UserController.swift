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
	var loginViewController: LoginViewController?
	var activityIndicator: ActivityIndicator?
	var emailVerified: Bool = false
	
	func logout() {
		/*
		Logout current user
		*/
		try! FIRAuth.auth()?.signOut()
		print(currentUser?.email)
		updateLocalLogin(email: nil, password: nil)
	}
	
	func updateLocalLogin(email: String?, password: String?, verified: String?="NO"){
		/*
		Save user cridentials locally
		*/
		UserDefaults.standard.set(email, forKey: "currentUserEmail")
		UserDefaults.standard.set(password, forKey: "currentUserPassword")
		UserDefaults.standard.set(verified, forKey: "currentUserVerified")
	}
	
	func handleLogin(email: String, password: String, sendEmail: Bool?=true) {
		/*
		Log user in, move to next view
		*/
		
		activityIndicator?.show(parentView: (loginViewController?.view)!)
		FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
			if error != nil {
				print("Error: \(error.debugDescription)")
				alertUser(viewController: self.loginViewController!)
				self.activityIndicator?.hide()
				self.loginViewController?.emailTextField.text = UserDefaults.standard.string(forKey: "currentUserEmail")
				self.updateLocalLogin(email: "", password: "")
			} else {
				self.currentUser = user
				if self.currentUser?.displayName == nil {
					// Continue registration if necessary
					self.loginViewController?.performSegue(withIdentifier: "LoginToRegister", sender: self.loginViewController)
				} else {
					if !(user?.isEmailVerified)! {
						self.loginViewController?.emailTextField.text = UserDefaults.standard.string(forKey: "currentUserEmail")
						// Send verification email again
						if sendEmail! {
							self.handleSendEmailVerification(user: user!, email: email, password: password)
						}
						self.activityIndicator?.hide()
					} else {
						self.emailVerified = true
						// Remeber user login cridentials
						self.updateLocalLogin(email: email, password: password, verified: "YES")
						// Take user to main menu
						self.loginViewController?.performSegue(withIdentifier: "LoginToMenu", sender: self.loginViewController)
					}
				}
			}
		}
		
	}
	
	func handleRegister(email: String, password: String) {
		/*
		Handle user register, go to next screen
		*/
		
		activityIndicator?.show(parentView: (loginViewController?.view)!)
		FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
			if error != nil {
				if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
					switch errCode {
					case .errorCodeEmailAlreadyInUse:
						alertUser(viewController: self.loginViewController!, message: "Email already in use.")
					default:
						alertUser(viewController: self.loginViewController!)
					}
					self.activityIndicator?.hide()
				}
			} else {
				uc.currentUser = user
				// Send verification email
				self.handleSendEmailVerification(user: user!, nextSegueIdentifier: "LoginToRegister", email: email, password: password)
			}
		}
	}
	
	func handleSendEmailVerification(user: FIRUser, nextSegueIdentifier: String?=nil, email: String, password: String) {
		/*
		Send verification email and notify user
		*/
		user.sendEmailVerification() { error in
			if error != nil {
				// An error happened.
				alertUser(viewController: self.loginViewController!)
			} else {
				// Create an AlertController to notify the user of confirmation email
				let alertController: UIAlertController = {
					let alert: UIAlertController = UIAlertController(
						title: "Verify your email address",
						message: "Please follow the link in the email sent to \((self.currentUser?.email)!). ",
						preferredStyle: .alert
					)
					alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {	(alertAction: UIAlertAction!) in
							// Remeber user login cridentials
							self.updateLocalLogin(email: email, password: password, verified: "NO")
							// Take user to main menu
							if nextSegueIdentifier != nil {
								// Has the user specified a segue?
								self.loginViewController?.performSegue(
									withIdentifier: nextSegueIdentifier!,
									sender: self.loginViewController)
							}
					}))
					return alert
				}()
				self.loginViewController?.present(alertController, animated: true, completion: nil)
			}
		}
	}
}

