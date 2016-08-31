//
//  GameOverScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/3/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//


import Foundation
import SpriteKit
import GameKit



class GameOverScene: SKScene, GKGameCenterControllerDelegate  {
    
    
    // we need to make sure to set this when we create our GameScene
    var viewController: GameViewController!
    
    
    var deadAliens:Int
    var deadBosses:Int
    
    let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
    let leaderboardLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    init(size: CGSize, aliensKilled:Int, numberBossesKilled:Int) {
        deadBosses = numberBossesKilled
        deadAliens = aliensKilled
        super.init(size: size)
    }
    
    
    
    override func didMoveToView(view: SKView) {
        
        //Leaderboard
        //authPlayer()
//        saveHighscore(deadAliens)
        //saveHighscore(15)
        saveHighscore(deadAliens + deadBosses*50)

        
        
        // 1
        backgroundColor = SKColor.blackColor()
        
        let defeatLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        defeatLabel.text = "You have been destroyed..."
        defeatLabel.fontSize = 40
        defeatLabel.fontColor = SKColor.redColor()
        defeatLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        //To allow for clicks on the label itself
        defeatLabel.userInteractionEnabled = false
        addChild(defeatLabel)
        
        
        
 
        
        let killedLabel = SKLabelNode(fontNamed: "Chalkduster")

        killedLabel.text = "However, you managed to kill " + String(deadAliens) + " Aliens and " + String(deadBosses) + " Bosses."

        killedLabel.fontSize = 20
        killedLabel.fontColor = SKColor.redColor()
        killedLabel.position = CGPoint(x: size.width/2, y: size.height/2.8)
        killedLabel.userInteractionEnabled = false
        addChild(killedLabel)
        

        
        
        
        let samLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        samLabel.text = "Far less then Sam's record of 10k lol"
        samLabel.fontSize = 5
        samLabel.fontColor = SKColor.redColor()
        samLabel.position = CGPoint(x: 65, y: 10)
        samLabel.userInteractionEnabled = false
        addChild(samLabel)
        
//        let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        restartLabel.text = "Tap here to restart!"
        restartLabel.fontSize = 12
        restartLabel.fontColor = SKColor.redColor()
        restartLabel.position = CGPoint(x: size.width*0.85, y: size.height*0.1)
        restartLabel.userInteractionEnabled = false
        addChild(restartLabel)
        
        
        
        
        
        leaderboardLabel.text = "Tap for Leaderboard"
        leaderboardLabel.fontSize = 12
        leaderboardLabel.fontColor = SKColor.redColor()
        leaderboardLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.2)
//        leaderboardLabel.userInteractionEnabled = false
        addChild(leaderboardLabel)

    }
    
    
    
    
    func restartGame(){
        
        runAction(
            SKAction.runBlock() {
                //Create the scene
                let gameScene:StartScene = StartScene(size: self.view!.bounds.size)
                gameScene.scaleMode = SKSceneScaleMode.Fill
                
                //Open it with a transition
                self.view!.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(1))
            }
        )

    }
    
    
    
    
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            
            for touch : AnyObject in touches {
                let location = touch.locationInNode(self)
                
                
                if(CGRectContainsPoint(restartLabel.frame, location)){
                    restartGame()
                }
                
                
                if(CGRectContainsPoint(leaderboardLabel.frame, location)){
                    

                    showLeader()

                }

                
            }
        }

        
        
        
        
        
        
        
        
    
    
    //LeaderBoard stuff
    
    //All leaderboard stuff
    
    
    
    func showLeader() {
        print("show that shit")
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        viewControllerVar?.presentViewController(gKGCViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func saveHighscore(gameScore: Int) {
        print("Player has been authenticated.")
        print("Save that shit")
        print(GKLocalPlayer.localPlayer().authenticated)
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            print("OFFICIALLY IN")
            let scoreReporter = GKScore(leaderboardIdentifier: "scoreBoard")
            scoreReporter.value = Int64(gameScore)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)

            
//            GKScore.reportScores(scoreArray, withCompletionHandler: {error -> Void in
//                if error != nil {
//                    print("An error has occured: \(error)")
//                }
//            })
        }
    }
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
    
    
    
    
    
    
    
    
    
    
//    func authPlayer(){
//        
//        //Create a play
//        let localPlayer = GKLocalPlayer.localPlayer()
//        
//        //See if signed in or not
//        localPlayer.authenticateHandler = {
//            //A view controller and an error handler
//            (view,error) in
//            
//            //If there is a view to work with
//            if view != nil {
//                self.presentViewController(view!, animated:true, completion: nil) //we dont want a completion handler
//            }
//                
//            else{
//                print(GKLocalPlayer.localPlayer().authenticated)
//            }
//        }
//        
//        
//    }
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
//    
//    
//    /*
//     I need:
//     - a add score -- right when the game is over
//     - a call to GameCenter -- right when the game is over
//     
//     
//     
//     */
//
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
    
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}