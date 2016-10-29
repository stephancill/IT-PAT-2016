//
//  GameScene.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/28.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
	
	var currentViewYOffset = 0
	
	let definitionLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.font = UIFont(name: "ComicSansMS", size: 15)
		label.textColor = UIColor.white
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	let newWordButton = SubmissionButton(named: "Skip")
	let speakButton = SubmissionButton(named: "Speak again")
	
	let inputContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 12
		return view
	}()
	
	let answerTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Word"
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.keyboardType = .alphabet
		tf.autocapitalizationType = .none
		tf.autocorrectionType = .no
		tf.returnKeyType = .go
		return tf
	}()
	
	let background: SKSpriteNode = {
		let sprite = SKSpriteNode(color: UIColor(red: 77/255, green: 99/255, blue: 179/255, alpha: 1), size: CGSize.zero)
		sprite.anchorPoint = CGPoint(x: 0, y: 0)
		return sprite
	}()
	
	override func didMove(to view: SKView) {
		//uc.activityIndicator?.show(parentView: self.view!)
		background.size = size
		
		setupUI()
		
		addChild(background)
		gc.pickNewWord()
		
		
	}
	
	func newWordButtonPressed() {
		gc.pickNewWord()
	}
	
	func speakButtonPressed() {
		gc.sayCurrentWord()
	}
	
	func textfFieldChanged() {
		print("checking")
		gc.checkAnswer(text: answerTextField.text!)
	}
	// Offset view to ensure visibility of all buttons/input fields.
	func keyboardWillShow(notification: NSNotification) {
		
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			
			if self.view?.frame.origin.y == 0 && keyboardSize.height > (view?.frame.height)! - speakButton.frame.maxY {
				print("called")
				currentViewYOffset = Int(keyboardSize.height) - Int((view?.frame.height)! - speakButton.frame.maxY)
				self.view?.frame.origin.y -= CGFloat(currentViewYOffset)
			}
		}
	}
	
	// Undo offset when keyboard is dismissed.
	func keyboardWillHide(notification: NSNotification) {
		if self.view?.frame.origin.y != 0{
			self.view?.frame.origin.y += CGFloat(currentViewYOffset)
		}
	}
	
	func setupUI() {
		view?.addSubview(definitionLabel)
		definitionLabel.centerYAnchor.constraint(equalTo: (view?.centerYAnchor)!).isActive = true
		definitionLabel.centerXAnchor.constraint(equalTo: (view?.centerXAnchor)!).isActive = true
		definitionLabel.widthAnchor.constraint(equalTo: (view?.widthAnchor)!).isActive = true
		
		view?.addSubview(inputContainerView)
		inputContainerView.centerXAnchor.constraint(equalTo: (view?.centerXAnchor)!, constant: -77/2).isActive = true
		inputContainerView.topAnchor.constraint(equalTo: definitionLabel.bottomAnchor, constant: 20).isActive = true
		inputContainerView.widthAnchor.constraint(equalToConstant: 179).isActive = true
		inputContainerView.heightAnchor.constraint(equalToConstant: 47).isActive = true
		
		inputContainerView.addSubview(answerTextField)
		answerTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
		answerTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
		answerTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		answerTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1).isActive = true
		answerTextField.addTarget(self, action: #selector(textfFieldChanged), for: .editingChanged)
		
		view?.addSubview(newWordButton)
		newWordButton.leftAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: 10).isActive = true
		newWordButton.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
		newWordButton.widthAnchor.constraint(equalToConstant: 67).isActive = true
		newWordButton.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor).isActive = true
		newWordButton.setTitleColor(background.color, for: .normal)
		newWordButton.addTarget(self, action: #selector(newWordButtonPressed), for: .touchUpInside)
		
		view?.addSubview(speakButton)
		speakButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 10).isActive = true
		speakButton.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
		speakButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		speakButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
		speakButton.setTitleColor(background.color, for: .normal)
		speakButton.addTarget(self, action: #selector(speakButtonPressed), for: .touchUpInside)
		
		view?.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view?.endEditing(_:))))
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
}
