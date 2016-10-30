//
//  LetterBlockArray.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/30.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class LetterBlockArray: UIView {

	var letterBlocks: [LetterBlockArrayElement]
	var letterBlocksCount: Int
	var width: CGFloat
	var parentCenterXAnchor: NSLayoutXAxisAnchor
	var parentCenterYAnchor: NSLayoutYAxisAnchor
	
	init(letterBlocks: Int, width: CGFloat, parentCenterXAnchor: NSLayoutXAxisAnchor, parentCenterYAnchor: NSLayoutYAxisAnchor) {
		self.letterBlocks = []
		self.letterBlocksCount = letterBlocks
		self.width = width
		self.parentCenterXAnchor = parentCenterXAnchor
		self.parentCenterYAnchor = parentCenterYAnchor
		super.init(frame: CGRect.zero)
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func clear() {
		for block in letterBlocks {
			block.textField.text = ""
		}
	}
	
	func setup() {
		self.letterBlocks.append(LetterBlockArrayElement(width: round((width-CGFloat(letterBlocksCount+1*10))/CGFloat(letterBlocksCount)), leftMargin: self.leftAnchor, parentYAnchor: self.centerYAnchor))
		self.letterBlocks[0].first = true
		self.addSubview(self.letterBlocks[0])
		
		
		for i in 1...letterBlocksCount-1 {
			self.letterBlocks.append(LetterBlockArrayElement(width: round((width-CGFloat(letterBlocksCount+1*10))/CGFloat(letterBlocksCount))))
			self.letterBlocks[i-1].following = self.letterBlocks[i]
			self.letterBlocks[i].previous = self.letterBlocks[i-1]
			self.addSubview(self.letterBlocks[i])
			self.letterBlocks[i-1].setupView()
		}
		
		self.letterBlocks[letterBlocksCount-1].last = true
		self.letterBlocks[letterBlocksCount-1].setupView()
	}

}
