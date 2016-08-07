//
//  GameScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 7/14/16.
//  Copyright (c) 2016 GuacGetters. All rights reserved.

//Adding a power up where the bullets slow down so they just keep killling things that go into them??
//Get global timer for everything- alien spwans, when to add new alein types, ect.
//Kills should be a currency of sorts
//





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


var shipAnimationFrames : [SKTexture]!


//preload textures
let laserImage = SKTexture(imageNamed: "Sprites/laser.jpg")



class GameScene: SKScene, SKPhysicsContactDelegate {

    
    
    //Multiplers ordered as: speed, spawn time, lives?
    var normAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    var downAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    var behindAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    
    
    var downNotCalledYet = true
    var behindNotCalledYet = true
    

    
    
    //Build the Aliens killed Label
    private var aliensKilled = 0 {
        didSet{
            self.aliensKilledLabel?.text = "Dead Foes: "+String(aliensKilled)
        }
    }
    private var aliensKilledLabel:SKLabelNode?
    
    //Instantiate the ship
    var aShip = Ship(startPosition: CGPoint(x:50,y:200), controllerVector: controlVector)
    
    //Build the shipLives label
    private var shipLives = 3 {
        didSet{
            self.shipLivesLabel?.text = "Lives: " + String(shipLives)
        }
    }
    private var shipLivesLabel:SKLabelNode?
    

    //controller configthis is the way to d
    let controlStick = SKSpriteNode(imageNamed: "Sprites/controllerHandle_2.png")
    let controlBase = SKSpriteNode(imageNamed: "Sprites/controllerBase3.png")
    var controllerOn:Bool = false
    
    
    
    
    override func didMoveToView(view: SKView) {
        
        
        //So when we go back to scene the ship isnt moving from the last played game
        controlVector = CGVector(dx: 0,dy: 0)

        let aliensKilledLabel = SKLabelNode(fontNamed: "Times New Roman")
        //aliensKilledLabel.text = aliensKilled.description
        aliensKilledLabel.text = "Foes Killed': " + String(aliensKilled)
        aliensKilledLabel.fontSize = 14
        aliensKilledLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*0.8,y:CGRectGetMidY(self.frame)*0.1)
        self.addChild(aliensKilledLabel)
        self.aliensKilledLabel = aliensKilledLabel
        
        
        let shipLivesLabel = SKLabelNode(fontNamed: "Times New Roman")
        shipLivesLabel.text = "Lives: " + String(aShip.lives)
        shipLivesLabel.fontSize = 14
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
        controlBase.position = CGPoint(x:size.width*0.075, y:size.height*0.1)
        controlBase.size = CGSize(width: 90, height: 90)
        controlBase.zPosition = 1
        addChild(controlBase)
        
        //Establish the stick
        controlStick.position = controlBase.position
        controlStick.size = CGSize(width: 50, height: 50)
        controlStick.zPosition = 2
        addChild(controlStick)

        //Make semi-transparent
        controlBase.alpha = 0.25
        controlStick.alpha = 0.25
        
        
        
        //Start spawning normal aliens immediately
        startSpawningNorm()
        

    }
    
    
    
    //Building the aliens (Why is this seperate
    func startSpawningNorm(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addNormAlien),
            SKAction.waitForDuration(Double(random(1,max: 4))-Double(normAlienMultiplers[1])),
            SKAction.runBlock(updateNormMultipliers)
            ])))
    }
    
    func startSpawningDown(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addDownAlien),
            SKAction.waitForDuration(Double(random(10,max: 15))-Double(downAlienMultiplers[1])),
            SKAction.runBlock(updateDownMultipliers)
            ])))
    }
    
    func startSpawningBehind(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addBehindAlien),
            SKAction.waitForDuration(Double(random(10,max: 20))-Double(behindAlienMultiplers[1])),
            SKAction.runBlock(updateBehindMultipliers)
            ])))
    }
    
    
    
    
    func killOffAlien(alien:SKNode){
        
        func stopMotion(){
            alien.physicsBody?.categoryBitMask = 0
            alien.physicsBody?.collisionBitMask = 0
            alien.physicsBody?.contactTestBitMask = 0
            
            alien.physicsBody?.dynamic = false
            alien.physicsBody?.velocity = CGVector(dx:0, dy:0)
            alien.removeActionForKey("facialMotion")
            
        }

        
        func removeAlien(){
            alien.removeFromParent()
        }
        
        let stopMoving = SKAction.runBlock(stopMotion)
        let color = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.7, duration: 0)

        let fadeOut = SKAction.fadeOutWithDuration(1)
        let removeFromParent = SKAction.runBlock(removeAlien)
        
        let die = SKAction.sequence([stopMoving, color, fadeOut, removeFromParent])

        alien.runAction(die)
    }
    
    
    
    
    func alien_laser_contact(contact:SKPhysicsContact){
        var alien:SKNode? = nil
        if contact.bodyA.categoryBitMask == PhysicsCategory.Alien && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            alien = contact.bodyA.node
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.Alien && contact.bodyA.categoryBitMask == PhysicsCategory.Laser{
            alien = contact.bodyB.node
        }
        else{
            return
        }
        
        aliensKilled = aliensKilled + 1
        aShip.lives = aShip.lives - 1
        
        killOffAlien((alien)!)
        

    }
    
    
    
    
    
    func alien_ship_contact(contact:SKPhysicsContact){
        var alien:SKNode? = nil
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.Alien && contact.bodyB.categoryBitMask == PhysicsCategory.Ship{
            alien = contact.bodyA.node
            
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.Alien && contact.bodyA.categoryBitMask == PhysicsCategory.Ship{
            alien = contact.bodyB.node

        }
        else{
            return
        }

        aliensKilled = aliensKilled + 1
        shipLives = shipLives-1
        aShip.lives = aShip.lives - 1
        
        killOffAlien((alien)!)
        
    }
    
    
    
    func didBeginContact(contact:SKPhysicsContact){
        alien_laser_contact(contact)
        alien_ship_contact(contact)
        
        
        if(aliensKilled > 10 && downNotCalledYet){
            startSpawningDown()
            downNotCalledYet = false
        }
        if(aliensKilled > 20 && behindNotCalledYet){
            startSpawningBehind()
            behindNotCalledYet = false
        }
        
        //Create and go to the game over scene if the ship has 0 lives
        if(shipLives<1){
            gameOver()
        }
        
        
    }
    func gameOver(){
        let gameOverScene = GameOverScene(size: self.size, aliensKilled: self.aliensKilled)
        //self.view?.presentScene(gameOverScene, transition: reveal)
        self.view?.presentScene(gameOverScene, transition: SKTransition.fadeWithColor(SKColor.redColor(), duration: 3))
    }
    

    func random(min:UInt32, max:UInt32) -> CGFloat{
        return CGFloat(arc4random_uniform(max - min) + min)
        //return CGFloat(arc4random_uniform(2))*(max-min) + min
    }
    
    

    
    //Make all this code way more compact later
    func updateNormMultipliers(){
        normAlienMultiplers[0] = normAlienMultiplers[0]*1.01
        normAlienMultiplers[1] = normAlienMultiplers[1]*1.01
    }
    func updateDownMultipliers(){
        downAlienMultiplers[0] = downAlienMultiplers[0]*1.01
        downAlienMultiplers[1] = downAlienMultiplers[1]*1.01
    }
    func updateBehindMultipliers(){
        behindAlienMultiplers[0] = behindAlienMultiplers[0]*1.01
        behindAlienMultiplers[1] = behindAlienMultiplers[1]*1.01
    }
    
    
    
    
    
    //Functions to create new alien instances with progressive difficulty
    func addNormAlien(){

        let mult = normAlienMultiplers
        
        let alienInst = normAlien(startPos:CGPoint(x: 10,y: 10), speed: random(UInt32(10),max: UInt32(50))*mult[0])
        let yStart = random(UInt32(alienInst.size.height/2), max: UInt32(size.height-alienInst.size.height))
        alienInst.position = CGPoint(x:size.width+alienInst.size.width/2, y:CGFloat(yStart))
        
        addChild(alienInst)
    }
    
    func addDownAlien(){
        
        let mult = downAlienMultiplers
        
        let alienInst = downAlien(startPos:CGPoint(x: 10,y: 10),speed: random(UInt32(10),max: UInt32(30))*mult[0])
        //this line makes no sense, maybe use lasy variables or something
        let xStart = random(UInt32(alienInst.size.width/2), max: UInt32(size.width-alienInst.size.width))
        alienInst.position = CGPoint(x: xStart, y:CGFloat(size.height + alienInst.size.width/2))
        addChild(alienInst)
    }
    
    func addBehindAlien(){
        
        let mult = behindAlienMultiplers
        
        let alienInst = behindAlien(startPos:CGPoint(x: 10,y: 10),speed: random(UInt32(5),max: UInt32(40))*mult[0])
        let yStart = random(UInt32(alienInst.size.height/2), max: UInt32(size.height-alienInst.size.height))
        alienInst.position = CGPoint(x: -alienInst.size.width/2, y:CGFloat(yStart))
        addChild(alienInst)
    }
    
    
    
    

    
    func normalizeVector(v:CGVector) -> CGVector{
        let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
        let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
        return ans
    }
    
    


    
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
    
    func goToGameScene(){
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size) // create your new scene
        let transition = SKTransition.fadeWithDuration(1.0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = SKSceneScaleMode.Fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)
            startingTouches[touch as! UITouch] = location
            
            if(CGRectContainsPoint(controlBase.frame, location)){
                controllerOn = true
            }
            else{
                controllerOn = false
                
                aShip.gun.shoot()
            }
            
//            if(CGRectContainsPoint(aShip.frame, location)){
//                goToGameScene()
//            }
            
        }
    }

    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)

            //The starting location of the given touch we're working with
            let touchStartPoint:CGPoint = startingTouches[touch as! UITouch]!
            
            
            //Play with this - Is it better than using the controller on??? (Note: u can move into the frame of the controller and move it)
            //if(controllerOn == true){
            if(CGRectContainsPoint(controlBase.frame, location)){
            
                let joyVector = CGVector(dx:location.x - controlBase.position.x, dy:location.y - controlBase.position.y)
                
                
                //Get angle between two components opp/adj of controlStick vector with arctan
                let angle = atan2(joyVector.dy, joyVector.dx)
                //Revise this- it's unneccasary because I normalize the vector anyway
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

            
                //Float bc cosf only takes floats not CGFloats -> what is the real difference?
                //let degree = angle * CGFloat(180/M_PI)
                //var calcRotation:Float = Float(angle-1.57879633) + Float(M_PI_2)
                //let xVelocity = 50 * CGFloat(cosf(calcRotation))
                //let yVelocity = 50 * CGFloat(sinf(calcRotation))
                
                let v:CGVector = CGVector(dx:joyVector.dx,dy:joyVector.dy)
                let unitVector:CGVector = normalizeVector(v)
                controlVector = CGVector(dx:unitVector.dx,dy:unitVector.dy)
                

 
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
            
            //Does this make any more sense than the commented code below it?
            //difference is that this code if speaking strictly about touch's location at start time rather than location at end time!
            
            //Reset if touch that is on controller is lifted or if no fingers are on the screen
            if(CGRectContainsPoint(controlBase.frame, startingTouches[touch as! UITouch]!)){
                resetController()
            }
//            if(startingTouches.count < 1){
//                resetController()
//            }
        
            //REmove the touch
            startingTouches.removeValueForKey(touch as! UITouch)
        }

    }
    
//    
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//        for touch:AnyObject in touches!{
//            
//            startingTouches.removeAll()
//            
//        }
//    }
//    
    
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        // list all values
//        print("Values of startingTouches: ")
//        for (key, value) in startingTouches {
//            print(value)
//        }
        

//        print(startingTouches.count)
//        if(startingTouches.count < 1){
//            resetController()
//        }
//        print(aShip.position)

//        boss.moveBody()
        
        
        aShip.updateShipProperties(shipVelocity: controlVector, laserStartPos: CGPoint(x:0,y:0))
        
        if(shipLives<1){
            enumerateChildNodesWithName("normAlien", usingBlock: gameOverBounceMode)
            enumerateChildNodesWithName("downAlien", usingBlock: gameOverBounceMode)
            enumerateChildNodesWithName("behindAlien", usingBlock: gameOverBounceMode)

        }
        
        //Screen boundries (Loop ship position)
        if(aShip.position.x > self.size.width){
            aShip.position.x = 0
        }
        if(aShip.position.x < 0){
            aShip.position.x = self.size.width
        }
        if(aShip.position.y > self.size.height + aShip.size.height/2){
            aShip.position.y = 0
        }
        if(aShip.position.y < 0){
            aShip.position.y = self.size.height - aShip.size.height/2
        }
        
        
    }


    func gameOverBounceMode(node:SKNode, abool:UnsafeMutablePointer<ObjCBool>){
//        node.physicsBody?.velocity = CGVector(dx:0,dy:0)
        node.physicsBody?.categoryBitMask = 0
    }
    

    
    
    
//---------------------------------------------------------------------------------------------------------------------------------------------

    
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
            laser.position = self.position//CGPointMake(50,-18) //to get to the barrel of the gun
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
    
//    let lasere = SKTexture(imageNamed: "Sprites/laser.jpg")
    
    class Laser:SKSpriteNode{
        
        init(){
            
//            let laser = SKTexture(imageNamed: "Sprites/laser.jpg")
            
            super.init(texture: laserImage, color: UIColor.clearColor(), size: laserImage.size())
            self.setScale(3)
            //Laser physics
            self.physicsBody = SKPhysicsBody(circleOfRadius: laserImage.size().width/2)
            self.physicsBody?.dynamic = true
            self.physicsBody?.categoryBitMask = PhysicsCategory.Laser
            self.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
            self.physicsBody?.collisionBitMask = PhysicsCategory.None
            self.physicsBody?.collisionBitMask = 0;
            self.physicsBody?.usesPreciseCollisionDetection = true
            self.physicsBody?.linearDamping = 0.0;
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
        
        
        
        
//        static var shipImage = SKTexture(imageNamed:"Sprites/fullShip.png")//: Int = Int(shipTypes[shipState]![0])
//        let shipImage = SKTexture(imageNamed:"shipBlink/samShip1")
//        
        
        let shipImage = SKTexture(imageNamed:"Sprites/shipSam1.png")

        
        init(startPosition startPos:CGPoint, controllerVector:CGVector){
            
            
            self.lives = 3
            
            self.moveSpeed = 160

//            let shipImage = SKTexture(imageNamed:"Sprites/fullShip.png")
            
            //Call super initilizer
            //super.init(texture: Ship.shipImage, color: UIColor.clearColor(), size: Ship.shipImage.size())
            super.init(texture: shipImage, color: UIColor.clearColor(), size: shipImage.size())

            
            gun.position = CGPointMake(165,-10)
            self.addChild(gun)

            
            self.setScale(0.08)
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
            
            let textureAtlas = SKTextureAtlas(named:"shipBlink")
            
            let frames = ["shipSam1","shipSam2","shipSam3","shipSam4","shipSam5","shipSam6","shipSam7","shipSam8","shipSam9",
                "shipSam10","shipSam10","shipSam10","shipSam10","shipSam10",
                "shipSam9","shipSam8","shipSam7","shipSam6","shipSam5","shipSam4","shipSam3","shipSam2","shipSam1",].map{textureAtlas.textureNamed($0)}// look up map

            let animate = SKAction.animateWithTextures(frames, timePerFrame: 0.1)
            
            let forever = SKAction.repeatActionForever(animate)
            self.runAction(forever)
            
        }
        
        
        func updateShipProperties(shipVelocity v:CGVector,laserStartPos laserStart:CGPoint){
            updateVelocity(v)
            //animateShip()
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
        
        //static let alienImage = SKTexture(imageNamed:"Sprites/trumpFace.png")
        static let alienImage = SKTexture(imageNamed:"Sprites/trumpFace.png")

        
        init(startPos:CGPoint,speed: CGFloat){
            
            super.init(texture:normAlien.alienImage, startPosition: startPos, moveSpeed:speed, velocityVector:CGVector(dx: -1,dy: 0))
            
            //Trump set scale size
            self.setScale(0.24)
            
            self.name = "normAlien"
            self.animateTrump()
            self.zPosition = 1
            
            
        }
        
        func animateTrump() {
            
            let textureAtlas = SKTextureAtlas(named:"trumpMoveMouth")
            
            let frames = ["trumpFaceOpen1","trumpFaceOpen2","trumpFaceOpen3","trumpFaceOpen4"].map{textureAtlas.textureNamed($0)}// look up map
            
            let animate = SKAction.animateWithTextures(frames, timePerFrame: 0.1)
            
            let forever = SKAction.repeatActionForever(animate)
            self.runAction(forever, withKey: "facialMotion")

        }


        
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    //Downward alien with Mikes face
    class downAlien:Alien{
        
        static let alienImage = SKTexture(imageNamed:"Sprites/mikeFace2.png")
        
        init(startPos:CGPoint,speed: CGFloat){
            
            super.init(texture:downAlien.alienImage, startPosition: startPos, moveSpeed:speed, velocityVector:CGVector(dx: 0,dy: -1))
            //Mike set scale size
            self.setScale(0.5)
            self.name = "downAlien"
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
    
    
    class behindAlien:Alien{
        
        static let alienImage = SKTexture(imageNamed:"Sprites/alien.png")
        
        init(startPos:CGPoint,speed: CGFloat){
            
            super.init(texture:behindAlien.alienImage, startPosition: startPos, moveSpeed:speed, velocityVector:CGVector(dx: 1,dy: 0))
            //Alien set scale size
            self.setScale(0.15)
            self.xScale = -self.xScale
            self.name = "behindAlien"
            self.animateAlien1()
        }
        
        
        func animateAlien1() {
            
            let textureAtlas = SKTextureAtlas(named:"Alien1Atlas")
            let frames = ["alienType1_3","alienType1_4 copy","alienType1_5 copy","alienType1_6 copy","alienType1_7","alienType1_8 copy","alienType1_9 copy","alienType1_10 copy",
                
                "alienType1_9","alienType1_8 copy","alienType1_7 copy","alienType1_6 copy","alienType1_5","alienType1_4 copy","alienType1_3"
                
                ].map{textureAtlas.textureNamed($0)}// look up map
            //10->50 /10 =>  1->5
            let animateSpeedFactor = Double(self.speed/100)
            let animate = SKAction.animateWithTextures(frames, timePerFrame: 0.08 - animateSpeedFactor)
            let forever = SKAction.repeatActionForever(animate)
            self.runAction(forever, withKey: "facialMotion")

        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    




    
    
    
    
    class bossAlien1:Alien{
        
        //Variable eye movement
        var velocityMagnitude:CGFloat = 15
        
        var shipPos:CGPoint

        var eye1:SKSpriteNode = SKSpriteNode(imageNamed:"eye1")
        var eye2:SKSpriteNode = SKSpriteNode(imageNamed:"eye2")
        var eye1Vector:CGVector
        
        
        
        
        init(startPos:CGPoint, shipPosition:CGPoint){
            let boss1Img = SKTexture(imageNamed:"Sprites/boss1Img_1")
//            eye1 = SKTexture(imageNamed:"Sprites/boss1_eyeImg")
//            eye2 = SKTexture(imageNamed:"Sprites/boss1_eyeImg")//Or have different eyes
            
            shipPos = shipPosition
            
            eye1Vector = CGVector(dx: shipPos.x - eye1.position.x, dy: shipPos.y - eye1.position.y )
            

            var velocity = CGVector(dx: 0, dy:0)
            
            super.init(texture:boss1Img, startPosition: startPos,
                       moveSpeed:velocityMagnitude, velocityVector:velocity)
            
            //Overwrite general aliens physics
            self.physicsBody?.categoryBitMask = 0
            self.physicsBody?.collisionBitMask = 0
            self.physicsBody?.contactTestBitMask = 0
            
            var eye1Coord = self.position
            var eye2Coord = self.position
            
            
            
        }
        
        
        
        
        func moveBody(){
            self.physicsBody?.velocity = CGVector(dx: shipPos.x - self.position.x, dy: shipPos.y - self.position.y )

            
            
        }
        
        
        
        
        
        func drawEyes(){
            
            self.eye1.position = self.position
            
            self.addChild(eye1)
            
            self.animateEyes()
        }
        
        func animateEyes(){
            
            //Has to be called in update
            
            let socketRadius = CGFloat(100) //socketSprite.size.width/2
            let socket = CGPoint(x: self.position.x-100, y: self.position.y-100)
            var xDist = self.eye1.position.x - socket.x
            var yDist = self.eye1.position.y - socket.y
            
            
            var dist = sqrt((xDist * xDist) + (yDist * yDist))
            
            if(dist > socketRadius){
                
                
                
            }

            
        }
        
        
        
        //Eye vector is from socket to ship and similarly, speed=0 if it would go out of bounds (Or rather, speed is 0 but only not in the area if statement: 
        
        //USe circle so radius (dist from center of socket<something)
        
        //Alein direction vector is from alien location to ship location, speed TBD
        
        
        
        
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    //Timer structure
//    
//    var timer = Timer(interval: 5.0, delegate: self)
    
    
    
    
    
    
    
    
    
    

}





































