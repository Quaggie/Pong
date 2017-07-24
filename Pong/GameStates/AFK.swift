//
//  AFK.swift
//  Pong
//
//  Created by Jonathan Bijos on 23/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import SpriteKit
import GameplayKit

class AFK: GKState {
    weak var scene: GameScene?
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            // Close menu message
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
    
}

