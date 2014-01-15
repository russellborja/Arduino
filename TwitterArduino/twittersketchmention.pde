import twitter4j.conf.*;
import twitter4j.internal.async.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
import twitter4j.json.*;
import twitter4j.internal.util.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;
import twitter4j.internal.json.*;
import java.util.Date;
import processing.serial.*;

static String OAuthConsumerKey = "l3ixCfeZjDhq19IjxTBgg";
static String OAuthConsumerSecret = "5qtPFZlEZCRy7XLNkHUGid99Vb7LRL372uWhpwpQ";
static String AccessToken = "505103325-jHBNqWBmg8WmeYGQVqFbiSdJ8kRCOol9XRUXHEy4";
static String AccessTokenSecret = "LdtKdOlvpyuAv6n7DvLt2fOwlSB7fkAToOCO0Z97n6sUp";

Serial arduino;
ResponseList<Status>statuses = null;
Twitter twitter = new TwitterFactory().getInstance();

String oldID = "";

void setup() {
  size(125, 125);
  frameRate(10);
  background(0);
  println(Serial.list());
  String arduinoPort = Serial.list()[0];
  arduino = new Serial(this, arduinoPort, 9600);
  loginTwitter();
}

void loginTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}

void draw() {
  background(0);
  text("test", 35, 65);
  listenToArduino();
  getMention();
  delay(20000);
  // wait 20 seconds to avoid Twitter Rate Limit
}

void listenToArduino() {
  String msgOut = "";
  String arduinoMsg = "";
  if (arduino.available() >= 1) {
    arduinoMsg = arduino.readString();
    msgOut = arduinoMsg+" at "+hour()+":"+minute()+":"+second()+" "+year()+month()+day();
    updateStatus(msgOut);
  }
}


void getMention() {
  ResponseList<Status> mentions = null;
  try {
    mentions = twitter.getMentionsTimeline();
  }
  catch(TwitterException e) {
    println("Exception: " + e + "; statusCode: " + e.getStatusCode());
  }
  Status status = (Status)mentions.get(0);
  String newID = str(status.getId());
  if (oldID.equals(newID) == false){
    oldID = newID;
    println(status.getText()+", by @"+status.getUser().getScreenName());
    //arduino.write(1); // arduino gets 1
    arduino.write(status.getText());
  }
}

void updateStatus(String s) {
  try {
    Status status = twitter.updateStatus(s);
    println("new tweet --:{ " + status.getText() + " }:--");
  }
    catch(TwitterException e) {
    println("Status Error: " + e + "; statusCode: " + e.getStatusCode());
  }
}
