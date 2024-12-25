import processing.serial.*; // Import thư viện Serial
import java.awt.event.KeyEvent; // Thư viện đọc dữ liệu từ cổng Serial
import java.io.IOException;

Serial myPort; // Định nghĩa đối tượng Serial

// Định nghĩa các biến
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;
PFont orcFont;

void setup() {
  size(1200, 700); // Kích thước cửa sổ - thay đổi nếu cần cho độ phân giải màn hình
  smooth();
  String portName = Serial.list()[0]; // Chọn cổng Serial đầu tiên có sẵn (có thể thay bằng "COM5" nếu bạn chắc chắn cổng)
  myPort = new Serial(this, portName, 9600); // Bắt đầu giao tiếp Serial
  myPort.bufferUntil('.'); // Đọc dữ liệu từ Serial đến ký tự '.'
}

void draw() {
  fill(98, 245, 31);

  // Hiệu ứng chuyển động mờ và làm chậm fade của dòng di chuyển
  noStroke();
  fill(0, 4);
  rect(0, 0, width, height - height * 0.065);

  fill(98, 245, 31); // Màu xanh lá
  // Gọi các hàm vẽ radar
  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) { // Bắt đầu đọc dữ liệu từ Serial
  data = myPort.readStringUntil('.');
  if (data != null) { // Kiểm tra nếu có dữ liệu
    data = data.trim(); // Xóa bỏ khoảng trắng dư thừa

    index1 = data.indexOf(","); // Tìm ký tự ',' trong chuỗi dữ liệu
    if (index1 > 0) {
      angle = data.substring(0, index1); // Lấy giá trị góc
      distance = data.substring(index1 + 1); // Lấy giá trị khoảng cách

      // Chuyển đổi giá trị String thành Integer
      iAngle = int(angle);
      iDistance = int(distance);
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);

  // Vẽ các vòng cung
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI);
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);

  // Vẽ các đường góc
  line(-width / 2, 0, width / 2, 0);
  for (int a = 30; a <= 150; a += 30) {
    line(0, 0, (-width / 2) * cos(radians(a)), (-width / 2) * sin(radians(a)));
  }
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(9);
  stroke(255, 10, 10); // Màu đỏ

  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025); // Chuyển đổi khoảng cách từ cảm biến sang pixels
  if (iDistance < 40) {
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),
         (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074);
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  pushMatrix();
  if (iDistance > 40) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }

  fill(0, 0, 0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);
  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);
  textSize(40);
  text("SciCraft ", width - width * 0.875, height - height * 0.0277);
  text("Angle: " + iAngle + " °", width - width * 0.48, height - height * 0.0277);
  text("Distance: ", width - width * 0.26, height - height * 0.0277);
  if (iDistance < 40) {
    text("        " + iDistance + " cm", width - width * 0.225, height - height * 0.0277);
  }
  popMatrix();
}
