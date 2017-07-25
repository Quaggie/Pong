//
//  GameOver.swift
//  Pong
//
//  Created by Jonathan Bijos on 23/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: CustomGKState {
    weak var scene: GameScene?
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene?.ball.removeFromParent()
        scene?.enemy.removeAllActions()
        if let gameWon = scene?.gameMode.gameWon {
            if gameWon {
                scene?.showLabel(title: "Você ganhou!")
            } else {
                scene?.showLabel(title: "Você perdeu!")
            }
        }
    }
    
    override func willExit(to nextState: GKState) {
        scene?.hideLabel()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is AFK.Type
    }
}

