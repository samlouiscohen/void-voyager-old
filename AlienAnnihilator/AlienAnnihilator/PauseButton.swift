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
    
    let theScene:SKScene//GameScene
    
    init(theTexture:SKTexture, aScene:SKScene){//GameScene){
                
        theScene = aScene
        
        super.init(texture: theTexture, color: UIColor.clear, size: theTexture.size())
        pausedLabel.text = "PAUSED"
        pausedLabel.color = SKColor.red
        pausedLabel.fontSize = 50
        pausedLabel.position = CGPoint(x:(theScene.view?.scene?.size.width)!/2, y:(theScene.view?.scene?.size.height)!/2)
        

        self.setScale(0.7)
        self.alpha = 0.4

    }
    
    
    

    
    
    func switchState(){
        
        //Grab all of the GameScene children
        let children = theScene.children
        
        //Button logic
        if(!down){
            self.setScale(0.9)
            
            down = true
            scene!.isPaused = true
            
            
            for child in children{
                print(child.name)
                child.alpha = 0.5
                if(child.name == "controlStick"||child.name == "controlBase"){
                    child.alpha = 0.125
                }
                
                self.alpha = 1
            }
            
            //Apparently labels should be added from within gamescene not from this class
            theScene.addChild(pausedLabel)
        }
        else{
            self.setScale(0.7)
            
            down = false
            scene!.isPaused = false
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
