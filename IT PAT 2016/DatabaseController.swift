//
//  DatabaseController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/28.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import FirebaseDatabase
import UIKit

class DatabaseController {

	var ref: FIRDatabaseReference?
	
	func configure() {
		ref = FIRDatabase.database().reference()
		topScores = getTopScores()
	}
	
	func updateUsername(username: String) {
		/*
		Set username in user tree
		*/
		ref?.child("users/\((uc.currentUser?.uid)!)/username").setValue(username)
	}
	
	func updateHighScore(newScore: Int) {
		/*
		Set high score for user and in scores tree
		*/
		ref?.child("users/\((uc.currentUser?.uid)!)/highScore").setValue("\(newScore)")
		ref?.child("scores/\((uc.currentUser?.displayName)!)").setValue(newScore)
	}
	
	func getHighScore(update textField: UILabel?=nil) -> String? {
		/*
		Get high score from user tree
		*/
		var highScore: String?
		let userID = uc.currentUser?.uid
		ref?.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			// Get user value
			let value = snapshot.value as? NSDictionary
			print("HELLO \(value?["highScore"] as! String)")
			gc.currentHighScore = Int(value?["highScore"] as! String)!
			highScore = value?["highScore"] as? String
			if (textField != nil) {
				textField?.text = "High score: \(value?["highScore"] as! String)"
			}
			// ...
		  }) { (error) in
			print(error.localizedDescription)
				}
		return highScore
	}
	
	func getTopScores() -> NSDictionary? {
		/*
		Set populate global topScores variable
		*/
		
		var value: NSDictionary?
		let topScoresQuery = ref?.child("scores").queryOrderedByKey()
		topScoresQuery?.observe(.value, with: { (snapshot) in
			value = snapshot.value as? NSDictionary
			topScores = snapshot.value as? NSDictionary
			print("Hello \(value)")
		})
		return value

	}
}
