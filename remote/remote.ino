#include <ESP8266WiFi.h>
#include "HTTP_Method.h"

// LEDS
#define PIN_LED_RED     14
#define PIN_LED_YELLOW  13
#define PIN_LED_GREEN   12

// button
#define PIN_BUTTON      4
#define DEBOUNCE_TIME 200 // milliseconds
volatile int button_a_count;
volatile unsigned long count_prev_time;

// Wifi
const char* WIFI_SSID = "EMLI";
const char* WIFI_PASSWORD = "EMLIpassword";

// Static IP address
IPAddress IPaddress(192, 168, 0, 222);
IPAddress gateway(192, 168, 0, 1);
IPAddress subnet(255, 255, 255, 0);
//IPAddress primaryDNS(1, 1, 1, 1); 
//IPAddress secondaryDNS(8, 8, 8, 8); 

// Webserver
#define CLIENT_TIMEOUT 2000
WiFiServer server(80);

void setupLEDS() {
  // LEDs
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  pinMode(PIN_LED_RED, OUTPUT);
  digitalWrite(PIN_LED_RED, LOW);
  pinMode(PIN_LED_YELLOW, OUTPUT);
  digitalWrite(PIN_LED_YELLOW, LOW);
  pinMode(PIN_LED_GREEN, OUTPUT);
  digitalWrite(PIN_LED_GREEN, LOW);
}

void setupWifi() {
  // configure as WiFi client
  WiFi.mode(WIFI_STA); 
  
  // connect to Wifi access point
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(WIFI_SSID);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  digitalWrite(LED_BUILTIN, HIGH);
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println("");

  // start webserver
  Serial.println("Starting webserver");
  Serial.println("");
  server.begin();

  // configure static IP address
  WiFi.config(IPaddress, gateway, subnet);
  //WiFi.config(IPaddress, gateway, subnet, primaryDNS, secondaryDNS);
}

void webServer() {
  // listen for incoming clients
  WiFiClient client = server.available();
  if (client) {
    clientConnectTime = millis();
    while (client.connected() && millis - clientConnectTime < CLIENT_TIMEOUT) {
      Serial.println("Connected to client");
      if (client.available()) {
        char c = client.read();
        Serial.write(c);

        if (currentLine.length() == 0) {
              Serial.println("Sending response");
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type: text/html");
            sprintf (s, "Content-Length: %d",strlen(response_s));
            client.println(s);
            client.println();
            //client.println("Connection: close");
            client.println(response_s);
            client.println();
            response_s[0] = 0;
        } else {
          if (currentLine.startsWith("GET /led/red/on")) {
            Serial.println("Red LED on");
            digitalWrite(PIN_LED_RED, HIGH);
          } else if (currentLine.startsWith("GET /led/red/off")) {
            Serial.println("Red LED off");
            digitalWrite(PIN_LED_RED, LOW);
          }
        }
      }
    }

    // close the connection:
    client.stop();
  }
}

void setup() {
  // serial
  Serial.begin(115200);
  delay(10);

  setupLEDS();
  setupWifi();
  

}

void loop() {

}