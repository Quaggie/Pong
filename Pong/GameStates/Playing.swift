//
//  Playing.swift
//  Pong
//
//  Created by Jonathan Bijos on 23/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    weak var scene: GameScene?
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is AFK {
            scene?.adjustBasedOnDifficulty()
            scene?.setupScene()
            scene?.label.removeFromParent()
        }
    }
  
    override func update(deltaTime seconds: TimeInterval) {
        scene?.adjustEnemyAI()
        scene?.adjustBallVelocity()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
    }
    
}

extension Playing {
    struct Names {
        static let ball = "ball"
        static let enemy = "enemy"
        static let player = "player"
    }
}
