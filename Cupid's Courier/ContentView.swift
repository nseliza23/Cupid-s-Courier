//
//  ContentView.swift
//  Cupid's Courier
//
//  Created by nandana on 4/29/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var currentScene: SKScene = {
        let welcome = WelcomeScene(size: UIScreen.main.bounds.size)
        welcome.scaleMode = .aspectFill
        return welcome
    }()
    
    var body: some View {
        SpriteView(scene: currentScene)
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .statusBarHidden(true)
            .onAppear {
                BGM.shared.play("bgm.mp3", volume: 0.3)
            }
//            .onAppear {
//                if let welcome = currentScene as? WelcomeScene {
//                    welcome.startAction = {
//                        let gameScene = Game(size: UIScreen.main.bounds.size)
//                        gameScene.scaleMode = .aspectFill
//                        self.currentScene = gameScene
//                    }
//                }
//            }
    }
}


#Preview {
    ContentView()
}
