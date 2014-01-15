#include <LiquidCrystal.h>
LiquidCrystal lcd(12,11,5,4,3,2);
const int switchPin = 6;
int reply;
int counter = 0;
const int ledPin = 13;
int sensorValue;
int sensorLow = 1023;
int sensorHigh = 0;
boolean currentState = false;
boolean prevState = false;

void setup(){
 lcd.begin(16,2);
 pinMode(switchPin, INPUT);
 lcd.print("Push Up Counter!");
 lcd.setCursor(0,1);
 lcd.print("*--------------*"); 
 Serial.begin(9600);
 /*digitalWrite(ledPin,HIGH);
 while (millis() <5000){
  sensorValue = analogRead(A0);
  if (sensorValue > sensorHigh){
   sensorHigh = sensorValue;
  } 
  if (sensorValue < sensorLow){
   sensorLow = sensorValue; 
  }
 }
 digitalWrite(ledPin,LOW);
 */
 
}

void loop(){
  sensorValue = analogRead(A0);
  Serial.print("Sensor Value is: ");
  Serial.print(sensorValue);
  //Serial.print(" Sensor Low: ");
  //Serial.print(sensorLow);
  Serial.print(" Current State is: ");
  Serial.print(currentState);
  Serial.print(" Previous State is: ");
  Serial.println(prevState);
  //if (sensorValue < (sensorLow + 50)){
  if (sensorValue < 425){
   currentState = true; 
  }
  else{
   currentState = false;
  }
  if (currentState != prevState){
    if (currentState == false){
     counter++;
     lcd.clear();
     lcd.setCursor(0,0);
     lcd.print("Push Up #");
     lcd.setCursor(0,1);
     lcd.print(counter); 
    }
  }
  prevState = currentState;
  
}
      
