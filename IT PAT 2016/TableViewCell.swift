//
//  TableViewCell.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/11/01.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

	/*
	Simple subclass of UITableViewCell that contains a UILabel
	*/
	
    @IBOutlet var textField: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setupCell(text: String) {
		textField.text = text
	}

}
