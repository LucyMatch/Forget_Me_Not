/*
 * Custom Data Type Example - Virtual Dice
 *
 *   Click the mouse to roll the virtual dice. Receive virtual dice rolls
 *   from other apps that publish dice data.
 * 
 */

import spacebrew.*;

String server="sandbox.spacebrew.cc";
String name="water your plants";
String description ="Client that sends and receives a virtual dice roll - a number between 1 and 6.";


Spacebrew sb;

// Keep track of our current place in the range
int water_can = 0;
int remote_dice = 0;

void setup() {
  size(400, 200);
  background(0);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "water_your_plant", "watercan", water_can ); 


  // connect!
  sb.connect(server, name, description );
  
}

void draw() {
  background(50);
  stroke(0);

}

void mouseClicked() {
  water_can = (floor(random(300)) + 1);
  sb.send("water_your_plant", str(water_can));
  println(water_can);
}


void onCustomMessage( String name, String type, String value ){
  println("got " + type + " message " + name + " : " + value);
  if (int(value) >= 1 || int(value) <= 6) {
    remote_dice = int(value);
  }
}
