//
//  Background.swift
//  Cupid's Courier
//
//  Created by nandana on 5/3/25.
//

import Foundation
import SpriteKit

class Background: SKNode {
    
    init(imageNamed: String, rows: Int, columns: Int) {
        super.init()
        
        let bgTexture = SKTexture(imageNamed: imageNamed)
        let textureSize = bgTexture.size()
        
        let tHeight = textureSize.height /// 2.0
        let tWidth = textureSize.width /// 2.0
        
        var y = -(CGFloat(rows) - 1) * tHeight * 0.5
        for _ in 0..<rows {
            var x = -(CGFloat(columns) - 1) * tWidth * 0.5
            for _ in 0..<columns {
                let node = SKSpriteNode(texture: bgTexture)
                node.name = "Background"
                node.zPosition = -1000
                node.position = CGPoint(x: x, y: y)
                addChild(node)
                x += tWidth
            }
            y += tHeight
        }
    }
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}
