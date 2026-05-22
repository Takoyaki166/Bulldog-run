 // ============================================================
//  BULLDAWG RUN — Running Without Signal
//  OOP Project | National University – Manila | BSIT G3
//  Processing 4
// ============================================================

GameScreen gameScreen;

void setup() {
  size(1200, 600);
  gameScreen = new GameScreen();
  gameScreen.initComponents();
}

void draw() {
  gameScreen.updateDisplay();
}

void keyPressed() {
  if (key == ' ' || keyCode == UP) {
    gameScreen.handleJump();
  }
  if (key == 'r' || key == 'R') {
    gameScreen.handleRestart();
  }
}

void mousePressed() {
  gameScreen.handleMousePress(mouseX, mouseY);
}
