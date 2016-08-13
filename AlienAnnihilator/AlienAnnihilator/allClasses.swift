//
//  allClasses.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/7/16.
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
        
        //We cannot shoot if we're still loading the gun
        if(stillLoading){
            return
        }
        
        //If the gun is done loading we can shoot
        addLaser()
        self.laser.physicsBody!.velocity = CGVector(dx:500,dy:0)
        
        //After shooting start loading gun timer again
        stillLoading = true
        self.loadingTime = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: #selector(GenericGun.finishLoading), userInfo: nil, repeats: false)
        
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
    

    init(startPos:CGPoint,speed: CGFloat){
        
        super.init(texture:trumpFaceTexture, startPosition: startPos, moveSpeed:speed, velocityVector:CGVector(dx: -1,dy: 0))
        
        //Trump set scale size
        //self.setScale(0.24)
        self.setScale(0.2)

        self.name = "normAlien"

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




class bossAlien1:Alien{
    
    //Variable eye movement
    var velocityMagnitude:CGFloat = 8
    
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
        
        //let texture = SKTextureAtlas(named:"sprites").textureNamed("croc_walk01")
        
        
        
        
        //shipPosition:CGPoint){
        let boss1Img = SKTextureAtlas(named:"Sprites").textureNamed("bossAlienReal0")


        
        
        let velocity = CGVector(dx: 0, dy:0)
        
        
        super.init(texture:boss1Img, startPosition: startPos, moveSpeed:velocityMagnitude, velocityVector:velocity)
        
        
        
        //Overwrite general aliens physics
        self.physicsBody?.categoryBitMask = PhysicsCategory.AlienBoss
        self.physicsBody?.collisionBitMask = 0//PhysicsCategory.Laser
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
        
    
        //Set name property
        self.name = "bossAlien"
        
        
        //Add Eye balls
        addEye(self.aEyeBig, theSocket:self.socketBig, position:CGPoint(x:0,y: self.size.height*1.58), scaleEye:1, scaleSocket:1)
        
        print("Boss height: ", self.size.height)
        print("Boss Socket height:", self.socketBig.size.height)
        
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
    
    
//    func animateEyeOriginal(theEye:SKSpriteNode, theSocket:SKSpriteNode, aShip:Ship){
//        let socketRadius:CGFloat = theSocket.size.width/2
//        
//        let eyeMoveSpeed:CGFloat = 50
//        let reSizeFactor:CGFloat = 0.2
//        var lastPosition = theEye.position
//        
//        //let toShipVectorEye = CGVector(dx: aShip.position.x - (self.position.x + socket.x), dy: aShip.position.y - (self.position.y + socket.y))
//        let toShipVectorEye = CGVector(dx: aShip.position.x - (self.position.x+theSocket.position.x*reSizeFactor), dy: aShip.position.y - (self.position.y + theSocket.position.y*reSizeFactor))
//        
//        print(toShipVectorEye)
//        
//        //let theVec = Alien.normalizeVector(vec)
//        let theVec = Alien.normalizeVector(toShipVectorEye)
//        
//        let xDist = theEye.position.x - theSocket.position.x
//        let yDist = theEye.position.y - theSocket.position.y
//        let dist = sqrt((xDist * xDist) + (yDist * yDist))
//        
//        print("eye pos: ", theEye.position)
//        print("socket pos: ", theSocket.position)
//
//        
//        func shiftEye(){
//            if(dist <= socketRadius - theEye.size.width/2){
//                lastPosition = theEye.position
//                theEye.physicsBody?.velocity = CGVector(dx:theVec.dx * eyeMoveSpeed, dy:theVec.dy * eyeMoveSpeed)
//                
//                print("in")
//            }
//            else{
//                let toCenterVector = Alien.normalizeVector( CGVector(dx:(theSocket.position.x - theEye.position.x), dy:(theSocket.position.y - theEye.position.y) ))
//                let toto = CGVector(dx:toCenterVector.dx*2, dy:toCenterVector.dy*2)
//                theEye.physicsBody?.velocity = toto//toCenterVector
//                print(toCenterVector)
//                print("Out")
//            }
//        }
//        
////        shiftEye()
////        shiftEye()
//
//    }
    
    func animateEye(theEye:SKSpriteNode, theSocket:SKSpriteNode, aShip:Ship){

        let eyeMoveSpeed:CGFloat = 50
        let reSizeFactor:CGFloat = 0.2

        let toShipVectorEye = CGVector(dx: aShip.position.x - (self.position.x+theSocket.position.x*reSizeFactor), dy: aShip.position.y - (self.position.y + theSocket.position.y*reSizeFactor))
        
//        let toShipVectorEye = CGVector(dx: -aShip.position.x + (self.position.x+theSocket.position.x*reSizeFactor), dy: -aShip.position.y + (self.position.y + theSocket.position.y*reSizeFactor))

        let theVec = Alien.normalizeVector(toShipVectorEye)
        theEye.physicsBody?.velocity = CGVector(dx:theVec.dx * eyeMoveSpeed, dy:theVec.dy * eyeMoveSpeed)
        
        //Keep the eye within eyeSocket bounds
        let rangeToCenterSprite = SKRange(lowerLimit: 0, upperLimit: theSocket.size.width/2 - theEye.size.width/2)
        var distanceConstraint: SKConstraint
        distanceConstraint = SKConstraint.distance(rangeToCenterSprite, toNode: theSocket)
        theEye.constraints = [distanceConstraint]
        
        
    }
    
    
    
    
    func updateAllEyes(aShip:Ship){
        animateEye(aEyeBig,theSocket: socketBig, aShip: aShip)
        animateEye(aEyeSmall1,theSocket: socketSmall1, aShip: aShip)
        animateEye(aEyeSmall2,theSocket: socketSmall2, aShip: aShip)
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
        updateAllEyes(aShip)
        
        
    
    }
    
    
    
    
    
    
    
    func shot(){
                    //boss has 10 lives totalLives
        let ratio = CGFloat(Double(self.lives)/Double(self.totalLives))
            
        print(ratio)
            
        let blendFactor:CGFloat = 1 - ratio
            
        let color = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: blendFactor, duration: 0)
            
        self.runAction(color)
        
        self.lives -= 1
        
//        if(self.lives < 1){
//            bossOn = false
//        }
        
        print(self.lives)
        print(blendFactor)
            
            
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
        
        print(ratio)
        
        let blendFactor:CGFloat = 1 - ratio
        
        let color = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: blendFactor, duration: 0)
        
        boss?.runAction(color)
        
        self.lives -= 1
        
//        if(self.lives < 1){
//            bossOn = false
//        }
        
        print(self.lives)
        print(blendFactor)
        
        
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








