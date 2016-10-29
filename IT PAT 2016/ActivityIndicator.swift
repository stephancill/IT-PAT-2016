//
//  ActivityIndicator.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/27.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit

class ActivityIndicator: UIView {
	var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
	var loadingView: UIView = UIView()
	var parentView: UIView?
	
	required init(coder aDecoder: NSCoder) {
		fatalError("This class does not support NSCoding")
	}
	
	init (parentView: UIView){
		super.init(frame: CGRect.zero)
		self.parentView = parentView
	}
	
	func show(parentView: UIView) {
		self.parentView = parentView
		DispatchQueue.main.async {
			self.loadingView = UIView()
			self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
			self.loadingView.center = (self.parentView?.center)!
			self.loadingView.backgroundColor = UIColor.lightGray
			self.loadingView.alpha = 0.7
			self.loadingView.clipsToBounds = true
			self.loadingView.layer.cornerRadius = 10
			
			self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
			self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
			self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
			
			self.loadingView.addSubview(self.spinner)
			self.parentView?.addSubview(self.loadingView)
			self.spinner.startAnimating()
		}
	}
	
	func hide() {
		DispatchQueue.main.async {
			self.spinner.stopAnimating()
			self.loadingView.removeFromSuperview()
		}
	}
}
