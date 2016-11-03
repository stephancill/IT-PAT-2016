//
//  XArray.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/31.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import SpriteKit

class XArray: SKNode {
	/*
	Initialize array of Xs to indicate how many incorrect answers a user has entered
	*/
	
	var nodes: [SKSpriteNode]
	
	init(Xs: Int, spacing: CGFloat) {
		nodes = []
		super.init()
		
		let firstSprite = SKSpriteNode(imageNamed: "incorrect")
		firstSprite.position = CGPoint(x: 0, y: 0)
		nodes.append(firstSprite)
		
		for i in 0...Xs {
			let sprite = SKSpriteNode(imageNamed: "incorrect")
			sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			sprite.position = CGPoint(x: nodes[i].position.x+spacing*2, y: 0)
			nodes.append(sprite)
		}
		
		for node in nodes {
			node.isHidden = true
			node.setScale(0.05)
			addChild(node)
		}
	}
	
	func displayNext() {
		for node in nodes {
			if node.isHidden {
				node.isHidden = false
				break
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
