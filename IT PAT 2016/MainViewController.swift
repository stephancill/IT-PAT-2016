//
//  MainViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/18.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//		let tmp = navigationItem.backBarButtonItem
//		navigationItem.backBarButtonItem = nil
//		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(getter: tmp?.action))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = true
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
