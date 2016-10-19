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
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		self.setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
	func setup() {
		addTarget(self, action: #selector(buttonDown), for: .touchDown)
		addTarget(self, action: #selector(buttonUp), for: .touchDragExit)
		addTarget(self, action: #selector(buttonDown), for: .touchDragEnter)
	}
	
	func buttonDown() {
		backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
	}
	
	func buttonUp() {
		backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
	}
}

