//
//  MainMenuScene.swift
//  Astroid Saga
//
//  Created by Paul on 2/7/17.
//  Copyright © 2017 Studio4Designsoftware. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

var justOnce:Bool = true

class MainMenuScene: SKScene, GKGameCenterControllerDelegate {
    let startGame = SKLabelNode(fontNamed: "Helvetica")
    let storeLable = SKLabelNode(fontNamed: "Helvetica")
    let cantStartGame = SKLabelNode(fontNamed: "Helvetica")
    
    override func didMove(to view: SKView) {
        /*
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            let vc = self.view!.window!.rootViewController!
            let alert = UIAlertController(title: "Message", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
 */
        
        let backgroundSound = SKAudioNode(fileNamed: "GamersDelight.wav")
        backgroundSound.removeFromParent()
        
        if UserDefaults.standard.bool(forKey: "setMusic") {
            
        }else {
            self.addChild(backgroundSound)
        }
        
        /*
        if lifeNumber == 0 {
            self.addChild(cantStartGame)
            if justOnce {
                let vc = self.view!.window!.rootViewController!
                let alert = UIAlertController(title: "Want to play again?", message: "If you want to level up faster you can get extera lives in the store.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                vc.present(alert, animated: true, completion: nil)
                justOnce = false
            }
        }else {
            self.addChild(startGame)
        }
 */
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameName1 = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameName1.text = "ASTROID"
        gameName1.fontSize = 200
        gameName1.fontColor = SKColor.blue
        gameName1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.82)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameName2.text = "SAGA"
        gameName2.fontSize = 200
        gameName2.fontColor = SKColor.blue
        gameName2.zPosition = 1
        gameName2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.72)
        self.addChild(gameName2)
        
        startGame.text = "Start Game"
        startGame.fontSize = 75
        startGame.fontColor = SKColor.green
        startGame.zPosition = 1
        startGame.position = CGPoint(x: self.size.width/2, y: self.size.height*0.57)
        startGame.name = "startButton"
        self.addChild(startGame)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        startGame.run(fadeInAction)
        
        let pulseUp = SKAction.scale(to: 1.5, duration: 0.5)
        let pulseDown = SKAction.scale(to: 1, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        startGame.run(repeatPulse)
        
        /*
        if lifeNumber == 0 {
            let pulseUp = SKAction.scale(to: 1.5, duration: 0.5)
            let pulseDown = SKAction.scale(to: 1, duration: 0.5)
            let pulse = SKAction.sequence([pulseUp, pulseDown])
            let repeatPulse = SKAction.repeatForever(pulse)
            storeLable.run(repeatPulse)
        }else {
            let pulseUp = SKAction.scale(to: 1.5, duration: 0.5)
            let pulseDown = SKAction.scale(to: 1, duration: 0.5)
            let pulse = SKAction.sequence([pulseUp, pulseDown])
            let repeatPulse = SKAction.repeatForever(pulse)
            startGame.run(repeatPulse)
        }
 */
        
        cantStartGame.text = "No More Lives"
        cantStartGame.fontSize = 75
        cantStartGame.fontColor = SKColor.red
        cantStartGame.zPosition = 1
        cantStartGame.position = CGPoint(x: self.size.width/2, y: self.size.height*0.57)
        cantStartGame.name = "noLifes"
        
        let instructions = SKLabelNode(fontNamed: "Helvetica")
        instructions.text = "Instructions"
        instructions.fontSize = 75
        instructions.fontColor = SKColor.white
        instructions.zPosition = 1
        instructions.position = CGPoint(x: self.size.width/2, y: self.size.height*0.50)
        instructions.name = "instructionsShow"
        self.addChild(instructions)
        
        storeLable.text = "Store"
        storeLable.fontSize = 75
        storeLable.fontColor = SKColor.white
        storeLable.zPosition = 1
        storeLable.position = CGPoint(x: self.size.width/2, y: self.size.height*0.43)
        storeLable.name = "storeShow"
        self.addChild(storeLable)
        
        let creditLable = SKLabelNode(fontNamed: "Helvetica")
        creditLable.text = "Credits"
        creditLable.fontSize = 75
        creditLable.fontColor = SKColor.white
        creditLable.zPosition = 1
        creditLable.position = CGPoint(x: self.size.width/2, y: self.size.height*0.36)
        creditLable.name = "creditsShow"
        self.addChild(creditLable)
        
        let highScoreBtn = SKLabelNode(fontNamed: "Helvetica")
        highScoreBtn.text = "Statistics"
        highScoreBtn.fontSize = 75
        highScoreBtn.fontColor = SKColor.white
        highScoreBtn.zPosition = 1
        highScoreBtn.position = CGPoint(x: self.size.width/2, y: self.size.height*0.29)
        highScoreBtn.name = "pressHighScoreBtn"
        self.addChild(highScoreBtn)
        
        let settingBtn = SKSpriteNode(imageNamed: "gear1")
        settingBtn.setScale(0.8)
        settingBtn.zPosition = 1
        settingBtn.position = CGPoint(x: self.size.width*0.64, y: self.size.height*0.16)
        settingBtn.name = "settingsName"
        self.addChild(settingBtn)
        
        let gCenter = SKSpriteNode(imageNamed: "GCimage")
        gCenter.setScale(0.8)
        gCenter.zPosition = 1
        gCenter.position = CGPoint(x: self.size.width*0.36, y: self.size.height*0.16)
        gCenter.name = "GCenterButton"
        self.addChild(gCenter)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            if nodeITapped.name == "startButton" {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }else if nodeITapped.name == "GCenterButton" {
                showLeaderBoard()
            }else if nodeITapped.name == "creditsShow" {
                showCredits()
            }else if nodeITapped.name == "instructionsShow" {
                showInstructions()                
            }else if nodeITapped.name == "storeShow" {
                showStore()
            }else if nodeITapped.name == "settingsName" {
                showSettings()
            }else if nodeITapped.name == "pressHighScoreBtn" {
                var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
                var bestLevelNumber = defaults.integer(forKey: "bestLevelSaved")
                
                if score > highScoreNumber {
                    highScoreNumber = score
                    defaults.set(highScoreNumber, forKey: "highScoreSaved")
                }
                
                if levelNumber > bestLevelNumber {
                    bestLevelNumber = levelNumber
                    defaults.set(bestLevelNumber, forKey: "bestLevelSaved")
                }
                
                let vc = self.view!.window!.rootViewController!
                let alert = UIAlertController(title: "", message: "High Score: \(highScoreNumber)\nBest Level: \(bestLevelNumber)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func showCredits() {
        let sceneToMoveTo = CreditsScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func showInstructions() {
        let sceneToMoveTo = instructionsScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func showLeaderBoard() {
        let MainMenuScene = self.view?.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        MainMenuScene?.present(gcvc, animated: true, completion: nil)
    }
    
    func showStore() {
        let sceneToMoveTo = StoreScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func showSettings() {
        let sceneToMoveTo = SettingsScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
