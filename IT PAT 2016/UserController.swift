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
	var activityIndicator: ActivityIndicator?
	
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
		activityIndicator?.show()
		FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
			if error != nil {
				print("Error: \(error.debugDescription)")
				alertUser(viewController: self.loginViewController!)
				self.activityIndicator?.hide()
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
		activityIndicator?.show()
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
				// Remeber user login cridentials
				uc.currentUser = user
				uc.updateLocalLogin(email: email, password: password)
				self.loginViewController?.performSegue(withIdentifier: "LoginToRegister", sender: self.loginViewController)
			}
		}
	}
	
	/* UI */
	
}


class ActivityIndicator: UIView {
	var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
	var loadingView: UIView = UIView()
	var parentView: UIView?
	
//	override init (frame : CGRect) {
//		super.init(frame : frame)
//	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("This class does not support NSCoding")
	}
	
	init (parentView: UIView){
		super.init(frame: CGRect.zero)
		self.parentView = parentView
	}
	
	func show() {
		DispatchQueue.main.async {
			self.loadingView = UIView()
			self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
			self.loadingView.center = (self.parentView?.center)!
			//		loadingView.backgroundColor = UIColor(rgba: "#444444")
			self.loadingView.backgroundColor = UIColor.lightGray
			self.loadingView.alpha = 0.7
			self.loadingView.clipsToBounds = true
			self.loadingView.layer.cornerRadius = 10
			
			self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
			self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
			self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
			
			self.loadingView.addSubview(self.spinner)
			self.parentView?.addSubview(self.loadingView)
			self.spinner.startAnimating()
		}
	}
	
	func hide() {
		DispatchQueue.main.async {
			self.spinner.stopAnimating()
			self.loadingView.removeFromSuperview()
		}
	}
}

