//
//  SubmissionButton.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/19.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class SubmissionButton: UIButton {
	/*
	Subclass of UIButton with standard application style
	*/

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		self.setup()
	}
	
	init(named: String) {
		super.init(frame: CGRect.zero)
		self.setTitle(named, for: .normal)
		self.setup()
	}
	
	func setup() {
		translatesAutoresizingMaskIntoConstraints = false
		layer.cornerRadius = 12
		backgroundColor = UIColor.white
		
		addTarget(self, action: #selector(buttonDown), for: .touchDown)
		addTarget(self, action: #selector(buttonUp), for: .touchDragExit)
		addTarget(self, action: #selector(buttonDown), for: .touchDragEnter)
		addTarget(self, action: #selector(buttonUp), for: .touchUpInside)
	}
	
	func buttonDown() {
		backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
	}
	
	func buttonUp() {
		backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
	}
}

