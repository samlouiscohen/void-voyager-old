//
//  SpaceShip.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/14/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit



class GenericGun:SKNode{
    
    var laser: Laser = Laser()
    
    //Loading time properties of the gun
    var loadingTime:NSTimer?
    var stillLoading: Bool
    
    //Questionable
    override init(){
        
        stillLoading = false
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Ready the laser for fire
    func addLaser(){
        laser = Laser()
        //laser.position = self.position//CGPointMake(50,-18) //to get to the barrel of the gun
        self.addChild(laser)
    }
    
    //Ready laser and apply a foward velocity to it
    func shoot(){
        
        let loadTime:Double  = 0.5
        
        //We cannot shoot if we're still loading the gun
        if(stillLoading){
            return
        }
        
        //If the gun is done loading we can shoot
        addLaser()
        self.laser.physicsBody!.velocity = CGVector(dx:500,dy:0)
        
        //After shooting start loading gun timer again
        stillLoading = true
        
        
        self.loadingTime = NSTimer.scheduledTimerWithTimeInterval(loadTime, target: self, selector: #selector(GenericGun.finishLoading), userInfo: nil, repeats: false)
        
    }
    
    //Method that is called by the scheduledTimer after a shot and wait time
    func finishLoading(){
        self.loadingTime?.invalidate()
        stillLoading = false
    }
    
    
    
}


class Laser:SKSpriteNode{
    
    init(){
        
        super.init(texture: laserTexture, color: UIColor.clearColor(), size: laserTexture.size())
        //self.setScale()
        //Laser physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: laserTexture.size().width/2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Laser
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = 0;
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.linearDamping = 0.0;
        
        
        self.setScale(0.6)
        
        self.name = "laser"
        //remove()
    }
    
    
    func remove(){
        
        print("in function")
        if(self.position.x > (scene?.size.width)!/2){
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//Ship class-------------------------

class Ship:SKSpriteNode{
    
    static var shipState = "norm"
    var laser: Laser = Laser()
    
    //A dictionary with String keys and AnyType array values
    static var shipTypes: [String: [Any]] = [
        
        //Array structure: ship/laser textures, fireRate, health stats (maybe invincible on one?)
        "norm":[SKTexture(imageNamed:"Sprites/fullShip.png"), SKTexture(imageNamed:"Sprites/laser.jpg"),7],
        "rapid":[SKTexture(imageNamed:"Sprites/fullShip.png"),7],
        "bazooka":[SKTexture(imageNamed:"Sprites/fullShip.png"),7]
    ]
    
    
    
    
    //All variables as to allow for powerups?
    var moveSpeed:CGFloat
    
    var lives:Int
    
    var lasers = [SKSpriteNode]()
    var canShoot = false
    
    
    
    let gun = GenericGun()
    
    
    let scaleFactor:CGFloat = 0.5
    
    init(startPosition startPos:CGPoint, controllerVector:CGVector){
        
        self.lives = 3
        self.moveSpeed = 160
        
        super.init(texture: shipStartTexture, color: UIColor.clearColor(), size: shipStartTexture.size())
        
        
        //Position gun within sprite according to
        gun.position = CGPointMake(self.size.width/2 + (self.size.width/20),-self.size.width/30)
        self.addChild(gun)
        
        //self.drawDebugBox()
        self.setScale(scaleFactor)
        //Position is an property of SKSpriteNode so super must be called first
        self.position = startPos
        
        //Physics of the ship
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ship
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.angularVelocity = CGFloat(0)
        self.physicsBody?.affectedByGravity = false //TBD
        
        self.physicsBody?.velocity.dx = controllerVector.dx * moveSpeed
        self.physicsBody?.velocity.dy = controllerVector.dy * moveSpeed
        self.animateShip1()
        
        self.name = "ship"
        
    }
    
    
    func updateVelocity(v:CGVector){
        self.physicsBody?.velocity.dx = v.dx * moveSpeed
        self.physicsBody?.velocity.dy = v.dy * moveSpeed
    }
    
    
    
    
    
    
    func animateShip1() {
        
        let textureAtlas = SKTextureAtlas(named:"Sprites")//SKTextureAtlas(named:"shipBlink")
        
        let frames = ["shipSam1","shipSam2","shipSam3","shipSam4","shipSam5","shipSam6","shipSam7","shipSam8","shipSam9",
            "shipSam10","shipSam10","shipSam10","shipSam10","shipSam10",
            "shipSam9","shipSam8","shipSam7","shipSam6","shipSam5","shipSam4","shipSam3","shipSam2","shipSam1"].map{textureAtlas.textureNamed($0)}// look up map
        
        let animate = SKAction.animateWithTextures(frames, timePerFrame: 0.1)
        
        let forever = SKAction.repeatActionForever(animate)
        self.runAction(forever)
        
    }
    
    
    func updateShipProperties(shipVelocity v:CGVector,laserStartPos laserStart:CGPoint){
        updateVelocity(v)
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
