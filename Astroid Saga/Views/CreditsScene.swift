//
//  CreditsScene.swift
//  Astroid Saga
//
//  Created by Paul on 6/10/17.
//  Copyright © 2017 Studio4Designsoftware. All rights reserved.
//

import UIKit
import SpriteKit

class CreditsScene: SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "GamersDelight.wav")
        backgroundSound.removeFromParent()
        
        if UserDefaults.standard.bool(forKey: "setMusic") {
            
        }else {
            self.addChild(backgroundSound)
        }
        
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let textLable = SKLabelNode(fontNamed: "Helvetica")
        textLable.text = "Game Developed by:"
        textLable.fontSize = 75
        textLable.fontColor = SKColor.white
        textLable.zPosition = 1
        textLable.position = CGPoint(x: self.size.width/2, y: self.size.height*0.80)
        self.addChild(textLable)
        
        let textLable2 = SKLabelNode(fontNamed: "Helvetica")
        textLable2.text = "Paul Roden II"
        textLable2.fontSize = 60
        textLable2.fontColor = SKColor.white
        textLable2.zPosition = 1
        textLable2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.75)
        self.addChild(textLable2)
        
        let textLable3 = SKLabelNode(fontNamed: "Helvetica")
        textLable3.text = "Founder/CEO of Studio4Design"
        textLable3.fontSize = 45
        textLable3.fontColor = SKColor.white
        textLable3.zPosition = 1
        textLable3.position = CGPoint(x: self.size.width/2, y: self.size.height*0.71)
        self.addChild(textLable3)
        
        let textLable4 = SKLabelNode(fontNamed: "Helvetica")
        textLable4.text = "Music by:"
        textLable4.fontSize = 75
        textLable4.fontColor = SKColor.white
        textLable4.zPosition = 1
        textLable4.position = CGPoint(x: self.size.width/2, y: self.size.height*0.60)
        self.addChild(textLable4)
        
        let textLable5 = SKLabelNode(fontNamed: "Helvetica")
        textLable5.text = "Midnight Bandit Music"
        textLable5.fontSize = 60
        textLable5.fontColor = SKColor.white
        textLable5.zPosition = 1
        textLable5.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        self.addChild(textLable5)
        
        let textLable6 = SKLabelNode(fontNamed: "Helvetica")
        textLable6.text = "Sound by:"
        textLable6.fontSize = 75
        textLable6.fontColor = SKColor.white
        textLable6.zPosition = 1
        textLable6.position = CGPoint(x: self.size.width/2, y: self.size.height*0.44)
        //self.addChild(textLable6)
        
        let textLable7 = SKLabelNode(fontNamed: "Helvetica")
        textLable7.text = "SoundJay.com"
        textLable7.fontSize = 60
        textLable7.fontColor = SKColor.white
        textLable7.zPosition = 1
        textLable7.position = CGPoint(x: self.size.width/2, y: self.size.height*0.39)
        //self.addChild(textLable7)
        
        let textLable8 = SKLabelNode(fontNamed: "Helvetica")
        textLable8.text = "Images by:"
        textLable8.fontSize = 75
        textLable8.fontColor = SKColor.white
        textLable8.zPosition = 1
        textLable8.position = CGPoint(x: self.size.width/2, y: self.size.height*0.28)
        //self.addChild(textLable8)
        
        let textLable9 = SKLabelNode(fontNamed: "Helvetica")
        textLable9.text = "<<<Add Name Here>>>"
        textLable9.fontSize = 60
        textLable9.fontColor = SKColor.white
        textLable9.zPosition = 1
        textLable9.position = CGPoint(x: self.size.width/2, y: self.size.height*0.23)
        //self.addChild(textLable9)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if background.contains(pointOfTouch) {
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
