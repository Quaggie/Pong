//
//  Categories.swift
//  Pong
//
//  Created by Jonathan Bijos on 23/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import Foundation

struct Categories {
    static let paddle: UInt32 = 0x1 << 1
    static let ball: UInt32 = 0x1 << 2
    static let playerBorder: UInt32 = 0x1 << 3
    static let enemyBorder: UInt32 = 0x1 << 4
}
