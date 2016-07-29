//
//  GameScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 7/14/16.
//  Copyright (c) 2016 GuacGetters. All rights reserved.
//

/* NOTES & Ideas
 * Lazy variables for init on undefined like spaceship start vat
 *        //Adding a power up where the bullets slow down so they just keep killling things that go into them?? (no linear damping)

 *In main menu allow for access of cheat codes to add peoples faces as the shooter ect. (in ship or as alein- they get to choose)
 
 */


/*
 
 Gun class: has timing function to determine when bullet is loaded
 
 bullet is a class that is instantiated within Gun- this is now a sprite node that has physics, speed, images
 
 maybe a new instance is created each time??? That would make it easier to change the features of the bullet as well
 
 
 
 
 
 */




//addLaser readys it for fire, but its not drawn/moving until user touches screen
//Add laser should be what is restricted- by both time and the number of lasers in the array
//A eventual upgrade could be that lasers are continually reloaded and you can use all at once
//Maybe even use a "power bar of sorts where a pressure hold makes a ball laser blast"



//Timer shouldnt even matter or change until the holder is empty, so countdown only when no bullets are in storage, and stop count when it says bullet is ready (Or counter is up and a bullet is loaded)

//        let bulletReady = SKAction.runBlock{
//            theShip.canShoot = true
//        }

/*
 
 func addLaser: make laser obj, store in theShip holder
 
 inGun: if(timer==0 && theShip.lasers<1) -> addLaser()
 [timer should run on node?????]
 
 
 func shoot: set laser speed, const y pos, startpos, and addChild
 
 
 userTap: if(aShip.canShoot): shoot()
 
 
 */
//---------------------------------------------------------------------------------------------------------------------------------------------








import SpriteKit

//Set up the physics catagories for collisions (each bit of the 32 is a catagory)
struct PhysicsCategory {
    static let None      :  UInt32 = 0;
    static let All       :  UInt32 = UInt32.max
    static let Alien     :  UInt32 = 0b1
    static let Laser     :  UInt32 = 0b10
    static let Ship      :  UInt32 = 0b11
}

var controlVector:CGVector = CGVector(dx: 0, dy: 0)

class GameScene: SKScene, SKPhysicsContactDelegate {

    //Build the Aliens killed Label
    private var aliensKilled = 0 {
        didSet{
            self.aliensKilledLabel?.text = aliensKilled.description
        }
    }
    private var aliensKilledLabel:SKLabelNode?
    
    
    //Build the shipLives label
    private var shipLives = 0 {
        didSet{
            self.shipLivesLabel?.text = (aShip.lives).description
        }
    }
    private var shipLivesLabel:SKLabelNode?
    
    
    //Instantiate the ship
    var aShip = Ship(startPosition: CGPoint(x:50,y:200),controllerVector: controlVector)

    //controller config
    let controlStick = SKSpriteNode(imageNamed: "Sprites/controlStick2.png")
    let controlBase = SKSpriteNode(imageNamed: "Sprites/controlBase.png")
    var controllerOn:Bool = false
    
    
    override func didMoveToView(view: SKView) {
        
        let killedStartLabel = SKLabelNode(fontNamed: "Times New Roman")
        killedStartLabel.fontSize = 24
        killedStartLabel.text = "Aliens Killed: "
        let aliensKilledLabel = SKLabelNode(fontNamed: "Times New Roman")
        aliensKilledLabel.text = killedStartLabel.text! + aliensKilled.description
        aliensKilledLabel.fontSize = 14
        aliensKilledLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*0.8,y:CGRectGetMidY(self.frame)*0.1)
        self.addChild(aliensKilledLabel)
        self.aliensKilledLabel = aliensKilledLabel
        
        let shipLivesLabel = SKLabelNode(fontNamed: "Times New Roman")
        shipLivesLabel.text = (aShip.lives).description
        shipLivesLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*1.3,y:CGRectGetMidY(self.frame)*0.1)
        self.addChild(shipLivesLabel)
        self.shipLivesLabel = shipLivesLabel
        
        //Set up the scene structure
        backgroundColor = SKColor.blackColor()
        
        addChild(aShip)

        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        
        /* Set up for the controller */
        //Establish the base
        controlBase.position = CGPoint(x:size.width*0.1, y:size.height*0.1)
        controlBase.size = CGSize(width: 100, height: 100)
        controlBase.zPosition = 1
        addChild(controlBase)
        
        //Establish the stick
        controlStick.position = controlBase.position
        controlStick.size = CGSize(width: 50, height: 50)
        controlStick.zPosition = 2
        addChild(controlStick)


        
        //Make semi-transparent
        controlBase.alpha = 0.5
        controlStick.alpha = 0.5
        
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addAlien), SKAction.waitForDuration(Double(random(1,max: 2)))])))
        
    }
    
    
    
    func alien_laser_contact(contact:SKPhysicsContact){
        var alien:SKNode? = nil
        if contact.bodyA.categoryBitMask == PhysicsCategory.Alien && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            alien = contact.bodyA.node
            //            alien?.removeFromParent()
            //            aliensKilled = aliensKilled + 1
            aShip.lives = aShip.lives - 1
            
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.Alien && contact.bodyA.categoryBitMask == PhysicsCategory.Laser{
            alien = contact.bodyB.node
            //            alien?.removeFromParent()
            //            aliensKilled = aliensKilled + 1
            aShip.lives = aShip.lives - 1
            
        }
        else{
            //            print("tits")
            return
        }
        
        alien?.removeFromParent()
        aliensKilled = aliensKilled + 1
        aShip.lives = aShip.lives - 1
    }
    
    
    func alien_ship_contact(contact:SKPhysicsContact){
        var alien:SKNode? = nil
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.Alien && contact.bodyB.categoryBitMask == PhysicsCategory.Ship{
            alien = contact.bodyA.node
            aShip.lives = aShip.lives - 1
            //            alien?.removeFromParent()
            //            aliensKilled = aliensKilled + 1
            
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.Alien && contact.bodyA.categoryBitMask == PhysicsCategory.Ship{
            alien = contact.bodyB.node
            aShip.lives = aShip.lives - 1
            
            //            alien?.removeFromParent()
            //            aliensKilled = aliensKilled + 1
            
        }
        else{
            //            print("tits")
            aShip.lives = aShip.lives - 1

            return
        }
        
        alien?.removeFromParent()
        aliensKilled = aliensKilled + 1
        aShip.lives = aShip.lives - 1
        
        
    }
    
    
    
    func didBeginContact(contact:SKPhysicsContact){
        print(aShip.lives)
        aShip.lives = aShip.lives - 1
        alien_laser_contact(contact)
        alien_ship_contact(contact)
    }
    
    
    
    //Define random function
    func random(min:UInt32, max:UInt32) -> UInt32{
        return UInt32(arc4random_uniform(max - min) + min)
      //return CGFloat(arc4random_uniform(2))*(max-min) + min
    }
    
    
    func addAlien(){
        let alienInst = normAlien(startPos:CGPoint(x: 10,y: 10),speed: CGFloat(100))
        let yStart = random(UInt32(alienInst.size.height/2), max: UInt32(size.height-alienInst.size.height))
        alienInst.position = CGPoint(x:size.width+alienInst.size.width/2, y:CGFloat(yStart))
        addChild(alienInst)
    }
    

    
    func normalizeVector(v:CGVector) -> CGVector{
        let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
        let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
        return ans
    }
    
//    func shoot(){
//        
//        //Figure out how to delay ("reload")
//        //Figure out why moving away from the bullet speeds it up
//        
//        let laser = SKSpriteNode(imageNamed: "Sprites/laser.jpg")
//        laser.position.x = aShip.position.x + (aShip.size.width / 2)
//        laser.position.y = aShip.position.y - (aShip.size.height * 0.04)
//        laser.setScale(0.5)
//        addChild(laser)
//        
//        //Laser physics
//        laser.physicsBody = SKPhysicsBody(circleOfRadius: laser.size.width/2)
//        laser.physicsBody?.dynamic = true
//        laser.physicsBody?.categoryBitMask = PhysicsCategory.Laser
//        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
//        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
//        laser.physicsBody?.collisionBitMask = 0;
//        //Used for fast & small moving bodies
//        laser.physicsBody?.usesPreciseCollisionDetection = true
//        let currShipY = aShip.position.y
//        
//        //THE MISSING PIECE!!! HAZAHHH!!!
//        laser.physicsBody?.linearDamping = 0.0;
//        
////        laser.physicsBody?.applyForce(CGVector(dx: 200.0,dy: 0))
////        if(laser.physicsBody?.velocity.dx > 50){
////            laser.physicsBody?.velocity.dx = 50
////        }
//        
//        laser.physicsBody?.velocity = CGVector(dx: 400.0,dy: 0)
//
//    }
    
    


    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch : AnyObject in touches {
//            let location = touch.locationInNode(self)
//            let actionBouger = SKAction.moveTo(CGPoint(x: location.x, y: location.y), duration: 2.5)
//            ship.runAction(actionBouger)
//            let dx = location.x - ship.position.x
//            let dy = location.y - ship.position.y
//            var angleInRadians = atan2(dy, dx) - CGFloat(M_PI_2)
//            if(angleInRadians < 0){
//                angleInRadians = angleInRadians + 2 * CGFloat(M_PI)
//            }
//            ship.zRotation = angleInRadians
//            let actionAngle = SKAction.rotateToAngle(angleInRadians, duration: 0)
//            ship.runAction(actionAngle)
//        }
//    }
    

    
    //A dictionary to hold all touch start locations
    var startingTouches = [UITouch : CGPoint]()
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)
            startingTouches[touch as! UITouch] = location
            
//            aShip.gun.shoot()
            
            if(CGRectContainsPoint(controlBase.frame, location)){
                controllerOn = true
            }
            else{
                controllerOn = false
                
                aShip.gun.shoot()
            }
        }
    }

    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)

            //The starting location of the given touch we're working with
            let touchStartPoint:CGPoint = startingTouches[touch as! UITouch]!

            //If the touch started outside of the controlStick than it can spawn aliens and shoot
//            if(!CGRectContainsPoint(controlBase.frame, touchStartPoint)){
//                let alien = normAlien(startPos:location,speed: CGFloat(10))
//                self.addChild(alien)
//            }
            
            
            //Play with this - Is it better than using the controller on??? (Note: u can move into the frame of the controller and move it)
            //if(controllerOn == true){
            if(CGRectContainsPoint(controlBase.frame, location)){
            
                let joyVector = CGVector(dx:location.x - controlBase.position.x, dy:location.y - controlBase.position.y)
                //ARCtan grabs the angle formed by opp/adj ratio in right triangle
                let angle = atan2(joyVector.dy, joyVector.dx)
                
                let degree = angle * CGFloat(180/M_PI)
                let length:CGFloat = controlBase.frame.size.height
                let xDist:CGFloat = sin(angle - 1.5879633) * length
                let yDist:CGFloat = cos(angle - 1.57879633) * length
                
                //Keep the stick on its "base"
                if(CGRectContainsPoint(controlBase.frame, location)){
                    controlStick.position = location
                }
                else{
                    controlStick.position = CGPoint(x:controlBase.position.x - xDist, y:controlBase.position.y - yDist)
                }
                //A rotation *about* the z-axis: what number is this
//                ship.zRotation = angle - 1.57879633
                
//                var shipRotation:CGFloat = ship.zRotation
                //Float bc cosf only takes floats not CGFloats -> what is the real difference?
                var calcRotation:Float = Float(angle-1.57879633) + Float(M_PI_2)
                let xVelocity = 50 * CGFloat(cosf(calcRotation))
                let yVelocity = 50 * CGFloat(sinf(calcRotation))
                
                let v:CGVector = CGVector(dx:joyVector.dx,dy:joyVector.dy)
                
//                func normalizeVector(v:CGVector) -> CGVector{
//                    let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
//                    let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
//                    return ans
//                }
                
                let unitVector:CGVector = normalizeVector(v)
//                let velocityVector:CGVector = CGVector(dx:unitVector.dx*200,dy:unitVector.dy*200)
                
                controlVector = CGVector(dx:unitVector.dx,dy:unitVector.dy)
                
                
                //Ship motion derived from controller
                
                //Ship boundries
                if(aShip.position.x > self.size.width){
                    print("right")
                    aShip.position.x = 0
                }
                if(aShip.position.x<0){
                    print("left")
                    aShip.position.x = self.size.width
                }
                if(aShip.position.y > self.size.height + aShip.size.height/2){
                    print("up")
                    aShip.position.y = 0
                }
                if(aShip.position.y<0){
                    aShip.position.y = self.size.height - aShip.size.height/2
                    print("down")
                }
 
            }
        }
        

    }

    
    func resetController(){
        let move:SKAction = SKAction.moveTo(controlBase.position, duration: 0.2)
        //Causes the animation to slow as it progresses
        move.timingMode = .EaseOut
        controlStick.runAction(move)
        controlVector = CGVector(dx:0,dy:0)
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            
            
            
            //????If your finger that was on the controller is lifted then move controlStick back to the center
            
            
            
            //Does this make any more sense than the commented code below it?
            //difference is that this code if speaking strictly about touch's location at start time rather than location at end time!
            if(CGRectContainsPoint(controlBase.frame, startingTouches[touch as! UITouch]!)){
                resetController()
            }
            
            //Nah wait this actually makes sense I think
            //Leads to jerky response time as controller reset everytime a finger is lifted?
//            if(CGRectContainsPoint(controlBase.frame, location)){
//                resetController()
//            }
            
            
            
            //REmove the touch
            startingTouches.removeValueForKey(touch as! UITouch)
        }
        

        
        //If the controller was on when the touch ended then reset?? Shouldnt this cover the code above it???
//        if(controllerOn){
//            resetController()
//        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        // list all values
        print("Values of startingTouches: ")
        for (key, value) in startingTouches {
            print(value)
        }
        
        aShip.updateShipProperties(shipVelocity: controlVector, laserStartPos: CGPoint(x:0,y:0))

    }



    

    
    
    
//---------------------------------------------------------------------------------------------------------------------------------------------
    
    //Attempt using Add child
    
    
    
    class GenericGun:SKNode{

        var laser: Laser = Laser()
        
        
        //Questionable
        override init(){
            super.init()
        }
    
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //Ready the laser for fire
        func addLaser(){
            laser = Laser()
            laser.position = CGPointMake(30,-18) //to get to the barrel of the gun
            self.addChild(laser)
        }
        
        //Ready laser and apply a foward velocity to it
        func shoot(){
            addLaser()
            self.laser.physicsBody!.velocity = CGVector(dx:500,dy:0)
        }

    }
    
    
    class Laser:SKSpriteNode{
        
        //Adding a power up where the bullets slow down so they just keep killling things that go into them??
        init(){
            
            let laser = SKTexture(imageNamed: "Sprites/laser.jpg")
            
            super.init(texture: laser, color: UIColor.clearColor(), size: laser.size())
            self.setScale(2)
            //Laser physics
            self.physicsBody = SKPhysicsBody(circleOfRadius: laser.size().width/2)
            self.physicsBody?.dynamic = true
            self.physicsBody?.categoryBitMask = PhysicsCategory.Laser
            self.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
            self.physicsBody?.collisionBitMask = PhysicsCategory.None
            self.physicsBody?.collisionBitMask = 0;
            self.physicsBody?.usesPreciseCollisionDetection = true
            self.physicsBody?.linearDamping = 0.0;
            self.physicsBody?.velocity = CGVector(dx:100,dy:0)
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
        
        
        
        
        static var shipImage = SKTexture(imageNamed:"Sprites/fullShip.png")//: Int = Int(shipTypes[shipState]![0])
        
        
        init(startPosition startPos:CGPoint, controllerVector:CGVector){
            
            self.lives = 3
            self.moveSpeed = 200

            
            //Call super initilizer
            super.init(texture: Ship.shipImage, color: UIColor.clearColor(), size: Ship.shipImage.size())
            
            gun.position = self.position
            self.addChild(gun)

            
            self.setScale(0.2)
            //Position is an property of SKSpriteNode so super must be called first
            self.position = startPos
            
            //Physics of the ship
            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
            self.physicsBody?.dynamic = true
            self.physicsBody?.collisionBitMask = 0//PhysicsCategory.Ship
            self.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
            self.physicsBody?.allowsRotation = false
            self.physicsBody?.angularVelocity = CGFloat(0)
            self.physicsBody?.affectedByGravity = false //TBD
            
            self.physicsBody?.velocity.dx = controllerVector.dx * moveSpeed
            self.physicsBody?.velocity.dy = controllerVector.dy * moveSpeed
            
        }
        
        func updateVelocity(v:CGVector){
            
//            if(v == CGVector(dx:0,dy:0)){
//                self.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
//            }
            self.physicsBody?.velocity.dx = v.dx * moveSpeed
            self.physicsBody?.velocity.dy = v.dy * moveSpeed
        }
        
        func updateLaserPos(){
            //            laser.position = self.position
        }
        
        func updateShipProperties(shipVelocity v:CGVector,laserStartPos laserStart:CGPoint){
            updateVelocity(v)
            updateLaserPos()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    
    
    
    
//---------------------------------------------------------------------------------------------------------------------------------------------
//    //Laser and Gun classes
//    
//    
//    
//    class genericGun:SKNode{
//        
//        var theShip:Ship
//        var theGameScene:GameScene
//        
//        init(gameScene:GameScene, shipInstance:Ship){
//            theShip = shipInstance
//            theGameScene = gameScene
//            super.init()
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        //Good
//        func addLaser(){
//            let aLaser = Laser(laserPosition: theShip.position)
//            theShip.lasers.append(aLaser)
//        }
//        
//        //If statement on user touch to call this
//        func shoot(){
//            //Pull out the laser from the ship
//            let availableLaser = theShip.lasers.removeLast()
//            
//            let constY:CGFloat = theShip.position.y
//            availableLaser.position = CGPoint(x: theShip.position.x, y:constY)
//            //Set its speed
//            availableLaser.physicsBody?.velocity = CGVector(dx: 400.0,dy: 0)
//            //Add it to the scene
//            theGameScene.addChild(availableLaser)
//            
//            theShip.canShoot = false
//            
//            func printHey(){print("Hey!!!!!!!!!!!!!!!!!!!!!!")}
//            let sayHey = SKAction.runBlock{printHey()}
//            let reloadTime = SKAction.waitForDuration(1)
//            let loadGun = SKAction.sequence([reloadTime, sayHey])
//            
//            theShip.runAction(SKAction.repeatActionForever(loadGun))
//            
//        }
//    }
//    
//    
//    
//    class Laser:SKSpriteNode{
//        
//        
//        //Adding a power up where the bullets slow down so they just keep killling things that go into them??
//        init(laserPosition:CGPoint){
//            
//            let laser = SKTexture(imageNamed: "Sprites/laser.jpg")
//            
//            super.init(texture: laser, color: UIColor.clearColor(), size: laser.size())
//            
//            //Laser physics
//            self.physicsBody = SKPhysicsBody(circleOfRadius: laser.size().width/2)
//            self.physicsBody?.dynamic = true
//            self.physicsBody?.categoryBitMask = PhysicsCategory.Laser
//            self.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
//            self.physicsBody?.collisionBitMask = PhysicsCategory.None
//            self.physicsBody?.collisionBitMask = 0;
//            self.physicsBody?.usesPreciseCollisionDetection = true
//            self.physicsBody?.linearDamping = 0.0;
//        }
//        
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        
//        
//    }
//
//    
//    
//    
//    
//    //Ship class-------------------------
//    
//    class Ship:SKSpriteNode{
//        
//        static var shipState = "norm"
//        
//        //A dictionary with String keys and AnyType array values
//        static var shipTypes: [String: [Any]] = [
//            
//            //Array structure: ship/laser textures, fireRate, health stats (maybe invincible on one?)
//            "norm":[SKTexture(imageNamed:"Sprites/fullShip.png"), SKTexture(imageNamed:"Sprites/laser.jpg"),7],
//            "rapid":[SKTexture(imageNamed:"Sprites/fullShip.png"),7],
//            "bazooka":[SKTexture(imageNamed:"Sprites/fullShip.png"),7]
//        ]
//        
//        //All variables as to allow for powerups?
//        var moveSpeed:CGFloat
//        var lives:Int
//        
//        var lasers = [SKSpriteNode]()
//        var canShoot = false
//        var aGun: genericGun? = nil
//        var theGameScene:GameScene
//        
//        
//        
//        static var shipImage = SKTexture(imageNamed:"Sprites/fullShip.png")//: Int = Int(shipTypes[shipState]![0])
//        
//        
//        init(gameScene:GameScene, startPosition startPos:CGPoint, controllerVector:CGVector){
//            
//            self.lives = 3
//            self.moveSpeed = 200
//            theGameScene = gameScene
//            
//            //Call super initilizer
//            super.init(texture: Ship.shipImage, color: UIColor.clearColor(), size: Ship.shipImage.size())
//            
//            
//            self.aGun = genericGun(gameScene: theGameScene, shipInstance: self)
//            
//            
//            self.setScale(0.2)
//            //Position is an property of SKSpriteNode so super must be called first
//            self.position = startPos
//            
//            //Physics of the ship
//            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
//            self.physicsBody?.dynamic = true
//            self.physicsBody?.collisionBitMask = 0//PhysicsCategory.Ship
//            self.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
//            self.physicsBody?.allowsRotation = false
//            self.physicsBody?.angularVelocity = CGFloat(0)
//            self.physicsBody?.affectedByGravity = false //TBD
//            
//            self.physicsBody?.velocity.dx = controllerVector.dx * moveSpeed
//            self.physicsBody?.velocity.dy = controllerVector.dy * moveSpeed
//            
//        }
//        
//        
//        func updateVelocity(v:CGVector){
//            
//            if(v == CGVector(dx:0,dy:0)){
//                self.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
//            }
//            self.physicsBody?.velocity.dx = v.dx * moveSpeed
//            self.physicsBody?.velocity.dy = v.dy * moveSpeed
//        }
//        
//        func updateLaserPos(){
//            //            laser.position = self.position
//        }
//        
//        func updateShipProperties(shipVelocity v:CGVector,laserStartPos laserStart:CGPoint){
//            updateVelocity(v)
//            updateLaserPos()
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//    }
//
    
    
    
    
    
    
//---------------------------------------------------------------------------------------------------------------------------------------------

    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
//   Abstract classes & offshoots
    
//    class LaserGun{
//        
//        init(laserStartPos: CGPoint){
//            
//        }
//        
//        static var canShoot = true
//        
//        //Should be inherited through ship and var with powerups
//        static var reloadTime = SKAction.waitForDuration(1)
//        
//        static let bulletReady = SKAction.runBlock{
//            canShoot = true
//            var laser = Laser(startPos: CGPoint(x: 200,y: 200))
//        }
//        
//        let loadGun = SKAction.sequence([reloadTime, bulletReady])
//        
//        self.runAction(loadGun)
//        
////        if(bulletIsShot){
////            canShoot = false
////            self.runAction(loadGun)
////        }
//    
//    }
//    
//    
//    
//    class Laser:SKSpriteNode{
//        init(startPos pos: CGPoint){
//            
//            let laser = SKTexture(imageNamed: "Sprites/laser.jpg")
//            
//            super.init(texture: laser, color: UIColor.clearColor(), size: laser.size())
//            
//            //self.position = Ship.getPos()//CGPoint(x: 200,y: 200)
//            //                self.position.x = aShip.position.x + (aShip.size.width / 2)
//            //                self.position.y = aShip.position.y - (aShip.size.height * 0.04)
//            
//            self.position = pos
//            self.setScale(0.5)
//            print("FUCK YEAH")
//            print(self.position)
//        }
//        
//        
//        
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    }
    
    
    

    
//    //Laser and Gun classes
//    
//    
//    class genericGun{
//
//        var theShip:Ship
//        var theGameScene:GameScene
//        
//        init(gameScene:GameScene, shipInstance:Ship){
//            theShip = shipInstance
//            theGameScene = gameScene
//        }
//        
//        //Good
//        func addLaser(){
//            let aLaser = Laser(laserPosition: theShip.position)
//            theShip.lasers.append(aLaser)
//        }
//        
//        //If statement on user touch to call this
//        func shoot(){
//            //Pull out the laser from the ship
//            let availableLaser = theShip.lasers.removeLast()
//            
//            let constY:CGFloat = theShip.position.y
//            availableLaser.position = CGPoint(x: theShip.position.x, y:constY)
//            //Set its speed
//            availableLaser.physicsBody?.velocity = CGVector(dx: 400.0,dy: 0)
//            //Add it to the scene
//            theGameScene.addChild(availableLaser)
//            
//            theShip.canShoot = false
//            
//            
//            
//            
//            func printHey(){print("Hey!!!!!!!!!!!!!!!!!!!!!!")}
//            let sayHey = SKAction.runBlock{printHey()}
//            let reloadTime = SKAction.waitForDuration(1)
//            let loadGun = SKAction.sequence([reloadTime, sayHey])
//            
//            theShip.runAction(SKAction.repeatActionForever(loadGun))
//            
//        }
//    }
//    
//    
//    
//    class Laser:SKSpriteNode{
//    
//        
//        //Adding a power up where the bullets slow down so they just keep killling things that go into them??
//        init(laserPosition:CGPoint){
//            
//            let laser = SKTexture(imageNamed: "Sprites/laser.jpg")
//            
//            super.init(texture: laser, color: UIColor.clearColor(), size: laser.size())
//            
//            //Laser physics
//            self.physicsBody = SKPhysicsBody(circleOfRadius: laser.size().width/2)
//            self.physicsBody?.dynamic = true
//            self.physicsBody?.categoryBitMask = PhysicsCategory.Laser
//            self.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
//            self.physicsBody?.collisionBitMask = PhysicsCategory.None
//            self.physicsBody?.collisionBitMask = 0;
//            //Used for fast & small moving bodies
//            self.physicsBody?.usesPreciseCollisionDetection = true
////            let currShipY = aShip.position.y
//            
//            //THE MISSING PIECE!!! HAZAHHH!!!
//            self.physicsBody?.linearDamping = 0.0;
//            
//            
//        }
//
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        
//        
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
//    class Ship:SKSpriteNode{
//        
//        static var shipState = "norm"
//        
//        //A dictionary with String keys and AnyType array values
//        static var shipTypes: [String: [Any]] = [
//            
//            //Array structure: ship/laser textures, fireRate, health stats (maybe invincible on one?)
//            "norm":[SKTexture(imageNamed:"Sprites/fullShip.png"), SKTexture(imageNamed:"Sprites/laser.jpg"),7],
//            "rapid":[SKTexture(imageNamed:"Sprites/fullShip.png"),7],
//            "bazooka":[SKTexture(imageNamed:"Sprites/fullShip.png"),7]
//        ]
//        
//        //All variables as to allow for powerups?
//        var moveSpeed:CGFloat
//        var lives:Int
//        
//        var lasers = [SKSpriteNode]()
//        var canShoot = false
//        var aGun: genericGun?
//        
//        
//        //Force unwrap
//        static var shipImage = SKTexture(imageNamed:"Sprites/fullShip.png")//: Int = Int(shipTypes[shipState]![0])
//
//        
//        init(gameScene:GameScene, startPosition startPos:CGPoint, controllerVector:CGVector){
//
//            self.lives = 3
//            self.moveSpeed = 200
//            
//            
//            //Call super initilizer
//            super.init(texture: Ship.shipImage, color: UIColor.clearColor(), size: Ship.shipImage.size())
//            
//            
////            self.aGun = genericGun(gameScene, shipInstance: self)
//            
//
//            self.setScale(0.2)
//            //Position is an property of SKSpriteNode so super must be called first
//            self.position = startPos
//            
//            //Physics of the ship
//            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
//            self.physicsBody?.dynamic = true
//            self.physicsBody?.collisionBitMask = 0//PhysicsCategory.Ship
//            self.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
//            self.physicsBody?.allowsRotation = false
//            self.physicsBody?.angularVelocity = CGFloat(0)
//            self.physicsBody?.affectedByGravity = false //TBD
//            
//            self.physicsBody?.velocity.dx = controllerVector.dx * moveSpeed
//            self.physicsBody?.velocity.dy = controllerVector.dy * moveSpeed
//            
//            
//            
//            
////            var gun = LaserGun(laserStartPos: self.position)
//            
//            
//            
//            
//            
//        }
//
//    
//        //Updating methods
//        
////        func shootGun(){
////            gun.shoo
////            
////            
////        }
//        
//        
//        
//        func updateVelocity(v:CGVector){
//            
//            if(v == CGVector(dx:0,dy:0)){
//                self.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
//            }
//            self.physicsBody?.velocity.dx = v.dx * moveSpeed
//            self.physicsBody?.velocity.dy = v.dy * moveSpeed
//        }
//        func updateLaserPos(){
////            laser.position = self.position
//        }
//        
//        
//
//        
//        func updateShipProperties(shipVelocity v:CGVector,laserStartPos laserStart:CGPoint){
//            updateVelocity(v)
//            updateLaserPos()
//        }
//        
////        static func getPos() -> CGPoint{
////            return self.position
////        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
// 
//    }
//    
    
    
    
    
    //ALL GOOD STUFF IN THIS SHIP CLASS FYI
    
//    class Ship:SKSpriteNode{
//        
//        static var shipState = "norm"
//        
//        //A dictionary with String keys and AnyType array values
//        static var shipTypes: [String: [Any]] = [
//            
//            //Array structure: ship/laser textures, fireRate, health stats (maybe invincible on one?)
//            "norm":[SKTexture(imageNamed:"Sprites/fullShip.png"), SKTexture(imageNamed:"Sprites/laser.jpg"),7],
//            "rapid":[SKTexture(imageNamed:"Sprites/fullShip.png"),7],
//            "bazooka":[SKTexture(imageNamed:"Sprites/fullShip.png"),7]
//        ]
//        
//        //All variables as to allow for powerups?
//        var moveSpeed:CGFloat
//        var lives:Int
//        
//        var lasers = [SKSpriteNode]()
//        var canShoot = false
////        var aGun: genericGun?
//        
//        
//        //Force unwrap
//        static var shipImage = SKTexture(imageNamed:"Sprites/fullShip.png")//: Int = Int(shipTypes[shipState]![0])
//        
//        
//        init(startPosition startPos:CGPoint, controllerVector:CGVector){
//            
//            self.lives = 3
//            self.moveSpeed = 200
//            
//            
//            //Call super initilizer
//            super.init(texture: Ship.shipImage, color: UIColor.clearColor(), size: Ship.shipImage.size())
//            
//            
//            //            self.aGun = genericGun(gameScene, shipInstance: self)
//            
//            
//            self.setScale(0.2)
//            //Position is an property of SKSpriteNode so super must be called first
//            self.position = startPos
//            
//            //Physics of the ship
//            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
//            self.physicsBody?.dynamic = true
//            self.physicsBody?.collisionBitMask = 0//PhysicsCategory.Ship
//            self.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
//            self.physicsBody?.allowsRotation = false
//            self.physicsBody?.angularVelocity = CGFloat(0)
//            self.physicsBody?.affectedByGravity = false //TBD
//            
//            self.physicsBody?.velocity.dx = controllerVector.dx * moveSpeed
//            self.physicsBody?.velocity.dy = controllerVector.dy * moveSpeed
//            
//            
//            
//            
//            //            var gun = LaserGun(laserStartPos: self.position)
//            
//            
//            
//            
//            
//        }
//        
//
//        func updateVelocity(v:CGVector){
//            
//            if(v == CGVector(dx:0,dy:0)){
//                self.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
//            }
//            self.physicsBody?.velocity.dx = v.dx * moveSpeed
//            self.physicsBody?.velocity.dy = v.dy * moveSpeed
//        }
//        
//        func updateLaserPos(){
////            laser.position = self.position
//        }
//        
//        func updateShipProperties(shipVelocity v:CGVector,laserStartPos laserStart:CGPoint){
//            updateVelocity(v)
//            updateLaserPos()
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//    }
    
    
    
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
        
        static let alienImage = SKTexture(imageNamed:"Sprites/mikeFace.png")

        init(startPos:CGPoint,speed: CGFloat){
            
            super.init(texture:normAlien.alienImage, startPosition: startPos, moveSpeed:speed,velocityVector:CGVector(dx: -1,dy: 0))
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