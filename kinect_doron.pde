import kinect4WinSDK.*;
import hypermedia.net.*;// kinect4WinSDK ライブラリを使う

UDP udp;
String ip = "192.168.10.1";
int port = 8889;

Kinect kine = new Kinect(this);               // Kinect オブジェクト "kine" の宣言
SkeletonData user;                            // SkeletonData オブジェクト "user" の宣言
//PImage backImage;                             // 背景画像用の PImage "backImage" の宣言

void setup() {
  size(640, 480);                             // ウィンドウのサイズ設定
  //backImage = loadImage("back.jpg");          // 背景画像の読み込み
  user = new SkeletonData();
  // SkeletonData のインスタンス化

  udp = new UDP(this, port);
  udp.listen(true);

  // 最初にcommand実行
  udp.send("command", ip, port);
}

void draw() {
  background(0);                              // 背景を黒く塗りつぶす
  //image(backImage, 0, 0, 640, 480);           // 背景画像を描画
  //image(kine.GetMask(), 0, 0, 640, 480);      // Kinect の人物マスク画像を描画
  drawPosition();                             // 関数 drawPosition() を実行
  drawSkeleton();                             // 関数 drawSkeleton() を実行
}

// 人物が検出された時に実行される appearEvent 関数
void appearEvent(SkeletonData sd) {
  user = sd;                                  // 検出された人物をuserに入れる
}

// 人物がいなくなった時に実行される disappearEvent 関数
void disappearEvent(SkeletonData sd) {
  user = null;                                // userを空（null）にする
}

// 人物の位置を描画する drawPosition 関数
void drawPosition() {
  if (user == null) {                          // userが空なら
    return;                                   // 何もしないで関数を抜ける
  }
  // 人物の位置に円を描く
  colorMode(RGB);                             // 色の指定を RGB 形式にする
  noStroke();                                 // 線は描かない
  //fill(255, 127, 0);                          // 塗りつぶす色の指定 (Red, Green, Blue)
  // 円の幅, 高さ
  // 人物の位置情報をテキストで描く
  textSize(48);                               // 文字サイズの設定
  text("ID:" + user.dwTrackingID    + "/ " +  // userのID
    nf(user.position.x, 1, 2)    + ", " +  // userのx座標（nfで小数第二位まで表示）
    nf(user.position.y, 1, 2)    + ", " +  // userのy座標（nfで小数第二位まで表示）
    round(user.position.z/100) + "cm", // userのz座標（距離：x100cmで得られるので100で割り四捨五入）
    20, 450);        // 文字列の表示位置 (x, y)

  if (user.position.x < 0.55 && user.position.x > 0.45 ) {
    fill(255, 0, 0);
  } else {
    fill(255, 127, 0);
  }


  if (user.position.z/100 > 100 && user.position.z/100 <110 ) {
    fill(255, 0, 0);
  } else {
    fill(255, 127, 0);
  }


  ellipse(user.position.x * width, // 円の中心のx座標（userのx座標は0～1で得られる）
    user.position.y * height, // 円の中心のy座標（userのy座標は0～1で得られる）
    30, 30);
}

// 関節（骨格）描画する drawPosition 関数
void drawSkeleton() {
  if (user == null) {                          // userが空なら
    return;                                   // 何もしないで関数を抜ける
  }
  colorMode(RGB);                             // 色の指定を RGB 形式にする
  noStroke();                                 // 線は描かない
  fill(255, 255, 255);                        // 塗りつぶす色の指定 (Red, Green, Blue)
  // 関節の位置に円を描く（右肩、右肘、右手首、右手）
  if (user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].y > user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y) {
    fill(255, 0, 0);
    ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].x * width,
      user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].y * height,
      10, 10);
  }

  if (user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].y > user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y) {
    fill(255, 0, 0);
    ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].x * width,
      user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].y * height,
      10, 10);
  }

  //ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].x * width,
  //  user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].y * height,
  //  //10, 10);
  ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].y * height,
    10, 10);
  ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT].y * height,
    10, 10);
  ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y * height,
    10, 10);

  //test
  //ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].x * width,
  //  user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].y * height,
  //  10, 10);
  ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].y * height,
    10, 10);
  ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_LEFT].y * height,
    10, 10);
  ellipse(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].y * height,
    10, 10);
  //test

  // 関節の間に線を描く
  stroke(255, 255, 255);                      // 線を描く (Red, Green, Blue)
  strokeWeight(3);                            // 先の太さ
  noFill();                                   // 塗りつぶさない
  line(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].y * height,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].y * height);
  line(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].y * height,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT].y * height);
  line(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT].y * height,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y * height);

  //test
  line(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].y * height,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].y * height);
  line(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].y * height,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_LEFT].y * height);
  line(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_LEFT].y * height,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].y * height);
  //test


  // 右手の位置に skeletonPositions 情報を表示
  textSize(30);                               // 文字サイズ
  text(nf(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x, 1, 2)    + ", " +
    nf(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y, 1, 2)    + ", " +
    round(user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].z / 100) + "cm",
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x * width,
    user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y * height);

  //if (user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].y > user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y) {
  //  udp.send("takeoff", ip, port);
  //}
  //if (user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].y > user.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].y) {
  //  udp.send("land", ip, port);
  //}
}

void keyPressed() {
  if (key == 't') {
    udp.send("takeoff", ip, port);
  } else if (key == 'l') {
    udp.send("land", ip, port);
  } else if (key == 'q') {
    udp.send("cw 100", ip, port);
    udp.send("down 100", ip, port);
  } else if (key == 'w') {
    udp.send("ccw 100", ip, port);
    udp.send("down 100", ip, port);
  } else if (key == 'p') {
    udp.send("speed?", ip, port);
    udp.send("battery?", ip, port);
    udp.send("time?", ip, port);
  }
}

void receive(byte[] data, String ip, int port) {
  // 後ろ2バイトは改行コード
  data = subset(data, 0, data.length-2);
  String recMess = new String(data);

  println(recMess);
}
