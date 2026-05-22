// ============================================================
//  GAME SCREEn
// ============================================================

class GameScreen {
  private GameEngine engine;

  private final int STATE_TITLE    = 0;
  private final int STATE_PLAYING  = 1;
  private final int STATE_GAMEOVER = 2;
  private int state;

  private int   bestScore;
  private float titlePulse;

  // shared background instance used on title screen too
  private Background titleBg;

  GameScreen() {
    engine     = new GameEngine();
    state      = STATE_TITLE;
    bestScore  = 0;
    titlePulse = 0;
    titleBg    = new Background();
  }

  void initComponents() {
    textFont(createFont("Arial Bold", 14));
  }

  void updateDisplay() {
    if (state == STATE_TITLE) {
      titleBg.update();
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

  // ── TITLE SCREEN ──────────────────────────────────────────
  private void drawTitleScreen() {
    // draw the same province background as the game
    titleBg.render();

    float cx = width / 2.0;
    float cy = height / 2.0;

    // NU Manila badge — top center
    float badgeW = width * 0.28;
    float badgeH = height * 0.042;
    fill(60, 90, 200);
    rect(cx - badgeW/2, height*0.04, badgeW, badgeH, 6);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(constrain(height*0.022, 10, 18));
    text("NU MANILA  •  OOP PROJECT 2025", cx, height*0.04 + badgeH/2);

    // Game title card — semi-transparent
    float cardW = width * 0.38;
    float cardH = height * 0.32;
    float cardX = cx - cardW/2;
    float cardY = cy - cardH/2 - height*0.04;
    fill(0, 0, 0, 120);
    rect(cardX, cardY, cardW, cardH, 16);

    // Title text
    titlePulse += 0.05;
    float pulse = 1 + sin(titlePulse) * 0.02;
    pushMatrix();
    translate(cx, cardY + cardH*0.30);
    scale(pulse);
    float ts = constrain(height * 0.09, 32, 80);
    // Shadow
    fill(0, 0, 0, 100);
    textSize(ts); textAlign(CENTER, CENTER);
    text("BULLDAWG", 3, 3);
    text("RUN", 3, ts + 6);
    // Gold + Blue
    fill(255, 190, 30); text("BULLDAWG", 0, 0);
    fill(60, 90, 200);  text("RUN", 0, ts + 6);
    popMatrix();

    // subtitle
    fill(220, 235, 255);
    textSize(constrain(height*0.018, 9, 14));
    textAlign(CENTER, CENTER);
    text("RUNNING WITHOUT SIGNAL", cx, cardY + cardH*0.78);

    // stats row
    float statY  = cy + height*0.10;
    float statW  = width * 0.36;
    float statH  = height * 0.07;
    fill(0, 0, 0, 130);
    rect(cx - statW/2, statY, statW, statH, 8);
    float col1 = cx - statW*0.34;
    float col2 = cx;
    float col3 = cx + statW*0.34;
    float labelY = statY + statH*0.28;
    float valY   = statY + statH*0.72;
    fill(180, 200, 240);
    textSize(constrain(height*0.016, 8, 13));
    text("BEST SCORE", col1, labelY);
    text("OBSTACLES", col2, labelY);
    text("LIVES",     col3, labelY);
    fill(255, 220, 50);
    textSize(constrain(height*0.026, 12, 22));
    text(bestScore, col1, valY);
    text("2",       col2, valY);
    text("3",       col3, valY);

    // play button
    float btnY = cy + height*0.22;
    float btnW = width * 0.22;
    float btnH = height * 0.07;
    drawButton(cx, btnY, btnW, btnH, "▶  PLAY NOW", color(255, 180, 0), color(30));

    // controls hint
    fill(200, 220, 255);
    textSize(constrain(height*0.016, 8, 13));
    textAlign(CENTER, CENTER);
    text("SPACEBAR or TAP to jump", cx, btnY + btnH*0.75);
  }

  // ── HUD ───────────────────────────────────────────────────
  private void drawHUD() {
    float barH = height * 0.075;
    fill(0, 0, 0, 140);
    noStroke();
    rect(0, 0, width, barH);

    float pad   = width * 0.025;
    float midH  = barH * 0.5;
    float lbl   = constrain(height*0.016, 8, 13);
    float val   = constrain(height*0.036, 14, 28);

    // score
    fill(255, 220, 50);
    textAlign(LEFT, CENTER); textSize(lbl);
    text("SCORE", pad, barH*0.28);
    textSize(val);
    text(nf(engine.getScore(), 6), pad, barH*0.72);

    // Speed
    fill(100, 200, 255);
    textAlign(CENTER, CENTER); textSize(lbl);
    text("SPEED", width/2.0, barH*0.28);
    textSize(val * 0.7);
    text("x" + nf(4.5 + engine.getScore()*0.003, 1, 1), width/2.0, barH*0.72);

    // lives
    textAlign(RIGHT, CENTER); textSize(lbl);
    fill(200, 180, 180);
    text("LIVES", width - pad, barH*0.28);
    float heartR = barH * 0.18;
    float heartY = barH * 0.68;
    for (int i = 0; i < 3; i++) {
      float hx = width - pad - i * (heartR*2.6);
      if (i < engine.getLives()) fill(255, 60, 80);
      else                        fill(80, 40, 50);
      drawHeart(hx, heartY, heartR);
    }

    // pause button
    float btnSz = barH * 0.55;
    fill(255, 255, 255, 60);
    rect(width - pad - btnSz*3.2, barH*0.22, btnSz*1.6, btnSz, 4);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(constrain(height*0.018, 8, 14));
    text("II", width - pad - btnSz*2.4, barH*0.5 + btnSz*0.12);
  }

  private void drawHeart(float hx, float hy, float r) {
    noStroke();
    ellipse(hx - r*0.5, hy - r*0.35, r, r);
    ellipse(hx + r*0.5, hy - r*0.35, r, r);
    triangle(hx - r, hy - r*0.05,
             hx + r, hy - r*0.05,
             hx,     hy + r*0.80);
  }

  // ── GAME OVER SCREEN ──────────────────────────────────────
  private void drawGameOverScreen() {
    float cx = width / 2.0;
    float cy = height / 2.0;

    fill(0, 0, 0, 170);
    noStroke();
    rect(0, 0, width, height);

    float cardW = width  * 0.40;
    float cardH = height * 0.55;
    float cardX = cx - cardW/2;
    float cardY = cy - cardH/2;

    fill(15, 20, 50, 245);
    stroke(255, 190, 30); strokeWeight(2);
    rect(cardX, cardY, cardW, cardH, 16);
    noStroke();

    // title
    fill(255, 60, 80);
    textAlign(CENTER, CENTER);
    textSize(constrain(height*0.06, 24, 52));
    text("GAME OVER", cx, cardY + cardH*0.14);

    // sad bulldog icon
    float ic = height * 0.05;
    float icy = cardY + cardH*0.30;
    fill(60, 90, 200);   ellipse(cx, icy, ic*1.3, ic);
    fill(230, 180, 140); ellipse(cx, icy - ic*0.6, ic, ic*0.85);
    fill(30); ellipse(cx-ic*0.22, icy-ic*0.65, ic*0.14, ic*0.16);
              ellipse(cx+ic*0.22, icy-ic*0.65, ic*0.14, ic*0.16);
    noFill(); stroke(30); strokeWeight(1.5);
    arc(cx, icy-ic*0.38, ic*0.38, ic*0.28, PI, TWO_PI);
    noStroke();

    // Score
    fill(160, 180, 220);
    textSize(constrain(height*0.02, 9, 16));
    text("YOUR SCORE", cx, cardY + cardH*0.50);
    fill(255, 220, 50);
    textSize(constrain(height*0.07, 28, 56));
    text(engine.getScore(), cx, cardY + cardH*0.63);

    fill(130, 160, 210);
    textSize(constrain(height*0.018, 8, 14));
    text("BEST  " + bestScore, cx, cardY + cardH*0.74);

    stroke(255, 190, 30, 80); strokeWeight(1);
    line(cx - cardW*0.32, cardY + cardH*0.80,
         cx + cardW*0.32, cardY + cardH*0.80);
    noStroke();

    float btnY = cardY + cardH*0.90;
    drawButton(cx, btnY, cardW*0.68, cardH*0.11,
               "▶  PLAY AGAIN", color(255, 180, 0), color(30));
  }

  // ── HELPERS ───────────────────────────────────────────────
  private void drawButton(float bx, float by, float bw, float bh,
                          String label, color bg, color fg) {
    boolean hover = mouseX > bx-bw/2 && mouseX < bx+bw/2 &&
                    mouseY > by-bh/2 && mouseY < by+bh/2;
    fill(hover ? color(red(bg)+30, green(bg)+30, blue(bg)) : bg);
    stroke(255, 255, 255, 80); strokeWeight(1);
    rect(bx - bw/2, by - bh/2, bw, bh, 10);
    noStroke();
    fill(fg);
    textAlign(CENTER, CENTER);
    textSize(constrain(bh*0.42, 12, 22));
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
    float cx   = width / 2.0;
    float cy   = height / 2.0;
    float barH = height * 0.075;

    if (state == STATE_TITLE) {
      float btnY = cy + height*0.22;
      float btnW = width * 0.22;
      float btnH = height * 0.07;
      if (mx > cx-btnW/2 && mx < cx+btnW/2 &&
          my > btnY-btnH/2 && my < btnY+btnH/2) {
        startPlaying();
      }
    } else if (state == STATE_PLAYING) {
      if (my > barH) engine.handleJump();
      // Pause button hit area
      float pad   = width * 0.025;
      float btnSz = barH * 0.55;
      if (mx > width-pad-btnSz*3.2 && mx < width-pad-btnSz*1.6 &&
          my > barH*0.22 && my < barH*0.78) {
        if (engine.isPlaying()) engine.pauseGame();
        else                    engine.resumeGame();
      }
    } else if (state == STATE_GAMEOVER) {
      float cardH = height * 0.55;
      float cardY = cy - cardH/2;
      float cardW = width * 0.40;
      float btnY  = cardY + cardH*0.90;
      float btnW  = cardW*0.68;
      float btnH  = cardH*0.11;
      if (mx > cx-btnW/2 && mx < cx+btnW/2 &&
          my > btnY-btnH/2 && my < btnY+btnH/2) {
        startPlaying();
      }
    }
  }

  private void startPlaying() {
    engine.startGame();
    state = STATE_PLAYING;
  }
}
