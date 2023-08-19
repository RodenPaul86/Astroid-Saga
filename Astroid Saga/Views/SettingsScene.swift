//
//  SettingsScene.swift
//  Astroid Saga
//
//  Created by Paul on 8/11/17.
//  Copyright © 2017 Studio4Designsoftware. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit
import AVFoundation
import MessageUI
import StoreKit

let defaults = UserDefaults.standard
let playersMusic = "playersMusic"
let musicSwitch = "musicSwitch"
let soundSwitch = "soundSwitch"

let kVersion = "CFBundleShortVersionString"
let kBuildNumber = "CFBundleVersion"

class SettingsScene: SKScene, MFMailComposeViewControllerDelegate, SKStoreProductViewControllerDelegate {
    var difficultyText:SKLabelNode!
    
    let background = SKSpriteNode(imageNamed: "background")
    let musicSetting = SKLabelNode(fontNamed: "Helvetica")
    let soundFX = SKLabelNode(fontNamed: "Helvetica")
    
    var musicSound: AVAudioPlayer!
    var FxSound: AVAudioNode!
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.name = "backGroundTouched"
        self.addChild(background)
        
        musicSetting.fontSize = 75
        musicSetting.fontColor = SKColor.white
        musicSetting.zPosition = 1
        musicSetting.position = CGPoint(x: self.size.width/2, y: self.size.height*0.82)
        musicSetting.name = "musicOn/Off"
        self.addChild(musicSetting)
        
        if defaults.bool(forKey: "setMusic") {
            musicSetting.text = "Music: OFF"
        } else {
            musicSetting.text = "Music: ON"
        }
        
        soundFX.fontSize = 75
        soundFX.fontColor = SKColor.white
        soundFX.zPosition = 1
        soundFX.position = CGPoint(x: self.size.width/2, y: self.size.height*0.75)
        soundFX.name = "soundOn/Off"
        self.addChild(soundFX)
        
        if defaults.bool(forKey: "setSounds") {
            soundFX.text = "Sound Fx: OFF"
        } else {
            soundFX.text = "Sound Fx: ON"
        }
        
        let difficultyBtn = SKLabelNode(fontNamed: "Helvetica")
        difficultyBtn.text = "Difficulty Level"
        difficultyBtn.fontSize = 75
        difficultyBtn.fontColor = SKColor.white
        difficultyBtn.zPosition = 1
        difficultyBtn.position = CGPoint(x: self.size.width/2, y: self.size.height*0.68)
        difficultyBtn.name = "difficultyLevel"
        self.addChild(difficultyBtn)
        
        difficultyText = SKLabelNode(fontNamed: "Helvetica")
        difficultyText.fontSize = 55
        difficultyText.zPosition = 1
        difficultyText.position = CGPoint(x: self.size.width/2, y: self.size.height*0.64)
        self.addChild(difficultyText)
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "setDiffText") {
            difficultyText.text = "Hard"
            difficultyText.fontColor = SKColor.red
        } else {
            difficultyText.text = "Easy"
            difficultyText.fontColor = SKColor.green
        }
        
        let feedBackLabel = SKLabelNode(fontNamed: "Helvetica")
        feedBackLabel.text = "Send Feedback"
        feedBackLabel.fontSize = 75
        feedBackLabel.fontColor = SKColor.green
        feedBackLabel.zPosition = 1
        feedBackLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.42)
        feedBackLabel.name = "feedMess"
        self.addChild(feedBackLabel)
        
        let shareLabel = SKLabelNode(fontNamed: "Helvetica")
        shareLabel.text = "Share This App"
        shareLabel.fontSize = 75
        shareLabel.fontColor = SKColor.green
        shareLabel.zPosition = 1
        shareLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.35)
        shareLabel.name = "shareApp"
        self.addChild(shareLabel)
        
        let moreApps = SKLabelNode(fontNamed: "Helvetica")
        moreApps.text = "More Apps"
        moreApps.fontSize = 75
        moreApps.fontColor = SKColor.green
        moreApps.zPosition = 1
        moreApps.position = CGPoint(x: self.size.width/2, y: self.size.height*0.28)
        moreApps.name = "moreApps"
        self.addChild(moreApps)
        
        let facebookBtn = SKSpriteNode(imageNamed: "FBicon")
        facebookBtn.setScale(0.8)
        facebookBtn.zPosition = 1
        facebookBtn.position = CGPoint(x: self.size.width*0.36, y: self.size.height*0.16)
        facebookBtn.name = "faceButton"
        self.addChild(facebookBtn)
        
        let webSiteBtn = SKSpriteNode(imageNamed: "S4Dicon")
        webSiteBtn.setScale(0.8)
        webSiteBtn.zPosition = 1
        webSiteBtn.position = CGPoint(x: self.size.width*0.64, y: self.size.height*0.16)
        webSiteBtn.name = "webButton"
        self.addChild(webSiteBtn)
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let currentYear = yearFormatter.string(from: Date())
        let copyrightLabel = SKLabelNode(fontNamed: "Helvetica")
        copyrightLabel.text = "© \(currentYear) S4D"
        copyrightLabel.fontSize = 40
        copyrightLabel.fontColor = SKColor.white
        copyrightLabel.zPosition = 1
        copyrightLabel.position = CGPoint(x: self.size.width*0.22, y: self.size.height*0.97)
        self.addChild(copyrightLabel)
        
        let verionLable = SKLabelNode(fontNamed: "Helvetica")
        verionLable.text = "V\(getVersion())"
        verionLable.fontSize = 40
        verionLable.fontColor = SKColor.white
        verionLable.zPosition = 1
        verionLable.position = CGPoint(x: self.size.width*0.80, y: self.size.height*0.97)
        self.addChild(verionLable)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            if nodeITapped.name == "backGroundTouched" {
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }else if nodeITapped.name == "musicOn/Off" {
                changeMusicBtn()
            }else if nodeITapped.name == "soundOn/Off" {
                changeSoundsBtn()
            }else if nodeITapped.name == "difficultyLevel" {
                changeDifficulty()
            }else if nodeITapped.name == "feedMess"{
                let SettingsScene = self.view?.window?.rootViewController
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    SettingsScene?.present(mailComposeViewController, animated: true, completion: nil)
                }else {
                    self.showSendMailErrorAlert()
                }
            }else if nodeITapped.name == "shareApp"{
                if let myWebsite = NSURL(string: "https://itunes.apple.com/us/app/astroid-saga/id1205737245?mt=8") {
                    let vc1 = self.view!.window!.rootViewController!
                    let objectsToShare = [myWebsite] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    //New Excluded Activities Code
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList]
                    
                    vc1.present(activityVC, animated:true, completion: nil)
                }
            }else if nodeITapped.name == "moreApps" {
                
                if let url  = NSURL(string: "https://itunes.apple.com/us/developer/paul-roden-ii/id693041126"),UIApplication.shared.canOpenURL(url as URL) == true  {
                    UIApplication.shared.open(URL(string: "\(url)")!)
                }
                
            }else if nodeITapped.name == "faceButton" {
                let vc2 = self.view!.window!.rootViewController!
                let alert = UIAlertController(title: "Message", message: "Your going to be redirected to our official Studio4Design FaceBook page.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {
                    
                    (action: UIAlertAction!) in
                    UIApplication.shared.open(URL(string: "http://www.facebook.com/studio4designsoftware")!)
                }))
                vc2.present(alert, animated: true, completion: nil)
                
            }else if nodeITapped.name == "webButton" {
                let vc3 = self.view!.window!.rootViewController!
                let alert = UIAlertController(title: "Message", message: "Your going to be redirected to our official Studio4Design website.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {
                    
                    (action: UIAlertAction!) in
                    UIApplication.shared.open(URL(string: "http://www.studio4designmobilesoftware.weebly.com")!)
                }))
                vc3.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func changeDifficulty() {
        let userDefaults = UserDefaults.standard
        
        if difficultyText.text == "Easy" {
            difficultyText.text = "Hard"
            difficultyText.fontColor = SKColor.red
            userDefaults.set(true, forKey: "setDiffText")
        } else if difficultyText.text == "Hard" {
            difficultyText.text = "Easy"
            difficultyText.fontColor = SKColor.green
            userDefaults.set(false, forKey: "setDiffText")
        }
        userDefaults.synchronize()
    }
    
    func changeMusicBtn() {
        let userDefaults = UserDefaults.standard
        if musicSetting.text == "Music: ON" {
            musicSetting.text = "Music: OFF"
            userDefaults.set(true, forKey: "setMusic")
        } else {
            musicSetting.text = "Music: ON"
            userDefaults.set(false, forKey: "setMusic")
        }
        userDefaults.synchronize()
    }
    
    func changeSoundsBtn() {
        let userDefaults = UserDefaults.standard
        if soundFX.text == "Sound Fx: ON" {
            soundFX.text = "Sound Fx: OFF"
            userDefaults.set(true, forKey: "setSounds")
        } else {
            soundFX.text = "Sound Fx: ON"
            userDefaults.set(false, forKey: "setSounds")
        }
        userDefaults.synchronize()
    }
    
    func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary[kVersion] as! String
        let build = dictionary[kBuildNumber] as! String
        return "\(version) (\(build))"
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["studio4designsoftware@outlook.com"])
        mailComposerVC.setSubject("Asteroid Saga v\(getVersion())")
        mailComposerVC.setMessageBody("Please tell us about your experience:\n\n\n\n\n\n\n\n\nApp Name: Asteroid Saga\nApp Version: \(getVersion())\nDevice: \(UIDevice.current.modelName)\n\(UIDevice.current.systemName) Version: \(UIDevice.current.systemVersion)", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let vc = self.view!.window!.rootViewController!
        let alert = UIAlertController(title: "Could Not Send Email",
                                      message: "Your device could not send an email. Please check your email configuralion and try again.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            case .cancelled: print("Sending Mail is cancelled")
            case .sent : print("Your Mail has been sent successfully")
            case .saved : print("Sending Mail is Saved")
            case .failed : print("Message sending failed")
        }
        controller.dismiss(animated: true)
    }
}
