//
//  ResetView.swift
//  Cupid's Courier
//
//  Created by nandana on 4/29/25.
//

import SwiftUI
import SpriteKit
import Foundation

class ResetScene: SKScene {
    let playerAvatarType: PlayerA.AvatarType
    let receiverAvatarType: PlayerB.AvatarType
    let giftType: String
    let level: SelectionScene.Level
    let finalScore: Int
    var originalAType: PlayerA.AvatarType = .femaleJump
    var originalBType: PlayerB.AvatarType = .skid
    private let playerName: String
    private let receiverName: String
    
    init(size: CGSize, playerAvatarType: PlayerA.AvatarType, receiverAvatarType: PlayerB.AvatarType, giftType: String, level: SelectionScene.Level, finalScore: Int, playerName: String, receiverName: String)
    {
        self.playerAvatarType   = playerAvatarType
        self.receiverAvatarType = receiverAvatarType
        self.giftType = giftType
        self.level = level
        self.finalScore = finalScore
        self.playerName = playerName
        self.receiverName = receiverName
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        let bg = Background(imageNamed: "bg_cloud", rows: 6, columns: 3)
        addChild(bg)
//        let playerAName = playerAvatarType.rawValue.capitalized
//        let playerBName = receiverAvatarType.rawValue.capitalized
        
        let title = SKLabelNode(fontNamed: "Helvetica-Bold")
        // title.text = "Good job \(playerName)!"
        title.fontSize = 40
        title.fontColor = .red
        title.numberOfLines = 2
        title.preferredMaxLayoutWidth = size.width * 0.8
        title.position = CGPoint(x: size.width/2, y: size.height * 0.85)
        title.horizontalAlignmentMode = .center
        if finalScore == 0 {
            title.text = "Oh no, \(playerName)!"
        }
        else {
            title.text = "Good job \(playerName)!"
        }
        addChild(title)
        
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        let giftPlural = finalScore == 1 ? giftType : "\(giftType)s"
        // scoreLabel.text = "You gave \(receiverName)\n    \(finalScore) \(giftPlural)! \n \(receiverName) is happy :)"
        scoreLabel.fontSize = 30
        scoreLabel.numberOfLines = 2
        scoreLabel.preferredMaxLayoutWidth = size.width * 0.8
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.70)
        scoreLabel.horizontalAlignmentMode = .center
        if finalScore == 0 {
            scoreLabel.text = """
            You gave \(receiverName)     
               0 \(giftPlural)! 
            \(receiverName) is sad :(
            """
        } else {
            scoreLabel.text = """
            You gave \(receiverName)
               \(finalScore) \(giftPlural)! 
            \(receiverName) is happy :)
            """
        }
        addChild(scoreLabel)
        
        let avatarY = size.height * 0.60
        let giftY   = size.height * 0.45
        let spacing = size.width / 4
        
//        let avatarAType = finalScore == 0 ? playerAvatarType.hurtVersion : playerAvatarType
//        let avatarBType = finalScore == 0 ? receiverAvatarType.hurtVersion : receiverAvatarType
        
        let pA = PlayerA(avatarType: playerAvatarType)
        pA.setScale(1.0)
        pA.position = CGPoint(x: spacing, y: avatarY)
        addChild(pA)
        
        let pALabel = SKLabelNode(text: playerName)
        pALabel.fontName = "Helvetica"
        pALabel.fontSize = 18
        pALabel.fontColor = .white
        pALabel.position = CGPoint(x: 0, y: -pA.size.height/2 - 16)
        pA.addChild(pALabel)
        
        let giftSprite = SKSpriteNode(imageNamed: giftType)
        giftSprite.size = CGSize(width: 80, height: 80)
        giftSprite.position = CGPoint(x: size.width/2, y: giftY)
        addChild(giftSprite)
        
        let giftLabel = SKLabelNode(text: giftType.capitalized + "s")
        giftLabel.fontName = "Helvetica"
        giftLabel.fontSize = 18
        giftLabel.fontColor = .white
        giftLabel.position = CGPoint(x: 0, y: -giftSprite.size.height/2 - 16)
        giftSprite.addChild(giftLabel)
        
        let pB = PlayerB(avatarType: receiverAvatarType)
        pB.setScale(1.0)
        pB.position = CGPoint(x: size.width - spacing, y: avatarY)
        addChild(pB)
        let pBLabel = SKLabelNode(text: receiverName)
        pBLabel.fontName = "Helvetica"
        pBLabel.fontSize = 18
        pBLabel.fontColor = .white
        pBLabel.position = CGPoint(x: 0, y: -pB.size.height/2 - 16)
        pB.addChild(pBLabel)
        


        let buttonSize = CGSize(width: 140, height: 50)
        let baseY: CGFloat = size.height * 0.20
        let verticalSpacing = buttonSize.height + 20

        // 1) Play Again
        let playAgainButton = SKShapeNode(rectOf: buttonSize, cornerRadius: 12)
        playAgainButton.name = "PlayAgain"
        playAgainButton.fillColor = UIColor(red: 248 / 255, green: 202 / 255, blue: 57 / 255, alpha: 1)
        playAgainButton.strokeColor = .clear
        playAgainButton.position = CGPoint(x: size.width/2, y: baseY)
        addChild(playAgainButton)

        let playAgainLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        playAgainLabel.text = "Play Again"
        playAgainLabel.fontSize = 20
        playAgainLabel.fontColor = .white
        playAgainLabel.verticalAlignmentMode = .center
        playAgainLabel.horizontalAlignmentMode = .center
        playAgainLabel.name = "PlayAgain"
        playAgainButton.addChild(playAgainLabel)

        let startOverButton = SKShapeNode(rectOf: buttonSize, cornerRadius: 12)
        startOverButton.name = "StartOver"
        startOverButton.fillColor = UIColor(red: 11 / 255, green: 187 / 255, blue: 231 / 255, alpha: 1)
        startOverButton.strokeColor = .clear
        startOverButton.position = CGPoint(x: size.width/2, y: baseY - verticalSpacing)
        addChild(startOverButton)

        let startOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        startOverLabel.text = "Start Over"
        startOverLabel.fontSize = 20
        startOverLabel.fontColor = .white
        startOverLabel.verticalAlignmentMode = .center
        startOverLabel.horizontalAlignmentMode = .center
        startOverLabel.name = "StartOver"
        startOverButton.addChild(startOverLabel)

        // 3) Exit Game (below Start Over)
        let exitGameButton = SKShapeNode(rectOf: buttonSize, cornerRadius: 12)
        exitGameButton.name = "ExitGame"
        exitGameButton.fillColor = UIColor(red: 214 / 255, green: 45 / 255, blue: 0 / 255, alpha: 1)
        exitGameButton.strokeColor = .clear
        exitGameButton.position = CGPoint(x: size.width/2, y: baseY - verticalSpacing * 2)
        addChild(exitGameButton)

        let exitGameLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        exitGameLabel.text = "Exit Game"
        exitGameLabel.fontSize = 20
        exitGameLabel.fontColor = .white
        exitGameLabel.verticalAlignmentMode = .center
        exitGameLabel.horizontalAlignmentMode = .center
        exitGameLabel.name = "ExitGame"
        exitGameButton.addChild(exitGameLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
                let tapped = nodes(at: loc)

        for node in tapped {
            guard let name = node.name else { continue }
            
            if name == "PlayAgain" {
                // Restart same Game
                let game = Game(
                    size: size,
                    playerAType: playerAvatarType, playerBType: receiverAvatarType,
                    selectedGiftType: giftType,
                    level: level,
                    playerName: playerName,
                    receiverName: receiverName
                )
                game.scaleMode = .aspectFill
                let t = SKTransition.crossFade(withDuration: 0.5)
                view?.presentScene(game, transition: t)
            }
            else if name == "StartOver" {
                // Back to UserScene
                let user = UserScene(size: size)
                user.scaleMode = .aspectFill
                let t = SKTransition.flipHorizontal(withDuration: 0.5)
                view?.presentScene(user, transition: t)
            }
            else if name == "ExitGame" {
                let welcome = WelcomeScene(size: size)
                welcome.scaleMode = .aspectFill
                let t = SKTransition.crossFade(withDuration: 0.5)
                view?.presentScene(welcome, transition: t)
            }
        }
    }
}

//#Preview {
//    ResetView()
//}
