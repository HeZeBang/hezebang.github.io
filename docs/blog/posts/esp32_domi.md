---
draft: false
date: 2024-10-15
categories:
  - ESP32
  - 智能家居
  - Servo
---

# ESP32 + 舵机实现寝室关灯不愁人

## 前情提要

学校 SI100B 的 EE Part 需要用到 ESP32 ，闲着无聊买回来然后琢磨怎么玩。然后就有了这个项目……

## 电机驱动

ESP32 的电机比较特殊，并不能直接 `#include <Servo.h>`， 我们需要在 Library 中下载专门编写的 `ESP32Servo` 并导入 `ESP32Servo.h` 才能使用。

其中我们定义，`Servo1` 和 `Servo2` 为 `Servo` 类型，并调用 `attach` 方法附加， `write` 方法书写角度。

## 电机调平

我们需要对两个电机分别通过手动尝试获得最佳偏移量。

## ESP32 Server模式

我们使用的是样例标程给出的 Server 的 Template， 将其中的 `SSID` 和 `Password` 两个变量分别为自身的无线局域网的 SSID 及密码

> PS. 上科大可以使用 [这个项目](https://github.com/ShanghaitechGeekPie/Auth-esp32-to-ShanghaiTech-wifi)

## 上机调试

为了方便调试，我们打开 115200 的串口调试

最终代码如下：

```c
#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <ESPmDNS.h>
#include <ESP32Servo.h>

const char* ssid = "1211";
const char* password = "p@ssw0rd";

WebServer server(80);
Servo servo1, servo2;
int isLedOn = 0;

const int led = 2;
const int PIN1 = 14;
const int PIN2 = 26;

void handleRoot() {
  digitalWrite(led, 1);
  server.send(200, "text/plain", "hello from esp32!");
  digitalWrite(led, 0);
}

void handleNotFound() {
  digitalWrite(led, 1);
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i = 0; i < server.args(); i++) {
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, "text/plain", message);
  digitalWrite(led, 0);
}

void setup(void) {
  pinMode(led, OUTPUT);
  servo1.attach(PIN1);
  servo1.write(85);
  servo2.attach(PIN2);
  digitalWrite(led, 1);
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");
  server.enableCORS(true);

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  digitalWrite(led, 0);
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  if (MDNS.begin("esp32")) {
    Serial.println("MDNS responder started");
  }

  servo2.write(95);

  server.on("/", handleRoot);

  server.on("/on", []() {
    servo2.write(59);
    delay(500);
    servo2.write(128);
    delay(500);
    servo2.write(95);
    delay(500);
    server.send(200, "text/plain", "OK");
  });

  server.on("/off", []() {
    servo1.write(115);
    delay(500);
    servo1.write(55);
    delay(500);
    servo1.write(85);
    delay(500);
    server.send(200, "text/plain", "OK");
  });

  // server.on("/lfton", []() {
  //   digitalWrite(led, 1);
  //   // servo1.write(85);
  //   servo2.write(62);
  //   server.send(200, "text/plain", "Left Oned");
  //   digitalWrite(led, 0);
  //   delay(500);
  //   servo2.write(95);
  //   delay(500);
  //   // servo1.write(85);
  // });

  // server.on("/lftoff", []() {
  //   digitalWrite(led, 1);
  //   // servo2.write(85);
  //   servo1.write(115);
  //   server.send(200, "text/plain", "Left Offed");
  //   digitalWrite(led, 0);
  //   delay(500);
  //   // servo2.write(85);
  //   servo1.write(85);
  //   delay(500);
  // });

  // server.on("/midon", []() {
  //   digitalWrite(led, 1);
  //   // servo1.write(85);
  //   servo2.write(128);
  //   server.send(200, "text/plain", "Mid Oned");
  //   digitalWrite(led, 0);
  //   delay(500);
  //   // servo1.write(85);
  //   servo2.write(95);
  //   delay(500);
  // });

  // server.on("/midoff", []() {
  //   digitalWrite(led, 1);
  //   // servo2.write(85);
  //   servo1.write(55);
  //   server.send(200, "text/plain", "Mid Offed");
  //   digitalWrite(led, 0);
  //   delay(500);
  //   // servo2.write(85);
  //   servo1.write(85);
  //   delay(500);
  // });

  server.onNotFound(handleNotFound);

  server.begin();
  Serial.println("HTTP server started");
}

void loop(void) {
  server.handleClient();
  digitalWrite(led, isLedOn);
  isLedOn = 1 - isLedOn;
  delay(10);  //allow the cpu to switch to other tasks
}
```