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
	
	let newWordButton = SubmissionButton(named: "New word")
	let speakButton = SubmissionButton(named: "Speak again")
	
	let background: SKSpriteNode = {
		let sprite = SKSpriteNode(color: UIColor(red: 77/255, green: 99/255, blue: 179/255, alpha: 1), size: CGSize.zero)
		sprite.anchorPoint = CGPoint(x: 0, y: 0)
		return sprite
	}()
	
	override func didMove(to view: SKView) {
		//uc.activityIndicator?.show(parentView: self.view!)
		background.size = size
		
		view.addSubview(definitionLabel)
		definitionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		definitionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		definitionLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		
		view.addSubview(newWordButton)
		newWordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
		newWordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		newWordButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
		newWordButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
		newWordButton.setTitleColor(background.color, for: .normal)
		newWordButton.addTarget(self, action: #selector(newWordButtonPressed), for: .touchUpInside)
		
		view.addSubview(speakButton)
		speakButton.bottomAnchor.constraint(equalTo: newWordButton.topAnchor, constant: -20).isActive = true
		speakButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		speakButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
		speakButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
		speakButton.setTitleColor(background.color, for: .normal)
		speakButton.addTarget(self, action: #selector(speakButtonPressed), for: .touchUpInside)
	
		addChild(background)
		gc.pickNewWord()
	}
	
	func newWordButtonPressed() {
		gc.pickNewWord()
	}
	
	func speakButtonPressed() {
		gc.sayCurrentWord()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { print(t.location(in: self)) }
	}
	
	
}
