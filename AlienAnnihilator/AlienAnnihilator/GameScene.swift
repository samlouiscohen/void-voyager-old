//
//  GameScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 7/14/16.
//  Copyright (c) 2016 GuacGetters. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let alien = SKSpriteNode(imageNamed: "Sprites/alien")
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        alien.position = CGPoint(x:size.width * 0.1,y:size.height * 0.5)
        addChild(alien)
        
        
        
//        
////         Setup your scene here 
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            let sprite = SKSpriteNode(imageNamed: "Sprites/alien")
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
