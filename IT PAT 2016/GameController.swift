//
//  GameController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/28.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit
import AVFoundation
import HNKWordLookup
import SpriteKit

class GameController {
	// TODO dictionary, choose random word based on difficulty
	var gameViewController: GameViewController?
	let difficulties: [Int] = [0, 4347, 12844, 27910, 48462, 74896, 103729, 131653, 155426, 174263, 188140, 197291, 202876, 206099, 207837, 208652, 209069, 209263, 209344, 209384, 209400]
	var dictionary: [String]?
	var lookup: HNKLookup? = nil
	
	var currentWord: String? = nil
	var currentDifficulty: Int = 0
	var currentScore: Int = 0
	
	func configure() {
		loadWords()
		lookup = HNKLookup.sharedInstance(withAPIKey: "43bd1e6a57d3a24bbc0050fa39b03086f7db8aab75af73002")
	}
	
	func loadWords() {
		do {
			if let path = Bundle.main.path(forResource: "words", ofType:"txt") {
				dictionary = try String.init(contentsOf: URL(fileURLWithPath: path)).components(separatedBy: "\n")
			}
		} catch {
			print("Could not load words")
		}
	}
	
	func pickNewWord(difficulty: Int?=0) {
		/* 
		Randomly pick a new word from the loaded list of words within the specified difficulty range
		*/
		var targetDifficulty = currentDifficulty
		if (difficulty != nil) {
			targetDifficulty = difficulty!
		}
		if targetDifficulty < difficulties.count - 1 {
			currentDifficulty = difficulty!
			let difficultyIndex = difficulties[difficulties.index(targetDifficulty, offsetBy: 0) ]
			let difficultyRange = difficulties[difficulties.index(targetDifficulty, offsetBy: 1)] - difficulties[difficulties.index(targetDifficulty, offsetBy: 0)]
			let random = difficultyIndex + Int(arc4random_uniform(UInt32((difficultyRange))))
			print("HELLO \(difficultyIndex), \(difficultyRange), \(random)")
			currentWord = dictionary?[(dictionary?.index(after: random))!]
			getDefinition()
		}
		
	}
	
	func getDefinition(for word: String?=nil) {
		/*
		Get the word's definition from wordnik via HNKWordLookup
		*/
		var result: String?
		var targetWord = currentWord
		if (word != nil) {
			targetWord = word
		}
		lookup?.definitions(forWord: targetWord, completion: { (definitions: [Any]?, error) in
			if (error != nil) {
				print(error.debugDescription)
				alertUser(viewController: self.gameViewController!, message: "An error has occurred. Please check your internet connection.")
				
			} else {
				if (definitions?.count)! > 0 && !("\(definitions)".contains("Definition: See")) {
					self.sayCurrentWord()
					result = "\(("\((definitions!.first)!)".components(separatedBy: ";").first?.replacingOccurrences(of: targetWord!, with: "[word]"))!)"
					self.gameViewController?.scene?.definitionLabel.text = result!
					print("HELLO \(self.currentWord): \(result!)")
					
				} else {
					print("HELLO choosing new word")
					self.pickNewWord(difficulty: self.currentDifficulty)
				}
				
			}
		})
	}
	
	func sayCurrentWord() {
		/*
		Speak the current word
		*/
		print(currentWord)
		let speechSynthesizer = AVSpeechSynthesizer()
		let utterance = AVSpeechUtterance(string: currentWord!)
		utterance.rate = 0.4
		utterance.voice = AVSpeechSynthesisVoice(language: "en-ZA")
		speechSynthesizer.speak(utterance)
	}
	
	func checkAnswer() {
		/*
		Check if the users input is correct
		*/
		var text = ""
		for block in (gameViewController?.scene?.inputContainerView?.letterBlocks)! {
			text = "\(text)\(block.textField.text!)"
		}
		print("\(currentWord) - \(text)")
		if (text == currentWord) {
			// Correct
			gameViewController?.scene?.animateInputContainerView(to: #colorLiteral(red: 0.328330636, green: 0.693198204, blue: 0.3570930958, alpha: 1) )
			for block in (gameViewController?.scene?.inputContainerView?.letterBlocks)! {
				block.textField.text = ""
			}
			gameViewController?.view.endEditing(true)
			let _ = gameViewController?.scene?.inputContainerView?.letterBlocks[0].textField.becomeFirstResponder()
			pickNewWord(difficulty: currentDifficulty)
		} else if text.characters.count >= (currentWord?.characters.count)! {
			gameViewController?.scene?.animateInputContainerView(to: #colorLiteral(red: 0.7995337248, green: 0.2348510623, blue: 0.3945492506, alpha: 1) )
		}
	}
	
	func updateScore(with points: Int) {
		
	}
}
