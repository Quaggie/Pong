//
//  Utils.swift
//  Pong
//
//  Created by Jonathan Bijos on 23/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import SpriteKit
import GameplayKit

func randomDouble() -> Double {
    return drand48()
}

class CustomGKState: GKState {
    func didTouch(touches: Set<UITouch>, event: UIEvent?) {
        
    }
}
