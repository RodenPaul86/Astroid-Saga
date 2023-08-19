//
//  GameViewController.swift
//  Astroid Saga
//
//  Created by Paul on 9/14/18.
//  Copyright © 2018 Studio4Designsoftware. All rights reserved.
//
// Ad unit ID for Banner: ca-app-pub-1844524695754391/6139352030
// Ad unit ID for Interstitial: ca-app-pub-1844524695754391/8520320404
//
// Test ad ID for Banner: ca-app-pub-3940256099942544/2934735716
// Test ad ID for Interstitial: ca-app-pub-3940256099942544/4411468910

import UIKit
import SpriteKit
import GameKit
import AVFoundation
import FBAudienceNetwork

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var bannerAdView: FBAdView!

    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        if getRunCounts() > 7 {
        } else {
            showReview()
        }
        
        // width and height is in pixels.
        // this line here is to make this game universal cross devices.
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        
        // Configure the view.
        let skView = self.view as! SKView
        
        // Sprite Kit applies additional optimizations to improve rendering performance.
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        // Set the scale mode to scale to fit the window.
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        authPlayer()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFacebookBannerAd()
        
        /*
        if UserDefaults.standard.object(forKey: "removeAds") != nil {
        } else {
            
        }
        */
    }
    
    //MARK: - Authentication for player
    func authPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {
            (view, Error) in
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}


extension GameViewController: FBAdViewDelegate {
    func loadFacebookBannerAd() {
        bannerAdView = FBAdView(placementID: "470270040346395_470302163676516", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        
        bannerAdView.frame = CGRect(x: 0, y: view.frame.size.height - bannerAdView.frame.size.height, width: bannerAdView.frame.size.width, height: bannerAdView.frame.size.height)
        
        bannerAdView.delegate = self
        bannerAdView.isHidden = true
        self.view.addSubview(bannerAdView)
        
        bannerAdView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            bannerAdView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            bannerAdView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            bannerAdView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
            bannerAdView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        } else {
            NSLayoutConstraint(item: bannerAdView as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: bannerAdView as Any, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: bannerAdView as Any, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true

            bannerAdView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        bannerAdView.loadAd()
    }
    
    
    func adViewDidLoad(_ adView: FBAdView) {
        bannerAdView.isHidden = false
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error)
    }
}


/*
extension GameViewController: UnityAdsDelegate {
    
    func loadUnityBannerAd() {
        UnityAds.initialize("4031370", delegate: self)
        UnityAds.show(self, placementId: "interstitialAds")
    }
    
    func unityAdsReady(_ placementId: String) {
        
    }
    
    func unityAdsDidStart(_ placementId: String) {
        
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        
    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        
        if (state != .skipped) {
            // reward the player
        }
    }
}
*/
