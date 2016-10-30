//
//  LetterBlock.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/30.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class LetterBlockArrayElement: UIView, UITextFieldDelegate {
	
	var previous: LetterBlockArrayElement?
	var following: LetterBlockArrayElement?
	var first: Bool = false
	var last: Bool = false
	
	var leftMargin: NSLayoutAnchor<NSLayoutXAxisAnchor>?
	var parentYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?
	
	var width: CGFloat
	var textField: LetterBlockTextField = LetterBlockTextField()
	
	init(width: CGFloat, leftMargin: NSLayoutAnchor<NSLayoutXAxisAnchor>?=nil, parentYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?=nil) {
		self.width = width
		super.init(frame: CGRect.zero)
		self.leftMargin = leftMargin
		self.parentYAnchor = parentYAnchor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		print("HELLO \(string)")
		let currentCharacterCount = textField.text?.characters.count ?? 0
		if (range.length + range.location > currentCharacterCount){
			return false
		}
		let newLength = currentCharacterCount + string.characters.count - range.length
		return newLength <= 1
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		DispatchQueue.main.async {
			textField.selectAll(nil)
		}
		return true
	}
	
	
	func setupView() {
		
		backgroundColor = UIColor.white
		translatesAutoresizingMaskIntoConstraints = false
		layer.cornerRadius = 12
		if previous == nil {
			first = true
			leftAnchor.constraint(equalTo: leftMargin!).isActive = true
			centerYAnchor.constraint(equalTo: parentYAnchor!).isActive = true
		}
		if following == nil {
			last = true
		}

		if !first {
			leftAnchor.constraint(equalTo: previous!.rightAnchor, constant: 10).isActive = true
			centerYAnchor.constraint(equalTo: (previous?.centerYAnchor)!).isActive = true
		}
		widthAnchor.constraint(equalToConstant: width).isActive = true
		heightAnchor.constraint(equalToConstant: 37).isActive = true
		
		
		
		if !first {
			textField.previous = previous?.textField
		}
		
		textField.placeholder = "."
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.keyboardType = .alphabet
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		textField.returnKeyType = .done
		textField.textAlignment = .center
		textField.isUserInteractionEnabled = true
		textField.delegate = self

		addSubview(textField)
		textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
		textField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		textField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
		
		if last {
			textField.addTarget(self, action: #selector(lastBlockChanged), for: .editingChanged)
		} else {
			textField.addTarget(self, action: #selector(nonLastBlockChanged), for: .editingChanged)
		}
	}
	
	@objc private func nonLastBlockChanged() {
		if (textField.text?.characters.count)! > 0 {
			textField.resignFirstResponder()
			let _ = following?.textField.becomeFirstResponder()
			following?.textField.selectAll(self)
			var text = ""
			for block in (gc.gameViewController?.scene?.inputContainerView?.letterBlocks)! {
				text = "\(text)\(block.textField.text!)"
			}
			if text.characters.count == gc.currentDifficulty + 4 {
				gc.checkAnswer()
			}
			
		}
	}
	
	@objc private func lastBlockChanged() {
		gc.checkAnswer()
	}
}
