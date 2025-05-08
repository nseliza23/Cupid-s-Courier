//
//  Game.swift
//  Cupid's Courier
//
//  Created by nandana on 4/30/25.
//

import Foundation
import SpriteKit
import SwiftUI

enum GameTouchState {
    case nothing
    case movingLeft
    case movingRight
    case jumping
}

struct PhysicsCategory {
    static let gift: UInt32 = 1 << 0  // 0b001
    static let bottom: UInt32 = 1 << 1  // 0b010
    static let player: UInt32 = 1 << 2  // 0b100
}

class Game: SKScene, SKPhysicsContactDelegate {
    var score = 0 {
        didSet {
            scoreNode.text = "\(score)"
        }
    }
    var scoreNode: SKLabelNode!
    var playerA: PlayerA!
    var touchState = GameTouchState.nothing
    private let selectedGiftType: String // gift that user selected
    private let level: SelectionScene.Level
    private let playerAType: PlayerA.AvatarType // avatar that user selected
    private let playerBType: PlayerB.AvatarType
    private let playerName: String
    private let receiverName: String
    
    init(size: CGSize, playerAType: PlayerA.AvatarType, playerBType: PlayerB.AvatarType, selectedGiftType: String, level: SelectionScene.Level, playerName: String, receiverName: String)
        {
            self.playerAType = playerAType
            self.playerBType = playerBType
            self.selectedGiftType = selectedGiftType
            self.level = level
            self.playerName = playerName
            self.receiverName = receiverName
            super.init(size: size)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        physicsWorld.contactDelegate = self
        
        let bg = Background(imageNamed: "bg_tree", rows: 6, columns: 3)
        addChild(bg)
        
        makeButtons()
        makeScoreNode()
        makeLowerBounds()
        
        playerA = PlayerA(avatarType: playerAType)
        playerA.position = CGPoint(x: frame.midX, y: 50)
        addChild(playerA)
        
        let playerConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0, upperLimit: frame.width))
        playerA.constraints = [playerConstraint]
        
        let spawnInterval: TimeInterval
        let spawnRange: TimeInterval
        
        switch level {
            case .easy:
                spawnInterval = 4.0
                spawnRange = 3.0
            case .medium:
                spawnInterval = 3.0
                spawnRange = 2.0
            case .hard:
                spawnInterval = 2.0
                spawnRange = 1.0
        }

        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: spawnInterval, withRange: spawnRange),
            SKAction.run { [self] in
                let texture = SKTexture(imageNamed: selectedGiftType)
                let halfW = texture.size().width / 2
                let minX = halfW
                let maxX = frame.width - halfW
                let randomX = CGFloat.random(in: minX...maxX)
                let startY  = frame.height + texture.size().height / 2
                
                let dropSpeed: CGFloat
                switch level {
                    case .easy: dropSpeed = 100
                    case .medium: dropSpeed = 200
                    case .hard: dropSpeed = 300
                }
                
                let node = Gift(type: selectedGiftType, x: randomX, y: startY, dropSpeed: dropSpeed)
                addChild(node)
            }
        ])))
    }
    
    func makeButtons() {
        let buttonWidth = frame.width / 3
        let leftButton = SKSpriteNode(color: .clear, size: CGSize(width: buttonWidth, height: 95))
        leftButton.name = "LeftButton"
        leftButton.position = CGPoint(x: buttonWidth / 2, y: 50)
        addChild(leftButton)
        
        let middleButton = SKSpriteNode(color: .clear, size: CGSize(width: buttonWidth, height: 95))
        middleButton.name = "MiddleButton"
        middleButton.position = CGPoint(x: buttonWidth / 2 + buttonWidth, y: 50)
        addChild(middleButton)
        
        let rightButton = SKSpriteNode(color: .clear, size: CGSize(width: buttonWidth, height: 95))
        rightButton.name = "RightButton"
        rightButton.position = CGPoint(x: buttonWidth / 2 + buttonWidth * 2, y: 50)
        addChild(rightButton)
    }
    
    func makeScoreNode() {
        scoreNode = SKLabelNode(fontNamed: "Helvetica")
        scoreNode.fontColor = .white
        scoreNode.fontSize = 35
        scoreNode.horizontalAlignmentMode = .right
        scoreNode.verticalAlignmentMode = .top
        scoreNode.position = CGPoint(x: frame.width - 20, y: frame.height - 18)
        scoreNode.text = "0"
        addChild(scoreNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first else {
            print("touchesBegan no first touch")
            return
        }
        let point = first.location(in: self)
        let nodes = nodes(at: point)
        
        if let firstNode = nodes.first, let firstName = firstNode.name {
            switch firstName {
                case "LeftButton":
                    touchState = .movingLeft
                case "RightButton":
                    touchState = .movingRight
                case "MiddleButton":
                    touchState = .nothing
                default:
                    touchState = .nothing
                }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchState = .nothing
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch touchState {
        case .nothing:
            break
        case .movingLeft:
            playerA.run(SKAction.move(by: CGVector(dx: -1, dy: 0), duration: 0))
        case .movingRight:
            playerA.run(SKAction.move(by: CGVector(dx: 1, dy: 0), duration: 0))
        case .jumping:
            playerA.jump()
        }
    }
    
//    func gameOver() {
//        removeAllActions()
//        isUserInteractionEnabled = false
//        let gameOverLabel = SKLabelNode(fontNamed: "Courier New")
//            gameOverLabel.text = "Game Over"
//            gameOverLabel.fontSize = 48
//            gameOverLabel.fontColor = .red
//            gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
//            addChild(gameOverLabel)
//            
//            // 3) After a short delay, transition or reset
//            let wait = SKAction.wait(forDuration: 2.0)
//        let restart = SKAction.run { [self] in
//            guard let view = self.view else { return }
//
//            let newScene = Game(
//                size: self.size,
//                playerAType: self.playerAType, playerBType: self.playerBType,
//                selectedGiftType: self.selectedGiftType,
//                level: self.level,
//                playerName: self.playerName,
//                receiverName: self.receiverName
//            )
//            newScene.scaleMode = .aspectFill
//
//            let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
//            view.presentScene(newScene, transition: transition)
//        }
//            run(.sequence([wait, restart]))
//    }
    
    func makeLowerBounds() {
        let bottom = SKSpriteNode(color: SKColor.white, size: CGSize(width: frame.width, height: 10))
        bottom.position = CGPoint(x: frame.midX, y: -5)
        bottom.name = "Bottom"
        
        let body = SKPhysicsBody(rectangleOf: bottom.size)
        body.isDynamic = false
        body.contactTestBitMask = PhysicsCategory.gift | PhysicsCategory.player
        body.categoryBitMask = PhysicsCategory.bottom
        body.collisionBitMask = PhysicsCategory.player
        bottom.physicsBody = body
        addChild(bottom)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask

        if (maskA == PhysicsCategory.gift && maskB == PhysicsCategory.player)
         || (maskA == PhysicsCategory.player && maskB == PhysicsCategory.gift)
        {
            let gift = maskA == PhysicsCategory.gift
                      ? contact.bodyA.node as! Gift
                      : contact.bodyB.node as! Gift

            gift.removeFromParent()
            score += 10
        }
        
        else if (maskA == PhysicsCategory.gift && maskB == PhysicsCategory.bottom)
             || (maskA == PhysicsCategory.bottom && maskB == PhysicsCategory.gift)
        {
            let gift = maskA == PhysicsCategory.gift
                      ? contact.bodyA.node as! Gift
                      : contact.bodyB.node as! Gift
            gift.removeFromParent()
//            gameOver()
            let reset = ResetScene(
                size: size,
                playerAvatarType: playerAType,
                receiverAvatarType: playerBType,
                giftType: selectedGiftType,
                level: level,
                finalScore: score,
                playerName: playerName,
                receiverName: receiverName
            )
            reset.scaleMode = .aspectFill
            let t = SKTransition.crossFade(withDuration: 0.5)
            view?.presentScene(reset, transition: t)

//            gift.run(
//              SKAction.sequence([
//                SKAction.wait(forDuration: 1),
//                SKAction.run { [self] in
//                    self.score -= 10
//                },
//                SKAction.removeFromParent()
//              ])
//            )
        }
    }

}

extension CGSize {
    static func * (lhs: CGSize, rhs: Double) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
