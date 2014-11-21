/* Tuitificador de sons. processing+libPD+twitter 
 
 Jordi Sala jordi@poperbu.net 
 
 musa.poperbu.net
 mobilitylab.net
 

 
 
 */

import processing.opengl.*; 
import oscP5.*;
import netP5.*;

//Twiter4j java lib->http://codigogenerativo.com/code/twitter-para-processing-2-0/

import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.*;
import java.util.*;

//OSC
OscP5 oscP5;
// a NetAddress contains the ip address and port number of a remote location in the network.
NetAddress myRemoteLocation; 
int sendPort;
int recvPort;

Twitter twitter;
String tweetMessage = "Tuitificador 2.0 (mobilitylab.net-2014)";
String frase;

void setup(){
    twitterConfiguration();

  size(800, 300);
  background(0);

  //OSC 
  // 22222 is the port number you are listening for incoming osc messages.
  oscP5 = new OscP5(this,22222);
  // with the oscP5.send method.
  myRemoteLocation = new NetAddress("127.0.0.1",11111);
  oscP5.plug(this,"recvTest","/test");
  oscP5.plug(this,"recvMissatge","/missatge");
  //frase="Tuitificador 2.0 (mobilitylab.net-2014)";

}

void draw(){
  background(0);
  fill(200, 0, 0);
  stroke(255, 0, 0);
  //ellipseMode(CENTER);
  //ellipse(mouseX, mouseY, 20, 20);
   fill(255);
  textSize(30);
  textAlign(CENTER);

  text(tweetMessage,400, 150);  // Text wraps within text box
}

////////////////////////////////// O S C  E V E N T S ///////////////////////////////
void recvTest(float testvalue1, float testvalue2, float testvalue3) {
    //handle OSC message  
    println(testvalue1);
    //, testvalue2, testvalue3);
    //sendTweet("Test audio1: pitch:"+testvalue1+"amplitude:"+testvalue2+"db:"+testvalue3);
}

void recvMissatge(int dB, float pH, float temperature) {
    //handle OSC message  
    println(dB+" dB "+pH+" pH "+temperature+" C");
    tweetMessage=dB+" dB "+pH+" pH "+temperature+" C #tuitificador2.0";
    
    tweet(tweetMessage);
}

//////////////////////////////////TWITTER FUNCTIONS///////////////////////////////////////////////////////////
void tweet(String _tweetMessage){
    try {
        Status status = twitter.updateStatus(_tweetMessage);
        println("Status updated to [" + status.getText() + "].");
    }catch (TwitterException te){
        System.out.println("Error: "+ te.getMessage()); 
    }
}


void keyPressed(){
    if(key == 't' || key =='T'){
        tweet(tweetMessage);
    }

}

void twitterConfiguration(){
    //to generate you twitter auth->  https://dev.twitter.com/apps/new
    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setOAuthConsumerKey("xxxxxxxxxxxxxxxx");
    cb.setOAuthConsumerSecret("xxxxxxxxxxxxxxxxxxxx");
    cb.setOAuthAccessToken("xxxxxxxxxxxxxxxxxxxxxx");
    cb.setOAuthAccessTokenSecret("xxxxxxxxxxxxxxxxxxxxxxx");
    TwitterFactory tf = new TwitterFactory(cb.build());
    twitter = tf.getInstance();
}
