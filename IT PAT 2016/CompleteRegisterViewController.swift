//
//  RegisterViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/18.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class ChooseNameViewController: UIViewController {

	var currentViewYOffset = 0
	
	let inputContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 12
		return view
	}()
	
	let usernameTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Choose a display name"
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.autocapitalizationType = .none
		return tf
	}()
	
	let submitButton = SubmissionButton(named: "Choose")
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(inputContainerView)
		view.addSubview(submitButton)
		setupInputContainerView()
		setupButtons()
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:))))
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
	
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 && keyboardSize.height > view.frame.height - submitButton.frame.maxY {
				currentViewYOffset = Int(keyboardSize.height) - Int(view.frame.height - submitButton.frame.maxY)
				self.view.frame.origin.y -= CGFloat(currentViewYOffset)
			}
		}
	}
	
	// Undo offset when keyboard is dismissed.
	func keyboardWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0{
			self.view.frame.origin.y += CGFloat(currentViewYOffset)
		}
	}
	
	func setupInputContainerView() {
		// Add and position input objects.
		inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		inputContainerView.widthAnchor.constraint(equalToConstant: 256).isActive = true
		inputContainerView.heightAnchor.constraint(equalToConstant: 47).isActive = true
		
		inputContainerView.addSubview(usernameTextField)
		usernameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
		usernameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
		usernameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1).isActive = true
	}
	
	func setupButtons() {
		// Set up buttons in view.
		submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		submitButton.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
		submitButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20).isActive = true
		submitButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		submitButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor, multiplier: 1).isActive = true
		submitButton.setTitleColor(view.backgroundColor, for: .normal)
		submitButton.addTarget(self, action: #selector(handleSubmitButtonPress), for: .touchUpInside)
	}

	func handleSubmitButtonPress() {
		guard let username = usernameTextField.text, (usernameTextField.text?.characters.count)! > 0 else {
			alertUser(viewController: self, message: "Please enter a valid display name.")
			return
		}
		// Change username
		let changeRequest = uc.currentUser?.profileChangeRequest()
		changeRequest?.displayName = username
		uc.activityIndicator = ActivityIndicator(parentView: self.view)
		uc.activityIndicator?.show(parentView: self.view)
		
		changeRequest?.commitChanges { error in
			if let error = error {
				// An error happened.
				alertUser(viewController: self, message: error.localizedDescription)
				uc.activityIndicator?.hide()
			} else {
				// Profile updated.
				dbc.updateHighScore(newScore: 0)
				uc.activityIndicator?.hide()
				self.performSegue(withIdentifier: "ChooseNameToMenu", sender: self)
			}
		}
	}
}
