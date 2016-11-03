//
//  LetterBlockTextField.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/30.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class LetterBlockTextField: UITextField {
	/*
	Custom text field that moves to a linked text field when delete is pressed if the text field is empty
	*/
	
	var previous: LetterBlockTextField?
	
	init() {
		super.init(frame: CGRect.zero)
		placeholder = "."
		translatesAutoresizingMaskIntoConstraints = false
		keyboardType = .alphabet
		autocapitalizationType = .none
		autocorrectionType = .no
		returnKeyType = .done
		textAlignment = .center
		isUserInteractionEnabled = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func deleteBackward() {
		// Move to previous text field in array when backspace is pressed
		if (text?.characters.count)! > 0 {
			super.deleteBackward()
		} else {
			if (previous != nil) {
				resignFirstResponder()
				previous?.becomeFirstResponder()
				previous?.selectAll(self)
			}
		}
		
	}
	
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		// Disable popup text tools when text is selected
		return false
	}

	
}
