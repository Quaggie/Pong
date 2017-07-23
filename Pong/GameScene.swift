//
//  GameScene.swift
//  Pong
//
//  Created by Jonathan Bijos on 21/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: Properties
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    lazy var border: SKPhysicsBody = {
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.restitution = 1.0
        border.friction = 0
        border.categoryBitMask = Categories.border
        return border
    }()
    
    lazy var player: SKSpriteNode = {
        let player = SKSpriteNode()
        player.position = CGPoint(x: self.frame.width / 2, y: self.frame.origin.y + 20)
        player.size = CGSize(width: 70, height: 10)
        player.color = .white
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.restitution = 0
        player.physicsBody?.friction = 0
        player.physicsBody?.categoryBitMask = Categories.paddle
        return player
    }()
    
    lazy var enemy: SKSpriteNode = {
        let enemy = SKSpriteNode()
        enemy.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 20)
        enemy.size = CGSize(width: 70, height: 10)
        enemy.color = .white
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.restitution = 0
        enemy.physicsBody?.friction = 0
        enemy.physicsBody?.categoryBitMask = Categories.paddle
        return enemy
    }()
    
    lazy var ball: SKSpriteNode = {
        let texture = SKTexture(imageNamed: "ball.png")
        let ball = SKSpriteNode(texture: texture)
        ball.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        ball.size = CGSize(width: 15, height: 15)
        ball.color = .white
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 7.5)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.friction = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.categoryBitMask = Categories.ball
        ball.physicsBody?.contactTestBitMask = Categories.paddle
        ball.physicsBody?.collisionBitMask = Categories.paddle | Categories.border
        return ball
    }()
    
    // MARK: Lifecycle
    
    override func didMove(to view: SKView) {
        setupSprites()
        setupScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.5))
    }
}

// MARK: Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let touchLocation = touch?.location(in: self) else {
            return
        }
        
        movePlayer(to: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let touchLocation = touch?.location(in: self) else {
            return
        }
        
        movePlayer(to: touchLocation)
    }
}

// MARK: Actions
extension GameScene {
    private func limitSprite(_ sprite: SKSpriteNode, inX x: CGFloat) -> CGFloat {
        var xPos = x
        xPos = max(frame.minX + (sprite.size.width / 2), x)
        xPos = min(frame.maxX - (sprite.size.width / 2), x)
        return xPos
    }
    
    private func movePlayer(to location: CGPoint) {
        let xPosition = limitSprite(player, inX: location.x)
        player.position = CGPoint(x: xPosition, y: player.position.y)
    }
    
    private func moveEnemy(to location: CGPoint) {
        let xPosition = limitSprite(enemy, inX: location.x)
        enemy.position = CGPoint(x: xPosition, y: enemy.position.y)
    }
}


// MARK: Setup
extension GameScene {
    private func setupSprites() {
        addChild(player)
        addChild(enemy)
        addChild(ball)
    }
    
    private func setupScene() {
        physicsBody = border
        ball.physicsBody?.applyImpulse(CGVector(dx: -5, dy: -5))
    }
}











