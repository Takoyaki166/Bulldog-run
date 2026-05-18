// ============================================================
//  GAME SCREEN — UI layer (Title, Game, Game Over)
// ============================================================

class GameScreen {
  private GameEngine engine;

  private final int STATE_TITLE    = 0;
  private final int STATE_PLAYING  = 1;
  private final int STATE_GAMEOVER = 2;
  private int state;

  private int bestScore;
  private float titlePulse;

  // Title screen background elements (match game background)
  private float[] tCloudX = { 40, 170, 340, 110, 290, 420 };
  private float[] tCloudY = { 60, 40, 80, 110, 30, 55 };
  private float[] tCloudS = { 1.0, 1.3, 0.9, 0.7, 1.1, 0.8 };
  private float[] tBirdX  = { 80, 200, 340, 420 };
  private float[] tBirdY  = { 70, 50, 90, 65 };
  private float   tBirdAnim = 0;
  private float   tHut1X = 300, tHut2X = 780;
  private float   tPalm1X = 140, tPalm2X = 620;
  private float   tFlagWave = 0;

  GameScreen() {
    engine     = new GameEngine();
    state      = STATE_TITLE;
    bestScore  = 0;
    titlePulse = 0;
  }

  void initComponents() {
    textFont(createFont("Arial Bold", 14));
  }

  void updateDisplay() {
    if (state == STATE_TITLE) {
      drawTitleScreen();
    } else if (state == STATE_PLAYING) {
      engine.update();
      engine.renderAll();
      drawHUD();
      if (engine.isGameOver()) {
        bestScore = max(bestScore, engine.getScore());
        state = STATE_GAMEOVER;
      }
    } else if (state == STATE_GAMEOVER) {
      engine.renderAll();
      drawGameOverScreen();
    }
  }

  // ── TITLE SCREEN — matches in-game province background ─────
  private void drawTitleScreen() {
    // Animate title screen elements
    titlePulse += 0.05;
    tBirdAnim  += 0.15;

    // Update clouds
    for (int i = 0; i < tCloudX.length; i++) {
      tCloudX[i] -= 0.4 * tCloudS[i];
      if (tCloudX[i] < -120) tCloudX[i] = width + 120;
    }
    // Update birds
    for (int i = 0; i < tBirdX.length; i++) {
      tBirdX[i] -= 1.5;
      if (tBirdX[i] < -30) tBirdX[i] = width + 30;
    }
    // Update huts
    tHut1X -= 1.2; tHut2X -= 1.2;
    if (tHut1X < -160) tHut1X = tHut2X + 480;
    if (tHut2X < -160) tHut2X = tHut1X + 480;
    // Update palms
    tPalm1X -= 1.2; tPalm2X -= 1.2;
    if (tPalm1X < -60) tPalm1X = tPalm2X + 480;
    if (tPalm2X < -60) tPalm2X = tPalm1X + 480;

    tFlagWave += 0.06;

    // === DRAW PROVINCE BACKGROUND ===
    // Sky gradient
    color skyTop = color(80, 160, 230);
    color skyBot = color(180, 220, 255);
    for (int i = 0; i < height; i++) {
      float t = constrain(map(i, 0, height * 0.6, 0, 1), 0, 1);
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

    // Clouds
    for (int i = 0; i < tCloudX.length; i++) {
      drawTitleCloud(tCloudX[i], tCloudY[i], tCloudS[i]);
    }

    // Birds
    stroke(40, 40, 60); strokeWeight(1.5); noFill();
    float wingFlap = sin(tBirdAnim) * 4;
    for (int i = 0; i < tBirdX.length; i++) {
      float bx = tBirdX[i];
      float by = tBirdY[i] + sin(tBirdAnim + i) * 3;
      arc(bx - 6, by + wingFlap, 12, 8, PI, TWO_PI);
      arc(bx + 6, by - wingFlap, 12, 8, PI, TWO_PI);
    }
    noStroke();

    // Distant mountains
    noStroke();
    fill(color(100, 130, 180, 160));
    beginShape();
    vertex(0, height - 300); vertex(0, height - 230);
    vertex(60, height - 270); vertex(130, height - 220);
    vertex(200, height - 260); vertex(270, height - 210);
    vertex(340, height - 250); vertex(400, height - 215);
    vertex(480, height - 245); vertex(480, height - 300);
    endShape(CLOSE);
    fill(color(80, 140, 80, 200));
    beginShape();
    vertex(0, height - 240); vertex(0, height - 195);
    vertex(50, height - 230); vertex(110, height - 185);
    vertex(180, height - 225); vertex(240, height - 180);
    vertex(310, height - 220); vertex(380, height - 178);
    vertex(440, height - 215); vertex(480, height - 188);
    vertex(480, height - 240);
    endShape(CLOSE);

    // Grass + path
    noStroke();
    fill(color(60, 130, 50));
    rect(0, height - 200, width, 32);
    fill(color(45, 110, 40));
    rect(0, height - 172, width, 6);
    fill(color(180, 150, 100));
    rect(0, height - 166, width, 116);
    stroke(color(160, 130, 85)); strokeWeight(1);
    for (int px = 0; px < width; px += 20) {
      line(px, height - 166, px + 10, height - 50);
    }
    noStroke();
    fill(color(140, 120, 80));
    rect(0, height - 168, width, 5);
    rect(0, height - 55,  width, 5);

    // Palm trees
    drawTitlePalm(tPalm1X);
    drawTitlePalm(tPalm2X);

    // Bahay kubos
    drawTitleBahayKubo(tHut1X);
    drawTitleBahayKubo(tHut2X);

    // Foreground grass
    noStroke();
    fill(color(40, 110, 35));
    rect(0, height - 52, width, 52);
    stroke(color(50, 140, 45)); strokeWeight(2);
    for (int gx = (frameCount * 2) % 16; gx < width; gx += 16) {
      float sway = sin(frameCount * 0.06 + gx * 0.15) * 3;
      line(gx,     height - 52, gx + sway,     height - 64);
      line(gx + 5, height - 52, gx + 5 + sway, height - 60);
      line(gx + 9, height - 52, gx + 9 + sway, height - 56);
    }
    noStroke();

    // PH Flag
    drawTitlePHFlag(width - 80, height - 380, tFlagWave);

    // === TITLE UI OVERLAY ===
    // NU Manila badge
    fill(color(60, 90, 200));
    rect(width/2 - 90, 40, 180, 28, 6);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(11);
    text("NU MANILA  •  OOP PROJECT 2025", width/2, 54);

    // Game title with pulse
    float pulse = 1 + sin(titlePulse) * 0.03;
    pushMatrix();
    translate(width/2, 155);
    scale(pulse);

    fill(0, 0, 0, 80);
    textSize(54); textAlign(CENTER, CENTER);
    text("BULLDAWG", 3, 3);
    text("RUN", 3, 63);

    fill(color(255, 190, 30));
    textSize(54);
    text("BULLDAWG", 0, 0);
    fill(color(60, 90, 200));
    text("RUN", 0, 60);
    popMatrix();

    // Subtitle
    fill(color(20, 40, 100, 200));
    rect(width/2 - 120, 222, 240, 20, 5);
    fill(255);
    textSize(11); textAlign(CENTER, CENTER);
    text("RUNNING WITHOUT SIGNAL", width/2, 232);

    // Idle bulldog
    drawIdleBulldog(width/2, height - 170);

    // Stats row
    fill(0, 0, 0, 120);
    rect(width/2 - 140, height - 310, 280, 44, 8);
    fill(255);
    textSize(10); textAlign(CENTER, CENTER);
    text("BEST SCORE", width/2 - 80, height - 298);
    text("OBSTACLES",  width/2,      height - 298);
    text("LIVES",      width/2 + 80, height - 298);
    fill(color(255, 220, 50));
    textSize(14);
    text(bestScore,   width/2 - 80, height - 284);
    text("2",         width/2,      height - 284);
    text("3",         width/2 + 80, height - 284);

    // Play button
    drawButton(width/2, height - 248, 180, 44, "▶  PLAY NOW",
               color(255, 180, 0), color(30));

    // Controls hint
    fill(color(20, 40, 100, 180));
    rect(width/2 - 100, height - 222, 200, 18, 4);
    fill(255);
    textSize(10); textAlign(CENTER, CENTER);
    text("SPACEBAR or TAP to jump", width/2, height - 213);
  }

  private void drawTitleCloud(float cx, float cy, float s) {
    noStroke();
    fill(255, 255, 255, 200);
    ellipse(cx,          cy,      80*s, 36*s);
    ellipse(cx + 28*s,   cy-12*s, 60*s, 32*s);
    ellipse(cx - 26*s,   cy- 8*s, 54*s, 28*s);
    ellipse(cx + 52*s,   cy,      50*s, 28*s);
    fill(240, 245, 255, 160);
    ellipse(cx,          cy+ 8*s, 76*s, 20*s);
  }

  private void drawTitlePalm(float px) {
    float py = height - 200;
    pushMatrix();
    translate(px, py);
    stroke(color(120, 80, 40)); strokeWeight(5); noFill();
    beginShape();
    curveVertex(0,  0); curveVertex(0,  0);
    curveVertex(4, -30); curveVertex(2, -60);
    curveVertex(6, -90); curveVertex(6, -90);
    endShape();
    noStroke();
    float sway = sin(frameCount * 0.04) * 3;
    for (int a = 0; a < 7; a++) {
      float angle = map(a, 0, 6, -160, 20) + sway;
      float len   = 35 + (a % 2) * 5;
      float ex = 6 + cos(radians(angle)) * len;
      float ey = -90 + sin(radians(angle)) * len;
      stroke(color(50, 130, 40)); strokeWeight(3);
      line(6, -90, ex, ey);
      fill(color(70, 150, 55)); noStroke();
      ellipse(ex, ey, 14, 6);
    }
    noStroke();
    fill(color(100, 70, 30));
    ellipse(6, -85, 10, 10); ellipse(14, -82, 8, 8);
    popMatrix();
  }

  private void drawTitleBahayKubo(float hx) {
    float hy = height - 170;
    pushMatrix();
    translate(hx, hy);
    stroke(color(100, 70, 30)); strokeWeight(4);
    line(-28, -10, -28, 20); line(28, -10, 28, 20);
    line(-10, -10, -10, 20); line(10, -10, 10, 20);
    noStroke();
    fill(color(160, 110, 50)); rect(-38, -18, 76, 10, 2);
    fill(color(200, 160, 80)); rect(-32, -55, 64, 40);
    stroke(color(160, 120, 55)); strokeWeight(1);
    for (int wx = -30; wx < 32; wx += 7) line(wx, -55, wx, -18);
    noStroke();
    fill(color(255, 230, 150, 180));
    rect(-14, -48, 12, 14, 2); rect(2, -48, 12, 14, 2);
    fill(color(140, 90, 40)); rect(-8, -28, 16, 12, 2);
    fill(color(100, 130, 60)); triangle(-52, -55, 52, -55, 0, -105);
    fill(color(70, 100, 40)); triangle(-52, -55, 52, -55, 0, -90);
    fill(color(120, 100, 50)); rect(-6, -107, 12, 8, 3);
    fill(color(50, 140, 50));
    ellipse(-40, -8, 18, 14); ellipse(40, -8, 18, 14);
    popMatrix();
  }

  private void drawTitlePHFlag(float fx, float fy, float waveTimer) {
    stroke(color(120, 80, 40)); strokeWeight(3);
    line(fx, fy, fx, fy + 90);
    noStroke();
    float wave = sin(waveTimer) * 4;
    fill(color(0, 56, 168));
    beginShape();
    vertex(fx, fy); vertex(fx + 60, fy + wave);
    vertex(fx + 60, fy + 20 + wave); vertex(fx, fy + 20);
    endShape(CLOSE);
    fill(color(206, 17, 38));
    beginShape();
    vertex(fx, fy + 20); vertex(fx + 60, fy + 20 + wave);
    vertex(fx + 60, fy + 40 + wave); vertex(fx, fy + 40);
    endShape(CLOSE);
    fill(255);
    beginShape();
    vertex(fx, fy); vertex(fx, fy + 40); vertex(fx + 28, fy + 20);
    endShape(CLOSE);
    fill(color(252, 209, 22));
    ellipse(fx + 14, fy + 20, 12, 12);
    stroke(color(252, 209, 22)); strokeWeight(1.5);
    for (int r = 0; r < 8; r++) {
      float angle = r * TWO_PI / 8;
      line(fx+14+cos(angle)*7, fy+20+sin(angle)*7,
           fx+14+cos(angle)*12, fy+20+sin(angle)*12);
    }
    noStroke();
    fill(color(252, 209, 22));
    drawTitleStar(fx + 6,  fy + 5,  3, 1.5);
    drawTitleStar(fx + 6,  fy + 35, 3, 1.5);
    drawTitleStar(fx + 24, fy + 20, 3, 1.5);
  }

  private void drawTitleStar(float sx, float sy, float outer, float inner) {
    noStroke();
    beginShape();
    for (int i = 0; i < 5; i++) {
      float outerAngle = -HALF_PI + i * TWO_PI / 5;
      vertex(sx + cos(outerAngle)*outer, sy + sin(outerAngle)*outer);
      float innerAngle = outerAngle + TWO_PI / 10;
      vertex(sx + cos(innerAngle)*inner, sy + sin(innerAngle)*inner);
    }
    endShape(CLOSE);
  }

  private void drawIdleBulldog(float cx, float cy) {
    pushMatrix();
    translate(cx, cy);
    noStroke(); fill(0, 0, 0, 50);
    ellipse(0, 4, 50, 10);
    fill(color(60, 90, 200));
    rect(-22, -52, 44, 36, 8);
    fill(color(255, 190, 30));
    textAlign(CENTER, CENTER); textSize(10);
    text("NU", 0, -36);
    fill(color(230, 180, 140));
    ellipse(0, -56, 36, 32);
    ellipse(-16, -64, 14, 18); ellipse(16, -64, 14, 18);
    fill(color(200, 140, 100));
    ellipse(-16, -62, 8, 12); ellipse(16, -62, 8, 12);
    fill(255); ellipse(-8, -58, 10, 10); ellipse(8, -58, 10, 10);
    fill(30);  ellipse(-8, -58, 5, 6);   ellipse(8, -58, 5, 6);
    fill(255); ellipse(-6, -59, 2, 2);   ellipse(10, -59, 2, 2);
    fill(color(200, 140, 100)); ellipse(0, -50, 18, 12);
    fill(30); ellipse(0, -53, 10, 7);
    noFill(); stroke(30); strokeWeight(1.5);
    arc(0, -48, 12, 8, 0, PI); noStroke();
    fill(color(30, 30, 100));
    rect(-14, -16, 13, 18, 5); rect(2, -16, 13, 18, 5);
    fill(color(255, 190, 30));
    rect(-18, 0, 18, 9, 3); rect(2, 0, 18, 9, 3);
    popMatrix();
  }

  // ── HUD ───────────────────────────────────────────────────
  private void drawHUD() {
    fill(0, 0, 0, 130); noStroke();
    rect(0, 0, width, 56);
    fill(color(255, 220, 50));
    textAlign(LEFT, TOP); textSize(11);
    text("SCORE", 16, 8);
    textSize(24);
    text(nf(engine.getScore(), 5), 16, 22);
    fill(color(100, 200, 255));
    textAlign(LEFT, TOP); textSize(10);
    text("SPEED", width/2 - 30, 8);
    textSize(13);
    text("x" + nf(4.5 + engine.getScore() * 0.003, 1, 1), width/2 - 30, 22);
    textAlign(RIGHT, TOP); textSize(11);
    fill(color(200, 180, 180));
    text("LIVES", width - 16, 8);
    for (int i = 0; i < 3; i++) {
      if (i < engine.getLives()) fill(color(255, 60, 80));
      else                        fill(color(80, 40, 50));
      drawHeart(width - 24 - i * 22, 28, 9);
    }
    fill(255, 255, 255, 60);
    rect(width - 38, 6, 24, 20, 4);
    fill(255);
    textAlign(CENTER, CENTER); textSize(10);
    text("II", width - 26, 16);
  }

  private void drawHeart(float hx, float hy, float r) {
    noStroke();
    ellipse(hx - r * 0.5, hy - r * 0.4, r, r);
    ellipse(hx + r * 0.5, hy - r * 0.4, r, r);
    triangle(hx - r, hy - r * 0.1,
             hx + r, hy - r * 0.1,
             hx,     hy + r * 0.8);
  }

  // ── GAME OVER SCREEN ──────────────────────────────────────
  private void drawGameOverScreen() {
    fill(0, 0, 0, 160); noStroke();
    rect(0, 0, width, height);
    fill(color(15, 20, 50, 240));
    stroke(color(255, 190, 30)); strokeWeight(2);
    rect(width/2 - 160, height/2 - 180, 320, 360, 16);
    noStroke();
    fill(color(255, 60, 80));
    textAlign(CENTER, CENTER); textSize(36);
    text("GAME OVER", width/2, height/2 - 130);
    fill(color(60, 90, 200));
    ellipse(width/2, height/2 - 70, 50, 40);
    fill(color(230, 180, 140));
    ellipse(width/2, height/2 - 85, 36, 30);
    fill(30); ellipse(width/2 - 8, height/2 - 87, 5, 5);
              ellipse(width/2 + 8, height/2 - 87, 5, 5);
    noFill(); stroke(30); strokeWeight(1.5);
    arc(width/2, height/2 - 77, 14, 10, PI, TWO_PI);
    noStroke();
    fill(color(160, 180, 220));
    textSize(12); textAlign(CENTER, CENTER);
    text("YOUR SCORE", width/2, height/2 - 20);
    fill(color(255, 220, 50));
    textSize(40);
    text(engine.getScore(), width/2, height/2 + 18);
    fill(color(130, 160, 210));
    textSize(11);
    text("BEST  " + bestScore, width/2, height/2 + 55);
    stroke(color(255, 190, 30, 80)); strokeWeight(1);
    line(width/2 - 100, height/2 + 70, width/2 + 100, height/2 + 70);
    noStroke();
    drawButton(width/2, height/2 + 110, 200, 48, "▶  PLAY AGAIN",
               color(255, 180, 0), color(30));
    fill(color(130, 150, 200));
    textSize(10);
    text("Press R to restart", width/2, height/2 + 148);
  }

  // ── HELPERS ───────────────────────────────────────────────
  private void drawButton(float bx, float by, float bw, float bh,
                          String label, color bg, color fg) {
    boolean hover = mouseX > bx - bw/2 && mouseX < bx + bw/2 &&
                    mouseY > by - bh/2 && mouseY < by + bh/2;
    fill(hover ? color(red(bg)+30, green(bg)+30, blue(bg)+30) : bg);
    stroke(color(255, 255, 255, 80)); strokeWeight(1);
    rect(bx - bw/2, by - bh/2, bw, bh, 10);
    noStroke();
    fill(fg);
    textAlign(CENTER, CENTER); textSize(16);
    text(label, bx, by);
  }

  // ── INPUT HANDLERS ────────────────────────────────────────
  void handleJump() {
    if (state == STATE_PLAYING) engine.handleJump();
  }

  void handleRestart() {
    if (state == STATE_GAMEOVER || state == STATE_TITLE) startPlaying();
  }

  void handleMousePress(int mx, int my) {
    if (state == STATE_TITLE) {
      if (mx > width/2 - 90 && mx < width/2 + 90 &&
          my > height - 270 && my < height - 226) {
        startPlaying();
      }
    } else if (state == STATE_PLAYING) {
      if (my > 60) engine.handleJump();
      if (mx > width - 42 && mx < width - 14 && my > 4 && my < 28) {
        if (engine.isPlaying()) engine.pauseGame();
        else                    engine.resumeGame();
      }
    } else if (state == STATE_GAMEOVER) {
      if (mx > width/2 - 100 && mx < width/2 + 100 &&
          my > height/2 + 86  && my < height/2 + 134) {
        startPlaying();
      }
    }
  }

  private void startPlaying() {
    engine.startGame();
    state = STATE_PLAYING;
  }
}
