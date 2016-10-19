//
//  RegisterViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/18.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

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
	
	let submitButton: UIButton  = {
		let button = UIButton()
		button.backgroundColor = UIColor(red: 122/255, green: 137/255, blue: 194/255, alpha: 1)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 12
		button.setTitle("Register", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		return button
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(inputContainerView)
		view.addSubview(submitButton)
		setupInputContainerView()
		setupButtons()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setupInputContainerView() {
		inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
		inputContainerView.heightAnchor.constraint(equalToConstant: 47).isActive = true
		
		inputContainerView.addSubview(usernameTextField)
		usernameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
		usernameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
		usernameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1).isActive = true
	}
	
	func setupButtons() {
		submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		submitButton.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
		submitButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20).isActive = true
		submitButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		submitButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor, multiplier: 1).isActive = true
		submitButton.addTarget(self, action: #selector(handleSubmitButtonPress), for: .touchUpInside)
	}

	func handleSubmitButtonPress() {
		guard let username = usernameTextField.text, (usernameTextField.text?.characters.count)! > 0 else {
			alertUser(viewController: self, message: "Please enter a valid display name.")
			return
		}
		let changeRequest = currentUser?.profileChangeRequest()
		changeRequest?.displayName = username
		changeRequest?.commitChanges { error in
			if let error = error {
				// An error happened.
				alertUser(viewController: self, message: error.localizedDescription)
			} else {
				// Profile updated.
				self.performSegue(withIdentifier: "RegisterToMenu", sender: self)
			}
		}
	}
}
