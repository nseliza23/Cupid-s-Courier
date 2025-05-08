//
//  Gifts.swift
//  Cupid's Courier
//
//  Created by nandana on 5/3/25.
//

import SwiftUI
import Foundation
import SpriteKit

class Gift: SKSpriteNode {
    static let textureNames = ["dollar", "cookie", "flower"]
    
    init(type: String, x: CGFloat, y: CGFloat, dropSpeed: CGFloat = 50) {
        guard Gift.textureNames.contains(type) else {
            fatalError("Invalid gift type: \(type)")
        }
        let giftTexture = SKTexture(imageNamed: type)
        super.init(texture: giftTexture, color: .white, size: giftTexture.size())
        
        position = CGPoint(x: x, y: y)
        name = type.capitalized      // “Flower”, “Cookie”, “Money”
        
        let fullSize = giftTexture.size()
        let halfHeight = fullSize.height * 0.5
        let body = SKPhysicsBody(rectangleOf: CGSize(width: fullSize.width, height: halfHeight),
                   center: CGPoint(x: 0, y: -halfHeight/2))
        body.affectedByGravity = false
        body.velocity = CGVector(dx: 0, dy: -dropSpeed)
        body.linearDamping = 0
        body.categoryBitMask = PhysicsCategory.gift
        body.contactTestBitMask = PhysicsCategory.bottom | PhysicsCategory.player
        body.collisionBitMask = 0
        body.usesPreciseCollisionDetection = true
        physicsBody = body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
