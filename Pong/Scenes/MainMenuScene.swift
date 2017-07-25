//
//  MainMenuScene.swift
//  Pong
//
//  Created by Jonathan Bijos on 25/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    // MARK: Properties
    
    struct Names {
        static let menu = "menu"
    }
    
    private lazy var menu: SKSpriteNode = {
        let menu = SKSpriteNode()
        menu.name = MainMenuScene.Names.menu
        menu.color = SKColor.lightGray
        menu.size = CGSize(width: 300, height: 300)
        menu.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        menu.zPosition = 100
        return menu
    }()
    
    // MARK: Lifecycle
    
    override func didMove(to view: SKView) {
        setupMenu()
    }
}

// MARK: Touches
extension MainMenuScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
                return
        }
        let touchLocation = touch.location(in: self)
        let node = atPoint(touchLocation)
        
        if let name = node.name {
            let scene = GameScene(size: size)
            
            switch name {
            case AFK.Names.easyButton:
                scene.changeDifficulty(to: .easy)
            case AFK.Names.normalButton:
                scene.changeDifficulty(to: .normal)
            case AFK.Names.hardButton:
                scene.changeDifficulty(to: .hard)
            default: break
            }
            
            view?.presentScene(scene, transition: .crossFade(withDuration: 1.0))
        }
    }
}

// MARK: Setup
extension MainMenuScene {
    
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
        addChild(menu)
        
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
}
