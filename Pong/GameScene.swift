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
    var gameOver = false
    
    var ballVelocity: CGFloat = 5
    var ballRate: CGFloat = 0
    lazy var ballRelativeVelocity: CGVector = {
        let ballVelocity = self.ball.physicsBody?.velocity ?? CGVector()
        return CGVector(dx: self.ballVelocity - ballVelocity.dx, dy: self.ballVelocity - ballVelocity.dy)
    }()
    
    lazy var border: SKPhysicsBody = {
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.restitution = 1.0
        border.friction = 0
        return border
    }()
    
    lazy var playerBorder: SKSpriteNode = {
        let pb = SKSpriteNode()
        pb.size = CGSize(width: self.frame.width, height: 2)
        pb.position = CGPoint(x: self.frame.width / 2, y: 0)
        pb.color = .red
        pb.physicsBody = SKPhysicsBody(rectangleOf: pb.size)
        pb.physicsBody?.affectedByGravity = false
        pb.physicsBody?.allowsRotation = false
        pb.physicsBody?.isDynamic = false
        pb.physicsBody?.categoryBitMask = Categories.playerBorder
        pb.physicsBody?.restitution = 0
        pb.physicsBody?.friction = 0
        pb.physicsBody?.angularDamping = 0
        pb.physicsBody?.linearDamping = 0
        return pb
    }()
    
    lazy var enemyBorder: SKSpriteNode = {
        let eb = SKSpriteNode()
        eb.size = CGSize(width: self.frame.width, height: 2)
        eb.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        eb.color = .red
        eb.physicsBody = SKPhysicsBody(rectangleOf: eb.size)
        eb.physicsBody?.affectedByGravity = false
        eb.physicsBody?.allowsRotation = false
        eb.physicsBody?.isDynamic = false
        eb.physicsBody?.categoryBitMask = Categories.enemyBorder
        eb.physicsBody?.restitution = 0
        eb.physicsBody?.friction = 0
        eb.physicsBody?.linearDamping = 0
        eb.physicsBody?.angularDamping = 0
        return eb
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
        ball.physicsBody?.contactTestBitMask = Categories.playerBorder | Categories.enemyBorder
        return ball
    }()
    
    // MARK: Lifecycle
    
    override func didMove(to view: SKView) {
        setupSprites()
        setupScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameOver {
            return
        }
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        adjustEnemyAI()
        adjustBallVelocity()
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver {
            view?.presentScene(GameScene(size: size), transition: SKTransition.crossFade(withDuration: 1.0))
            gameOver = false
        }
    }
}

// MARK: Actions
extension GameScene {
    private func limitSprite(_ sprite: SKSpriteNode, inX x: CGFloat) -> CGFloat {
        var xPos = x
        xPos = max(frame.minX + (sprite.size.width / 2), xPos)
        xPos = min(frame.maxX - (sprite.size.width / 2), xPos)
        return xPos
    }
    
    private func movePlayer(to location: CGPoint) {
        let xPosition = limitSprite(player, inX: location.x)
        player.position = CGPoint(x: xPosition, y: player.position.y)
    }
    
    private func adjustEnemyAI() {
        let xPosition = limitSprite(enemy, inX: ball.position.x)
        enemy.run(SKAction.moveTo(x: xPosition, duration: 0.25))
    }
    
    private func adjustBallVelocity() {
        let ballVelocity = ball.physicsBody?.velocity ?? CGVector()
        let dx = ballVelocity.dx + (ballRelativeVelocity.dx * ballRate)
        let dy = ballVelocity.dy + (ballRelativeVelocity.dy * ballRate)
        ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
}


// MARK: Setup
extension GameScene {
    private func setupSprites() {
        addChild(player)
        addChild(enemy)
        addChild(ball)
        addChild(playerBorder)
        addChild(enemyBorder)
    }
    
    private func setupScene() {
        physicsWorld.contactDelegate = self
        physicsBody = border
        ball.physicsBody?.applyImpulse(CGVector(dx: -ballVelocity, dy: -ballVelocity))
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        let categories = [bodyA.categoryBitMask, bodyB.categoryBitMask]
        
        // Change gamescene
        if categories.contains(Categories.playerBorder) {
            let label = SKLabelNode()
            label.position = CGPoint(x: size.width / 2, y: size.height / 2)
            label.color = .white
            addChild(label)
            ball.removeFromParent()
            enemy.removeAllActions()
            label.text = "You lose!"
            gameOver = true
        } else if categories.contains(Categories.enemyBorder) {
            let label = SKLabelNode()
            label.position = CGPoint(x: size.width / 2, y: size.height / 2)
            label.color = .white
            addChild(label)
            ball.removeFromParent()
            enemy.removeAllActions()
            label.text = "You Win!"
            gameOver = true
        }
    }
}











