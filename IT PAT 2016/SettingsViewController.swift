//
//  SettingsViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/11/01.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

	@IBOutlet var speakingSpeedLabel: UILabel!
	@IBOutlet var startingDifficultyLabel: UILabel!
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var startingDifficultySlider: UISlider!
	@IBOutlet var speakingSpeedSlider: UISlider!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		startingDifficultySlider.value = Float(UserDefaults.standard.integer(forKey: "startingDifficulty"))
		speakingSpeedSlider.value = Float(UserDefaults.standard.float(forKey: "speakingSpeed"))
		speakingSpeedLabel.text = "\(UserDefaults.standard.float(forKey: "speakingSpeed"))"
		startingDifficultyLabel.text = "\(UserDefaults.standard.integer(forKey: "startingDifficulty"))"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func startingDifficultyValueChanged(_ sender: AnyObject) {
		// User defaults
		UserDefaults.standard.set(Int(startingDifficultySlider.value), forKey: "startingDifficulty")
		startingDifficultyLabel.text = "\(Int(startingDifficultySlider.value))"
		print("\(UserDefaults.standard.integer(forKey: "startingDifficulty"))")
	}

	@IBAction func speakingSpeedValueChanged(_ sender: AnyObject) {
		// User defaults
		UserDefaults.standard.set(Float(speakingSpeedSlider.value), forKey: "speakingSpeed")
		speakingSpeedLabel.text = "\(speakingSpeedSlider.value)"
	}

	@IBAction func usernameChangeButtonPressed(_ sender: AnyObject) {
		let changeRequest = uc.currentUser?.profileChangeRequest()
		changeRequest?.displayName = usernameTextField.text
		uc.activityIndicator = ActivityIndicator(parentView: self.view)
		uc.activityIndicator?.show(parentView: self.view)
		dbc.updateHighScore(newScore: 0)
		changeRequest?.commitChanges { error in
			if let error = error {
				// An error happened.
				alertUser(viewController: self, message: error.localizedDescription)
				uc.activityIndicator?.hide()
			} else {
				// Profile updated.
				uc.activityIndicator?.hide()
			}
		}
	}

}
