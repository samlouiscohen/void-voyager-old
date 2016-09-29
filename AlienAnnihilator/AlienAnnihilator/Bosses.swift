//
//  Bosses.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/14/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit


class bossAlien1:Alien{
    
    //Variable eye movement
    var velocityMagnitude:CGFloat = 0
    
    var totalLives = 10
    var lives:Int = 10
    
    
    //Create all sub spriteNodes and set their textures
    var aEyeBig:SKSpriteNode = SKSpriteNode(texture: boss1BigEyeTexture, color: UIColor.clear, size: boss1BigEyeTexture.size()) //Now we can scale here btw (CHANGE THIS)
    var socketBig:SKSpriteNode = SKSpriteNode(texture: boss1BigEyeSocketTexture, color: UIColor.clear, size: boss1BigEyeSocketTexture.size())
    
    var aEyeSmall1:SKSpriteNode = SKSpriteNode(texture: boss1SmallEyeTexture, color: UIColor.clear, size: boss1SmallEyeTexture.size())
    var socketSmall1:SKSpriteNode = SKSpriteNode(texture: boss1SmallEyeSocketTexture, color: UIColor.clear, size: boss1SmallEyeSocketTexture.size())
    
    var aEyeSmall2:SKSpriteNode = SKSpriteNode(texture: boss1SmallEyeTexture, color: UIColor.clear, size: boss1SmallEyeTexture.size())
    var socketSmall2:SKSpriteNode = SKSpriteNode(texture: boss1SmallEyeSocketTexture, color: UIColor.clear, size: boss1SmallEyeSocketTexture.size())
    
    let scaleSize:CGFloat = 1//0.1
    
    
    init(startPos:CGPoint,bossSpeed:CGFloat){
        
        
        self.velocityMagnitude = bossSpeed
        let velocity = CGVector(dx: 0, dy:0)
        
        super.init(texture:bossAlienReal0, startPosition: startPos, moveSpeed:velocityMagnitude, velocityVector:velocity)
        
        
        totalNodes+=1
        //Overwrite general aliens physics
        self.physicsBody?.categoryBitMask = PhysicsCategory.AlienBoss
        self.physicsBody?.collisionBitMask = 0//PhysicsCategory.Laser
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        
        
        //Set name property
        self.name = "bossAlien"
        
        //Add Eye balls (Frame drop comes from here)
        addEye(self.aEyeBig, theSocket:self.socketBig, position:CGPoint(x:0,y: self.size.height*0.3), scaleEye:1, scaleSocket:1)
//        addEye(self.aEyeBig, theSocket:self.socketBig, position:CGPoint(x:0,y: self.size.height*1.58), scaleEye:1, scaleSocket:1)
        addEye(self.aEyeSmall1, theSocket:self.socketSmall1, position:CGPoint(x: -24,y: 11), scaleEye:0.4, scaleSocket:0.35)
        addEye(self.aEyeSmall2, theSocket:self.socketSmall2, position:CGPoint(x: 24,y: 11), scaleEye:0.4, scaleSocket:0.35)
        
        //Start mouth animation (This is static)
        self.animateMouth()
        
        //Last thing- scale down
        self.setScale(scaleSize)
    }
    
    
    func addEye(_ theEye:SKSpriteNode, theSocket:SKSpriteNode, position:CGPoint, scaleEye:CGFloat, scaleSocket:CGFloat){
        
        
        /**
            Sets a given SKSpriteNode 'eye' to a proper position and adds it as a child to the bosses face
         */
        

        theEye.position = CGPoint(x: position.x, y: position.y)
        theSocket.position = CGPoint(x: position.x, y: position.y)
        
        //Build the eye physics body
        theEye.physicsBody = SKPhysicsBody(circleOfRadius: theEye.size.width/2)
        theEye.physicsBody?.collisionBitMask = 0
        theEye.physicsBody?.categoryBitMask = 0
        
        //Do we need socket physics?
        theSocket.physicsBody?.collisionBitMask = 0
        theSocket.physicsBody?.categoryBitMask = 0
        
        self.addChild(theSocket)
        self.addChild(theEye)
    }
    
    
    
    
    
    
    
    func animateEye(_ theEye:SKSpriteNode, theSocket:SKSpriteNode, bossBodyVector:CGVector, aShip:Ship){
        
        /**
         Creates a vector from a given eye's socket to the ship center 
            and applies a velocity to the eye as long as it's within bounds of its socket.
         */
        
        
        let eyeMoveSpeed:CGFloat = 50
        
        //Vector to ship center from eye socket center
        let eyeToshipVec = CGVector(dx: aShip.position.x - (self.position.x + theSocket.position.x*scaleSize), dy: aShip.position.y - (self.position.y + theSocket.position.y*scaleSize))
        let eyeToshipUnitVec = normalizeVector(eyeToshipVec)
        let eyeToshipVelocity = CGVector(dx: eyeToshipUnitVec.dx * eyeMoveSpeed, dy: eyeToshipUnitVec.dy * eyeMoveSpeed)
        
        
        //Factor in body velocity so that eye velocity is relative to the face
        theEye.physicsBody?.velocity = CGVector(dx: eyeToshipVelocity.dx + bossBodyVector.dx, dy: eyeToshipVelocity.dy + bossBodyVector.dy)
        
        
        //Keep the eye within eyeSocket bounds
        let rangeToCenterSprite = SKRange(lowerLimit: 0, upperLimit: theSocket.size.width/2 - theEye.size.width/2)
        var distanceConstraint: SKConstraint
        distanceConstraint = SKConstraint.distance(rangeToCenterSprite, to: theSocket)
        theEye.constraints = [distanceConstraint]

    }
    
    
    
    
    func updateAllEyes(_ aShip:Ship, bossBodyVector:CGVector){
        animateEye(aEyeBig,theSocket: socketBig, bossBodyVector: bossBodyVector, aShip: aShip)
        animateEye(aEyeSmall1,theSocket: socketSmall1,bossBodyVector: bossBodyVector, aShip: aShip)
        animateEye(aEyeSmall2,theSocket: socketSmall2,bossBodyVector: bossBodyVector, aShip: aShip)
    }
    
    func animateMouth() {
        let animate = SKAction.animate(with: bossFrames, timePerFrame: 0.03)
        let forever = SKAction.repeatForever(animate)
        self.run(forever, withKey: "facialMotion")
    }

    
    func moveBody(vectorToShip vec:CGVector){
        self.physicsBody?.velocity = vec
    }
    
    
    
    
    func update(_ aShip:Ship){
        let unitToShipVector = normalizeVector(CGVector(dx: aShip.position.x - self.position.x, dy: aShip.position.y - self.position.y))
        let toShipVector = CGVector(dx: unitToShipVector.dx * self.velocityMagnitude ,dy:unitToShipVector.dy*self.velocityMagnitude)
        
        moveBody(vectorToShip: toShipVector)
        updateAllEyes(aShip, bossBodyVector:toShipVector)
        
        
        
    }
    
    
    
    
    
    
    
    func shot(){
        //boss has 10 lives totalLives
        let ratio = CGFloat(Double(self.lives)/Double(self.totalLives))
        
        //print(ratio)
        
        let blendFactor:CGFloat = 1 - ratio
        
        let color = SKAction.colorize(with: SKColor.red, colorBlendFactor: blendFactor, duration: 0)
        
        self.run(color)
        
        self.lives -= 1
        
        if(self.lives < 1){
            self.removeFromParent()
        }
    }
    
    
    
    func boss_laser_contact(_ contact:SKPhysicsContact){
        
        var boss:SKNode? = nil
        if contact.bodyA.categoryBitMask == PhysicsCategory.AlienBoss && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            boss = contact.bodyA.node
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.AlienBoss && contact.bodyA.categoryBitMask == PhysicsCategory.Laser{
            boss = contact.bodyB.node
        }
        else{
            return
        }
        
        
        
        //boss has 10 lives totalLives
        let ratio = CGFloat(Double(self.lives)/Double(self.totalLives))
        

        let blendFactor:CGFloat = 1 - ratio
        
        let color = SKAction.colorize(with: SKColor.red, colorBlendFactor: blendFactor, duration: 0)
        
        boss?.run(color)
        
        self.lives -= 1

        
    }
    
    
    

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}








