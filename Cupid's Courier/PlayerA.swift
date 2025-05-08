//
//  PlayerA.swift
//  Cupid's Courier
//
//  Created by nandana on 5/3/25.
//

import SwiftUI
import Foundation
import SpriteKit

class PlayerA: SKSpriteNode {
    
    enum AvatarType: String, CaseIterable {
        case femaleJump = "female_jump"
        case adventurerCheer = "adventurer_cheer1"
        case playerAction = "player_action1"
//        case femaleHurt = "female_hurt"
//        case adventurerHurt = "adventurer_hurt"
//        case playerHurt = "player_hurt"
    }
    
    
    convenience init() {
            self.init(avatarType: .femaleJump)
    }
    
    init(avatarType: AvatarType) {
        let playerATexture = SKTexture(imageNamed: avatarType.rawValue)
        super.init(texture: playerATexture, color: .white, size: playerATexture.size())

        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.gift
        physicsBody?.collisionBitMask = 0
        self.setScale(1.5)

        name = "PlayerA"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jump () {
        guard let physics = physicsBody, !physics.affectedByGravity
        else {
            return
        }

        physics.affectedByGravity = true
        physics.applyImpulse(CGVector(dx: 0, dy: 100))

        let resetGravity = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run {
                physics.affectedByGravity = false
                physics.velocity.dy = 0
            }
        ])
        run(resetGravity)
    }
}

//extension PlayerA.AvatarType {
//    var hurtVersion: PlayerA.AvatarType {
//        switch self {
//        case .femaleJump: return .femaleHurt
//        case .adventurerCheer: return .adventurerHurt
//        case .playerAction: return .playerHurt
//        case .femaleHurt, .adventurerHurt, .playerHurt:
//            return self
//        }
//    }
//}
