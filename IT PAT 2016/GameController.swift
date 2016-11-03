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
	var gameViewController: GameViewController?
	let difficulties: [Int] = [0, 4347, 12844, 27910, 48462, 74896, 103729, 131653, 155426, 174263, 188140, 197291, 202876, 206099, 207837, 208652, 209069, 209263, 209344, 209384, 209400]
	var difficultyCorrect: [Int:Int]
	var dictionary: [String]?
	var lookup: HNKLookup? = nil
	
	var currentWord: String = ""
	var currentDifficulty: Int = UserDefaults.standard.integer(forKey: "startingDifficulty")
	var currentScore: Int = 0
	var levelCorrect: Int = 0
	var gameIncorrect: Int = 0
	var maxIncorrect: Int = 5
	
	var currentHighScore: Int = 0
	
	init() {
		difficultyCorrect = [0:15, 4347:15, 12844:10, 27910:5, 48462:5, 74896:5, 103729:5, 131653:5, 155426:5, 174263:5, 188140:5, 197291:5, 202876:5, 206099:5, 207837:4, 208652:4, 209069:4, 209263:4, 209344:3, 209384:2, 209400:1]
	}
	
	func reset() {
		
		if currentScore > currentHighScore {
			// Update high score in database
			dbc.updateHighScore(newScore: currentScore)
		}
		
		currentWord = ""
		currentDifficulty = UserDefaults.standard.integer(forKey: "startingDifficulty")
		currentScore = 0
		levelCorrect = 0
		gameIncorrect = 0
		maxIncorrect = 5
	}
	
	func configure() {
		loadWords()
		lookup = HNKLookup.sharedInstance(withAPIKey: "43bd1e6a57d3a24bbc0050fa39b03086f7db8aab75af73002")
	}
	
	func loadWords() {
		/*
		Load words from file into array
		*/
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
		gameViewController?.scene?.inputContainerView?.clear()
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
			currentWord = (dictionary?[(dictionary?.index(after: random))!])!
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
			targetWord = word!
		}
		lookup?.definitions(forWord: targetWord, completion: { (definitions: [Any]?, error) in
			if (error != nil) {
				print(error.debugDescription)
				alertUser(viewController: self.gameViewController!, message: "An error has occurred. Please check your internet connection.")
				
			} else {
				if (definitions?.count)! > 0 && !("\(definitions)".contains("Definition: See")) {
					self.sayCurrentWord()
					result = "\(("\((definitions!.first)!)".components(separatedBy: ";").first?.replacingOccurrences(of: targetWord, with: "[word]"))!)"
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
		let utterance = AVSpeechUtterance(string: currentWord)
		utterance.rate = UserDefaults.standard.float(forKey: "speakingSpeed")
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
			answerCorrect()
		} else if text.characters.count >= currentWord.characters.count {
			// Incorrect
			gameViewController?.scene?.animateBackground(to: #colorLiteral(red: 0.7995337248, green: 0.2348510623, blue: 0.3945492506, alpha: 1) )
			levelCorrect = 0
			gameIncorrect += 1
			gameViewController?.scene?.xArray.displayNext()
			updateScore(with: -(currentDifficulty+4)*10)
			if gameIncorrect >= maxIncorrect {
				gameViewController?.scene?.gameOver()
			}else {
				pickNewWord(difficulty: currentDifficulty)
			}
			
		}
	}
	
	func clue() {
		/*
		Fill in an incorrect/incomplete letter
		*/
		var text = gameViewController?.scene?.inputContainerView?.text()
		if (text?.characters.count)! < currentDifficulty+4 {
			// Replace empty spaces with _
			for _ in 0...currentDifficulty+4-(text?.characters.count)! {
				text = "\(text!)_"
			}
		}
		for i in 0...currentWord.characters.count-1 {
			let cwl = currentWord[currentWord.index(currentWord.startIndex, offsetBy: i)]
			let tl = text?[(text?.index((text?.startIndex)!, offsetBy: i))!]
			if ("\(cwl)" != "\(tl!)") {
				gameViewController?.scene?.inputContainerView?.letterBlocks[(gameViewController?.scene?.inputContainerView?.letterBlocks.index(i, offsetBy: 0))!].textField.text = "\(cwl)"
				break
			}
		}
		updateScore(with: -5)
		if gameViewController?.scene?.inputContainerView?.text().characters.count == currentDifficulty+4 {
			checkAnswer()
		}
	}
	
	func stepDifficulty(by int: Int) {
		/*
		Change difficulty
		*/
		if currentDifficulty < difficulties.count {
			levelCorrect = 0
			currentDifficulty += int
			gameViewController?.scene?.difficultyLabel.text = "Difficulty: \(currentDifficulty)"
			gameViewController?.scene?.inputContainerView?.updateBlockCount(with: currentDifficulty+4)
		}
	}
	
	private func answerCorrect() {
		/*
		Actions to take when answer is correct
		*/
		levelCorrect += 1
		if levelCorrect >= difficultyCorrect[difficulties[currentDifficulty]]! {
			stepDifficulty(by: 1)
		}
		
		gameViewController?.scene?.animateCorrectAnswer()
		gameViewController?.scene?.animateBackground(to: #colorLiteral(red: 0.328330636, green: 0.693198204, blue: 0.3570930958, alpha: 1) )
		for block in (gameViewController?.scene?.inputContainerView?.letterBlocks)! {
			block.textField.text = ""
		}
		gameViewController?.view.endEditing(true)
		let _ = gameViewController?.scene?.inputContainerView?.letterBlocks[0].textField.becomeFirstResponder()
		updateScore(with: (currentDifficulty+4)*20)
		pickNewWord(difficulty: currentDifficulty)
	}
	
	private func updateScore(with points: Int) {
		/*
		Run score change animations and update variable
		*/
		currentScore += points
		if points > 0 {
			// Green animation
			gameViewController?.scene?.animateScoreChange(new: currentScore, with: #colorLiteral(red: 0.328330636, green: 0.693198204, blue: 0.3570930958, alpha: 1))
		} else {
			// Red animation
			gameViewController?.scene?.animateScoreChange(new: currentScore, with: #colorLiteral(red: 0.7995337248, green: 0.2348510623, blue: 0.3945492506, alpha: 1), wait: false)
		}
	}
}
