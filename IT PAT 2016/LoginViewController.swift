//
//  LoginViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/17.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
	
	var currentViewYOffset = 0
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Sample Text"
		label.font = UIFont(name: "ComicSansMS", size: 100)
		label.textColor = UIColor.white
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontSizeToFitWidth = true
		return label
	}()
	
	let actionSegmentController: UISegmentedControl = {
		let segments = ["Login" , "Register"]
		let controller = UISegmentedControl(items: segments)
		controller.selectedSegmentIndex = 0
		controller.translatesAutoresizingMaskIntoConstraints = false
		return controller
	}()
	
	let inputContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 12
		return view
	}()
	
	let emailTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Email"
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.keyboardType = .emailAddress
		tf.autocapitalizationType = .none
		tf.autocorrectionType = .no
		return tf
	}()
	
	let tfSeparatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.lightGray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let passwordTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Password"
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.isSecureTextEntry = true
		return tf
	}()
	
	let submitButton: SubmissionButton  = {
		let button = SubmissionButton()
		button.backgroundColor = UIColor.white
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 12
		button.setTitle("Login", for: .normal)
		return button
	}()
		
    override func viewDidLoad() {
        super.viewDidLoad()
		
		uc.loginViewController = self
		uc.activityIndicator = ActivityIndicator(parentView: self.view)
		uc.emailTextField = emailTextField
		
		if UserDefaults.standard.string(forKey: "currentUserEmail") != nil {
			// User previously logged in.
			let email = UserDefaults.standard.string(forKey: "currentUserEmail")
			let password = UserDefaults.standard.string(forKey: "currentUserPassword")
			uc.handleLogin(email: email!, password: password!, sendEmail: false)
		}
		if UserDefaults.standard.string(forKey: "currentUserVerified") == "NO" {
			// Prepare login screen.
			view.addSubview(titleLabel)
			view.addSubview(inputContainerView)
			view.addSubview(actionSegmentController)
			view.addSubview(submitButton)
			setupInputContainerView()
			setupTitle()
			setupButtons()
			
			view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:))))
			NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
			NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		}
        // Do any additional setup after loading the view.
		
		/*
		TESTING INPUTS
		*/
//		emailTextField.text = "stephanus.cilliers@gmail.com"
//		passwordTextField.text = "example"
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
		view.endEditing(true)
		uc.activityIndicator?.hide()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = true
		view.endEditing(true)
	}
	
	func setupTitle() {
		// Position and size title in view.
		titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		titleLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: actionSegmentController.topAnchor, constant: -20).isActive = true
		titleLabel.heightAnchor.constraint(equalToConstant: 180).isActive = true
	}
	
	func setupInputContainerView() {
		// Add and position input objects.
		inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		inputContainerView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//		inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
		inputContainerView.widthAnchor.constraint(equalToConstant: 265) .isActive = true
		inputContainerView.heightAnchor.constraint(equalToConstant: 94).isActive = true
		
		inputContainerView.addSubview(emailTextField)
		emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
		emailTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
		emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
		
		inputContainerView.addSubview(tfSeparatorView)
		tfSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
		tfSeparatorView.topAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
		tfSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		tfSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
		
		inputContainerView.addSubview(passwordTextField)
		passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
		passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
		passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
		
	}
	
	func setupButtons() {
		// Set up buttons in view.
		actionSegmentController.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
		actionSegmentController.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -20).isActive = true
		actionSegmentController.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		actionSegmentController.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
		actionSegmentController.backgroundColor = view.backgroundColor
		actionSegmentController.tintColor = UIColor.white
		actionSegmentController.addTarget(self, action: #selector(handleSegmentControllerValueChanged), for: .valueChanged)
		
		submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		submitButton.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
		submitButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20).isActive = true
		submitButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		submitButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: 1).isActive = true
		submitButton.setTitleColor(view.backgroundColor, for: .normal)
		submitButton.addTarget(self, action: #selector(handleSubmitButtonPress), for: .touchUpInside)
	}
	
	// Offset view to ensure visibility of all buttons/input fields.
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
	
	func handleSegmentControllerValueChanged() {
		// Update button names to correlate with Segment Controller.
		switch actionSegmentController.selectedSegmentIndex {
		case 0:
			submitButton.setTitle("Login", for: .normal)
		case 1:
			submitButton.setTitle("Register", for: .normal)
		default: break
		}
	}

	func handleSubmitButtonPress() {
		view.endEditing(true)
		
		guard let email = emailTextField.text, let password = passwordTextField.text, (passwordTextField.text?.characters.count)! >= 6, isValidEmail(testStr: email) else {
			//Present the AlertController.
			if !(isValidEmail(testStr: emailTextField.text!)) {
				alertUser(viewController: self, message: "Invalid email.")
				return
				
			}else if (passwordTextField.text?.characters.count)! < 6 {
				alertUser(viewController: self, message: "Password must contain 6 or more characters.")
				return
			}
			return
		}
		
		// Register or login dependent on segment controller.
		switch actionSegmentController.selectedSegmentIndex {
		case 0:
			uc.handleLogin(email: email, password: password)
		case 1:
			uc.handleRegister(email: email, password: password)
		default: break
		}

	}
	
	func isValidEmail(testStr:String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: testStr)
	}
	
	

}

