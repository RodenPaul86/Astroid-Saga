//
//  instructionsScene.swift
//  Astroid Saga
//
//  Created by Paul on 6/12/17.
//  Copyright © 2017 Studio4Designsoftware. All rights reserved.
//

import UIKit
import SpriteKit

class instructionsScene: SKScene {
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
        
        let textLable0 = SKLabelNode(fontNamed: "Helvetica")
        textLable0.text = "Instructions:"
        textLable0.fontSize = 75
        textLable0.fontColor = SKColor.yellow
        textLable0.zPosition = 1
        textLable0.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.80)
        self.addChild(textLable0)
        
        let textLable1 = SKLabelNode(fontNamed: "Helvetica")
        textLable1.text = "Shoot the asteroids before they"
        textLable1.fontSize = 60
        textLable1.fontColor = SKColor.white
        textLable1.zPosition = 1
        textLable1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        self.addChild(textLable1)
        
        let textLable2 = SKLabelNode(fontNamed: "Helvetica")
        textLable2.text = "hit you, and be-careful of the"
        textLable2.fontSize = 60
        textLable2.fontColor = SKColor.white
        textLable2.zPosition = 1
        textLable2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.70)
        self.addChild(textLable2)
        
        let textLable3 = SKLabelNode(fontNamed: "Helvetica")
        textLable3.text = "asteroids passing you too,"
        textLable3.fontSize = 60
        textLable3.fontColor = SKColor.white
        textLable3.zPosition = 1
        textLable3.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.65)
        self.addChild(textLable3)
        
        let textLable4 = SKLabelNode(fontNamed: "Helvetica")
        textLable4.text = "if they do the lower your score"
        textLable4.fontSize = 60
        textLable4.fontColor = SKColor.white
        textLable4.zPosition = 1
        textLable4.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.60)
        self.addChild(textLable4)
        
        let textLable5 = SKLabelNode(fontNamed: "Helvetica")
        textLable5.text = "becomes."
        textLable5.fontSize = 60
        textLable5.fontColor = SKColor.white
        textLable5.zPosition = 1
        textLable5.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.55)
        self.addChild(textLable5)
        
        let textLable6 = SKLabelNode(fontNamed: "Helvetica")
        textLable6.text = "Also when you increase"
        textLable6.fontSize = 60
        textLable6.fontColor = SKColor.white
        textLable6.zPosition = 1
        textLable6.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.48)
        self.addChild(textLable6)
        
        let textLable7 = SKLabelNode(fontNamed: "Helvetica")
        textLable7.text = "your ''level'' the more asteroids"
        textLable7.fontSize = 60
        textLable7.fontColor = SKColor.white
        textLable7.zPosition = 1
        textLable7.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.43)
        self.addChild(textLable7)
        
        let textLable8 = SKLabelNode(fontNamed: "Helvetica")
        textLable8.text = "will come down."
        textLable8.fontSize = 60
        textLable8.fontColor = SKColor.white
        textLable8.zPosition = 1
        textLable8.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.38)
        self.addChild(textLable8)
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
