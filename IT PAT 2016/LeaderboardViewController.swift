//
//  LeaderboardViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/11/01.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var dictionary: NSDictionary?
	var titles: [String] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if (topScores != nil) {
			for score in topScores! {
				titles.append("\(score.key) - \(score.value)")
			}
		} else {
			titles.append("No scores recorded")
		}
		
		view.frame.origin.y += (navigationController?.navigationBar.frame.height)!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("Hello \(titles.count)")
		return (titles.count)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Return custom table view cell
		print("HELLO calling")
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
		cell.setupCell(text: titles[indexPath.row%titles.count])
		return cell
	}
	

}
