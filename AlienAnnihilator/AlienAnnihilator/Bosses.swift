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
    var velocityMagnitude:CGFloat = 50
    
    var totalLives = 10
    var lives:Int = 10
    
    var aEyeBig:SKSpriteNode = SKSpriteNode(texture: boss1BigEyeTexture, color: UIColor.clearColor(), size: boss1BigEyeTexture.size()) //Now we can scale here btw (CHANGE THIS)
    var socketBig:SKSpriteNode = SKSpriteNode(texture: boss1BigEyeSocketTexture, color: UIColor.clearColor(), size: boss1BigEyeSocketTexture.size())
    
    var aEyeSmall1:SKSpriteNode = SKSpriteNode(texture: boss1SmallEyeTexture, color: UIColor.clearColor(), size: boss1SmallEyeTexture.size())
    var socketSmall1:SKSpriteNode = SKSpriteNode(texture: boss1SmallEyeSocketTexture, color: UIColor.clearColor(), size: boss1SmallEyeSocketTexture.size())
    
    var aEyeSmall2:SKSpriteNode = SKSpriteNode(texture: boss1SmallEyeTexture, color: UIColor.clearColor(), size: boss1SmallEyeTexture.size())
    var socketSmall2:SKSpriteNode = SKSpriteNode(texture: boss1SmallEyeSocketTexture, color: UIColor.clearColor(), size: boss1SmallEyeSocketTexture.size())
    
    
    
    
    let scaleSize:CGFloat = 0.1
    
    
    init(startPos:CGPoint){
        
        let velocity = CGVector(dx: 0, dy:0)
        
        super.init(texture:boss1StartTexture, startPosition: startPos, moveSpeed:velocityMagnitude, velocityVector:velocity)
        
        
        
        //Overwrite general aliens physics
        self.physicsBody?.categoryBitMask = PhysicsCategory.AlienBoss
        self.physicsBody?.collisionBitMask = 0//PhysicsCategory.Laser
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        
        
        //Set name property
        self.name = "bossAlien"
        
        
        //Add Eye balls (Frame drop comes from here)
        addEye(self.aEyeBig, theSocket:self.socketBig, position:CGPoint(x:0,y: self.size.height*1.58), scaleEye:1, scaleSocket:1)
        addEye(self.aEyeSmall1, theSocket:self.socketSmall1, position:CGPoint(x: -240,y: 110), scaleEye:0.4, scaleSocket:0.35)
        addEye(self.aEyeSmall2, theSocket:self.socketSmall2, position:CGPoint(x: 240,y: 110), scaleEye:0.4, scaleSocket:0.35)
        
        //Start mouth animation (This is static)
        self.animateMouth()
        //self.drawDebugBox()
        
        
        //Last thing- scale down
        self.setScale(scaleSize)
    }
    
    
    func addEye(theEye:SKSpriteNode, theSocket:SKSpriteNode, position:CGPoint, scaleEye:CGFloat, scaleSocket:CGFloat){
        //theEye.setScale(scaleEye)
        theEye.position = CGPointMake(position.x, position.y)
        //theSocket.setScale(scaleSocket)
        theSocket.position = CGPointMake(position.x, position.y)
        
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
    
    
    
    
    
    
    
    
    func animateEye(theEye:SKSpriteNode, theSocket:SKSpriteNode, bossBodyVector:CGVector, aShip:Ship){
        
        let eyeMoveSpeed:CGFloat = 50//self.velocityMagnitude + 50//changed //This is a huge problem if the body and eye speeds equal, maybe add body velocity to eye velocity??
        
        let eyeToshipVec = CGVector(dx: aShip.position.x - (self.position.x + theSocket.position.x*scaleSize), dy: aShip.position.y - (self.position.y + theSocket.position.y*scaleSize))
        
        let eyeToshipUnitVec = Alien.normalizeVector(eyeToshipVec)
        let eyeToshipSpeedVec = CGVector(dx: eyeToshipUnitVec.dx * eyeMoveSpeed, dy: eyeToshipUnitVec.dy * eyeMoveSpeed)
        
        //Factor in body velocity so that eye velocity is relative to the face
        theEye.physicsBody?.velocity = CGVector(dx: eyeToshipSpeedVec.dx + bossBodyVector.dx, dy: eyeToshipSpeedVec.dy + bossBodyVector.dy)
        
        
        //Keep the eye within eyeSocket bounds
        let rangeToCenterSprite = SKRange(lowerLimit: 0, upperLimit: theSocket.size.width/2 - theEye.size.width/2)
        var distanceConstraint: SKConstraint
        distanceConstraint = SKConstraint.distance(rangeToCenterSprite, toNode: theSocket)
        theEye.constraints = [distanceConstraint]

    }
    
    
    
    
    func updateAllEyes(aShip:Ship, bossBodyVector:CGVector){
        animateEye(aEyeBig,theSocket: socketBig, bossBodyVector: bossBodyVector, aShip: aShip)
        animateEye(aEyeSmall1,theSocket: socketSmall1,bossBodyVector: bossBodyVector, aShip: aShip)
        animateEye(aEyeSmall2,theSocket: socketSmall2,bossBodyVector: bossBodyVector, aShip: aShip)
    }
    
    
    
    
    
    
    
    func animateMouth() {
        
        let textureAtlas = SKTextureAtlas(named:"Sprites")
        //        let frames = ["bossAlienReal10","bossAlienReal10","bossAlienReal10","bossAlienReal9","bossAlienReal9","bossAlienReal9","bossAlienReal8","bossAlienReal8","bossAlienReal7","bossAlienReal7","bossAlienReal6","bossAlienReal6","bossAlienReal5","bossAlienReal4","bossAlienReal3","bossAlienReal2","bossAlienReal1","bossAlienReal0","bossAlienReal1","bossAlienReal2","bossAlienReal3","bossAlienReal4","bossAlienReal5","bossAlienReal6","bossAlienReal6","bossAlienReal7","bossAlienReal7","bossAlienReal8","bossAlienReal8","bossAlienReal9","bossAlienReal9","bossAlienReal9","bossAlienReal10","bossAlienReal10","bossAlienReal10"].map{textureAtlas.textureNamed($0)}// look up map
        //10->50 /10 =>  1->5
        //let animateSpeedFactor = Double(self.speed/100)
        let animate = SKAction.animateWithTextures(bossFrames, timePerFrame: 0.03)
        let forever = SKAction.repeatActionForever(animate)
        self.runAction(forever, withKey: "facialMotion")
        
    }
    
    
    
    
    
    
    
    
    
    
    func moveBody(vectorToShip vec:CGVector){
        self.physicsBody?.velocity = vec
    }
    
    
    
    
    func update(aShip:Ship){
        let unitToShipVector = Alien.normalizeVector(CGVector(dx: aShip.position.x - self.position.x, dy: aShip.position.y - self.position.y))
        let toShipVector = CGVector(dx: unitToShipVector.dx * self.velocityMagnitude ,dy:unitToShipVector.dy*self.velocityMagnitude)
        
        moveBody(vectorToShip: toShipVector)
        updateAllEyes(aShip, bossBodyVector:toShipVector)
        
        
        
    }
    
    
    
    
    
    
    
    func shot(){
        //boss has 10 lives totalLives
        let ratio = CGFloat(Double(self.lives)/Double(self.totalLives))
        
        //print(ratio)
        
        let blendFactor:CGFloat = 1 - ratio
        
        let color = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: blendFactor, duration: 0)
        
        self.runAction(color)
        
        self.lives -= 1
        
        //        if(self.lives < 1){
        //            bossOn = false
        //        }
        
        //print(self.lives)
        //print(blendFactor)
        
        
        if(self.lives < 1){
            self.removeFromParent()
        }
    }
    
    
    
    func boss_laser_contact(contact:SKPhysicsContact){
        
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
        
        //print(ratio)
        
        let blendFactor:CGFloat = 1 - ratio
        
        let color = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: blendFactor, duration: 0)
        
        boss?.runAction(color)
        
        self.lives -= 1
        
        //        if(self.lives < 1){
        //            bossOn = false
        //        }
        
        //print(self.lives)
        //print(blendFactor)
        
        
        //        if(self.lives < 1){
        //            boss!.removeFromParent()
        //            GameScene.numberBossesKilled += 1
        //            print(GameScene.numberBossesKilled)
        //        }
        
    }
    
    
    
    func drawDebugBox(){
        
        //let debugFrame = SKShapeNode(rectOfSize: CGSize(width: self.size.width,height: self.size.height))
        let debugFrame = SKShapeNode(rectOfSize: self.size)
        
        
        //let debugFrame = SKShapeNode.init(rect: self.frame) //This references the .frame which is the Scene's coordinates
        debugFrame.strokeColor = SKColor.redColor()
        self.addChild(debugFrame)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Originally attempted to use "Future" position to do distance checks of eyes
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}








