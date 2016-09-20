# AlienAnnihilator


Efficiency issues:

Moved updateShip properties from update to touchesMoved









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

