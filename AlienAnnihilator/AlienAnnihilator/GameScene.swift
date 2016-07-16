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
    //joystick config
    let joyStick = SKSpriteNode(imageNamed: "Sprites/joyStickHandle.jpg")
    let joyBase = SKSpriteNode(imageNamed: "Sprites/joyStickBase.jpg")
    var controllerOn:Bool = false
    
    
    override func didMoveToView(view: SKView) {
        
        //Set up the scene structure
        backgroundColor = SKColor.blackColor()
        ship.position = CGPoint(x:size.width * 0.1,y:size.height * 0.5)
        ship.setScale(0.3)
        
        //Physics of the ship
        ship.physicsBody?.dynamic = true
        ship.physicsBody?.allowsRotation = true
        ship.physicsBody?.affectedByGravity = true //??? OR nah
        ship.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"Sprites/fullShip.png"), size: ship.size)
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

    
    }
    
    
    
    //Define random functions
    func random(min:CGFloat, max:CGFloat) -> CGFloat{
        
        
        return CGFloat(arc4random_uniform(2))*(max-min) + min
    }
    
    
    
    
    
    func addAlien(){
        
        //Create the alien sprite
        let alien = SKSpriteNode(imageNamed:"alien.png")
        
        //Determine where to spawn the alien on the Y-axis (NOTE: in swift 2.2 you need argument labels
        let yStart = random(alien.size.height/2,max: size.height-alien.size.height)
        
        //Places the alien start just off screen in the x-axis
        alien.position = CGPoint(x: size.width+alien.size.width/2,y: yStart)
        
        //Add the Alien to the scene
        addChild(alien)
        
        
        /*Alien physics*/
        //Create a physics body for the sprite (a circle)
        alien.physicsBody = SKPhysicsBody(circleOfRadius: alien.size.height/2)
        
        //The sprite should be dynamic (i.e. the physics engine wont dictate movement- only actions will)
        alien.physicsBody?.dynamic = true
        
        //Defines what physics catagory the alien belongs to
//        alien.physicsBody?.categoryBitMask =
        
        
        
        
        
    }
    
    
//    func addMonster() {
//        
//        //Create sprite
//        let monster = SKSpriteNode(imageNamed:"monster")
//        
//        
//        //Makeshift:
//        //    let screenSize: CGRect = UIScreen.mainScreen().bounds
//        
//        //Deterime where to spawn the monster along the Y axis
//        let actualY = random(min:monster.size.height/2, max:size.height - monster.size.height/2)
//        
//        
//        monster.position = CGPoint(x:size.width + monster.size.width/2, y:actualY)
//        
//        //Add monster to the scene
//        addChild(monster)
//        
//        
//        /** Monster physics **/
//        
//        //Create a physics body for the sprite, defined as a rectangle
//        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
//        //Sprite is dynamic, the physics engine will not control movement (only the move actions will)
//        monster.physicsBody?.dynamic = true
//        //Sets the category bitmask to the monsterCategory defined above
//        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
//        //Categories of objects the object should notify the contact listener when they interesect
//        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
//        //This line handles collisions (not just contact) so like bouncing off ect - dont need it
//        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
//        
//        
//        
//        
//        
//        //Determine speed of the monster
//        let actualDuration = random(min:CGFloat(2.0), max:CGFloat(4.0))
//        
//        //Create the actions
//        let actionMove = SKAction.moveTo(CGPoint(x:-monster.size.width/2, y:actualY), duration: NSTimeInterval(actualDuration))
//        
//        let actionMoveDone = SKAction.removeFromParent()
//        
//        monster.runAction(SKAction.sequence([actionMove,actionMoveDone]))
//        
//    }

    
    
    
    
    
    
    

    
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
            
            
            
            
//            if((CGRectContainsPoint(joyBase.frame, location)){
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

            
            
            
            if(!CGRectContainsPoint(joyBase.frame, location)){
                let alien = SKSpriteNode(imageNamed: "Sprites/alien")
                alien.setScale(0.1)
                alien.position = location
                
                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
                
                alien.runAction(SKAction.repeatActionForever(action))
                
                self.addChild(alien)

            }
            
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
                let velocityVector:CGVector = CGVector(dx: xVelocity, dy: yVelocity)
                let v:CGVector = CGVector(dx:joyVector.dx,dy:joyVector.dy)
                //Use velocity vector to apply a force on the ship
//                ship.physicsBody?.applyForce(velocityVector)
                
                func normalizeVector(v:CGVector) -> CGVector{
                    
                    let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
                    
                    let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
                    
                    return ans
                }
                
                let unitVector:CGVector = normalizeVector(v)
                let forceVector:CGVector = CGVector(dx:unitVector.dx*200,dy:unitVector.dy*200)
                
                ship.physicsBody?.applyForce(forceVector)
                
            }
        }
    }

    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
    }


    
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       /* Called when a touch begins */
//        
//        for touch in touches {
//            
//            let location = touch.locationInNode(self)
//            let alien = SKSpriteNode(imageNamed: "Sprites/alien")
//            alien.setScale(0.1)
//            alien.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            alien.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(alien)
//        }
//    }
   
//
//
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in (touches as! Set<UITouch>){
//            let location = touch.locationInNode(self)
//        }
//    }
//
//
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in (touches as! Set<UITouch>){
//            let location = touch.locationInNode(self)
//        }
//    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    








}