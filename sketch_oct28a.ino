// Khai báo thư viện servo
//
#include <Servo.h>

// Khai báo các chân cảm biến siêu âm
const int trigPin = 13;
const int echoPin = 12;

// Tạo biến dùng để lưu thời gian và khoảng cách
long duration;
int distance; // Sửa lại tên biến để đúng với kiểu dữ liệu

// Tạo đối tượng servo để điều khiển động cơ
Servo myServo;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  
  // Hiển thị dữ liệu trên Serial Monitor
  Serial.begin(9600);
  
  // Kết nối servo với PIN 10
  myServo.attach(8);
}

void loop() {
  // Lặp từ góc 15 đến 165 độ
  for (int i = 15; i <= 165; i++) {
    myServo.write(i);
    delay(10);
    distance = calculateDistance(); // Gọi hàm calculateDistance để tính khoảng cách từ ultrasonic sensor
    
    // Hiển thị góc và khoảng cách đo được trên Serial Monitor
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
  
  // Lặp từ góc 165 đến 15 độ (quay ngược lại)
  for (int i = 165; i > 15; i--) {
    myServo.write(i);
    delay(10);
    distance = calculateDistance();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

// Hàm tính toán khoảng cách đo được từ cảm biến siêu âm
int calculateDistance() { 
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  
  // Đặt trigPin ở mức HIGH trong 10 micro giây
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Đọc echoPin và trả về thời gian sóng âm phản hồi
  duration = pulseIn(echoPin, HIGH);
  
  // Tính toán khoảng cách dựa trên thời gian
  distance = duration * 0.034 / 2;
  return distance;
}
