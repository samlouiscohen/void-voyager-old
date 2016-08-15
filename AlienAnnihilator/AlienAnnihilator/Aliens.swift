//
//  Aliens.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/14/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit

//Generic alien type: a blue-print of sorts
class Alien:SKSpriteNode{
    
    static func normalizeVector(vector:CGVector) -> CGVector{
        let len = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
        
        return CGVector(dx:vector.dx / len, dy:vector.dy / len)
    }
    
    let velocityVector:CGVector
    let startPos:CGPoint
    
    init(texture:SKTexture, startPosition startPos:CGPoint,moveSpeed: CGFloat,velocityVector:CGVector){
        
        self.velocityVector = Alien.normalizeVector(velocityVector)
        self.startPos = startPos
        
        //Makes sure the SKSpriteNode is initialized before modifying its properties
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.setScale(0.2)
        
        //PhysicsBody is a property of super so super.init must be called first (init SKSpriteNode)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2) //Why THE FUCK IS THIS* NOT AN OPTIONAL?
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Alien //physicsBody?. is optional chaining?
        self.physicsBody?.collisionBitMask = PhysicsCategory.Laser //Do I need this? or jsut use in laser class
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.linearDamping = 0.0;
        
        //Motion
        self.physicsBody?.velocity.dx = velocityVector.dx * moveSpeed
        self.physicsBody?.velocity.dy = velocityVector.dy * moveSpeed
        
        self.position = startPos
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class normAlien:Alien{
    
    //var path:UIBezierPath
    //self.physicsBody = SKPhysicsBody(polygonFromPath: path.CGPath)
    
    init(startPos:CGPoint,speed: CGFloat){
        
        super.init(texture:trumpFaceTexture, startPosition: startPos, moveSpeed:speed, velocityVector:CGVector(dx: -1,dy: 0))
        
        //Trump set scale size
        //self.setScale(0.24)
        self.setScale(0.2)
        
        self.name = "normAlien"
        
        //let path = UIBezierPath(rect: CGRect(x: self.position.x, y: self.position.y, width: self.size.width, height: self.size.height))
        //self.physicsBody = SKPhysicsBody(polygonFromPath: path.CGPath)
        
        self.animateTrump()
        
        //self.drawDebugBox()
    }
    
    func animateTrump() {
        
        let textureAtlas = SKTextureAtlas(named:"Sprites")
        
        //let frames = ["trumpFaceOpen1","trumpFaceOpen2","trumpFaceOpen3","trumpFaceOpen4"].map{textureAtlas.textureNamed($0)}// look up map
        
        let animate = SKAction.animateWithTextures(trumpFrames, timePerFrame: 0.1)
        
        let forever = SKAction.repeatActionForever(animate)
        self.runAction(forever, withKey: "facialMotion")
        
    }
    
    func drawDebugBox(){
        let debugFrame = SKShapeNode(rectOfSize: self.size)
        
        //let debugFrame = SKShapeNode.init(rect: self.frame) //This references the .frame which is the Scene's coordinates
        debugFrame.strokeColor = SKColor.greenColor()
        self.addChild(debugFrame)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//Downward alien with Mikes face
class downAlien:Alien{
    
    
    init(startPos:CGPoint,speed: CGFloat){
        
        super.init(texture:mikeFaceTexture, startPosition: startPos, moveSpeed:speed, velocityVector:CGVector(dx: 0,dy: -1))
        //Mike set scale size
        self.setScale(0.1)
        self.name = "downAlien"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class behindAlien:Alien{
    
    
    init(startPos:CGPoint,speed: CGFloat){
        
        super.init(texture:behindAlienTexture, startPosition: startPos, moveSpeed:speed, velocityVector:CGVector(dx: 1,dy: 0))
        //Alien set scale size
        self.setScale(0.1)
        self.xScale = -self.xScale
        self.name = "behindAlien"
        self.animateAlien1()
    }
    
    
    func animateAlien1() {
        
        let textureAtlas = SKTextureAtlas(named:"Sprites")
        //        let frames = ["alien1_1","alien1_2","alien1_3","alien1_4","alien1_5","alien1_6","alien1_7","alien1_8",
        //
        //            "alien1_8","alien1_7","alien1_6","alien1_5","alien1_4","alien1_3","alien1_2","alien1_1",
        //
        //            ].map{textureAtlas.textureNamed($0)}// look up map
        //10->50 /10 =>  1->5
        let animateSpeedFactor = Double(self.speed/100)
        let animate = SKAction.animateWithTextures(behindFrames, timePerFrame: 0.08 - animateSpeedFactor)
        let forever = SKAction.repeatActionForever(animate)
        self.runAction(forever, withKey: "facialMotion")
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
