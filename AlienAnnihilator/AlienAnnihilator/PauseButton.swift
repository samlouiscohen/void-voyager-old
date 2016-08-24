//
//  PauseButton.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/15/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit




class PauseButton:SKSpriteNode{
    
    /*
     
     Have to press button and game state paused
        - lifting finger, or sliding off doesnt do anything at this point
     
     Have to press button again and game state unpaused
        -Lifting finger or sliding off doesnt do anthing at this point
     
     
     */
    
    
    

    
    //var sceneSize:CGSize
    
    let downTexture = SKTexture(imageNamed: "downTexture")
    let upTexture = SKTexture(imageNamed: "downTexture")
    var down = false
    
    let pausedLabel:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
    
    let theGameScene:GameScene
    
    init(theTexture:SKTexture, gameScene:GameScene){
                
        theGameScene = gameScene
        
        super.init(texture: theTexture, color: UIColor.clearColor(), size: theTexture.size())
        pausedLabel.text = "PAUSED"
        pausedLabel.color = SKColor.redColor()
        pausedLabel.fontSize = 50
        pausedLabel.position = CGPoint(x:(theGameScene.view?.scene?.size.width)!/2, y:(theGameScene.view?.scene?.size.height)!/2)
        

        self.setScale(0.7)
        self.alpha = 0.4

    }
    
    
    

    
    
    func switchState(){
        
        //Grab all of the GameScene children
        let children = theGameScene.children
        
        //Button logic
        if(!down){
            self.setScale(0.9)
            
            down = true
            scene!.paused = true
            
            
            for child in children{
                print(child.name)
                child.alpha = 0.5
                if(child.name == "controlStick"||child.name == "controlBase"){
                    child.alpha = 0.125
                }
                
                self.alpha = 1
            }
            
            //Apparently labels should be added from within gamescene not from this class
            theGameScene.addChild(pausedLabel)
        }
        else{
            self.setScale(0.7)
            
            down = false
            scene!.paused = false
            for child in children{
                child.alpha = 1
                
                if(child.name == "controlStick"||child.name == "controlBase"){
                    child.alpha = 0.25
                }
            }
            self.alpha = 0.5

            
            pausedLabel.removeFromParent()
        }
        
    }


    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}