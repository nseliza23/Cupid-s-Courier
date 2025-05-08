//
//  PlayerB.swift
//  Cupid's Courier
//
//  Created by nandana on 5/3/25.
//

import SwiftUI
import Foundation
import SpriteKit

class PlayerB: SKSpriteNode {
    enum AvatarType: String, CaseIterable {
            case skid = "player_skid"
            case swim = "adventurer_swim2"
            case femaleWalk = "female_walk1"
//            case playerHurt = "player_hurt"
//            case adventurerHurt = "adventurer_hurt"
//            case femaleHurt = "female_hurt"
        }

        convenience init() {
            self.init(avatarType: .skid)
        }

        init(avatarType: AvatarType) {
            let playerBTexture = SKTexture(imageNamed: avatarType.rawValue)
            super.init(texture: playerBTexture, color: .white, size: playerBTexture.size())

            name = "PlayerB"
        }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension PlayerB.AvatarType {
//    var hurtVersion: PlayerB.AvatarType {
//        switch self {
//        case .skid: return .playerHurt
//        case .swim: return .adventurerHurt
//        case .femaleWalk: return .femaleHurt
//        case .femaleHurt, .adventurerHurt, .playerHurt:
//            return self
//        }
//    }
//}
