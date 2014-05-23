// PlotClock
//   Listen from SpaceBrew cloud to send commands to control plot clock writing.
// Created by Ryan Tseng
// http://gogoprivateryan.blogspot.com

import processing.serial.*;
import spacebrew.*;

Serial myPort;  // Create object from Serial class

String server="sandbox.spacebrew.cc";
String name="GoGoPrivateRyan- Plot Clock";
String description ="Listen from publisher to control plot clock writing.";

String typing = ""; // Variable to store text currently being typed
String saved = ""; // Variable to store saved text when return is hit

String remote_string = "";
String local_string = "";

int timeInterval = 60*1000;
int lastUpdate;

Spacebrew sb;

void setup() 
{
  size(400,200);
  myPort = new Serial(this, Serial.list()[5], 9600);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew(this);
  //sb.addPublish("plotclock_response", "string", local_string);
  sb.addSubscribe("input_commands", "string");
  // connect!
  sb.connect(server, name, description);
  
  lastUpdate = millis() - timeInterval;
}

void draw() 
{
  background(255);
  int indent = 10;
  
  if (millis()-lastUpdate >= timeInterval)
  {
    println("1 minute...");
    //println(local_string);
    // query plot clock mode
    myPort.write("ggpr,qry\n");
    // notify javascript
    lastUpdate = millis();
  }
  
  // Set the font and fill for text
  fill(0);
  
  // draw instruction text
  text("Listen from publisher to control plot clock writing.", indent, 20);
  
  // draw latest received message
  text("\nMessage Received: ", indent, 70);  
  text(remote_string, 50, 130);  
}

void onStringMessage(String name, String value)
{
  println("got string message " + name + " : " + value);
  remote_string = value;
  myPort.write(remote_string);
  
  // if got a "wbc,qry" command
  
  //check serial port for plot clock response 
  //sb.send("plotclock_response", local_string);  
  // or 
  //actively query every minute
}

void keyPressed() 
{
  typing = typing + key;
  
  // If the return key is pressed, save the String and clear it
  if (key == '\n' ) 
  {
    saved = typing;
    // A String can be cleared by setting it equal to ""
    typing = ""; 
    println(saved);    
    myPort.write(saved);
  } 
}

/*
void serialEvent(Serial myPort) 
{
  while (myPort.available() > 0) 
  {
    local_string = myPort.readString();   
    if (local_string != null) 
    {
      println(local_string);
    }
  }
}
*/

  
