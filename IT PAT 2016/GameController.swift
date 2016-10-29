//
//  GameController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/28.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class GameController {
	// TODO dictionary, choose random word based on difficulty
	var dictionary: [String]?
	let difficulties: [Int] = [0, 1634, 6904, 17135, 34842, 58709, 88700, 121101, 151979, 177992, 198454, 213393, 223158, 229083, 232460, 234273, 235115, 235543, 235741, 235823, 235864, 235881]
	func loadWords() {
		do {
			if let path = Bundle.main.path(forResource: "words", ofType:"txt") {
				dictionary = try String.init(contentsOf: URL(fileURLWithPath: path)).components(separatedBy: "\n")
				print(dictionary?.count)
			}
		} catch {
			
		}
	}
}
