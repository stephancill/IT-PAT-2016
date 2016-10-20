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
	
	let playButton: SubmissionButton = {
		let button = SubmissionButton()
		button.setTitle("Play", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 12
		button.backgroundColor = UIColor.white
		return button
	}()
	
	let leaderboardsButton: SubmissionButton = {
		let button = SubmissionButton()
		button.setTitle("Leaderboards", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 12
		button.backgroundColor = UIColor.white
		return button
	}()
	
	let settingsButton: SubmissionButton = {
		let button = SubmissionButton()
		button.setTitle("Settings", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 12
		button.backgroundColor = UIColor.white
		return button
	}()
	
	let logoutButton: SubmissionButton = {
		let button = SubmissionButton()
		button.setTitle("Logout", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 12
		button.backgroundColor = UIColor.white
		return button
	}()
	
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
		setupTitle()
		setupButtons()
    }

	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = true
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
		displayNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(55) * (CGFloat(menuOptions.count)+1) * -1).isActive = true
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
		uc.logout()
		performSegue(withIdentifier: "MainToLogin", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		navigationController?.isNavigationBarHidden = false
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
