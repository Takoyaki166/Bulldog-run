// ============================================================
//  BACKGROUND — Filipino Province: Bahay Kubo & Province Scene
// ============================================================

class Background extends GameObject {
  private float offset1, offset2;

  // Sky colors — bright daytime province sky
  private color skyTop = color(80, 160, 230);
  private color skyBot = color(180, 220, 255);

  // Cloud positions
  private float[] cloudX = { 50, 180, 350, 120, 300, 430 };
  private float[] cloudY = { 60, 40, 80, 110, 30, 55 };
  private float[] cloudS = { 1.0, 1.3, 0.9, 0.7, 1.1, 0.8 };

  // Bahay kubo positions (two houses cycling)
  private float hut1X, hut2X;

  // Palm tree positions (two trees cycling)
  private float palm1X, palm2X;

  // Birds
  private float[] birdX = { 80, 200, 340, 420 };
  private float[] birdY = { 70, 50, 90, 65 };
  private float   birdAnim = 0;

  Background() {
    super(0, 0, 1);
    offset1 = 0;
    offset2 = 480;
    hut1X   = 320;
    hut2X   = 320 + 480;
    palm1X  = 150;
    palm2X  = 150 + 480;
  }

  @Override
  void update() {
    offset1 -= 0.6;
    offset2 -= 0.6;
    if (offset1 < -480) offset1 = 480;
    if (offset2 < -480) offset2 = 480;

    hut1X -= 1.2;
    hut2X -= 1.2;
    if (hut1X < -160) hut1X = hut2X + 480;
    if (hut2X < -160) hut2X = hut1X + 480;

    palm1X -= 1.2;
    palm2X -= 1.2;
    if (palm1X < -60) palm1X = palm2X + 480;
    if (palm2X < -60) palm2X = palm1X + 480;

    for (int i = 0; i < cloudX.length; i++) {
      cloudX[i] -= 0.4 * cloudS[i];
      if (cloudX[i] < -120) cloudX[i] = width + 120;
    }

    for (int i = 0; i < birdX.length; i++) {
      birdX[i] -= 1.5;
      if (birdX[i] < -30) birdX[i] = width + 30;
    }

    birdAnim += 0.15;
  }

  @Override
  void render() {
    drawSky();
    drawClouds();
    drawBirds();
    drawDistantMountains();
    drawGrassGround();
    drawPath();
    drawPalmTree(palm1X);
    drawPalmTree(palm2X);
    drawBahayKubo(hut1X);
    drawBahayKubo(hut2X);
    drawPathDetails();
    drawForegroundGrass();
    drawPHFlag(width - 80, height - 380);
  }

  private void drawSky() {
    for (int i = 0; i < height; i++) {
      float t = map(i, 0, height * 0.6, 0, 1);
      t = constrain(t, 0, 1);
      stroke(lerpColor(skyTop, skyBot, t));
      line(0, i, width, i);
    }
    noStroke();

    // Sun
    fill(255, 240, 100, 220);
    ellipse(60, 55, 52, 52);
    fill(255, 240, 100, 60);
    ellipse(60, 55, 74, 74);
    fill(255, 240, 100, 30);
    ellipse(60, 55, 96, 96);
  }

  private void drawClouds() {
    for (int i = 0; i < cloudX.length; i++) {
      drawCloud(cloudX[i], cloudY[i], cloudS[i]);
    }
  }

  private void drawCloud(float cx, float cy, float s) {
    noStroke();
    fill(255, 255, 255, 200);
    ellipse(cx,          cy,      80*s, 36*s);
    ellipse(cx + 28*s,   cy-12*s, 60*s, 32*s);
    ellipse(cx - 26*s,   cy- 8*s, 54*s, 28*s);
    ellipse(cx + 52*s,   cy,      50*s, 28*s);
    fill(240, 245, 255, 160);
    ellipse(cx,          cy+ 8*s, 76*s, 20*s);
  }

  private void drawBirds() {
    stroke(40, 40, 60);
    strokeWeight(1.5);
    noFill();
    float wingFlap = sin(birdAnim) * 4;
    for (int i = 0; i < birdX.length; i++) {
      float bx = birdX[i];
      float by = birdY[i] + sin(birdAnim + i) * 3;
      arc(bx - 6, by + wingFlap, 12, 8, PI, TWO_PI);
      arc(bx + 6, by - wingFlap, 12, 8, PI, TWO_PI);
    }
    noStroke();
  }

  private void drawDistantMountains() {
    noStroke();
    fill(color(100, 130, 180, 160));
    beginShape();
    vertex(0, height - 300);
    vertex(0, height - 230);
    vertex(60,  height - 270);
    vertex(130, height - 220);
    vertex(200, height - 260);
    vertex(270, height - 210);
    vertex(340, height - 250);
    vertex(400, height - 215);
    vertex(480, height - 245);
    vertex(480, height - 300);
    endShape(CLOSE);

    fill(color(80, 140, 80, 200));
    beginShape();
    vertex(0,   height - 240);
    vertex(0,   height - 195);
    vertex(50,  height - 230);
    vertex(110, height - 185);
    vertex(180, height - 225);
    vertex(240, height - 180);
    vertex(310, height - 220);
    vertex(380, height - 178);
    vertex(440, height - 215);
    vertex(480, height - 188);
    vertex(480, height - 240);
    endShape(CLOSE);
  }

  private void drawGrassGround() {
    noStroke();
    fill(color(60, 130, 50));
    rect(0, height - 200, width, 32);
    fill(color(45, 110, 40));
    rect(0, height - 172, width, 6);
  }

  private void drawPath() {
    noStroke();
    fill(color(180, 150, 100));
    rect(0, height - 166, width, 116);

    stroke(color(160, 130, 85));
    strokeWeight(1);
    for (int px = 0; px < width; px += 20) {
      line(px, height - 166, px + 10, height - 50);
    }
    noStroke();

    fill(color(140, 120, 80));
    rect(0, height - 168, width, 5);
    rect(0, height - 55,  width, 5);
  }

  private void drawPalmTree(float px) {
    float py = height - 200;
    pushMatrix();
    translate(px, py);

    stroke(color(120, 80, 40));
    strokeWeight(5);
    noFill();
    beginShape();
    curveVertex(0,  0);
    curveVertex(0,  0);
    curveVertex(4, -30);
    curveVertex(2, -60);
    curveVertex(6, -90);
    curveVertex(6, -90);
    endShape();
    noStroke();

    float sway = sin(frameCount * 0.04) * 3;
    for (int a = 0; a < 7; a++) {
      float angle = map(a, 0, 6, -160, 20) + sway;
      float len   = 35 + (a % 2) * 5;
      float ex = 6 + cos(radians(angle)) * len;
      float ey = -90 + sin(radians(angle)) * len;
      stroke(color(50, 130, 40));
      strokeWeight(3);
      line(6, -90, ex, ey);
      fill(color(70, 150, 55));
      noStroke();
      ellipse(ex, ey, 14, 6);
    }
    noStroke();

    fill(color(100, 70, 30));
    ellipse(6, -85, 10, 10);
    ellipse(14, -82, 8, 8);

    popMatrix();
  }

  private void drawBahayKubo(float hx) {
    float hy = height - 170;
    pushMatrix();
    translate(hx, hy);

    stroke(color(100, 70, 30));
    strokeWeight(4);
    line(-28, -10, -28, 20);
    line( 28, -10,  28, 20);
    line(-10, -10, -10, 20);
    line( 10, -10,  10, 20);
    noStroke();

    fill(color(160, 110, 50));
    rect(-38, -18, 76, 10, 2);

    fill(color(200, 160, 80));
    rect(-32, -55, 64, 40);

    stroke(color(160, 120, 55));
    strokeWeight(1);
    for (int wx = -30; wx < 32; wx += 7) {
      line(wx, -55, wx, -18);
    }
    noStroke();

    fill(color(255, 230, 150, 180));
    rect(-14, -48, 12, 14, 2);
    rect(  2, -48, 12, 14, 2);
    stroke(color(120, 80, 30)); strokeWeight(1);
    line(-8, -48, -8, -34);
    line( 8, -48,  8, -34);
    noStroke();

    fill(color(140, 90, 40));
    rect(-8, -28, 16, 12, 2);

    fill(color(100, 130, 60));
    triangle(-52, -55, 52, -55, 0, -105);

    fill(color(70, 100, 40));
    triangle(-52, -55, 52, -55, 0, -90);

    stroke(color(80, 110, 45));
    strokeWeight(1);
    for (int rl = -4; rl <= 4; rl++) {
      float rx = rl * 10.0;
      float topY = map(abs(rx), 0, 50, -105, -60);
      line(rx, topY, rx < 0 ? -52 : 52, -55);
    }
    noStroke();

    fill(color(120, 100, 50));
    rect(-6, -107, 12, 8, 3);

    fill(color(50, 140, 50));
    ellipse(-40, -8, 18, 14);
    ellipse( 40, -8, 18, 14);
    fill(color(60, 160, 60));
    ellipse(-40, -12, 12, 10);
    ellipse( 40, -12, 12, 10);

    popMatrix();
  }

  private void drawPathDetails() {
    noStroke();
    fill(color(200, 185, 155));
    for (int i = 0; i < 20; i++) {
      float px = (i * 83 + frameCount) % width;
      float py = height - 140 + (i % 5) * 14;
      ellipse(px, py, 5, 3);
    }

    fill(color(160, 110, 40, 180));
    for (int i = 0; i < 10; i++) {
      float lx = (i * 137 + frameCount * 2) % width;
      float ly = height - 155 + (i % 4) * 18;
      ellipse(lx, ly, 7, 4);
    }
  }

  private void drawForegroundGrass() {
    noStroke();
    fill(color(40, 110, 35));
    rect(0, height - 52, width, 52);

    stroke(color(50, 140, 45));
    strokeWeight(2);
    for (int gx = (frameCount * 2) % 16; gx < width; gx += 16) {
      float sway = sin(frameCount * 0.06 + gx * 0.15) * 3;
      line(gx,     height - 52, gx + sway,     height - 64);
      line(gx + 5, height - 52, gx + 5 + sway, height - 60);
      line(gx + 9, height - 52, gx + 9 + sway, height - 56);
    }
    noStroke();
  }

  // === PHILIPPINE FLAG ===
  private void drawPHFlag(float fx, float fy) {
    // Flagpole
    stroke(color(120, 80, 40));
    strokeWeight(3);
    line(fx, fy, fx, fy + 90);
    noStroke();

    // Wave animation
    float wave = sin(frameCount * 0.06) * 4;

    // Blue top half
    fill(color(0, 56, 168));
    beginShape();
    vertex(fx,       fy);
    vertex(fx + 60,  fy + wave);
    vertex(fx + 60,  fy + 20 + wave);
    vertex(fx,       fy + 20);
    endShape(CLOSE);

    // Red bottom half
    fill(color(206, 17, 38));
    beginShape();
    vertex(fx,       fy + 20);
    vertex(fx + 60,  fy + 20 + wave);
    vertex(fx + 60,  fy + 40 + wave);
    vertex(fx,       fy + 40);
    endShape(CLOSE);

    // White triangle on hoist side
    fill(255);
    beginShape();
    vertex(fx,      fy);
    vertex(fx,      fy + 40);
    vertex(fx + 28, fy + 20);
    endShape(CLOSE);

    // Yellow sun
    fill(color(252, 209, 22));
    ellipse(fx + 14, fy + 20, 12, 12);

    // Sun rays (8)
    stroke(color(252, 209, 22));
    strokeWeight(1.5);
    for (int r = 0; r < 8; r++) {
      float angle = r * TWO_PI / 8;
      line(fx + 14 + cos(angle) * 7, fy + 20 + sin(angle) * 7,
           fx + 14 + cos(angle) * 12, fy + 20 + sin(angle) * 12);
    }
    noStroke();

    // Three stars
    fill(color(252, 209, 22));
    drawStar(fx + 6,  fy + 5,  3, 1.5);
    drawStar(fx + 6,  fy + 35, 3, 1.5);
    drawStar(fx + 24, fy + 20, 3, 1.5);
  }

  private void drawStar(float sx, float sy, float outer, float inner) {
    noStroke();
    beginShape();
    for (int i = 0; i < 5; i++) {
      float outerAngle = -HALF_PI + i * TWO_PI / 5;
      vertex(sx + cos(outerAngle) * outer, sy + sin(outerAngle) * outer);
      float innerAngle = outerAngle + TWO_PI / 10;
      vertex(sx + cos(innerAngle) * inner, sy + sin(innerAngle) * inner);
    }
    endShape(CLOSE);
  }

  @Override
  void onCollide() { }

  void scroll() { update(); }
  void reset()  { offset1 = 0; offset2 = 480; }
}
