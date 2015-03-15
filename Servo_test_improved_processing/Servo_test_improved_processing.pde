import processing.serial.*;
import java.awt.*; 

Serial myPort;  
Choice guiChoice = new Choice();

int[] servoangle = { 
  90, 90, 90, 90, 90, 90
};
byte[] inControl = {
  0, 0, 0, 0, 0, 0
};
boolean firstContact = false;
boolean selected_port = false;

void setup() {
  size(320, 200);
  background(230, 230, 230);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Choose the serial port from the list \n and then click anywhere to continue", width/2, height/2); // display text to user

  int port_list_length = Serial.list().length;

  if (port_list_length==0) {
    println("There are no serial available.");
    exit();
  } else {
    for (int i=0; i< port_list_length; i++)
    {
      guiChoice.add(Serial.list()[i]);  //Add each serial port found to the selection
    }

    add(guiChoice); //Place the Choice selection box on the display area.
    frame.setResizable(true);
  }
}

void draw() {
  if (selected_port == true) {

    frame.setSize(displayWidth/3, displayHeight*2/3); 

    background(230, 230, 230); 
    text("Servo Tester Ver1.1", width/2, 40);
    text("by AO IEONG KIN KEI & LOK CHON MOU", width/2, height-40);
    for (byte i = 0; i <= 5; i++) {  
      colorMode(RGB, 255);
      rectMode(CENTER);
      fill(255);
      stroke(0);
      rect(width*(i+1)/7, height/2, 50, 360);

      colorMode(HSB, 100);
      rectMode(CORNER);
      fill(100*i*inControl[i]/6, 40*inControl[i], 90+ 70*inControl[i]);
      rect(width*(i+1)/7 - 25, height/2 +180, 50, -  servoangle[i]*2); 

      colorMode(RGB, 255);
      fill(0);
      text("A"+i, width*(i+1)/7, 75);
      text(servoangle[i], width*(i+1)/7, 15+ height/2 +( 90 - servoangle[i])*2);
    }
  }
}

void serialEvent(Serial myPort) {
  //  println("I received");
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    println(myString);
    //    println("sending");
    for (byte i = 0; i <= 5; i++)
      if (inControl[i] == 1)
        myPort.write(byte(servoangle[i]));
      else 
        myPort.write(255);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getAmount();

  for (byte i = 0; i <= 5; i++) {  
    if (mouseX >= width*(i+1)/7 - 25 && mouseX <= width*(i+1)/7 + 25 && inControl[i] == 1) {
      servoangle[i] -= e;
      servoangle[i] = constrain(servoangle[i], 0, 180);
    }
  }
}

void mouseClicked() {

  if (selected_port == false) {
    println(guiChoice.getSelectedItem()); // print selection
    myPort= new Serial(this, guiChoice.getSelectedItem(), 115200);
    remove(guiChoice); // remove drop-down list, otherwise it appears on top of the video feed
    selected_port= true;
  } else {
    for (byte i = 0; i <= 5; i++) {  
      if (mouseX >= width*(i+1)/7 - 25 && mouseX <= width*(i+1)/7 + 25) {
        if (inControl[i] == 0) inControl[i] = 1;
        else if (inControl[i] == 1) inControl[i] = 0;
      }
    }
  }
}

