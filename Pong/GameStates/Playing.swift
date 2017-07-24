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
            scene?.setupScene()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
    }
    
}
