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
    lazy var gameMode: GameMode = {
        let states: [GKState] = [
            AFK(scene: self),
            Playing(scene: self),
            GameOver(scene: self)
        ]
        return GameMode(difficulty: .normal, states: states)
    }()
    
    var enemyMovementSpeed: TimeInterval = 0.08
    var ballVelocity: CGFloat = 3
    var ballRate: CGFloat = 0
    var ballRelativeVelocity: CGVector {
        let ballVelocity = self.ball.physicsBody?.velocity ?? CGVector()
        return CGVector(dx: self.ballVelocity - ballVelocity.dx, dy: self.ballVelocity - ballVelocity.dy)
    }
    
    lazy var label: SKLabelNode = {
        let label = SKLabelNode()
        label.color = .white
        label.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) + 20)
        label.text = "Pressione para jogar"
        label.zPosition = 50
        return label
    }()
    
    lazy var border: SKPhysicsBody = {
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.restitution = 1.0
        border.friction = 0
        return border
    }()
    
    lazy var playerBorder: SKSpriteNode = {
        let pb = SKSpriteNode()
        pb.size = CGSize(width: self.frame.width, height: 5)
        pb.position = CGPoint(x: self.frame.width / 2, y: 0)
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
        eb.size = CGSize(width: self.frame.width, height: 5)
        eb.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
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
        player.name = Playing.Names.player
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
        enemy.name = Playing.Names.enemy
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
        ball.name = Playing.Names.ball
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
        gameMode.state.enter(AFK.self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        gameMode.state.update(deltaTime: currentTime)
    }
}

// MARK: Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameMode.state.currentState is Playing {
            let touch = touches.first
            guard let touchLocation = touch?.location(in: self) else {
                return
            }
            movePlayer(to: touchLocation)
        }
        
        if let currentState = gameMode.state.currentState as? AFK {
            currentState.didTouch(touches: touches, event: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameMode.state.currentState is Playing {
            let touch = touches.first
            guard let touchLocation = touch?.location(in: self) else {
                return
            }
            
            movePlayer(to: touchLocation)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameMode.state.currentState is GameOver {
            view?.presentScene(MainMenuScene(size: size), transition: .moveIn(with: .up, duration: 0.4))
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
    
    func adjustEnemyAI() {
        let xPosition = limitSprite(enemy, inX: ball.position.x)
        enemy.run(SKAction.moveTo(x: xPosition, duration: enemyMovementSpeed))
    }
    
    func adjustBallVelocity() {
        let ballVelocity = ball.physicsBody?.velocity ?? CGVector()
        let dx = ballVelocity.dx + (ballRelativeVelocity.dx * ballRate)
        let dy = ballVelocity.dy + (ballRelativeVelocity.dy * ballRate)
        ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
    
    func adjustBasedOnDifficulty() {
        switch gameMode.difficulty {
        case .easy:
            ballVelocity = 3
            enemyMovementSpeed = 0.15
        case .normal:
            ballVelocity = 3
            enemyMovementSpeed = 0.08
        case .hard:
            ballVelocity = 4
            enemyMovementSpeed = 0.05
        }
    }
    
    func changeDifficulty(to difficulty: GameMode.Difficulty) {
        gameMode.difficulty = difficulty
    }
    
    func showLabel(title: String) {
        addChild(label)
        label.text = title
    }
    
    func hideLabel() {
        label.removeFromParent()
    }
}


// MARK: Setup
extension GameScene {
    private func setupSprites() {
        addChild(player)
        addChild(enemy)
        addChild(playerBorder)
        addChild(enemyBorder)
        addChild(ball)
        physicsWorld.contactDelegate = self
        physicsBody = border
    }
    
    func setupScene() {
        let dx = randomDouble() > 0.5 ? -ballVelocity : ballVelocity
        let dy = randomDouble() > 0.5 ? -ballVelocity : ballVelocity
        ball.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
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
            gameMode.gameWon = false
            gameMode.state.enter(GameOver.self)
        } else if categories.contains(Categories.enemyBorder) {
            gameMode.gameWon = true
            gameMode.state.enter(GameOver.self)
        }
    }
}











