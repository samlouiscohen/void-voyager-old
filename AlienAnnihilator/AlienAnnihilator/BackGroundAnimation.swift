//
//  BackGroundAnimation.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/25/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit



////Should this just be a node?
//class BackGroundAnimation:SKNode{
//    
////    var star:SKSpriteNode = SKSpriteNode(texture:starTexture)
//    
//    let theView:SKView
//    
//    init(aView:SKView){
//
//        theView = aView
//        
//        super.init()
//        
//        animate()
//    }
//    
//    
//    func animate(){
//        
//        
//        for _ in 1...200{
//            
//            let randomSize = random(1, max: 3)
//            var randomPosx = random(1,max: 1000)
//            randomPosx = randomPosx/1000.0
//            var randomPosy = random(1,max: 1000)
//            randomPosy = randomPosy/1000.0
//            
//            let star:SKSpriteNode = SKSpriteNode(texture:starTexture)
//            star.setScale(randomSize/60.0)
//            
//            
//            
//            star.position = CGPoint(x:(theView.scene?.size.width)! * randomPosx,y:(theView.scene?.size.width)! * randomPosy)//    (self.scene.size.width)*randomPosx, y:(self.scene.size.height) * randomPosy)
//
//            //star.position = CGPoint(x: 200,y: 200)
//            
//            star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width/2 )
//            star.physicsBody?.collisionBitMask = 0
//            star.physicsBody?.categoryBitMask = 0
//            star.physicsBody?.contactTestBitMask = 0
//
//            star.physicsBody?.linearDamping = 0
//            star.physicsBody?.velocity = CGVector(dx:1 * randomSize, dy:0)
//            star.name = "star"
//            
//            //addChild(star)
//            self.addChild(star)
//            self.moveToParent(self.scene!)
//            
//
//        }
//        
//        
//    }
//    
//    
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
//}