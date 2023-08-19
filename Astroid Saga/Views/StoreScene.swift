//
//  StoreScene.swift
//  Astroid Saga
//
//  Created by Paul on 7/21/17.
//  Copyright © 2017 Studio4Designsoftware. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import MessageUI
import SpriteKit
import StoreKit

var removeAdBtn:SKLabelNode!
var removeAdBtnText:SKLabelNode!
var restorePur:SKLabelNode!

class StoreScene: SKScene, SKStoreProductViewControllerDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    var product: SKProduct?
    var productID = "Studio4DesignSoftware.AstroidSaga.adRemoval"
    //var banner = GameViewController(coder: "GameViewController")
    
    let save = UserDefaults.standard
    let background = SKSpriteNode(imageNamed: "background")
    
    override func didMove(to view: SKView) {
        let backgroundSound = SKAudioNode(fileNamed: "GamersDelight.wav")
        backgroundSound.removeFromParent()
        
        if UserDefaults.standard.bool(forKey: "setMusic") {
        } else {
            self.addChild(backgroundSound)
        }
        
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.name = "backGroundTouched"
        self.addChild(background)
        
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            //guard let strongSelf = self else{ return }
            if type == .purchased {
                let vc = self?.view!.window!.rootViewController!
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertView.addAction(action)
                vc?.present(alertView, animated: true, completion: nil)
            }
        }
        
        let LifeLabel1 = SKLabelNode(fontNamed: "Helvetica")
        LifeLabel1.text = "6 Extra Lives for"
        LifeLabel1.fontSize = 70
        LifeLabel1.fontColor = SKColor.white
        LifeLabel1.zPosition = 1
        LifeLabel1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.86)
        LifeLabel1.name = "appPurchase1"
        self.addChild(LifeLabel1)
        
        let LifeLabel2 = SKLabelNode(fontNamed: "Helvetica")
        LifeLabel2.text = "$2.99"
        LifeLabel2.fontSize = 55
        LifeLabel2.fontColor = SKColor.yellow
        LifeLabel2.zPosition = 1
        LifeLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.83)
        self.addChild(LifeLabel2)
        
        let LifeLabel3 = SKLabelNode(fontNamed: "Helvetica")
        LifeLabel3.text = "8 Extra Lives for"
        LifeLabel3.fontSize = 70
        LifeLabel3.fontColor = SKColor.white
        LifeLabel3.zPosition = 1
        LifeLabel3.position = CGPoint(x: self.size.width/2, y: self.size.height*0.76)
        LifeLabel3.name = "appPurchase2"
        self.addChild(LifeLabel3)
        
        let LifeLabel4 = SKLabelNode(fontNamed: "Helvetica")
        LifeLabel4.text = "$3.99"
        LifeLabel4.fontSize = 55
        LifeLabel4.fontColor = SKColor.yellow
        LifeLabel4.zPosition = 1
        LifeLabel4.position = CGPoint(x: self.size.width/2, y: self.size.height*0.73)
        self.addChild(LifeLabel4)
        
        let LifeLabel5 = SKLabelNode(fontNamed: "Helvetica")
        LifeLabel5.text = "10 Extea Lives for"
        LifeLabel5.fontSize = 70
        LifeLabel5.fontColor = SKColor.white
        LifeLabel5.zPosition = 1
        LifeLabel5.position = CGPoint(x: self.size.width/2, y: self.size.height*0.66)
        LifeLabel5.name = "appPurchase3"
        self.addChild(LifeLabel5)
        
        let LifeLabel6 = SKLabelNode(fontNamed: "Helvetica")
        LifeLabel6.text = "$4.99"
        LifeLabel6.fontSize = 55
        LifeLabel6.fontColor = SKColor.yellow
        LifeLabel6.zPosition = 1
        LifeLabel6.position = CGPoint(x: self.size.width/2, y: self.size.height*0.63)
        self.addChild(LifeLabel6)
        
        let LifeLabel7 = SKLabelNode(fontNamed: "Helvetica")
        LifeLabel7.text = "8 Extra Lives for"
        LifeLabel7.fontSize = 70
        LifeLabel7.fontColor = SKColor.white
        LifeLabel7.zPosition = 1
        LifeLabel7.position = CGPoint(x: self.size.width/2, y: self.size.height*0.76)
        LifeLabel7.name = "appPurchase4"
        LifeLabel7.removeFromParent()
        
        let LifeLabel8 = SKLabelNode(fontNamed: "Helvetica")
        LifeLabel8.text = "$4.99"
        LifeLabel8.fontSize = 55
        LifeLabel8.fontColor = SKColor.yellow
        LifeLabel8.zPosition = 1
        LifeLabel8.position = CGPoint(x: self.size.width/2, y: self.size.height*0.73)
        LifeLabel8.removeFromParent()
        
        removeAdBtn = SKLabelNode(fontNamed: "Helvetica")
        removeAdBtn.text = "Remove Ads"
        removeAdBtn.fontSize = 70
        removeAdBtn.fontColor = SKColor.white
        removeAdBtn.zPosition = 1
        removeAdBtn.position = CGPoint(x: self.size.width/2, y: self.size.height*0.20)
        removeAdBtn.name = "appPurchase5"
        
        removeAdBtnText = SKLabelNode(fontNamed: "Helvetica")
        removeAdBtnText.text = "Only $1.99"
        removeAdBtnText.fontSize = 55
        removeAdBtnText.fontColor = SKColor.yellow
        removeAdBtnText.zPosition = 1
        removeAdBtnText.position = CGPoint(x: self.size.width/2, y: self.size.height*0.17)
        
        restorePur = SKLabelNode(fontNamed: "Helvetica")
        restorePur.text = "Restore Purchase"
        restorePur.fontSize = 65
        restorePur.fontColor = SKColor.red
        restorePur.zPosition = 1
        restorePur.position = CGPoint(x: self.size.width/2, y: self.size.height*0.10)
        restorePur.name = "restoreAll"
        
        
        
        let save = UserDefaults.standard
        if save.value(forKey: "removeAdsPurchased") == nil {
            //self.addChild(removeAdBtn)
            //self.addChild(removeAdBtnText)
            //self.addChild(restorePur)
            
            removeAdBtn.removeFromParent()
            removeAdBtnText.removeFromParent()
            restorePur.removeFromParent()
        } else {
            removeAdBtn.removeFromParent()
            removeAdBtnText.removeFromParent()
            restorePur.removeFromParent()
        }
        
        
        
        let description0 = SKLabelNode(fontNamed: "Helvetica")
        description0.text = "Astroid Saga was created by Paul Roden II, an"
        description0.fontSize = 45
        description0.fontColor = SKColor.white
        description0.zPosition = 1
        description0.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.54)
        self.addChild(description0)
        
        let description2 = SKLabelNode(fontNamed: "Helvetica")
        description2.text = "independent developer. Its development"
        description2.fontSize = 45
        description2.fontColor = SKColor.white
        description2.zPosition = 1
        description2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.51)
        self.addChild(description2)
        
        let description3 = SKLabelNode(fontNamed: "Helvetica")
        description3.text = "is supported directly by its customers."
        description3.fontSize = 45
        description3.fontColor = SKColor.white
        description3.zPosition = 1
        description3.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.48)
        self.addChild(description3)
        
        let description4 = SKLabelNode(fontNamed: "Helvetica")
        description4.text = "If you find Astroid Saga fun to play,"
        description4.fontSize = 45
        description4.fontColor = SKColor.white
        description4.zPosition = 1
        description4.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.41)
        self.addChild(description4)
        
        let description5 = SKLabelNode(fontNamed: "Helvetica")
        description5.text = "please consider paying for extra"
        description5.fontSize = 45
        description5.fontColor = SKColor.white
        description5.zPosition = 1
        description5.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.38)
        self.addChild(description5)
        
        let description6 = SKLabelNode(fontNamed: "Helvetica")
        description6.text = "lifes to keep the game going."
        description6.fontSize = 45
        description6.fontColor = SKColor.white
        description6.zPosition = 1
        description6.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35)
        self.addChild(description6)
        
        
        
        
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
                
            } else if nodeITapped.name == "appPurchase1" {
                IAPHandler.shared.purchaseMyProduct(index: 1)
                
            } else if nodeITapped.name == "appPurchase2" {
                IAPHandler.shared.purchaseMyProduct(index: 2)
                
            } else if nodeITapped.name == "appPurchase3" {
                IAPHandler.shared.purchaseMyProduct(index: 0)
                
            } else if nodeITapped.name == "appPurchase5" {
                IAPHandler.shared.purchaseMyProduct(index: 3)
            } else if nodeITapped.name == "restoreAll" {
                IAPHandler.shared.restorePurchase()
            }
        }
    }
    
    
    // these functions for the app store
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let vc = self.view!.window!.rootViewController!
        
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                vc.present(storeViewController, animated: true, completion: nil)
                //self?.present(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func getPurchaseInfo() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: NSSet(object: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "Warning:", message: "Please enable ''In App Purchases'' in your settings.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        if (products.count == 0) {
            let alert = UIAlertController(title: "Warning:", message: "Product Not Found!!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        } else {
            product = products[0]
            self.addChild(removeAdBtn)
        }
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids {
            print("product not found: \(product)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                let alert = UIAlertController(title: "Thank You!!", message: "The product has been purcheaed successfully.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                //removeAdBtn.removeFromParent()
                //banner.isHidden = true
                
                let save = UserDefaults.standard
                save.set(true, forKey: "noelPurchased")
                save.synchronize()
                
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                let alert = UIAlertController(title: "Warning:", message: "The product has not been purcheaed.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        // nonConsumablePurchaseMade = true
    }
    
    
    
}
