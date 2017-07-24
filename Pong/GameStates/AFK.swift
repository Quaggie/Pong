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
    
    private lazy var menu: SKSpriteNode = {
        let menu = SKSpriteNode()
        menu.name = AFK.Names.menu
        menu.color = SKColor.lightGray
        menu.size = CGSize(width: 300, height: 300)
        menu.position = .zero
        menu.zPosition = 100
        return menu
    }()
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if let scene = scene {
            scene.addChild(menu)
            menu.position = CGPoint(x: scene.frame.width / 2, y: scene.frame.height / 2)
            setupMenu()
        }
    }
    
    override func willExit(to nextState: GKState) {
        menu.removeFromParent()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
    
    private func menuButton(name: String) -> SKSpriteNode {
        let btn = SKSpriteNode()
        btn.name = name
        btn.color = .darkText
        btn.size = CGSize(width: 280, height: 90)
        btn.zPosition = 110
        btn.alpha = 0.2
        return btn
    }
        
    private func buttonLabel(title: String) -> SKLabelNode {
        let label = SKLabelNode(text: title)
        label.fontColor = SKColor.white
        label.fontSize = 40
        label.zPosition = 150
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        return label
    }
    
    private func setupMenu() {
        let spacing: CGFloat = 7.5
        let btnEasy = menuButton(name: AFK.Names.easyButton)
        let btnNormal = menuButton(name: AFK.Names.normalButton)
        let btnHard = menuButton(name: AFK.Names.hardButton)
        
        menu.addChild(btnEasy)
        menu.addChild(btnNormal)
        menu.addChild(btnHard)
        
        let labelEasy = buttonLabel(title: "Fácil")
        labelEasy.name = AFK.Names.easyButton
        let labelNormal = buttonLabel(title: "Normal")
        labelNormal.name = AFK.Names.normalButton
        let labelHard = buttonLabel(title: "Difícil")
        labelHard.name = AFK.Names.hardButton
        
        menu.addChild(labelEasy)
        menu.addChild(labelNormal)
        menu.addChild(labelHard)
        
        btnEasy.position = CGPoint(x: 0, y: btnEasy.size.height + spacing)
        btnNormal.position = .zero
        btnHard.position = CGPoint(x: 0, y: -btnHard.size.height - spacing)
        
        labelEasy.position = btnEasy.position
        labelNormal.position = btnNormal.position
        labelHard.position = btnHard.position
    }
    
    override func didTouch(touches: Set<UITouch>, event: UIEvent?) {
        super.didTouch(touches: touches, event: event)
        
        guard let scene = scene,
            let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: scene)
        let node = scene.atPoint(touchLocation)
        
        if let name = node.name {
            switch name {
            case AFK.Names.easyButton:
                scene.changeDifficulty(to: .easy)
                scene.gameMode.state.enter(Playing.self)
            case AFK.Names.normalButton:
                scene.changeDifficulty(to: .normal)
                scene.gameMode.state.enter(Playing.self)
            case AFK.Names.hardButton:
                scene.changeDifficulty(to: .hard)
                scene.gameMode.state.enter(Playing.self)
            default: break
            }
        }
    }
}

extension AFK {
    struct Names {
        static let menu = "menu"
        static let easyButton = "easyButton"
        static let normalButton = "normalButton"
        static let hardButton = "hardButton"
    }
}

