#include <WiFi.h>
#include <HTTPClient.h>
#include <DHT.h>
#include <ESP32Servo.h>


// =====================================
// Pin configuration
// =====================================

#define DHT_PIN 13
#define SERVO_PIN 14
#define RAIN_PIN 15
#define LDR_PIN 2

#define DHT_TYPE DHT11


// =====================================
// WiFi configuration
// =====================================

const char* ssid =
  "VVT_L4";

const char* password =
  "Vvt@1537174";


// =====================================
// Server configuration
// =====================================

// Replace this IP address with the laptop IPv4 address.

const char* deviceStateUrl =
  "http://192.168.1.6:8080/SmartAgriDrying/api/device-state";

const char* sensorUrl =
  "http://192.168.1.6:8080/SmartAgriDrying/api/sensor";


// =====================================
// Device configuration
// =====================================

const char* DEVICE_ID =
  "D001";


// =====================================
// Objects
// =====================================

DHT dht(
  DHT_PIN,
  DHT_TYPE);

Servo roofServo;


// =====================================
// Light configuration
// =====================================

// Based on the tested hardware:
// LDR > 2000 means DARK.
// LDR <= 2000 means BRIGHT.

// const int LDR_DARK_THRESHOLD =
//   50;


// =====================================
// Temperature warning configuration
// =====================================

const float TEMP_HIGH =
  40.0;

const float TEMP_LOW =
  15.0;


// =====================================
// Servo configuration
// =====================================

// Based on the tested hardware:
// 0 degrees means CLOSED.
// 90 degrees means OPEN.

const int ROOF_CLOSED_ANGLE =
  0;

const int ROOF_OPEN_ANGLE =
  100;


// =====================================
// Device state
// =====================================

String currentMode =
  "AUTO";

String roofStatus =
  "CLOSED";

String manualRoofCommand =
  "CLOSED";


// =====================================
// Cached sensor values
// =====================================

float currentTemperature =
  0.0;

float currentHumidity =
  0.0;

bool dhtDataAvailable =
  false;

bool currentIsRaining =
  false;

bool currentIsDark =
  false;

int currentLdrValue =
  0;


// =====================================
// Timers
// =====================================

unsigned long lastDhtReadTime =
  0;

unsigned long lastCommandCheckTime =
  0;

unsigned long lastSensorSaveTime =
  0;


// Read DHT11 every 2 seconds.

const unsigned long DHT_INTERVAL =
  2000;


// Check web commands every 2 seconds.

const unsigned long COMMAND_INTERVAL =
  2000;


// Save sensor history every 5 minutes.

const unsigned long SENSOR_SAVE_INTERVAL =
  300000;

// check changed
bool sensorStateChanged =
  false;

bool rainStateInitialized =
  false;

bool lightStateInitialized =
  false;

bool temperatureStateInitialized =
  false;

bool previousIsRaining =
  false;

bool previousIsDark =
  false;

int previousTemperatureState =
  0;
// =====================================
// Function declarations
// =====================================

void connectWiFi();

void readFastSensors();

void readDhtSensor();

void applyRoofControl();

void openRoof();

void closeRoof();

void checkServerCommand();

void parseServerResponse(
  String response);

void sendSensorHistory();


// =====================================
// Setup
// =====================================

void setup() {

  Serial.begin(
    115200);


  delay(
    1000);


  Serial.println();
  Serial.println(
    "========================================");

  Serial.println(
    "SMART AGRICULTURAL DRYING SYSTEM");

  Serial.println(
    "========================================");


  // ===================================
  // Initialize sensors
  // ===================================

  dht.begin();


  pinMode(
    RAIN_PIN,
    INPUT);

  pinMode(
    LDR_PIN,
    INPUT);


  // ===================================
  // Initialize servo
  // ===================================

  ESP32PWM::allocateTimer(
    0);

  ESP32PWM::allocateTimer(
    1);


  roofServo.setPeriodHertz(
    50);


  roofServo.attach(
    SERVO_PIN,
    500,
    2400);


  // ===================================
  // Start with the roof closed
  // ===================================

  roofServo.write(
    ROOF_CLOSED_ANGLE);

  roofStatus =
    "CLOSED";


  // ===================================
  // Connect WiFi
  // ===================================

  connectWiFi();


  // ===================================
  // Force the first reads immediately
  // ===================================

  lastDhtReadTime =
    millis() - DHT_INTERVAL;

  lastCommandCheckTime =
    millis() - COMMAND_INTERVAL;

  lastSensorSaveTime =
    millis() - SENSOR_SAVE_INTERVAL;
}


// =====================================
// Main loop
// =====================================

void loop() {

  unsigned long currentTime =
    millis();


  // ===================================
  // Read rain and light sensors
  // ===================================

  readFastSensors();


  // ===================================
  // Read DHT11 every 2 seconds
  // ===================================

  if (
    currentTime - lastDhtReadTime
    >= DHT_INTERVAL) {

    readDhtSensor();

    lastDhtReadTime =
      currentTime;
  }


  // ===================================
  // Apply local roof control
  // ===================================

  applyRoofControl();


  // ===================================
  // Check server command every 2 seconds
  // ===================================

  if (
    currentTime - lastCommandCheckTime
    >= COMMAND_INTERVAL) {

    checkServerCommand();

    lastCommandCheckTime =
      currentTime;


    /*
     * Apply the command immediately after
     * receiving the server response.
     */

    applyRoofControl();
  }


  // ===================================
  // Save sensor history every 5 minutes
  // ===================================

  if (
    dhtDataAvailable
    && (sensorStateChanged
        || currentTime - lastSensorSaveTime
             >= SENSOR_SAVE_INTERVAL)) {

    sendSensorHistory();

    sensorStateChanged =
      false;

    lastSensorSaveTime =
      currentTime;
  }

  delay(
    200);
}


// =====================================
// Read rain and light sensors
// =====================================

void readFastSensors() {

  int rainValue =
    digitalRead(
      RAIN_PIN);


  bool newIsRaining =
    (rainValue
     == LOW);


  currentLdrValue =
    digitalRead(
      LDR_PIN);


  bool newIsDark =
    (currentLdrValue
     == LOW);


  // Detect rain status changes.
  if (
    rainStateInitialized
    && newIsRaining
         != previousIsRaining) {

    sensorStateChanged =
      true;
  }


  previousIsRaining =
    newIsRaining;

  rainStateInitialized =
    true;


  // Detect light status changes.
  if (
    lightStateInitialized
    && newIsDark
         != previousIsDark) {

    sensorStateChanged =
      true;
  }


  previousIsDark =
    newIsDark;

  lightStateInitialized =
    true;


  currentIsRaining =
    newIsRaining;

  currentIsDark =
    newIsDark;
}

// =====================================
// Read DHT11
// =====================================

void readDhtSensor() {

  float temperature =
    dht.readTemperature();


  float humidity =
    dht.readHumidity();


  if (
    isnan(temperature)
    || isnan(humidity)) {

    Serial.println(
      "[ERROR] Failed to read DHT11.");

    return;
  }


  currentTemperature =
    temperature;

  currentHumidity =
    humidity;

  dhtDataAvailable =
    true;

  int currentTemperatureState =
    0;


  if (
    currentTemperature
    >= TEMP_HIGH) {

    currentTemperatureState =
      1;

  } else if (
    currentTemperature
    <= TEMP_LOW) {

    currentTemperatureState =
      -1;
  }


  // Detect temperature warning state changes.
  if (
    temperatureStateInitialized
    && currentTemperatureState
         != previousTemperatureState) {

    sensorStateChanged =
      true;
  }


  previousTemperatureState =
    currentTemperatureState;

  temperatureStateInitialized =
    true;
  Serial.println();
  Serial.println(
    "========== SENSOR ==========");


  Serial.print(
    "Temperature: ");

  Serial.print(
    currentTemperature);

  Serial.println(
    " C");


  Serial.print(
    "Humidity: ");

  Serial.print(
    currentHumidity);

  Serial.println(
    " %");


  Serial.print(
    "Rain: ");

  Serial.println(
    currentIsRaining
      ? "RAINING"
      : "NO_RAIN");


  Serial.print(
    "LDR: ");

  Serial.println(
    currentLdrValue);


  Serial.print(
    "Light: ");

  Serial.println(
    currentIsDark
      ? "DARK"
      : "BRIGHT");


  Serial.print(
    "Mode: ");

  Serial.println(
    currentMode);


  Serial.print(
    "Roof: ");

  Serial.println(
    roofStatus);
}


// =====================================
// Apply AUTO or MANUAL roof control
// =====================================

void applyRoofControl() {

  if (
    currentMode
    == "AUTO") {

    /*
     * AUTO mode:
     *
     * Rain or darkness
     * -> close the roof.
     *
     * Bright and no rain
     * -> open the roof.
     */

    if (
      currentIsRaining
      || currentIsDark) {

      closeRoof();

    } else {

      openRoof();
    }

  } else if (
    currentMode
    == "MANUAL") {

    /*
     * MANUAL mode:
     *
     * Rain and light sensors do not control
     * the roof.
     *
     * The roof follows the command
     * received from the server.
     */

    if (
      manualRoofCommand
      == "OPEN") {

      openRoof();

    } else {

      closeRoof();
    }
  }
}


// =====================================
// Open roof slowly
// =====================================

void openRoof() {

  if (roofStatus != "OPEN") {

    for (int angle = ROOF_CLOSED_ANGLE;
         angle <= ROOF_OPEN_ANGLE;
         angle++) {

      roofServo.write(angle);

      delay(25);
    }

    roofStatus = "OPEN";

    sensorStateChanged = true;

    Serial.println(
      "ROOF -> OPEN"
    );
  }
}


// =====================================
// Close roof slowly
// =====================================

void closeRoof() {

  if (roofStatus != "CLOSED") {

    for (int angle = ROOF_OPEN_ANGLE;
         angle >= ROOF_CLOSED_ANGLE;
         angle--) {

      roofServo.write(angle);

      delay(25);
    }

    roofStatus = "CLOSED";

    sensorStateChanged = true;

    Serial.println(
      "ROOF -> CLOSED"
    );
  }
}

// =====================================
// Check server command
// =====================================

void checkServerCommand() {

  if (
    WiFi.status()
    != WL_CONNECTED) {

    Serial.println(
      "[WARNING] WiFi disconnected.");


    connectWiFi();

    return;
  }


  HTTPClient http;


  http.begin(
    deviceStateUrl);


  http.addHeader(
    "Content-Type",
    "application/x-www-form-urlencoded");


  String postData =
    "deviceId="
    + String(
      DEVICE_ID)

    + "&roofStatus="
    + roofStatus;


  int httpResponseCode =
    http.POST(
      postData);


  if (
    httpResponseCode
    > 0) {

    String response =
      http.getString();


    parseServerResponse(
      response);

  } else {

    Serial.print(
      "[ERROR] Device state request failed: ");

    Serial.println(
      httpResponseCode);
  }


  http.end();
}


// =====================================
// Parse server response
// =====================================

void parseServerResponse(
  String response) {

  response.trim();


  Serial.println();
  Serial.println(
    "===== SERVER COMMAND =====");

  Serial.println(
    response);


  // ===================================
  // Read mode
  // ===================================

  if (
    response.indexOf(
      "MODE=MANUAL")
    >= 0) {

    currentMode =
      "MANUAL";

  } else if (
    response.indexOf(
      "MODE=AUTO")
    >= 0) {

    currentMode =
      "AUTO";
  }


  // ===================================
  // Read roof command
  // ===================================

  if (
    response.indexOf(
      "ROOF=OPEN")
    >= 0) {

    manualRoofCommand =
      "OPEN";

  } else if (
    response.indexOf(
      "ROOF=CLOSED")
    >= 0) {

    manualRoofCommand =
      "CLOSED";
  }


  Serial.print(
    "Mode: ");

  Serial.println(
    currentMode);


  Serial.print(
    "Server roof command: ");

  Serial.println(
    manualRoofCommand);
}


// =====================================
// Save sensor history
// =====================================

void sendSensorHistory() {

  if (
    WiFi.status()
    != WL_CONNECTED) {

    Serial.println(
      "[WARNING] Sensor history was not sent because WiFi is disconnected.");

    connectWiFi();

    return;
  }


  HTTPClient http;


  http.begin(
    sensorUrl);


  http.addHeader(
    "Content-Type",
    "application/x-www-form-urlencoded");


  String rainStatus =
    currentIsRaining
      ? "RAINING"
      : "NO_RAIN";


  String lightStatus =
    currentIsDark
      ? "DARK"
      : "BRIGHT";


  String postData =
    "deviceId="
    + String(
      DEVICE_ID)

    + "&temperature="
    + String(
      currentTemperature,
      2)

    + "&humidity="
    + String(
      currentHumidity,
      2)

    + "&rainStatus="
    + rainStatus

    + "&lightStatus="
    + lightStatus

    + "&roofStatus="
    + roofStatus;


  Serial.println();
  Serial.println(
    "===== SAVE SENSOR HISTORY =====");


  Serial.println(
    postData);


  int httpResponseCode =
    http.POST(
      postData);


  Serial.print(
    "HTTP Response Code: ");

  Serial.println(
    httpResponseCode);


  if (
    httpResponseCode
    > 0) {

    String response =
      http.getString();


    Serial.println(
      response);

  } else {

    Serial.println(
      "[ERROR] Failed to save sensor history.");
  }


  http.end();
}


// =====================================
// Connect WiFi
// =====================================

void connectWiFi() {

  if (
    WiFi.status()
    == WL_CONNECTED) {

    return;
  }


  Serial.print(
    "Connecting to WiFi");


  WiFi.begin(
    ssid,
    password);


  unsigned long startTime =
    millis();


  while (
    WiFi.status()
    != WL_CONNECTED) {

    delay(
      500);


    Serial.print(
      ".");


    /*
     * Stop waiting after 15 seconds
     * so the main loop is not blocked forever.
     */

    if (
      millis() - startTime
      > 15000) {

      Serial.println();

      Serial.println(
        "[ERROR] WiFi connection timeout.");

      return;
    }
  }


  Serial.println();


  Serial.println(
    "WiFi connected.");


  Serial.print(
    "ESP32 IP: ");


  Serial.println(
    WiFi.localIP());
}