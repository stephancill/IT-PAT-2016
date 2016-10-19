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
		return button
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = true
	}

	func setupButtons() {
		view.addSubview(logoutButton)
		logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		logoutButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
		logoutButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
		logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
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
