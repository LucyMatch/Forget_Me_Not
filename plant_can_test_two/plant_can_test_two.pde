/*
Created by Nicole Yi Messier, Joselyn Neon and LuCy Matchett
This sketch uses the standard Firmata Library to take in information from an arduino.
By picking up your watering can to water your plants, this will send a value via spaceBrew
to a corressponding processing/ arduino sketch and water another plant remotely
*/


/******* ARDUINO & FIRMATA STUFF *******/
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

/***SPACE BREW SHIZ********************/
import spacebrew.*;
String server="sandbox.spacebrew.cc";
String name="Water -> Sending";
String description ="An App that lets you water your loved ones dying plants.";
Spacebrew sb;

/***********Set up photoresistor****************/
int lightPin = 0; 
String plant_can = "";
int value1 = 10;



void setup(){
  //instantiate the spacebrewConnection variable
  sb = new Spacebrew(this);
  
  //declare publisherz (name, data type, value)
  sb.addPublish("water_plant2", "water_can", plant_can);

  
  // connect! 
  sb.connect(server, name, description);
  
  //Print the arduino list so that you know which serial your arduino is connected to
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[9], 57600); //have to change the [] to relate to corresponding arduino serial
 
   //set pin you are using on the arduino to INPUT
   arduino.pinMode(lightPin, Arduino.INPUT);
  
}

void draw(){
 
  //set value to analogRead of the photoresistor 
  value1 = arduino.analogRead(lightPin);
  println("value1: " + value1); 
  
  //if watering can has been lifted send information via spacebrew
  if( arduino.analogRead(lightPin) > 500){
    
  //send the custom data type, waterCan
  sb.send("water_plant2", value1 );
  println("message sent!");
  
  }
}


void onCustomMessage( String name, String type, String value ){
  
}

