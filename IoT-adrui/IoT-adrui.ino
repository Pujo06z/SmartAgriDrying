
#define PIR_PIN 2

// Thoi gian giu HIGH: 10 giay
const unsigned long HOLD_TIME = 15000;

// Thoi gian in ket qua: 1 giay
const unsigned long PRINT_INTERVAL = 1000;

bool motionDetected = false;
unsigned long lastMotionTime = 0;
unsigned long lastPrintTime = 0;

void setup() {
  Serial.begin(115200);
  pinMode(PIR_PIN, INPUT);

  Serial  .println("Khoi dong cam bien PIR...");
  delay(3000);

  Serial.println("CAM BIEN SAN SANG!");

  if (digitalRead(PIR_PIN) == HIGH) {
    motionDetected = true;
    lastMotionTime = millis();
  }
}

void loop() {
  unsigned long currentTime = millis();

  // Doc tin hieu PIR lien tuc
  int pirValue = digitalRead(PIR_PIN);

  // Khi PIR phat hien chuyen dong
  if (pirValue == HIGH) {
    motionDetected = true;
    lastMotionTime = currentTime;
  }

  // Chi chuyen LOW khi het thoi gian giu
  if (motionDetected &&
      pirValue == LOW &&
      currentTime - lastMotionTime >= HOLD_TIME) {
    motionDetected = false;
  }

  // Xuat ket qua moi 1 giay
  if (currentTime - lastPrintTime >= PRINT_INTERVAL) {
    lastPrintTime = currentTime;

    if (motionDetected) {
      Serial.println("HIGH - PHAT HIEN CHUYEN DONG");
    } else {
      Serial.println("LOW - KHONG CO CHUYEN DONG");
    }
  }
}
