//
//  AFK.swift
//  Pong
//
//  Created by Jonathan Bijos on 23/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import SpriteKit
import GameplayKit

class AFK: CustomGKState {
    weak var scene: GameScene?
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene?.showLabel(title: "Pressione para jogar")
    }
    
    override func willExit(to nextState: GKState) {
        scene?.hideLabel()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
    
    override func didTouch(touches: Set<UITouch>, event: UIEvent?) {
        super.didTouch(touches: touches, event: event)
        
        guard let scene = scene else {
            return
        }
        
        scene.gameMode.state.enter(Playing.self)
    }
}

extension AFK {
    struct Names {
        static let easyButton = "easyButton"
        static let normalButton = "normalButton"
        static let hardButton = "hardButton"
    }
}

