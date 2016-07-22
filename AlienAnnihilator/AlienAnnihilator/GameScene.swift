//
//  GameScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 7/14/16.
//  Copyright (c) 2016 GuacGetters. All rights reserved.
//

/* NOTES & Ideas
 *
 *
 */




import SpriteKit

//Set up the physics catagories (each bit of the 32 is a catagory)
struct PhysicsCategory {
    static let None      :  UInt32 = 0;
    static let All       :  UInt32 = UInt32.max
    static let Alien   :  UInt32 = 0b1
    static let Laser:  UInt32 = 0b10
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    /**Name controller over this**?*/
    //Ship
    let ship = SKSpriteNode(imageNamed: "Sprites/fullShip.png")
    let laser = SKSpriteNode(imageNamed: "Sprites/laser.jpg")
    //joystick config
    let joyStick = SKSpriteNode(imageNamed: "Sprites/joyStickHandle.jpg")
    let joyBase = SKSpriteNode(imageNamed: "Sprites/joyStickBase.jpg")
    var controllerOn:Bool = false
    
    
    override func didMoveToView(view: SKView) {
        
        //Set up the scene structure
        backgroundColor = SKColor.blackColor()
        ship.position = CGPoint(x:size.width * 0.1,y:size.height * 0.5)
        ship.setScale(0.2)
        
        //Physics of the ship
        ship.physicsBody?.dynamic = true
        ship.physicsBody?.allowsRotation = true
        ship.physicsBody?.affectedByGravity = true //??? OR nah
        ship.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"Sprites/fullShip.png"), size: ship.size)
        ship.physicsBody?.collisionBitMask = 0;
        addChild(ship)
        
        //Does self reference the window or all sprites?
//        self.anchorPoint = CGPoint(x:0.5, y:0.5)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        
        /* Set up for the controller */
        //Establish the base
        joyBase.position = CGPoint(x:size.width*0.1, y:size.height*0.1)
        joyBase.size = CGSize(width: 100, height: 100)
        addChild(joyBase)
        //Establish the stick
        joyStick.position = joyBase.position
        joyStick.size = CGSize(width: 50, height: 50)
        addChild(joyStick)
        
        //Make semi-transparent
        joyBase.alpha = 0.5
        joyStick.alpha = 0.5
        
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addAlien), SKAction.waitForDuration(Double(random(1.0,max: 2.0)))])))
        
//        let aAlien = normAlien(startPos:CGPoint(x:100,y:100), speed:5)
//        print(aAlien.physicsBody)
        
//        let aAlien = normAlien(startPos:CGPoint(x:100,y:100), speed:5)
////                let aPlayfulAlien = normAlien(startPos:CGPoint(x:0,y:size.height/2), speed:100)
//        //        aAlien.physicsBody?.velocity = CGVector(dx:50,dy:0)
////                aPlayfulAlien.physicsBody?.applyForce(CGVector(dx:5,dy:0))
//        addChild(aAlien)
        
        
    }
    
    
    
    //Define random functions
    func random(min:CGFloat, max:CGFloat) -> CGFloat{
        return CGFloat(arc4random_uniform(2))*(max-min) + min
    }
    
    func addAlien(){
        
//        //Create the alien sprite
//        let alien = SKSpriteNode(imageNamed:"Sprites/alien.png")
//        alien.setScale(0.1)
//        
//        //Determine where to spawn the alien on the Y-axis (NOTE: in swift 2.2 you need argument labels
//        let yStart = random(alien.size.height/2, max: size.height-alien.size.height)
//        
//        //Places the alien start just off screen in the x-axis
//        alien.position = CGPoint(x: size.width+alien.size.width/2,y: yStart)
//        
//        //Add the Alien to the scene
//        addChild(alien)
//        
//        
//        /*Alien physics*/
//        //Create a physics body for the sprite (a circle)
//        alien.physicsBody = SKPhysicsBody(circleOfRadius: alien.size.height/2)
//        //The sprite should be dynamic (i.e. the physics engine wont dictate movement- only actions will)
//        alien.physicsBody?.dynamic = true
//        //Defines what physics catagory the alien belongs to
//        alien.physicsBody?.categoryBitMask = PhysicsCategory.Alien
//        //Categories of objects the object should notify the contact listener when they interesect 
//        alien.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
//        //This line handles collisions (not just contact) so like bouncing off ect - dont need it
//        alien.physicsBody?.collisionBitMask = PhysicsCategory.None
//        
//
//        //Create time to cross screen
//        let travelTime:Double = Double(random(2, max: 4))
//        
//        //Create actions
//        let alienMove = SKAction.moveTo(CGPoint(x: -alien.size.width/2,y: yStart), duration: travelTime)
//        //Remove alien
//        let alienOffScreen = SKAction.removeFromParent()
//        
//        alien.runAction(SKAction.sequence([alienMove,alienOffScreen]))
        
        
        
        
//        let yStart = random(aAlien.size.height/2, max: size.height-aAlien.size.height)
        let travelTime:Double = Double(random(2, max: 4))
        let travelSpeed:CGFloat = CGFloat(random(10, max: 14))
//        let alienMove = SKAction.moveTo(CGPoint(x: -aAlien.size.width/2,y: yStart), duration: travelTime)
        //Remove alien
        let alienOffScreen = SKAction.removeFromParent()
        
        
////        let aAlien = normAlien(startPos:CGPoint(x:-aAlien.size.width/2,y:yStart), speed:travelSpeed)
//        let aPlayfulAlien = normAlien(startPos:CGPoint(x:0,y:size.height/2), speed:100)
////        aAlien.physicsBody?.velocity = CGVector(dx:50,dy:0)
////        aPlayfulAlien.physicsBody?.applyForce(CGVector(dx:5,dy:0))
//        addChild(aPlayfulAlien)
//        
//        let act = SKAction.runBlock(aPlayfulAlien.motion(CGVector(dx:1,dy:0), multiplier:CGFloat(100)))
//        
//        aPlayfulAlien.runAction(SKAction.sequence([alienOffScreen]))

       
        
//        let aAlien = normAlien(startPos:CGPoint(x:0,y:size.height/2), speed:100)
//
//        aAlien.physicsBody?.velocity = CGVector(dx:100,dy:0)
//        addChild(aAlien)
        
//        
//        let act = SKAction.runBlock(aAlien.motion(CGVector(dx:1,dy:0), multiplier:CGFloat(100)))
//        
//        aPlayfulAlien.runAction(SKAction.sequence([alienOffScreen]))
//        
        
        
    }
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    func loadLaser(){
        
//        let laser = SKSpriteNode(imageNamed: "Sprites/laser")
        
        let laser = SKSpriteNode(imageNamed: "Sprites/laser.jpg")
        laser.position = ship.position
        addChild(laser)
        
        //Laser physics
        laser.physicsBody = SKPhysicsBody(circleOfRadius: laser.size.width/2)
        laser.physicsBody?.dynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.Laser
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser.physicsBody?.collisionBitMask = 0;
        //Used for fast & small moving bodies
        laser.physicsBody?.usesPreciseCollisionDetection = true
//        print("load?")
//        addChild(laser)
        
        
        
        
        
        
        
    }
    
    func normalizeVector(v:CGVector) -> CGVector{
        let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
        let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
        return ans
    }
    func shoot(){
        
        //Figure out how to delay ("reload")
        //Figure out why moving away from the bullet speeds it up
        
        let laser = SKSpriteNode(imageNamed: "Sprites/laser.jpg")
        laser.position = ship.position
        laser.setScale(0.5)
        addChild(laser)
        
        //Laser physics
        laser.physicsBody = SKPhysicsBody(circleOfRadius: laser.size.width/2)
        laser.physicsBody?.dynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.Laser
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser.physicsBody?.collisionBitMask = 0;
        //Used for fast & small moving bodies
        laser.physicsBody?.usesPreciseCollisionDetection = true
        let currShipY = ship.position.y
        
        laser.physicsBody?.applyForce(CGVector(dx: 200.0,dy: 0))
        
        if(laser.physicsBody?.velocity.dx > 50){
            laser.physicsBody?.velocity.dx = 50
        }
        
        laser.physicsBody?.velocity = CGVector(dx: 10.0,dy: 0)
//        print(laser.physicsBody?.velocity)
        
//        let moveLaser = SKAction.moveTo(CGPoint(x: size.width,y: currShipY), duration: 3)
        
        
//        laser.runAction(moveLaser)

    }
    
    
    
    func shootLaser(){
        
        let currShipY = ship.position.y
        
        let moveLaser = SKAction.moveTo(CGPoint(x: size.width,y: currShipY), duration: 5)
        
        
       laser.runAction(moveLaser)
    }
    
    
    
    
    
    
    
    
    
    
    

    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch : AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let actionBouger = SKAction.moveTo(CGPoint(x: location.x, y: location.y), duration: 2.5)
//            ship.runAction(actionBouger)
//            
//            let dx = location.x - ship.position.x
//            let dy = location.y - ship.position.y
//            var angleInRadians = atan2(dy, dx) - CGFloat(M_PI_2)
//            
//            if(angleInRadians < 0){
//                angleInRadians = angleInRadians + 2 * CGFloat(M_PI)
//            }
//            
//            ship.zRotation = angleInRadians
//            
//            let actionAngle = SKAction.rotateToAngle(angleInRadians, duration: 0)
//            ship.runAction(actionAngle)
//        }
//    }
    

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches as! Set<UITouch>){
            let location = touch.locationInNode(self)
            
            if(CGRectContainsPoint(joyBase.frame, location)){
                controllerOn = true
            }
            else{
                controllerOn = false
            }
        }
    }

    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)
            
            
            if(!CGRectContainsPoint(joyBase.frame, location)){
//                let alien3 = SKSpriteNode(imageNamed: "Sprites/alien")
//
//                alien3.setScale(0.1)
//                alien3.position = location
//                alien3.physicsBody = SKPhysicsBody(circleOfRadius: alien3.size.width/2)
//                print("fake")
//                print(alien3)
//                print(alien3.physicsBody)
//                print("---------------")
//                print(alien.physicsBody)
//                alien.physicsBody?.velocity = CGVector(dx:10,dy:0)
//                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//                alien.runAction(SKAction.repeatActionForever(action))
//                self.addChild(alien)
                
                let alien = normAlien(startPos:location,speed: CGFloat(10))
                print("real")
                print(alien)
//                alien.physicsBody = SKPhysicsBody(circleOfRadius: alien.size.width/2)
                print("PhysicsBody:->>>>")
                print(alien.physicsBody)
                
                self.addChild(alien)
                
            }
            
//            if((CGRectContainsPoint(joyBase.frame, location)){
//            
////                let alien = normAlien(startPos:CGPoint(x:100,y:100),speed: CGFloat(10))
            
//            
//            }
            
            
//            if((CGRectContainsPoint(joyBase.frame, location)){
//                let alien = SKSpriteNode(imageNamed: "Sprites/alien")
//                alien.setScale(0.1)
//                alien.position = location
//                alien.physicsBody = SKPhysicsBody(circleOfRadius: alien.size.width/2)
//            
//                print(alien.physicsBody)
//                alien.physicsBody?.velocity = CGVector(dx:10,dy:0)
////                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
////            
////                alien.runAction(SKAction.repeatActionForever(action))
//            
//                self.addChild(alien)
//            }

            
            
            
//            if(!CGRectContainsPoint(joyBase.frame, location)){
//                let alien = SKSpriteNode(imageNamed: "Sprites/alien")
//                alien.setScale(0.1)
//                alien.position = location
//                
//                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//                
//                alien.runAction(SKAction.repeatActionForever(action))
//                
//                self.addChild(alien)

//            }
            
            if(controllerOn == true){
                
                let joyVector = CGVector(dx:location.x - joyBase.position.x, dy:location.y - joyBase.position.y)
                //ARCtan grabs the angle formed by opp/adj ratio in right triangle
                let angle = atan2(joyVector.dy, joyVector.dx)
                
                let degree = angle * CGFloat(180/M_PI)
                
                //????
                let length:CGFloat = joyBase.frame.size.height
                
                
                let xDist:CGFloat = sin(angle - 1.5879633) * length
                let yDist:CGFloat = cos(angle - 1.57879633) * length
                
                //Keep the stick on its "base"
                if(CGRectContainsPoint(joyBase.frame, location)){
                    joyStick.position = location
                }
                else{
                    joyStick.position = CGPoint(x:joyBase.position.x - xDist, y:joyBase.position.y - yDist)
                }
                //A rotation *about* the z-axis: what number is this
                ship.zRotation = angle - 1.57879633
                
                
                var shipRotation:CGFloat = ship.zRotation
                //Float bc cosf only takes floats not CGFloats -> what is the real difference?
                var calcRotation:Float = Float(angle-1.57879633) + Float(M_PI_2)
                let xVelocity = 50 * CGFloat(cosf(calcRotation))
                let yVelocity = 50 * CGFloat(sinf(calcRotation))
//                let velocityVector:CGVector = CGVector(dx: xVelocity, dy: yVelocity)
                let v:CGVector = CGVector(dx:joyVector.dx,dy:joyVector.dy)
                //Use velocity vector to apply a force on the ship
//                ship.physicsBody?.applyForce(velocityVector)
                
//                func normalizeVector(v:CGVector) -> CGVector{
//                    let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
//                    let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
//                    return ans
//                }
                
                let unitVector:CGVector = normalizeVector(v)
                let velocityVector:CGVector = CGVector(dx:unitVector.dx*200,dy:unitVector.dy*200)
//                let forceVector:CGVector = CGVector(dx:unitVector.dx*200,dy:unitVector.dy*200)
                
                ship.physicsBody?.velocity = velocityVector
//                ship.physicsBody?.applyForce(forceVector)
                
                if(ship.position.x>self.size.width){
                    ship.position.x = 0
                }
                
            }
        }
    }

    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)
            if(!CGRectContainsPoint(joyBase.frame, location)){
                shoot()
            }
        }
        
        
        if(controllerOn){
            let move:SKAction = SKAction.moveTo(joyBase.position, duration: 0.2)
            //Causes the animation to slow as it progresses
            move.timingMode = .EaseOut
            
            joyStick.runAction(move)
            ship.physicsBody?.velocity = CGVector(dx:0.0,dy:0.0)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        alien.physicsBody?.velocity = CGVector(dx:10,dy:0)
        
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
            self.physicsBody?.collisionBitMask = 0 //Do I need this? or jsut use in laser class
            self.physicsBody?.contactTestBitMask = PhysicsCategory.Laser
            self.physicsBody?.usesPreciseCollisionDetection = true
            
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
        
        static let alienImage = SKTexture(imageNamed:"Sprites/alien.png")

        init(startPos:CGPoint,speed: CGFloat){
            
            super.init(texture:normAlien.alienImage, startPosition: startPos, moveSpeed:speed,velocityVector:CGVector(dx: 1,dy: 0))
            self.setScale(0.1)
            
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
//    func boxedZigZag()->SKAction{
//    
//        let path = 'left',
//    
//        let path:CGPath = CGPath()
//        
//       let moveRight = SKAction
//        
//    
//    }






}