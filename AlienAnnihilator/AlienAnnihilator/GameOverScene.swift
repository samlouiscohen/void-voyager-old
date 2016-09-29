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
    
    var totalScore:Int = 0
    var accuracy:Int
    
    
    let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
    let leaderboardLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    init(size: CGSize, aliensKilled:Int, numberBossesKilled:Int, laserAccuracy:Int) {
        deadBosses = numberBossesKilled
        deadAliens = aliensKilled
        accuracy = laserAccuracy
        
        super.init(size: size)
    }
    
    
    
    override func didMove(to view: SKView) {
        
        //Leaderboard
        //authPlayer()
//        saveHighscore(deadAliens)
        //saveHighscore(15)
        
        totalScore = deadAliens + deadBosses*50
        //accuracy = shotsHit/shotsFired
        
        saveHighscore(totalScore)

        
        
        // 1
        backgroundColor = SKColor.black
        
        let defeatLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        defeatLabel.text = "You have been destroyed..."
        defeatLabel.fontSize = 40
        defeatLabel.fontColor = SKColor.red
        defeatLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        //To allow for clicks on the label itself
        defeatLabel.isUserInteractionEnabled = false
        addChild(defeatLabel)
        
        
        
 
        
        let killedLabel = SKLabelNode(fontNamed: "Chalkduster")

        killedLabel.text = "However, you managed to kill " + String(deadAliens) + " Aliens and " + String(deadBosses) + " Bosses."

        killedLabel.fontSize = 20
        killedLabel.fontColor = SKColor.red
        killedLabel.position = CGPoint(x: size.width/2, y: size.height/2.8)
        killedLabel.isUserInteractionEnabled = false
        addChild(killedLabel)
        
        let pointsLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        pointsLabel.text = "For a total of: " + String(totalScore) + " points."
        
        pointsLabel.fontSize = 20
        pointsLabel.fontColor = SKColor.red
        pointsLabel.position = CGPoint(x: size.width/2, y: size.height/4)
        pointsLabel.isUserInteractionEnabled = false
        addChild(pointsLabel)
        

        
        
        
        let samLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        samLabel.text = "Far less then Sam's record of 10k lol"
        samLabel.fontSize = 5
        samLabel.fontColor = SKColor.red
        samLabel.position = CGPoint(x: 65, y: 10)
        samLabel.isUserInteractionEnabled = false
        addChild(samLabel)
        
//        let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        restartLabel.text = "Tap here to restart!"
        restartLabel.fontSize = 12
        restartLabel.fontColor = SKColor.red
        restartLabel.position = CGPoint(x: size.width*0.85, y: size.height*0.1)
        restartLabel.isUserInteractionEnabled = false
        addChild(restartLabel)
        
        
        
        
        
        leaderboardLabel.text = "Tap here for leaderboards"
        leaderboardLabel.fontSize = 12
        leaderboardLabel.fontColor = SKColor.red
        leaderboardLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.15)
//        leaderboardLabel.userInteractionEnabled = false
        addChild(leaderboardLabel)

    }
    
    
    
    
    func restartGame(){
        
        run(
            SKAction.run() {
                //Create the scene
                let gameScene:StartScene = StartScene(size: self.view!.bounds.size)
                gameScene.scaleMode = SKSceneScaleMode.fill
                
                //Open it with a transition
                self.view!.presentScene(gameScene, transition: SKTransition.doorway(withDuration: 1))
            }
        )

    }
    
    
    
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            for touch : AnyObject in touches {
                let location = touch.location(in: self)
                
                
                if(restartLabel.frame.contains(location)){
                    restartGame()
                }
                
                
                if(leaderboardLabel.frame.contains(location)){
                    

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
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    func saveHighscore(_ gameScore: Int) {
        //print("Player has been authenticated.")
        print("Save that shit")
        print(GKLocalPlayer.localPlayer().isAuthenticated)
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            print("OFFICIALLY IN")
            var scoreArray: [GKScore] = []
            
            
            //Total Score
            let scoreReporter = GKScore(leaderboardIdentifier: "scoreBoard")
            scoreReporter.value = Int64(gameScore)
            scoreArray.append(scoreReporter)
            
            //Aliens killed
            //let killedReporter = GKScore(leaderboardIdentifier: "AliensKilled")
            //killedReporter.value = Int64(aliensKilled)
            //scoreArray.append(killedReporter)
            
            //Accuracy
            //let accuracyReporter = GKScore(leaderboardIdentifier: "accuracyLeaderBoard")
            //accuracyReporter.value = Int64(accuracy)
            //scoreArray.append(accuracyReporter)

            
            //Report all scores
            GKScore.report(scoreArray, withCompletionHandler: nil)

            
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
