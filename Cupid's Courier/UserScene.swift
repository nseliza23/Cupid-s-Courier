//
//  UserView.swift
//  Cupid's Courier
//
//  Created by nandana on 4/29/25.
//

import SwiftUI
import SpriteKit

// change to SKScene
// make avatars bigger when selected
// change user name input text box or find alternative in SKScene
// music? - SKAction playSoundFileNamed
// AVPLAyer object for spanning across different scenes

class UserScene: SKScene {
    var nextAction: ((_ playerAType: PlayerA.AvatarType, _ playerBType: PlayerB.AvatarType) -> Void)?
    
    private var playerAvatars: [SKSpriteNode] = []
    private var receiverAvatars: [SKSpriteNode] = []
    private var selectedPlayerIndex: Int?
    private var selectedReceiverIndex: Int?

//    override init(size: CGSize) {
//        super.init(size: size)
//        scaleMode = .resizeFill
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
//        let bg = SKSpriteNode(imageNamed: "bg_simple")
//        bg.zPosition = -1000
//        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        bg.size = size
        let bg = Background(imageNamed: "bg_night", rows: 6, columns: 3)
        addChild(bg)
        
        let playerPrompt = SKLabelNode(fontNamed: "Helvetica-Bold")
        playerPrompt.text = "Hey! I'm Cupid :) \nWhat's your name?"
        playerPrompt.fontSize = 30
        playerPrompt.fontColor = .white
        playerPrompt.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        playerPrompt.numberOfLines = 2
        playerPrompt.preferredMaxLayoutWidth = size.width * 0.8
        addChild(playerPrompt)
        
        let spacing = size.width / CGFloat(PlayerA.AvatarType.allCases.count + 1)
        let playerY = size.height * 0.70
        let receiverY = size.height * 0.30
        let playerLabels = ["Lucy","Jack","Nemo"]
        let receiverLabels = ["Noah","Liam","Emma"]

        // PlayerA avatars
        for (i, avatar) in PlayerA.AvatarType.allCases.enumerated() {
            let node = SKSpriteNode(imageNamed: avatar.rawValue)
            node.name = "playerAvatar_\(i)"
            node.size = CGSize(width: 70, height: 100)
            node.position = CGPoint(x: spacing * CGFloat(i+1), y: playerY)
            addChild(node)
            playerAvatars.append(node)

            let label = SKLabelNode(fontNamed: "Helvetica")
            label.text = playerLabels[i]
            label.fontSize  = 14
            label.fontColor = .white
            label.position  = CGPoint(x: 0, y: -node.size.height/2 - 16)
            node.addChild(label)
        }

        let receiverPrompt = SKLabelNode(fontNamed: "Helvetica-Bold")
        receiverPrompt.text = "I heard you wanna make someone's day better. \nWho is it gonna be today?"
        receiverPrompt.fontSize = 25
        receiverPrompt.fontColor = .white
        receiverPrompt.numberOfLines = 2
        receiverPrompt.position = CGPoint(x: size.width/2, y: size.height * 0.42)
        receiverPrompt.preferredMaxLayoutWidth = size.width * 0.8
        addChild(receiverPrompt)
        
        // PlayerB avatars
        for (i, avatar) in PlayerB.AvatarType.allCases.enumerated() {
            let node = SKSpriteNode(imageNamed: avatar.rawValue)
            node.name = "receiverAvatar_\(i)"
            node.size = CGSize(width: 70, height: 100)
            node.position = CGPoint(x: spacing * CGFloat(i+1), y: receiverY)
            addChild(node)
            receiverAvatars.append(node)

            let label = SKLabelNode(fontNamed: "Helvetica")
            label.text = receiverLabels[i]
            label.fontSize = 14
            label.fontColor = .white
            label.position = CGPoint(x: 0, y: -node.size.height/2 - 16)
            node.addChild(label)
        }
        
        let nextBg = SKShapeNode(circleOfRadius: 25)
        nextBg.name = "nextButton"
        nextBg.fillColor = .red
        nextBg.strokeColor = .clear
        nextBg.position = CGPoint(x: size.width * 0.90, y: size.height * 0.10)
        addChild(nextBg)

        let nextLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        nextLabel.text = ">"
        nextLabel.fontSize = 30
        nextLabel.verticalAlignmentMode = .center
        nextLabel.horizontalAlignmentMode = .center
        nextLabel.fontColor = .white
        nextLabel.name = "nextButton"
        nextBg.addChild(nextLabel)
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
            
            if name.starts(with: "playerAvatar_") {
                let idx = Int(name.replacingOccurrences(of: "playerAvatar_", with: ""))!
                selectPlayer(at: idx)
            }
            else if name.starts(with: "receiverAvatar_") {
                let idx = Int(name.replacingOccurrences(of: "receiverAvatar_", with: ""))!
                selectReceiver(at: idx)
            }
            else if name == "nextButton" {
                guard let p = selectedPlayerIndex,
                     let r = selectedReceiverIndex
                else {
                    return
                }
                let playerLabels = ["Lucy", "Jack", "Nemo"]
                let receiverLabels = ["Noah", "Liam", "Emma"]
                
                let typeA = PlayerA.AvatarType.allCases[p]
                let typeB = PlayerB.AvatarType.allCases[r]
//                nextAction?(typeA, typeB)
                
                let playerName = playerLabels[p]
                let receiverName = receiverLabels[r]
                
                let selectionScene = SelectionScene(size: size)
                selectionScene.playerAType = typeA
                selectionScene.playerBType = typeB
                selectionScene.playerName = playerName
                selectionScene.receiverName = receiverName
                selectionScene.scaleMode = scaleMode
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                view?.presentScene(selectionScene, transition: transition)
            }
        }
    }
    
    private func selectPlayer(at index: Int) {
        selectedPlayerIndex = index
        for (i, node) in playerAvatars.enumerated() {
            node.setScale(i == index ? 1.5 : 1.0) // increase size when selected
        }
    }
    
    private func selectReceiver(at index: Int) {
        selectedReceiverIndex = index
        for (i, node) in receiverAvatars.enumerated() {
            node.setScale(i == index ? 1.5 : 1.0) // increase size when selected
        }
    }
}

//#Preview {
//    UserScene()
//}
