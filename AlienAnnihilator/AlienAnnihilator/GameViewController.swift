//
//  GameViewController.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 7/14/16.
//  Copyright (c) 2016 GuacGetters. All rights reserved.
//

import UIKit
import SpriteKit
//For leaderboard and Game Center
import GameKit

class GameViewController: UIViewController{//, GKGameCenterControllerDelegate {
    
    
    //leaderboard
    var score = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //leaderboard-autheticate player immediately
        
        
        
        self.view.isMultipleTouchEnabled = true;
    
        let scene = StartScene(size: view.bounds.size)
        let skView = view as! SKView
        //skView.frameInterval = 4
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        //skView.showsPhysics = true
        
        
        //scene.size = skView.bounds.size //???Added becuase screen dimensions didnt make sense?

        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        authenticateLocalPlayer()
        

    }
    
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    
    
    
    
    
//    //All leaderboard stuff
    
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer() //GKLocalPlayer.localPlayer()
        
        print(localPlayer)
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            }
            else {
                print((GKLocalPlayer.localPlayer().isAuthenticated))
                print("HEEHHEHEHEHEHEHEHEHEHEH")
            }
        }
    }
    
    
    
    
    
    
    func showLeader() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        //gKGCViewController.gameCenterDelegate = self
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
}
