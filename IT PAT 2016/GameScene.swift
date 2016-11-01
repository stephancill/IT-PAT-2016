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
	
	let helpButton = SubmissionButton(named: "Help")
	
	let scoreLabel: SKLabelNode = {
		let label = SKLabelNode(fontNamed: "ComicSansMS")
		label.text = "0"
		label.fontSize = 30
		label.verticalAlignmentMode = .center
		return label
	}()
	
	let difficultyLabel: SKLabelNode = {
		let label = SKLabelNode(fontNamed: "ComicSansMS")
		label.text = "Difficulty: 0"
		label.fontSize = 15
		return label
	}()
	
	let xArray = XArray(Xs: 5, spacing: 10)
	
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
	
	var inputContainerView: LetterBlockArray? = nil
	
	let speakButton = SubmissionButton(named: "Speak again")
	
	let clueButton = SubmissionButton(named: "?")
	
	let defaultBackgroundColor = UIColor(red: 77/255, green: 99/255, blue: 179/255, alpha: 1)
	
	let background: SKSpriteNode = {
		let sprite = SKSpriteNode(color: UIColor(red: 77/255, green: 99/255, blue: 179/255, alpha: 1), size: CGSize.zero)
		sprite.anchorPoint = CGPoint(x: 0, y: 0)
		return sprite
	}()
	
	override func didMove(to view: SKView) {
		background.size = size
		
		setupUI()
		
		addChild(background)
		gc.stepDifficulty(by: 0)
		gc.pickNewWord(difficulty: gc.currentDifficulty)
	}
	
	override func willMove(from view: SKView) {
		reset()
	}
	
	func newWordButtonPressed() {
		gc.pickNewWord(difficulty: gc.currentDifficulty)
	}
	
	func speakButtonPressed() {
		gc.sayCurrentWord()
	}
	
	func clueButtonPressed() {
		gc.clue()
	}
	
	func textfFieldChanged() {
		print("checking")
	}
	
	func setupUI() {
		
		view?.addSubview(helpButton)
		helpButton.rightAnchor.constraint(equalTo: (view?.rightAnchor)!, constant: -10).isActive = true
		helpButton.topAnchor.constraint(equalTo: (view?.topAnchor)!, constant: 50).isActive = true
		helpButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
		helpButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
		helpButton.setTitleColor(background.color, for: .normal)
		helpButton.addTarget(self, action: #selector(showHelp), for: .touchUpInside)
		
		scoreLabel.position = CGPoint(x: size.width/2, y: size.height-scoreLabel.frame.size.height-50)
		addChild(scoreLabel)
		
		difficultyLabel.position = CGPoint(x: scoreLabel.position.x, y:scoreLabel.position.y-difficultyLabel.frame.size.height*2)
		difficultyLabel.text = "Difficulty: \(gc.currentDifficulty)"
		addChild(difficultyLabel)
		
		xArray.position = CGPoint(x: 10, y: size.height-(xArray.nodes.first?.size.height)!-75)
		addChild(xArray)
		
		inputContainerView = LetterBlockArray(letterBlocks: gc.currentDifficulty+4, width: CGFloat(256)-CGFloat(((gc.currentDifficulty+4)*10)), parentCenterXAnchor: (view?.centerXAnchor)!, parentCenterYAnchor: (view?.centerYAnchor)!)
		
		view?.addSubview(inputContainerView!)
		inputContainerView!.centerXAnchor.constraint(equalTo: (view?.centerXAnchor)!).isActive = true
		inputContainerView!.centerYAnchor.constraint(equalTo: (view?.centerYAnchor)!).isActive = true
		inputContainerView!.heightAnchor.constraint(equalToConstant: 35).isActive = true
		inputContainerView!.widthAnchor.constraint(equalToConstant: 246).isActive = true
		inputContainerView?.setup()
		
		view?.addSubview(definitionLabel)
		definitionLabel.bottomAnchor.constraint(equalTo: (inputContainerView?.topAnchor)!, constant: -20).isActive = true
		definitionLabel.centerXAnchor.constraint(equalTo: (view?.centerXAnchor)!).isActive = true
		definitionLabel.widthAnchor.constraint(equalTo: (view?.widthAnchor)!).isActive = true
		
		view?.addSubview(speakButton)
		speakButton.topAnchor.constraint(equalTo: (inputContainerView?.bottomAnchor)!, constant: 10).isActive = true
		speakButton.leftAnchor.constraint(equalTo: (inputContainerView?.leftAnchor)!).isActive = true
		speakButton.widthAnchor.constraint(equalTo: (inputContainerView?.widthAnchor)!, multiplier: 60/100).isActive = true
		speakButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
		speakButton.setTitleColor(background.color, for: .normal)
		speakButton.addTarget(self, action: #selector(speakButtonPressed), for: .touchUpInside)
		
		view?.addSubview(newWordButton)
		newWordButton.leftAnchor.constraint(equalTo: speakButton.rightAnchor, constant: 10).isActive = true
		newWordButton.centerYAnchor.constraint(equalTo: speakButton.centerYAnchor).isActive = true
		newWordButton.widthAnchor.constraint(equalTo: (inputContainerView?.widthAnchor)!, multiplier: 30/100).isActive = true
		newWordButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
		newWordButton.setTitleColor(background.color, for: .normal)
		newWordButton.addTarget(self, action: #selector(newWordButtonPressed), for: .touchUpInside)
		
		view?.addSubview(clueButton)
		clueButton.leftAnchor.constraint(equalTo: newWordButton.rightAnchor, constant: 10).isActive = true
		clueButton.centerYAnchor.constraint(equalTo: speakButton.centerYAnchor).isActive = true
		clueButton.heightAnchor.constraint(equalTo: speakButton.heightAnchor).isActive = true
		clueButton.widthAnchor.constraint(equalTo: (inputContainerView?.widthAnchor)!, multiplier: 10/100).isActive = true
		clueButton.setTitleColor(background.color, for: .normal)
		clueButton.addTarget(self, action: #selector(clueButtonPressed), for: .touchUpInside)

		view?.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view?.endEditing(_:))))
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	func animateInputContainerView(to color: UIColor) {
		background.run(SKAction.sequence([
			SKAction.colorize(with: color, colorBlendFactor: 1, duration: 0.5),
			SKAction.colorize(with: defaultBackgroundColor, colorBlendFactor: 1, duration: 0.5)
			]))
	}
	
	func animateCorrectAnswer() {
		let correctAnswerLabel: SKLabelNode = {
			let label = SKLabelNode(fontNamed: "ComicSansMS")
			label.text = gc.currentWord
			label.fontSize = 30
			label.verticalAlignmentMode = .center
			return label
		}()
		correctAnswerLabel.position = scoreLabel.position
		correctAnswerLabel.alpha = 0
		addChild(correctAnswerLabel)
		
		scoreLabel.run(SKAction.sequence([
			SKAction.scale(to: 0, duration: 0.25),
			SKAction.wait(forDuration: 1.5),
			SKAction.scale(to: 1, duration: 0.25)]))
		correctAnswerLabel.run(SKAction.sequence(
			[
				SKAction.fadeAlpha(to: 1, duration: 1),
				SKAction.scale(to: 0, duration: 1.5),
				SKAction.fadeAlpha(to: 0, duration: 0),
				SKAction.scale(to: 1, duration: 0)
			])) {
				correctAnswerLabel.removeFromParent()
		}
	}
	
	func animateScoreChange(new points: Int, with color: UIColor, wait: Bool?=true) {
		var actions = [
			SKAction.customAction(withDuration: 0, actionBlock: { (SKNode) in
				self.scoreLabel.text = "\(points)"
			}),
			SKAction.colorize(with: color, colorBlendFactor: 1, duration: 0.5),
			SKAction.wait(forDuration: 0.1),
			SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.5)
		]
		
		if (wait != nil) {
			if wait! {
				actions.insert(SKAction.wait(forDuration: 1.5), at: 0)
			}
		}
		
		scoreLabel.run(SKAction.sequence(actions))
		
	}
	
	func showHelp() {
		let alertController: UIAlertController = {
			let alert: UIAlertController = UIAlertController(title: "Help", message: "Type out what you hear the voice say. The definition is there to help you. Press ? to fill in a single letter for you or skip the word if you don't know it.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {(alertAction: UIAlertAction!) in
				()
			}))
			return alert
		}()
		gc.gameViewController?.present(alertController, animated: true, completion: nil)
	}
	
	// Offset view to ensure visibility of all buttons/input fields.
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view?.frame.origin.y == 0 && keyboardSize.height > (view?.frame.height)! - speakButton.frame.maxY { //
				currentViewYOffset = Int(keyboardSize.height) - Int((view?.frame.height)! - speakButton.frame.maxY)
				self.view?.frame.origin.y -= CGFloat(currentViewYOffset)
			}
		}
	}
	
	// Undo offset when keyboard is dismissed.
	func keyboardWillHide(notification: NSNotification) {
		if self.view?.frame.origin.y != 0 {
			self.view?.frame.origin.y += CGFloat(currentViewYOffset)
		}
	}
	
	func gameOver() {
		var title = "Game Over"
		if gc.currentScore > gc.currentHighScore {
			title = "New High Score"
		}
		
		let alertController: UIAlertController = {
			let alert: UIAlertController = UIAlertController(title: title, message: "You made it to difficulty \(gc.currentDifficulty) and scored \(gc.currentScore)", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: {(alertAction: UIAlertAction!) in
				
				let _ = gc.gameViewController?.navigationController?.popToRootViewController(animated: true)
			}))
			return alert
		}()
		gc.gameViewController?.present(alertController, animated: true, completion: nil)
		self.reset()
		
		print("HELLO GAME OVER")
		
	}
	
	private func reset() {
		gc.reset()
		for v in (view?.subviews)! {
			v.removeFromSuperview()
		}
		
		for n in children {
			n.removeFromParent()
		}
	}
	
	let defaultAlertMessage = "Something isn't quite right, try again."
	
	
}

