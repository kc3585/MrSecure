#include <ArduinoJson.h>

#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>

// Set these to run example.
#define FIREBASE_HOST "nodemcu-ace5b.firebaseio.com"
#define FIREBASE_AUTH "kKMQvdfbalkyQSeYnYgTdZ3urqPOX3KqQYL9WUPR"
#define WIFI_SSID "freewifi"
#define WIFI_PASSWORD "takemywifi"

String str = String("");
String serialIn;
long m;

void setup() {
  Serial.begin(9600);

  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  serialIn = String("");
}

void loop() {
  
  String data = String("$");
  data += getData();
  data += "*";

  for (int i = 0; i < data.length(); i++) {
    Serial.write(data.charAt(i));
  }
  Firebase.setInt("numbers/test",5);
  m = millis();

  while (m + 10000 > millis()){

    if (Serial.available()){
      char c = (char) Serial.read();

      if (c == '(') {
  
        boolean keepgoing = true;

        while (keepgoing){

          if (Serial.available()){

             char b = (char) Serial.read();

             if (b == ')'){
              keepgoing = false;
             }else{
              serialIn += b;
             }
            
          }
          
        }
        
      }

      push(serialIn);
      
      serialIn = String("");
    }
  }
}

void push(String out){

  if (out.length() < 4){
    return;
  }
  
  Firebase.setString("lastscan/id",out);

  if (Firebase.success()){
    //Serial.println(str+"Successfully sent: "+out);
  }else{
    //Serial.println("Unable to push to lastscan/id ");
  }
  
}

String getData(){
  String output = String();

  int id = 0;
  boolean found = false;

  while (!found){
    String input = Firebase.getString(str+"tracking_values/"+id);

    if (input.length() < 4){
      found = true;
    }else{
      output += input + "_";
      id++;
    }
  }

  return output;
}
