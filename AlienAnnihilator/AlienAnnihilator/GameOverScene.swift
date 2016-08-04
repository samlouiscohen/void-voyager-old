//
//  GameOverScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/3/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//


import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    var deadAliens:Int
    
    
    init(size: CGSize, aliensKilled:Int) {
        deadAliens = aliensKilled
        super.init(size: size)
    }
    
    
    
    override func didMoveToView(view: SKView) {
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

        killedLabel.text = "However, you managed to kill " + String(deadAliens) + " Aliens."
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
        
        let resartLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        resartLabel.text = "Tap anywhere to restart!"
        resartLabel.fontSize = 12
        resartLabel.fontColor = SKColor.redColor()
        resartLabel.position = CGPoint(x: size.width*0.85, y: size.height*0.1)
        resartLabel.userInteractionEnabled = false
        addChild(resartLabel)
        
        
        
        
        
    

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
                print("Helllllo")

                
                restartGame()

                
            }
        }

        
        
        
        
        
        
        
        
        
        
        
        
    
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}