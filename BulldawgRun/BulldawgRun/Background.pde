// ============================================================
//  BACKGROUND — Filipino Province: Bahay Kubo + PH Flag
//  Fully dynamic — uses width/height for any screen size
// ============================================================

class Background extends GameObject {
  private float offset1, offset2;
  private float hut1X, hut2X;
  private float[] cloudX = { 0.10, 0.37, 0.72, 0.25, 0.62, 0.88 };
  private float[] cloudY = { 0.08, 0.05, 0.11, 0.15, 0.04, 0.07 };
  private float[] cloudS = { 1.0,  1.3,  0.9,  0.7,  1.1,  0.8  };
  private float[] birdX  = { 0.16, 0.42, 0.70, 0.87 };
  private float[] birdY  = { 0.09, 0.07, 0.12, 0.08 };
  private float   birdAnim = 0;
  private float   flagWave = 0;

  // Ground / road level as fraction of height
  final float GROUND_F  = 0.72;  // top of grass strip
  final float ROAD_TOP  = 0.75;  // top of dirt path
  final float ROAD_BOT  = 0.93;  // bottom of dirt path

  Background() {
    super(0, 0, 1);
    offset1 = 0;
    offset2 = 1;   // will be set to width in first update
    hut1X   = -1;  // sentinel — initialised on first update
    hut2X   = -1;
  }

  @Override
  void update() {
    // Lazy-init so width is valid
    if (offset2 == 1) { offset2 = width; }
    if (hut1X   == -1) { hut1X = width * 0.62; hut2X = hut1X + width * 1.05; }

    float scrollSpd = width * 0.001;

    offset1 -= scrollSpd * 0.5;
    offset2 -= scrollSpd * 0.5;
    if (offset1 < -width) offset1 = width;
    if (offset2 < -width) offset2 = width;

    hut1X -= scrollSpd * 1.0;
    hut2X -= scrollSpd * 1.0;
    if (hut1X < -width * 0.18) hut1X = hut2X + width * 1.05;
    if (hut2X < -width * 0.18) hut2X = hut1X + width * 1.05;

    for (int i = 0; i < cloudX.length; i++) {
      cloudX[i] -= 0.00035 * cloudS[i];
      if (cloudX[i] < -0.15) cloudX[i] = 1.15;
    }
    for (int i = 0; i < birdX.length; i++) {
      birdX[i] -= 0.0012;
      if (birdX[i] < -0.06) birdX[i] = 1.06;
    }
    birdAnim += 0.15;
    flagWave += 0.08;
  }

  @Override
  void render() {
    drawSky();
    drawClouds();
    drawBirds();
    drawDistantMountains();
    drawGrassField((int)offset1);
    drawGrassField((int)offset2);
    drawGrassGround();
    drawPath();
    drawBahayKubo(hut1X, height * GROUND_F);
    drawBahayKubo(hut2X, height * GROUND_F);
    drawPalmTree(hut1X + width * 0.12, height * GROUND_F);
    drawPalmTree(hut2X - width * 0.08, height * GROUND_F);
    drawPHFlag(width * 0.88, height * 0.18);
    drawPathDetails();
    drawForegroundGrass();
  }

  void drawSky() {
    for (int i = 0; i < height; i++) {
      float t = constrain(map(i, 0, height * 0.65, 0, 1), 0, 1);
      stroke(lerpColor(color(85, 165, 235), color(185, 225, 255), t));
      line(0, i, width, i);
    }
    noStroke();
    // Sun
    float sx = width * 0.07, sy = height * 0.08, sr = height * 0.06;
    fill(255, 245, 100, 230); ellipse(sx, sy, sr, sr);
    fill(255, 245, 100,  55); ellipse(sx, sy, sr*1.42, sr*1.42);
    fill(255, 245, 100,  25); ellipse(sx, sy, sr*1.85, sr*1.85);
  }

  void drawClouds() {
    for (int i = 0; i < cloudX.length; i++) {
      drawCloud(cloudX[i] * width, cloudY[i] * height, cloudS[i]);
    }
  }

  void drawCloud(float cx, float cy, float s) {
    float u = width * 0.055;
    noStroke();
    fill(255, 255, 255, 210);
    ellipse(cx,       cy,      u*1.5*s, u*0.65*s);
    ellipse(cx+u*s,   cy-u*0.23*s, u*1.1*s, u*0.58*s);
    ellipse(cx-u*0.95*s, cy-u*0.14*s, u*s, u*0.5*s);
    ellipse(cx+u*1.9*s,  cy,     u*0.9*s, u*0.47*s);
    fill(240, 246, 255, 150);
    ellipse(cx, cy+u*0.16*s, u*1.4*s, u*0.36*s);
  }

  void drawBirds() {
    stroke(35, 35, 55); strokeWeight(max(1, height*0.002));
    noFill();
    for (int i = 0; i < birdX.length; i++) {
      float bx = birdX[i] * width;
      float by = birdY[i] * height + sin(birdAnim + i) * height * 0.004;
      float flap = sin(birdAnim + i * 1.3) * height * 0.005;
      float ws = height * 0.012;
      arc(bx - ws, by + flap, ws*1.6, ws, PI, TWO_PI);
      arc(bx + ws, by - flap, ws*1.6, ws, PI, TWO_PI);
    }
    noStroke();
  }

  void drawDistantMountains() {
    float g = height * GROUND_F;
    noStroke();
    // Far range
    fill(110, 145, 190, 150);
    beginShape();
    vertex(0,       g);
    vertex(0,       g - height*0.11);
    vertex(width*0.11, g - height*0.17);
    vertex(width*0.27, g - height*0.10);
    vertex(width*0.43, g - height*0.16);
    vertex(width*0.57, g - height*0.09);
    vertex(width*0.72, g - height*0.15);
    vertex(width*0.84, g - height*0.09);
    vertex(width,   g - height*0.13);
    vertex(width,   g);
    endShape(CLOSE);
    // Near range
    fill(75, 145, 75, 210);
    beginShape();
    vertex(0,       g);
    vertex(0,       g - height*0.07);
    vertex(width*0.11, g - height*0.12);
    vertex(width*0.24, g - height*0.06);
    vertex(width*0.38, g - height*0.12);
    vertex(width*0.52, g - height*0.05);
    vertex(width*0.65, g - height*0.11);
    vertex(width*0.80, g - height*0.05);
    vertex(width*0.92, g - height*0.10);
    vertex(width,   g - height*0.05);
    vertex(width,   g);
    endShape(CLOSE);
  }

  void drawGrassField(int xOff) {
    float g   = height * GROUND_F;
    float u   = width;
    noStroke();
    fill(85, 160, 65);
    beginShape();
    vertex(xOff,          g);
    vertex(xOff,          g - height*0.025);
    vertex(xOff+u*0.12,   g - height*0.033);
    vertex(xOff+u*0.25,   g - height*0.020);
    vertex(xOff+u*0.41,   g - height*0.030);
    vertex(xOff+u*0.58,   g - height*0.018);
    vertex(xOff+u*0.75,   g - height*0.027);
    vertex(xOff+u*0.91,   g - height*0.016);
    vertex(xOff+u,        g - height*0.024);
    vertex(xOff+u,        g);
    endShape(CLOSE);

    // Wildflowers
    for (int fx = xOff + (int)(u*0.02); fx < xOff + (int)u; fx += (int)(u*0.075)) {
      float fy = g - height*0.03 + sin(fx * 0.05) * height*0.008;
      stroke(50, 120, 40); strokeWeight(1);
      line(fx, fy, fx, fy - height*0.015);
      noStroke();
      fill(255, 200, 50, 200);
      float fr = height * 0.006;
      ellipse(fx, fy - height*0.017, fr*2, fr*2);
      fill(255, 100, 120, 200);
      ellipse(fx + (int)(u*0.04), fy - height*0.012, fr*1.7, fr*1.7);
    }
    noStroke();
  }

  void drawGrassGround() {
    float g = height * GROUND_F;
    noStroke();
    fill(62, 135, 52);
    rect(0, g, width, height * 0.05);
    fill(48, 115, 42);
    rect(0, g + height*0.048, width, height*0.008);
  }

  void drawPath() {
    float rt = height * ROAD_TOP;
    float rb = height * ROAD_BOT;
    float rh = rb - rt;
    noStroke();
    fill(185, 155, 105);
    rect(0, rt, width, rh);
    // Tire tracks
    stroke(165, 135, 88); strokeWeight(1);
    for (int px = 0; px < width; px += (int)(width*0.045)) {
      line(px, rt, px + width*0.022, rb);
    }
    noStroke();
    fill(145, 118, 78);
    rect(0, rt - height*0.004, width, height*0.007);
    rect(0, rb - height*0.007, width, height*0.007);
  }

  void drawBahayKubo(float hx, float hy) {
    float s = height * 0.0016; // scale factor
    pushMatrix();
    translate(hx, hy);

    // Stilts
    stroke(100, 70, 30); strokeWeight(max(2, s*2.5));
    line(-28*s, -10*s, -28*s,  22*s);
    line( 28*s, -10*s,  28*s,  22*s);
    line(-10*s, -10*s, -10*s,  22*s);
    line( 10*s, -10*s,  10*s,  22*s);
    noStroke();

    // Floor
    fill(162, 112, 52);
    rect(-40*s, -20*s, 80*s, 12*s, 2);

    // Walls
    fill(205, 162, 82);
    rect(-34*s, -58*s, 68*s, 40*s);
    stroke(162, 122, 58); strokeWeight(1);
    for (float wx = -32*s; wx < 34*s; wx += 7*s) {
      line(wx, -58*s, wx, -20*s);
    }
    noStroke();

    // Windows
    fill(255, 235, 155, 185);
    rect(-16*s, -50*s, 13*s, 15*s, 2);
    rect(  3*s, -50*s, 13*s, 15*s, 2);
    stroke(118, 78, 30); strokeWeight(1);
    line(-10*s, -50*s, -10*s, -35*s);
    line(  9*s, -50*s,   9*s, -35*s);
    noStroke();

    // Door
    fill(138, 88, 40);
    rect(-9*s, -30*s, 18*s, 14*s, 2);

    // Roof
    fill(95, 130, 58);
    triangle(-56*s, -58*s, 56*s, -58*s, 0, -112*s);
    fill(68, 105, 42);
    triangle(-56*s, -58*s, 56*s, -58*s, 0, -95*s);
    stroke(78, 112, 46); strokeWeight(1);
    for (int rl = -4; rl <= 4; rl++) {
      float rx = rl * 11.0 * s;
      float topY = map(abs(rx), 0, 52*s, -112*s, -62*s);
      line(rx, topY, rx < 0 ? -56*s : 56*s, -58*s);
    }
    noStroke();
    fill(118, 98, 48);
    rect(-7*s, -115*s, 14*s, 9*s, 3);

    // Plants
    fill(48, 145, 52);
    ellipse(-44*s, -10*s, 20*s, 15*s);
    ellipse( 44*s, -10*s, 20*s, 15*s);
    fill(62, 165, 62);
    ellipse(-44*s, -14*s, 13*s, 11*s);
    ellipse( 44*s, -14*s, 13*s, 11*s);

    popMatrix();
  }

  void drawPalmTree(float tx, float ty) {
    float s = height * 0.0016;
    pushMatrix();
    translate(tx, ty);
    // Trunk
    stroke(120, 80, 40); strokeWeight(max(3, s*4));
    for (int seg = 0; seg < 6; seg++) {
      float sway = sin(seg * 0.8 + flagWave * 0.3) * 2 * s;
      line(sway * seg, -seg*18*s, sway*(seg+1), -(seg+1)*18*s);
    }
    noStroke();
    // Fronds
    float topY = -108*s;
    fill(60, 150, 50);
    for (int f = 0; f < 7; f++) {
      float angle = f * TWO_PI / 7 - HALF_PI;
      float len   = 38*s;
      beginShape();
      vertex(0, topY);
      vertex(cos(angle)*len*0.5 + cos(angle+0.3)*8*s,
             topY + sin(angle)*len*0.5 + sin(angle+0.3)*8*s);
      vertex(cos(angle)*len, topY + sin(angle)*len);
      endShape();
    }
    // Coconuts
    fill(100, 70, 30);
    ellipse(6*s, topY+8*s, 10*s, 10*s);
    ellipse(-5*s, topY+12*s, 9*s, 9*s);
    popMatrix();
  }

  void drawPHFlag(float fx, float fy) {
    float fw = width  * 0.12;
    float fh = height * 0.09;
    pushMatrix();
    translate(fx, fy);

    // Flagpole
    stroke(160, 140, 100); strokeWeight(max(2, height*0.003));
    line(0, 0, 0, -fh * 1.4);
    noStroke();

    float fy0 = -fh * 1.4;

    // Blue band (top)
    for (int row = 0; row < (int)(fh/2); row++) {
      float wave = sin(flagWave + row * 0.3) * fw * 0.04;
      fill(0, 56, 168);
      rect(wave * 0.2, fy0 + row, fw, 1);
    }
    // Red band (bottom)
    for (int row = (int)(fh/2); row < (int)fh; row++) {
      float wave = sin(flagWave + row * 0.3) * fw * 0.04;
      fill(206, 17, 38);
      rect(wave * 0.2, fy0 + row, fw, 1);
    }

    // White triangle
    fill(255);
    triangle(0, fy0, 0, fy0+fh, fh*0.65, fy0+fh/2);

    // Sun
    float sunX = fh * 0.24;
    float sunY = fy0 + fh/2.0;
    float sr   = fh * 0.14;
    fill(252, 209, 22);
    ellipse(sunX, sunY, sr, sr);
    stroke(252, 209, 22); strokeWeight(max(1, height*0.002));
    for (int r = 0; r < 8; r++) {
      float angle = r * TWO_PI/8 - QUARTER_PI;
      line(sunX+cos(angle)*sr*0.7, sunY+sin(angle)*sr*0.7,
           sunX+cos(angle)*sr*1.4, sunY+sin(angle)*sr*1.4);
    }
    noStroke();

    // Three stars
    float starR = fh * 0.045;
    drawStar(fh*0.24,  fy0 + fh*0.12,  starR);
    drawStar(fh*0.24,  fy0 + fh*0.88,  starR);
    drawStar(fh*0.57,  fy0 + fh*0.5,   starR);

    // Border
    noFill(); stroke(0, 0, 0, 60); strokeWeight(1);
    rect(0, fy0, fw, fh);
    noStroke();

    popMatrix();
  }

  void drawStar(float sx, float sy, float r) {
    fill(252, 209, 22); noStroke();
    beginShape();
    for (int i = 0; i < 5; i++) {
      float oa = -HALF_PI + i * TWO_PI/5;
      float ia = oa + PI/5;
      vertex(sx+cos(oa)*r,     sy+sin(oa)*r);
      vertex(sx+cos(ia)*r*0.4, sy+sin(ia)*r*0.4);
    }
    endShape(CLOSE);
  }

  void drawPathDetails() {
    float rt = height * ROAD_TOP;
    float rh = height * (ROAD_BOT - ROAD_TOP);
    noStroke();
    fill(200, 182, 152);
    for (int i = 0; i < 28; i++) {
      float px = (i * 87 + frameCount) % width;
      float py = rt + rh*0.3 + (i % 5) * rh*0.1;
      ellipse(px, py, width*0.004, height*0.004);
    }
    fill(155, 108, 38, 175);
    for (int i = 0; i < 14; i++) {
      float lx = (i * 141 + frameCount * 2) % width;
      float ly = rt + rh*0.15 + (i % 4) * rh*0.18;
      ellipse(lx, ly, width*0.006, height*0.005);
    }
  }

  void drawForegroundGrass() {
    float rb = height * ROAD_BOT;
    noStroke();
    fill(42, 115, 36);
    rect(0, rb, width, height - rb);
    stroke(52, 142, 46); strokeWeight(max(1.5, height*0.002));
    for (int gx = (frameCount * 2) % 16; gx < width; gx += 16) {
      float sway = sin(frameCount * 0.06 + gx * 0.15) * 3;
      float gh   = height * 0.018;
      line(gx,   rb, gx+sway,   rb-gh);
      line(gx+5, rb, gx+5+sway, rb-gh*0.8);
      line(gx+9, rb, gx+9+sway, rb-gh*0.6);
    }
    noStroke();
  }

  @Override
  void onCollide() { }
  void scroll()    { update(); }
  void reset()     { offset1 = 0; offset2 = width; }
}
