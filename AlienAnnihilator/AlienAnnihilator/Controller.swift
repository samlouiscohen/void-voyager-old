//
//  Controller.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/29/16.
//  Copyright © 2016 SamuelStudios. All rights reserved.
//

import Foundation
import SpriteKit




class Controller:SKNode{
    
    
    let base:SKSpriteNode = SKSpriteNode(imageNamed: "")
    let stick:SKSpriteNode = SKSpriteNode(imageNamed: "")
    
    
    override init(){
        
        
        super.init()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func draw(){
        
        base.position = CGPoint(x:base.size.width/2, y:base.size.height/2)//self.scene?.size.width
        stick.position = base.position

        stick.alpha = 0.25
        base.alpha = 0.25
        
        addChild(stick)
        addChild(base)
    }
    
    
    
    
    
    func update(){
        
        let rangeToCenterSprite = SKRange(lowerLimit: 0, upperLimit: base.size.width/2 - stick.size.width/2)
        let distanceConstraint:SKConstraint = SKConstraint.distance(rangeToCenterSprite, toPoint: base.position)
        stick.constraints = [distanceConstraint]
        
        
        //With the contstraint it should be able to move anywhere-- and take this vector
        
        
        
        //dispVector = getDisplacementVector()
        
        
    }
    
    
    func getDisplacementVector(){
        
    }
    
    
    
}

