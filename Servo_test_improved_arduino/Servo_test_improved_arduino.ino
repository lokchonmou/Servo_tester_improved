#include <Servo.h> 

byte currentValue = 5;
byte values[6];
Servo servo[6];   

void setup() {
  Serial.begin(115200);
  establishContact();
}

void loop() {
  if(Serial.available() > 0){
    digitalWrite(13, HIGH);
    values[currentValue] = Serial.read();
    if (values[currentValue] != 255 ) 
    {
      if (servo[currentValue].attached() == LOW)  servo[currentValue].attach(14+currentValue);
      servo[currentValue].write(values[currentValue]);
    }
    else {
      if (servo[currentValue].attached() == HIGH)  servo[currentValue].detach();
    }
     currentValue++;
    if(currentValue > 5){
      currentValue = 0;
      Serial.write('A');
    }
     
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write('A');   // send an initial string
    delay(300);
  }
}


