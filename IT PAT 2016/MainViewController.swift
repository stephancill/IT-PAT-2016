//
//  MainViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/18.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	let logoutButton: SubmissionButton = {
		let button = SubmissionButton()
		button.setTitle("Logout", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 12
		button.backgroundColor = UIColor.white
		return button
	}()
	
	let displayNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "ComicSansMS", size: 100)
		label.textColor = UIColor.white
		label.text = "[Display Name]"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontSizeToFitWidth = true
		return label
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupButtons()
		setupTitle()
    }

	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = true
	}

	func setupButtons() {
		view.addSubview(logoutButton)
		logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		logoutButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
		logoutButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
		logoutButton.setTitleColor(view.backgroundColor, for: .normal)
		logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
	}
	
	func setupTitle() {
		displayNameLabel.text = uc.currentUser?.displayName
		view.addSubview(displayNameLabel)
		displayNameLabel.leftAnchor.constraint(equalTo: logoutButton.leftAnchor).isActive = true
//		displayNameLabel.bottomAnchor.constraint(equalTo: logoutButton.topAnchor).isActive = true
		displayNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
		displayNameLabel.widthAnchor.constraint(equalTo: logoutButton.widthAnchor).isActive = true
		displayNameLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
	}
	
	func logout() {
		uc.logout()
		performSegue(withIdentifier: "MainToLogin", sender: self)
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
