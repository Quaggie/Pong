//
//  GameMode.swift
//  Pong
//
//  Created by Jonathan Bijos on 23/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import SpriteKit
import GameplayKit

struct GameMode {
    let difficulty: Difficulty
    
    var state: GKStateMachine
    
    enum Difficulty {
        case easy
        case normal
        case hard
    }
    
    init(difficulty: Difficulty, states: [GKState]) {
        self.difficulty = difficulty
        self.state = GKStateMachine(states: states)
    }
}
