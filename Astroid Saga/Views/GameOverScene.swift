//
//  GameOverScene.swift
//  Astroid Saga
//
//  Created by Paul on 2/7/17.
//  Copyright © 2017 Studio4Designsoftware. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let defaults = UserDefaults()
    let background = SKSpriteNode(imageNamed: "background")
    let restartLabel = SKLabelNode(fontNamed: "Helvetica")
    let mainMenuLabel = SKLabelNode(fontNamed: "Helvetica")
        
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "It'sOn.wav")
        backgroundSound.removeFromParent()
        
        if UserDefaults.standard.bool(forKey: "setMusic") {
            
        }else {
            self.addChild(backgroundSound)
        }
        
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 160
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.56)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 75
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.47)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        if score > highScoreNumber {
            highScoreNumber = score
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        let highScoreLabel = SKLabelNode(fontNamed: "Helvetica")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 75
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.42)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 75
        restartLabel.fontColor = SKColor.green
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
        restartLabel.removeFromParent()
        restartLabel.removeFromParent()
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        restartLabel.run(fadeInAction)
        
        let pulseUp = SKAction.scale(to: 1.5, duration: 0.5)
        let pulseDown = SKAction.scale(to: 1, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        restartLabel.run(repeatPulse)
        
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontSize = 75
        mainMenuLabel.fontColor = SKColor.white
        mainMenuLabel.zPosition = 1
        mainMenuLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.33)
        mainMenuLabel.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            } else if background.contains(pointOfTouch) {
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
