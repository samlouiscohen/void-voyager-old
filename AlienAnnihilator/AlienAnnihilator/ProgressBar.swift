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
        
        super.init(texture: nil ,color: UIColor.red, size: CGSize(width: startWidth, height: startHeight))
        
        
        
        self.name = "progressBar"
    }
    
 
    func decrement(){
        
        //decrement
        
        
        
        self.size.height = self.startHeight * (self.startTime/self.remainingTime)
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}
