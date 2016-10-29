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
	let difficulties: [Int] = [0, 1634, 6904, 17135, 34842, 58709, 88700, 121101, 151979, 177992, 198454, 213393, 223158, 229083, 232460, 234273, 235115, 235543, 235741, 235823, 235864, 235881]
	var dictionary: [String]?
	var lookup: HNKLookup? = nil
	
	var currentWord: String? = nil
	var currentDifficulty: Int = 0
	
	
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
			let difficultyIndex = difficulties[difficulties.index(after: targetDifficulty)]
			let difficultyRange = difficulties[difficulties.index(after: targetDifficulty+1)] - difficulties[difficulties.index(after: targetDifficulty)]
			let random = difficultyIndex + Int(arc4random_uniform(UInt32((difficultyRange))))
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
		let speechSynthesizer = AVSpeechSynthesizer()
		let utterance = AVSpeechUtterance(string: currentWord!)
		utterance.rate = 0.4
		utterance.voice = AVSpeechSynthesisVoice(language: "en-ZA")
		speechSynthesizer.speak(utterance)
	}
	
	func checkAnswer(text: String) {
		print("\(currentWord) - \(text)")
		if (text == currentWord) {
			gameViewController?.scene?.answerTextField.text = ""
			pickNewWord()
		} else if text.characters.count >= (currentWord?.characters.count)! {
			gameViewController?.scene?.answerTextField.text = ""
		}
	}
}
