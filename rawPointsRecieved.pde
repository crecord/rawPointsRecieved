// this sketch draws the webcam
// and all the raw face tracking points on top of it
// make sure you have "raw" checked in your faceOSC application

// for the webcan
import processing.video.*;
Capture cam;

// to recieve osc messages 
import oscP5.*;
OscP5 oscP5;

// global array of points to draw
float[] rawPoints = new float[132];

void setup() {
  size(640, 480);
  frameRate(30);

  // setup osc 
  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "rawReceived", "/raw");
  
 // set up the webcam
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
  
  fill(255);
  noStroke(); 
 
}

void draw() {  
  background(255);
  
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);

  // draw all the points in the array
  for (int i=0; i<rawPoints.length-1; i+=2) {
    ellipse(rawPoints[i], rawPoints[i+1], 5, 5);
  }
}

public void rawReceived(float[] allPoints) {
  // receive the array of allPoints and store them 
  //in the global rawPoints array
  for (int i=0; i < allPoints.length; i++) {
    rawPoints[i] = allPoints[i];
  }
}