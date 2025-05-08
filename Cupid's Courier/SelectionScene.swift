//
//  SelectionView.swift
//  Cupid's Courier
//
//  Created by nandana on 4/29/25.
//

import SwiftUI
import SpriteKit
import Foundation

class SelectionScene: SKScene {
    var playGameAction: ((_ giftType: String, _ level: Level) -> Void)? // change to navigate to Game with playerA, playerB, Gift
    var playerAType: PlayerA.AvatarType!
    var playerBType: PlayerB.AvatarType!
    var playerName: String!
    var receiverName: String!
    
    private let giftTypes = Gift.textureNames
    private let levels = Level.allCases
    
    enum Level: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    private var giftNodes: [SKSpriteNode] = []
    private var levelNodes: [SKLabelNode] = []
    private var selectedGiftIndex: Int? { didSet {
        updateGiftHighlight()
    }}
    private var selectedLevelIndex: Int? { didSet {
        updateLevelHighlight()
    }}
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        let bg = Background(imageNamed: "bg_pines", rows: 6, columns: 3)
        addChild(bg)
        
        let giftPrompt = SKLabelNode(fontNamed: "Helvetica-Bold")
        giftPrompt.text = "What do you wanna gift today?"
        giftPrompt.fontSize = 30
        giftPrompt.fontColor = .white
        giftPrompt.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        giftPrompt.numberOfLines = 2
        giftPrompt.preferredMaxLayoutWidth = size.width * 0.8
        giftPrompt.horizontalAlignmentMode = .center
        addChild(giftPrompt)
        
        let giftY = size.height * 0.70
        let giftCount = giftTypes.count
        let spacing = size.width / CGFloat(giftCount + 1)
        for (i, type) in giftTypes.enumerated() {
            let node = SKSpriteNode(imageNamed: type)
            node.name = "gift_\(i)"
            node.size = CGSize(width: 70, height: 80)
            node.position = CGPoint(x: spacing * CGFloat(i+1), y: giftY)
            addChild(node)
            giftNodes.append(node)
        }
        
        let levelPrompt = SKLabelNode(fontNamed: "Helvetica-Bold")
        levelPrompt.text = "Choose a level"
        levelPrompt.fontSize = 30
        levelPrompt.fontColor = .white
        levelPrompt.position = CGPoint(x: size.width/2, y: size.height * 0.55)
         levelPrompt.numberOfLines = 1
        levelPrompt.preferredMaxLayoutWidth = size.width * 0.8
        levelPrompt.horizontalAlignmentMode = .center
        addChild(levelPrompt)
        
        let levelY = size.height * 0.45
        let levelCount = levels.count
        let levelSpacing = size.width / CGFloat(levelCount + 1)
        let buttonSize = CGSize(width: 90, height: 45)

        for (i, level) in levels.enumerated() {
            let levelButton = SKShapeNode(rectOf: buttonSize, cornerRadius: 10)
            levelButton.name = "level_\(i)"
            levelButton.fillColor = UIColor(white: 0.2, alpha: 0.6)
            levelButton.strokeColor = .black
            levelButton.position  = CGPoint(x: levelSpacing * CGFloat(i+1), y: levelY)
            addChild(levelButton)
            
            let label = SKLabelNode(fontNamed: "Helvetica")
            label.name = "level_\(i)"
            label.text = level.rawValue
            label.fontSize = 20
            label.fontColor = .lightGray
            label.position = CGPoint(x: 0, y: -4) //CGPoint(x: levelSpacing * CGFloat(i+1), y: levelY)
            levelButton.addChild(label)
            levelNodes.append(label)
        }
        
        let playButton = SKShapeNode(rectOf: CGSize(width: 120, height: 70), cornerRadius: 20)
        playButton.strokeColor = .clear
        playButton.fillColor = UIColor(red: 15 / 255, green: 134 / 255, blue: 143 / 255, alpha: 1)
        // startButton.colorBlendFactor = 1
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.30)
        playButton.name = "PlayButton"
        // startButton.shadowed()
        addChild(playButton)
        
        let label = SKLabelNode(text: "Play")
        label.fontColor = .white
        label.fontName = "AvenirNext-Bold"
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.name = "PlayButton"
        label.shadowed()
        playButton.addChild(label)
    }
    
    private func updateGiftHighlight() {
        for (i, node) in giftNodes.enumerated() {
            node.setScale(i == selectedGiftIndex ? 1.5 : 1.0) // increase size when selected
        }
    }

    private func updateLevelHighlight() {
        for (i, label) in levelNodes.enumerated() {
            label.fontColor = (i == selectedLevelIndex ? .white : .lightGray)
            label.fontSize  = (i == selectedLevelIndex ? 24 : 20)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self)
        else {
            print("touchesBegan no first touch")
            return
        }
        let tapped = nodes(at: loc)
        
        for node in tapped {
            guard let name = node.name
            else {
                continue
            }
            
            if name.starts(with: "gift_") {
                let idx = Int(name.replacingOccurrences(of: "gift_", with: ""))!
                selectedGiftIndex = idx
                return
            }
            
            if name.starts(with: "level_") {
                let idx = Int(name.replacingOccurrences(of: "level_", with: ""))!
                selectedLevelIndex = idx
            }
            
            if name == "PlayButton",
                let giftIndex = selectedGiftIndex,
                let levelIndex = selectedLevelIndex
                {
                    let giftType = giftTypes[giftIndex]
                    let level = levels[levelIndex]
                    
                let gameScene = Game(size: self.size, playerAType: self.playerAType, playerBType: self.playerBType, selectedGiftType: giftType, level: level, playerName: playerName, receiverName: receiverName)
                gameScene.scaleMode = .aspectFill
                
                let transition = SKTransition.crossFade(withDuration: 0.5)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
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


//#Preview {
//    SelectionView()
//}
