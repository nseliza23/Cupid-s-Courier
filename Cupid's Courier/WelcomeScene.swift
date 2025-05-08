//
//  WelcomeView.swift
//  Cupid's Courier
//
//  Created by nandana on 4/29/25.
//

import SwiftUI
import SpriteKit
import Foundation


// change everything to SKScene instead of SwiftUI - means change images to SKTexture(imageNamed:) etc.
// follow transition code from latest demo
// follow meteor app code for actual game
// code touchesBegan, didMove, etc in Game.swift


class WelcomeScene: SKScene {
    var startAction: (() -> Void)?
    
    override func didMove(to view: SKView) {
        
        // background stuff
        backgroundColor = .black
        let bg = Background(imageNamed: "bg_cloud", rows: 6, columns: 3)
        addChild(bg)
        
        let gameTitle = SKLabelNode(fontNamed: "Marker Felt")
        gameTitle.text = " Cupid's \n Courier \n  ˚ʚ♡ɞ˚"
        gameTitle.numberOfLines = 3
        gameTitle.fontColor = .white
        gameTitle.fontSize = 80
        gameTitle.verticalAlignmentMode = .center
        gameTitle.horizontalAlignmentMode = .center
        gameTitle.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        gameTitle.shadowed()
        addChild(gameTitle)
        
        let startButton = SKShapeNode(rectOf: CGSize(width: 120, height: 70), cornerRadius: 20)
        startButton.strokeColor = .clear
        startButton.fillColor = UIColor(red: 15 / 255, green: 134 / 255, blue: 143 / 255, alpha: 1)
        // startButton.colorBlendFactor = 1
        startButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        startButton.name = "StartButton"
        // startButton.shadowed()
        addChild(startButton)
        
        let label = SKLabelNode(text: "START")
        label.fontColor = .white
        label.fontName = "AvenirNext-Bold"
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.name = "StartButton"
        label.shadowed()
        startButton.addChild(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let tap = touches.first else {
            print("touchesBegan no first touch")
            return
        }
        let tappedNodes = nodes(at: tap.location(in: self))
        guard tappedNodes.contains(where: {
            $0.name == "StartButton"
        }) else {
            return
        }
        
        let userScene = UserScene(size: UIScreen.main.bounds.size)
        userScene.scaleMode = .aspectFill
        
        let transition = SKTransition.crossFade(withDuration: 0.5)
        self.view?.presentScene(userScene, transition: transition)
    }
}

private extension SKLabelNode {
    func shadowed(offset: CGFloat = 7, color: SKColor = .blue.withAlphaComponent(0.4)) {
        let copy = SKLabelNode(fontNamed: fontName)
        copy.text    = text
        copy.fontSize = fontSize
        copy.numberOfLines = numberOfLines
        copy.horizontalAlignmentMode = horizontalAlignmentMode
        copy.verticalAlignmentMode   = verticalAlignmentMode
        copy.fontColor = color
        copy.position  = CGPoint(x: -offset, y: -offset)
        copy.zPosition = zPosition - 1
        addChild(copy)
    }
}


