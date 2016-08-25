//
//  ProgressBar.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/24/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit



class ProgressBar:SKSpriteNode{
    
    let startTime:CGFloat
    var remainingTime:CGFloat
    let startHeight:CGFloat// = 50.0
    let startWidth:CGFloat// = 20.0
    
    
    

//    let timeInterval = 0.01
//    let decrementTime = SKAction.runBlock(<#T##block: dispatch_block_t##dispatch_block_t##() -> Void#>)
//    
    
    init(progressBarTime:CGFloat, shipSize:CGSize){
        
        
        
        startHeight = shipSize.height
        startWidth = shipSize.width/7.0
        
        
        startTime = progressBarTime
        remainingTime = startTime
        
        super.init(texture: nil ,color: UIColor.redColor(), size: CGSize(width: startWidth, height: startHeight))
        
        //self.decrement()
        
        
        self.name = "progressBar"
        
//        let updateProgressBar = SKAction.repeatActionForever((SKAction.sequence(
//            [SKAction.runBlock(update),
//                SKAction.waitForDuration(0.001)])))
//        
        
        
        //self.runAction(updateProgressBar)
    }
    
    
    
//    func update(){
//        
////        guard let scene = scene else { return }
////        guard let gameScene = scene as? GameScene else { return }
////        
////        remainingTime = remainingTime - 0.01
////        //gameScene.updat
////        
////        //self.size.height = self.startHeight * (remainingTime/startTime)
////        print("Height: ", self.size.height)
////        print("Pos: ",gameScene)
//        
//        //self.position = (self.parent?.position)!
////        self.position = gameScene.aShip.position
//        
//    }
//    
    func decrement(){
        
        //decrement
        
        
        
        self.size.height = self.startHeight * (self.startTime/self.remainingTime)
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}