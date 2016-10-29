//
//  GameViewController.swift
//  IT PAT 2016
//
//  Created by Stephan Cilliers on 2016/10/28.
//  Copyright © 2016 Stephan Cilliers. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	
	var scene: GameScene?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = false
		
		if let view = self.view as! SKView? {
			// Load the SKScene from 'GameScene.sks'
			scene = GameScene()
			// Set the scale mode to scale to fit the window
			scene?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
			scene?.scaleMode = .fill
			// Present the scene
			view.presentScene(scene)
			
			view.ignoresSiblingOrder = true
			
			view.showsFPS = true
			view.showsNodeCount = true
		}
		gc.gameViewController = self
	}
	
	override var shouldAutorotate: Bool {
		return true
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .landscape
		} else {
			return .landscape
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
