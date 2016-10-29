//
//  DatabaseController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/28.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import FirebaseDatabase

class DatabaseController {

	var ref: FIRDatabaseReference?
	
	func configure() {
		ref = FIRDatabase.database().reference()
	}
	
	func update(key: String, value: String, for uid: String) {
		if uc.emailVerified {
			ref?.child("users").child(uid).setValue([key: value])
		}
	}

}
