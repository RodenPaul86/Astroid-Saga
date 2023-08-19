//
//  GameScene.swift
//  Astroid Saga
//
//  Created by Paul on 2/7/17.
//  Copyright © 2017 Studio4Designsoftware. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
import GameplayKit
import AVFoundation
import AudioToolbox
import FBAudienceNetwork

enum gameState {
    case preGame    //when the game state is before the start of the game.
    case inGame     //when the game state is during the game.
    case pausedGame //when the game state is paused.
    case afterGame  //when the game state is after the game.
}

private var safeArea: SafeAreaNode!

var score:Int = 0
var levelNumber:Int = 1
var lifeNumber:Int = 4
var addOns = false

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate, UIGestureRecognizerDelegate {
    var interstitialAdView: FBInterstitialAd?
    
    //MARK: Elements of game
    var currentGameState = gameState.preGame
    var background:SKSpriteNode!
    var player:SKSpriteNode!
    var enemy:SKSpriteNode!
    var tapToStartLabel:SKLabelNode!
    var scoreLabel:SKLabelNode!
    var levelLabel:SKLabelNode!
    var lifeLabel:SKLabelNode!
    var pauseBtn:SKSpriteNode!
    var tapToResume:SKLabelNode!
    var quitGame:SKLabelNode!
    var dimPanel:SKSpriteNode!
    var addNumber:SKLabelNode!
    var timeDuration = 0.75

    // Behavior variables.
    var gameTimer:Timer!
    var possibleAliens = ["aestroid1", "aestroid2", "aestroid3", "aestroid4"]
    
    let torpedoCategory:UInt32      = 0x1 << 0   // 1
    let alienCategory:UInt32        = 0x1 << 2   // 2
    let shipCategory:UInt32         = 0x1 << 1   // 4
    //let enemyTorpedoCategory:UInt32 = 0x1 << 5
    //let enemyCategory:UInt32        = 0x1 << 6
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
            let maxAspectRatio: CGFloat = 16.0/9.0
            let playableWidth = size.height / maxAspectRatio
            let margin = (size.width - playableWidth) / 2
            gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
            super.init(size: size)
        } else {
            let maxAspectRatio: CGFloat = 16.0/10.9
            let playableWidth = size.height / maxAspectRatio
            let margin = (size.width - playableWidth) / 2
            gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
            super.init(size: size)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - didMoveToView
    
    override func didMove(to view: SKView) {
        score = 0
        levelNumber = 1
        
        if addOns == false {
            lifeNumber = 4
        }else if addOns == true {
            if lifeNumber == defaults.integer(forKey: "6LifesPurchased") {
                lifeNumber += 6
                lifeLabel.text = "❤️ x \(lifeNumber)"
            }else if lifeNumber == defaults.integer(forKey: "8LifesPurchased") {
                lifeNumber += 8
                lifeLabel.text = "❤️ x \(lifeNumber)"
            }else if lifeNumber == defaults.integer(forKey: "10LifesPurchased") {
                lifeNumber += 10
                lifeLabel.text = "❤️ x \(lifeNumber)"
            }
        } else {
            addOns = false
        }
        
        let backgroundSound = SKAudioNode(fileNamed: "It'sOn.wav")
        backgroundSound.removeFromParent()
        
        
        if UserDefaults.standard.bool(forKey: "setMusic") {
        } else {
            self.addChild(backgroundSound)
        }
        
        
        let pressed:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        pressed.delegate = self
        pressed.minimumPressDuration = 0.1
        view.addGestureRecognizer(pressed)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1 {
            background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = -1
            background.name = "BackGround"
            self.addChild(background)
        }
        
        tapToStartLabel = SKLabelNode(text: "Tap To Start")
        tapToStartLabel.fontSize = 70
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        let pulseUp = SKAction.scale(to: 1.5, duration: 0.5)
        let pulseDown = SKAction.scale(to: 1, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        tapToStartLabel.run(repeatPulse)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.zPosition = 7
        scoreLabel.position = CGPoint(x: self.size.width*0.20, y: self.size.height*0.93)
        //scoreLabel.position = scoreLabel.anchor(local: CGPoint.upperRight, other: CGPoint.upperRight, target: safeArea) - CGPoint(x: 20, y: 20)
        
        //scoreLabel.position = scoreLabel.anchored(value: CGPoint.upperLeft)
        
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = UIColor.white
        
        self.addChild(scoreLabel)
        
        levelLabel = SKLabelNode(text: "Level: 1")
        levelLabel.zPosition = 7
        levelLabel.position = CGPoint(x: self.size.width*0.21, y: self.size.height*0.89)
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.fontName = "Helvetica-Bold"
        levelLabel.fontSize = 50
        levelLabel.fontColor = UIColor.white
        self.addChild(levelLabel)
        
        lifeLabel = SKLabelNode(text: "❤️ x \(lifeNumber)")
        lifeLabel.zPosition = 7
        lifeLabel.position = CGPoint(x: self.size.width*0.80, y: self.size.height*0.93)
        lifeLabel.horizontalAlignmentMode = .right
        lifeLabel.fontName = "Helvetica-Bold"
        lifeLabel.fontSize = 50
        lifeLabel.fontColor = UIColor.white
        self.addChild(lifeLabel)
        
        pauseBtn = SKSpriteNode(imageNamed: "pauseButton")
        pauseBtn.zPosition = 7
        pauseBtn.position = CGPoint(x: self.size.width*0.76, y: self.size.height*0.89)
        pauseBtn.name = "pauseCurrentGame"
        pauseBtn.removeFromParent()
        
        tapToResume = SKLabelNode(text: "Resume")
        tapToResume.fontSize = 70
        tapToResume.fontName = "Helvetica"
        tapToResume.fontColor = SKColor.white
        tapToResume.zPosition = 9
        tapToResume.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToResume.name = "resumeCurrentGame"
        tapToResume.removeFromParent()
        
        quitGame = SKLabelNode(text: "Quit")
        quitGame.fontSize = 70
        quitGame.fontName = "Helvetica"
        quitGame.fontColor = SKColor.red
        quitGame.zPosition = 9
        quitGame.position = CGPoint(x: self.size.width/2, y: self.size.height*0.43)
        quitGame.name = "quitCurrentGame"
        quitGame.removeFromParent()
        
        dimPanel = SKSpriteNode(color: UIColor.black, size: self.size)
        dimPanel.alpha = 0.75
        dimPanel.zPosition = 8
        dimPanel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        dimPanel.removeFromParent()
        
        player = SKSpriteNode(imageNamed: "playerShip")
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 3
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = shipCategory
        player.physicsBody?.contactTestBitMask = alienCategory
        //player.physicsBody?.contactTestBitMask = enemyTorpedoCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
        
        let leftEnginePath = Bundle.main.path(forResource: "leftRocketThrust", ofType: "sks")!
        let leftEngine = NSKeyedUnarchiver.unarchiveObject(withFile: leftEnginePath) as! SKEmitterNode
        leftEngine.particleZPosition = 1
        
        leftEngine.xScale = 0.90
        leftEngine.yScale = 0.90
        
        let leftThrusterEffectNode = SKEffectNode()
        leftThrusterEffectNode.addChild(leftEngine)
        leftThrusterEffectNode.position.x = -60
        leftThrusterEffectNode.position.y = -60
        player.addChild(leftThrusterEffectNode)
        
        let rightEnginePath = Bundle.main.path(forResource: "rightRocketThrust", ofType: "sks")!
        let rightEngine = NSKeyedUnarchiver.unarchiveObject(withFile: rightEnginePath) as! SKEmitterNode
        rightEngine.particleZPosition = 1
        
        rightEngine.xScale = 0.90
        rightEngine.yScale = 0.90
        
        let rightThrusterEffectNode = SKEffectNode()
        rightThrusterEffectNode.addChild(rightEngine)
        rightThrusterEffectNode.position.x = 60
        rightThrusterEffectNode.position.y = -60
        player.addChild(rightThrusterEffectNode)
        
        /*
        enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        enemy.zPosition = 3
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = torpedoCategory
        enemy.physicsBody?.collisionBitMask = 0
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(enemy)
        */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            if nodeITapped.name == "pauseCurrentGame" {
                pauseBtn.isHidden = true
                pauseGame()
                gameTimer.invalidate()
                self.addChild(tapToResume)
                self.addChild(quitGame)
                self.addChild(dimPanel)
                
            } else if nodeITapped.name == "resumeCurrentGame" {
                pauseBtn.isHidden = false
                resumeGame()
                gameTimer = Timer.scheduledTimer(timeInterval: timeDuration, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
                tapToResume.removeFromParent()
                quitGame.removeFromParent()
                dimPanel.removeFromParent()
                
            }else if nodeITapped.name == "quitCurrentGame" {
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
        
        if currentGameState == gameState.preGame {
            startGame()
        }else if currentGameState == gameState.inGame {
            fireTorpedo()
        }
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            print("LongPress BEGAN detected")
        }
        
        if sender.state == .ended {
            print("LongPress ENDED detected")
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            let previonsPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previonsPointOfTouch.x
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width/2 {
                player.position.x = gameArea.maxX - player.size.width/2
            }
            
            if player.position.x < gameArea.minX + player.size.width/2 {
                player.position.x = gameArea.minX + player.size.width/2
            }
        }
    }
    
    func startGame() {
        if UserDefaults.standard.object(forKey: "removeAds") != nil {
        } else {
            createAndLoadInterstitial()
        }
        
        currentGameState = gameState.inGame
        self.addChild(pauseBtn)
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewGame)
        
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
    }
    
    func pauseGame() {
        currentGameState = gameState.pausedGame
        let skView = self.view
        skView?.scene?.isPaused = true
    }
    
    func resumeGame() {
        currentGameState = gameState.inGame
        let skView = self.view
        skView?.scene?.isPaused = false
    }
    
    func startNewGame() {
        // Add spwan enemies code here.
        if UserDefaults.standard.bool(forKey: "setDiffText") {
            timeDuration = 0.3
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeDuration, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
    }
    
    func changeLevel() {
        if score == 95 {
            //Level 2
            levelNumber += 1
            levelLabel.text = "Level: \(levelNumber)"
            /*
            let moveShipOntoScreenAction = SKAction.moveTo(y: self.frame.height, duration: 0.5)
            enemy.run(moveShipOntoScreenAction)
            */
        } else if score == 195 {
            //Level 3
            levelNumber += 1
            levelLabel.text = "Level: \(levelNumber)"
            gameTimer = Timer.scheduledTimer(timeInterval: 0.85, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        } else if score == 295 {
            //Level 4
            levelNumber += 1
            levelLabel.text = "Level: \(levelNumber)"
            gameTimer = Timer.scheduledTimer(timeInterval: 0.90, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        } else if score == 395 {
            //Level 5
            levelNumber += 1
            levelLabel.text = "Level: \(levelNumber)"
            gameTimer = Timer.scheduledTimer(timeInterval: 0.95, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        } else if score == 495 {
            //Level 6
            levelNumber += 1
            levelLabel.text = "Level: \(levelNumber)"
            gameTimer = Timer.scheduledTimer(timeInterval: 1.00, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        } else if score == 595 {
            //Level 7
            levelNumber += 1
            levelLabel.text = "Level: \(levelNumber)"
            gameTimer = Timer.scheduledTimer(timeInterval: 1.05, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        } else if score == 695 {
            //Level 8
            levelNumber += 1
            levelLabel.text = "Level: \(levelNumber)"
            gameTimer = Timer.scheduledTimer(timeInterval: 1.10, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        } else if score == 795 {
            //Level 9
            levelNumber += 1
            levelLabel.text = "Level: \(levelNumber)"
            gameTimer = Timer.scheduledTimer(timeInterval: 1.15, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        }
    }
    
    func loseALife() {
        lifeNumber -= 1
        lifeLabel.text = "❤️ x \(lifeNumber)"
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        lifeLabel.run(scaleSequence)
        
    }
    
    func loseScoring() {
        if score > 0 {
            score -= 5
            scoreLabel.text = "Score: \(score)"
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            scoreLabel.run(scaleSequence)
        }else if score == 0 {
            let changeSceneAction = SKAction.run(self.changeScene)
            let waitToChangeScene = SKAction.wait(forDuration: 1)
            let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
            self.run(changeSceneSequence)
        }
    }
    
    func saveHighscore(number :Int) {
        if GKLocalPlayer.local.isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "asteroidCrashID")
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func addAlien()  {
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 500)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.name = "Aliens"
        alien.zPosition = 2
        alien.position = startPoint
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = torpedoCategory
        alien.physicsBody?.contactTestBitMask = shipCategory
        alien.physicsBody?.collisionBitMask = 0
        self.addChild(alien)
        
        let animationDuration: TimeInterval = 6
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        actionArray.append(SKAction.run {
            
            if lifeNumber > 0 {
                self.loseScoring()
            }else {
                if lifeNumber == 0 {
                    let changeSceneAction = SKAction.run(self.changeScene)
                    let waitToChangeScene = SKAction.wait(forDuration: 1)
                    let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
                    self.run(changeSceneSequence)
                }
            }
        })
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
    }
    
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
        if UserDefaults.standard.object(forKey: "removeAds") != nil {
        } else {
            laodAd()
        }
    }
    
    func fireTorpedo() {
        if UserDefaults.standard.bool(forKey: "setSounds") {
            
        }else {
            self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        }
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.name = "Torpedos"
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        torpedoNode.zPosition = 2
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = torpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration: TimeInterval = 1
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.size.height + torpedoNode.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpedoNode.run(SKAction.sequence(actionArray))
    }
    
    // Collision Physics body.
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node != nil && contact.bodyB.node != nil {
            var firstBody:SKPhysicsBody
            var secondBody:SKPhysicsBody
            
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            if (firstBody.categoryBitMask == torpedoCategory) && (secondBody.categoryBitMask == alienCategory) {
                torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
            } else if (firstBody.contactTestBitMask == alienCategory) && (secondBody.contactTestBitMask == shipCategory) {
                playerShipDidCollide(shipNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
            }
        }
    }
    
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        addNumber = SKLabelNode(text: "+5")
        addNumber.zPosition = 7
        addNumber.position = alienNode.position
        addNumber.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addNumber.fontName = "Helvetica-Bold"
        addNumber.fontSize = 50
        addNumber.fontColor = UIColor.white
        self.addChild(addNumber)
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        if UserDefaults.standard.bool(forKey: "setSounds") {
            
        }else {
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        }
        
        let scale = SKAction.scale(to: 0.8, duration: 0.5)
        let fade = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([scale, fade, remove])
        addNumber.run(sequence)
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        changeLevel()
        score += 5
        scoreLabel.text = "Score: \(score)"
        saveHighscore(number: score)
    }
    
    func playerShipDidCollide (shipNode:SKSpriteNode, alienNode:SKSpriteNode) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        if UserDefaults.standard.bool(forKey: "setSounds") {
            
        }else {
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        }
        
        alienNode.removeFromParent()
        
        let shipOnFirePath = Bundle.main.path(forResource: "shipOnFire", ofType: "sks")!
        let onFire = NSKeyedUnarchiver.unarchiveObject(withFile: shipOnFirePath) as! SKEmitterNode
        onFire.particleZPosition = 1
        
        let shipOnFireEffectNode = SKEffectNode()
        shipOnFireEffectNode.addChild(onFire)
        shipOnFireEffectNode.position.x = 0
        shipOnFireEffectNode.position.y = 0
        player.addChild(shipOnFireEffectNode)
        
        self.run(SKAction.wait(forDuration: 6)) {
            shipOnFireEffectNode.removeFromParent()
        }
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        if score > 0 {
            score -= 5
        }
        
        scoreLabel.text = "Score: \(score)"
        saveHighscore(number: score)
        
        if lifeNumber > 0 {
            self.loseALife()
            
            if lifeNumber == 0 {
                currentGameState = gameState.afterGame
                
                self.removeAllActions()
                self.enumerateChildNodes(withName: "Aliens") {
                    alien, stop in
                    alien.removeAllActions()
                }
                self.enumerateChildNodes(withName: "Torpedos") {
                    torpedoNode, stop in
                    torpedoNode.removeAllActions()
                }
                
                let changeSceneAction = SKAction.run(self.changeScene)
                let waitToChangeScene = SKAction.wait(forDuration: 1)
                let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
                self.run(changeSceneSequence)
            }
        }
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "BackGround") {
            background, stop in
            
            if self.currentGameState == gameState.inGame {
                background.position.y -= amountToMoveBackground
            }
            
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
        }
    }
    
    //MARK: - End Of Code...
}

//MARK: - Extensions

extension GameScene: FBInterstitialAdDelegate {
    //MARK: - Facebook Ads
    fileprivate func createAndLoadInterstitial() {
        interstitialAdView = FBInterstitialAd(placementID: "470270040346395_523297101710355")
        interstitialAdView?.delegate = self
        interstitialAdView!.load()
    }
    
    func laodAd() {
        let currentViewController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        if interstitialAdView != nil && interstitialAdView!.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAdView?.show(fromRootViewController: currentViewController)
        }
    }
    
    func interstitialAdWillClose(_ interstitialAd: FBInterstitialAd) {
        print("Interstitial will close")
    }
    
    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        print("Interstitial did close")
    }
} // showing Interstitial ads
