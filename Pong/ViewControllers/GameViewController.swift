//
//  GameViewController.swift
//  Pong
//
//  Created by Jonathan Bijos on 21/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let isDebug = false
    lazy var skView: SKView = SKView(frame: self.view.frame)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(skView)
        
        let width = skView.frame.width
        let height = skView.frame.height
        let scene = MainMenuScene(size: CGSize(width: width, height: height))
        scene.scaleMode = .aspectFill
        
        skView.ignoresSiblingOrder = true
        
        if isDebug {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
        }
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
