//
//  GameScene.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/28.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	
	
	let background: SKSpriteNode = {
		let sprite = SKSpriteNode(color: UIColor(red: 77/255, green: 99/255, blue: 179/255, alpha: 1), size: CGSize.zero)
		sprite.anchorPoint = CGPoint(x: 0, y: 0)
		return sprite
	}()
	
	
	override func didMove(to view: SKView) {
		uc.activityIndicator?.show(parentView: self.view!)
		background.size = size
		addChild(background)
	}
	
}
