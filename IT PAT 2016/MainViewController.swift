//
//  MainViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/18.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	let displayNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "ComicSansMS", size: 100)
		label.textColor = UIColor.white
		label.text = "[Display Name]"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontSizeToFitWidth = true
		label.textAlignment = .center
		return label
	}()
	
	let highScoreLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "ComicSansMS", size: 20)
		label.textColor = UIColor.white
		label.text = ""
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		return label
	}()
	
	let playButton = SubmissionButton(named: "Play")
	let leaderboardsButton = SubmissionButton(named: "Leaderboards")
	let settingsButton = SubmissionButton(named: "Settings")
	let logoutButton = SubmissionButton(named: "Logout")
	
	var menuOptions: [SubmissionButton] = []
	var menuOptionsSelectors: [Selector] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		menuOptions = [
			playButton,
			leaderboardsButton,
			settingsButton,
			logoutButton
		]
		menuOptionsSelectors = [
			#selector(playButtonPressed),
			#selector(leaderboardsButtonPressed),
			#selector(settingsButtonPressed),
			#selector(logoutButtonPressed)
		]
		
		
		dbc.updateUsername(username: (uc.currentUser?.displayName)!)
		setupTitle()
		setupButtons()
		if let tmp = dbc.getHighScore(update: highScoreLabel) {
			gc.currentHighScore = Int(tmp)!
		}
		view.addSubview(highScoreLabel)
		highScoreLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor).isActive = true
		highScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		highScoreLabel.widthAnchor.constraint(equalToConstant: 265).isActive = true
		highScoreLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		gc.loadWords()
		
    }

	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = true
		if let tmp = dbc.getHighScore(update: highScoreLabel) {
			gc.currentHighScore = Int(tmp)!
		}
		displayNameLabel.text = uc.currentUser?.displayName
		
		gc.currentDifficulty = UserDefaults.standard.integer(forKey: "startingDifficulty")
	}

	func setupButtons() {
		for button in menuOptions {
			view.addSubview(button)
			if menuOptions.index(of: button) == 0 {
				button.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor).isActive = true
			} else {
				button.topAnchor.constraint(equalTo: menuOptions[(menuOptions.index(of: button))!-1].bottomAnchor, constant: 20).isActive = true
			}
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
			button.widthAnchor.constraint(equalToConstant: 150).isActive = true
			button.heightAnchor.constraint(equalToConstant: 35).isActive = true
			button.setTitleColor(view.backgroundColor, for: .normal)
			button.addTarget(self, action: menuOptionsSelectors[(menuOptions.index(of: button))!], for: .touchUpInside)
		}
	}
	
	func setupTitle() {
		displayNameLabel.text = uc.currentUser?.displayName
		view.addSubview(displayNameLabel)
		displayNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		displayNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: (CGFloat(55) * (CGFloat(menuOptions.count)+1) * -1) / 2).isActive = true
		displayNameLabel.widthAnchor.constraint(equalToConstant: 265).isActive = true
		displayNameLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
	}
	
	func playButtonPressed() {
		performSegue(withIdentifier: "MainToGame", sender: self)
	}
	
	func leaderboardsButtonPressed() {
		performSegue(withIdentifier: "MainToLeaderboards", sender: self)
	}
	
	func settingsButtonPressed() {
		performSegue(withIdentifier: "MainToSettings", sender: self)
	}
	
	func logoutButtonPressed() {
		let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
		
		refreshAlert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction!) in
			uc.logout(); self.performSegue(withIdentifier: "MainToLogin", sender: self);
		}))
		
		refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
			print("")
		}))
		
		present(refreshAlert, animated: true, completion: nil)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		navigationController?.isNavigationBarHidden = false
	}
	

}
