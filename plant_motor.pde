/*Created by Nicole Yi Messier, Joseyln Neon McDonald & LuCy Matchett
This sketch recieves a value via SpaceBrew from another Arduino/Processing Sketch, which indicates
that a servo should move and water your plants.
This sketch uses the Firmata Library in conjuction with the arduino and a servo motor.
*/


/******* ARDUINO & FIRMATA STUFF *******/
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

/***SPACE BREW SHIZ********************/
import spacebrew.*;
String server="sandbox.spacebrew.cc";
String name="Water -> Receiving";
String description ="An App that lets you water your loved ones dying plants.";
Spacebrew sb;

/***********Set up motor****************/
int servoPin = 10; // the pin the servo is connected to
int receivedValue = 1;
boolean turn_on = false;
int pos = 0; // this will set the position of the servo later on


void setup(){
  //instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );
  
  //declare publisherz (name, data type, value)
   sb.addSubscribe("waterplant", "water_can");
  
  // connect! 
  sb.connect(server, name, description);
  
  //Print the arduino list so that you know which serial your arduino is connected to
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[8], 57600); //have to change the [] to relate to corresponding arduino serial
  
  //set pin you are using on the arduino to OUTPUT
  arduino.pinMode(servoPin, Arduino.OUTPUT);
  
}

void draw(){
  println("receivedValue: " + receivedValue);
  
  //if the recieved value is above 600 i.e. the watering can has been lifted off the stand
  // make the turn_on boolean equal true.
  //this may require some calibration by looking at your sensor input values
  if (receivedValue > 600){
    turn_on = true;
  } else if (receivedValue < 600){
    turn_on = false;
  }
  
  //if the recieved value is on, then run the pourWater function
  if (turn_on){
    pourWater();
  }
}

// this function controls the servo motor
void pourWater(){
    //this for loop rotates the arm in incriments 
    for(pos = 90; pos < 180; pos += 1) {
      arduino.analogWrite(servoPin, pos);
      delay(15);
    }
    //this loop rotates it back to original position
    for(pos = 180; pos >= 90; pos -= 1) {
      arduino.analogWrite(servoPin, pos); 
      delay(15);
    }
}

//recieving the message from the other processing sketch and converting the value back into an int from a string
void onCustomMessage( String name, String type, String value ){
  println("got " + type + " message " + name + " : " + value);
  if ( type.equals("water_can") ){
    receivedValue = int(value);
   
  }
}
