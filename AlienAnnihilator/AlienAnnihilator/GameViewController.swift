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
        //authPlayer()
        authenticateLocalPlayer()
        
        self.view.multipleTouchEnabled = true;
    
        let scene = StartScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        skView.showsPhysics = true
        
        
        //scene.size = skView.bounds.size //???Added becuase screen dimensions didnt make sense?

        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        
        
        
        
        
        
        //Comment out bc this hurt performance - instead I'll be explicit on specifics
//        skView.ignoresSiblingOrder = false;
        
        
//        @objc @objc func doubleTapped(){
//            
//        }
//        
//        //Switch between mike trump and aliens
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        tap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(tap)
        
        
        
        

    }
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    
    
    
    
//    //All leaderboard stuff
    
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    
    
    
    
    
    func showLeader() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        //gKGCViewController.gameCenterDelegate = self
        viewControllerVar?.presentViewController(gKGCViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    
//    
//        func authPlayer(){
//    
//            //Create a play
//            let localPlayer = GKLocalPlayer.localPlayer()
//            
//            //See if signed in or not
//            localPlayer.authenticateHandler = {
//                //A view controller and an error handler
//                (view,error) in
//    
//                //If there is a view to work with
//                if view != nil {
//                    self.presentViewController(view!, animated:true, completion: nil) //we dont want a completion handler
//                }
//    
//                else{
//                    print(GKLocalPlayer.localPlayer().authenticated)
//                }
//            }
//            
//            
//        }
//
//    
//    
//    
//    
//    
//    
//    
//    
//    //Call this when ur highscore should be saved
//    func saveHighScore(number:Int){
//        
//        
//        if(GKLocalPlayer.localPlayer().authenticated){
//            
//            let scoreReporter = GKScore(leaderboardIdentifier: "scoreBoard")
//            
//            scoreReporter.value = Int64(number)
//            
//            
//            //Takes every score reporter and put in an array and upload to leaderboard to check which is hiher ect.
//            let scoreArray: [GKScore] = [scoreReporter]
//            
//            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
//            
//        }
//        
//    }
//    
//    
//    func showLeaderBoard(){
//        
//        let viewController = self.view.window?.rootViewController
//        let gcvc = GKGameCenterViewController()
//        
//        gcvc.gameCenterDelegate = self
//        
//        viewController?.presentViewController(gcvc, animated: true, completion: nil)
//        
//        
//    }
//    
//    
//    
//    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
//        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    
    /*
     I need:
     - a add score -- right when the game is over
     - a call to GameCenter -- right when the game is over
     
     
     
     */
    
    
    
    
    
    
    
}
