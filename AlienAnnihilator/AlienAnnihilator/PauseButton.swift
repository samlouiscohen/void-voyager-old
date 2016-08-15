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
    
    
    
    init(theTexture:SKTexture){
        
        //sceneSize = viewSceneSize
        
        //paused.
        
        super.init(texture: theTexture, color: UIColor.clearColor(), size: theTexture.size())
        pausedLabel.text = "Paused"
        pausedLabel.fontSize = 14
        pausedLabel.position = CGPoint(x:200, y:200)

        self.setScale(0.7)
        self.alpha = 0.4
        //self.position = CGPoint(x: viewSceneSize.width - self.size.width*0.6, y: viewSceneSize.height - self.size.height*0.6)


    }
    
    
//    func makePausedLabel() -> SKLabelNode{
//        
//        let pausedLabel:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
//        pausedLabel.text = "PAUSED"
//        pausedLabel.fontSize = 14
//        pausedLabel.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
//        
//        return pausedLabel
//        
//    }
    
    
    
    func switchState(){
        
        //If button already not down then set it as down
        
        
        if(!down){
            self.setScale(0.9)
            self.alpha = 1
            down = true
            scene!.paused = true
            //GameScene.addChild(pausedLabel)
        }
        else{
            self.setScale(0.7)
            self.alpha = 0.5
            down = false
            scene!.paused = false
        }
        
    }

    
    func inAndDown(){
        //self.texture = downTexture
        self.setScale(0.9)
        self.alpha = 1
        down = true
    }
    func up(){
        self.setScale(0.7)
        self.alpha = 0.5
        down = false
    }
    func slideoff_up(){
        self.texture = upTexture
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}