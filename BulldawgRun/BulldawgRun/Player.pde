// ============================================================
//  PLAYER — Nationalian Bulldog
// ============================================================

class Player extends GameObject {
  private int    lives;
  private int    score;
  private boolean isJumping;
  private float  jumpForce;
  private float  gravity;
  private float  groundY;
  private int    animFrame;
  private int    animTimer;
  private boolean isHurt;
  private int    hurtTimer;

  // Hitbox dimensions
  final int W = 48;
  final int H = 52;

  Player(float x, float y) {
    super(x, y, 0);   // player doesn't scroll
    lives      = 3;
    score      = 0;
    isJumping  = false;
    jumpForce  = 0;
    gravity    = 0.8;
    groundY    = y;
    animFrame  = 0;
    animTimer  = 0;
    isHurt     = false;
    hurtTimer  = 0;
  }

  // Override update — player doesn't move left
  @Override
  void update() {
    // Jumping physics
    if (isJumping) {
      y         -= jumpForce;
      jumpForce -= gravity;
      if (y >= groundY) {
        y         = groundY;
        isJumping = false;
        jumpForce = 0;
      }
    }

    // Score ticks up while alive
    score++;

    // Animation cycling
    animTimer++;
    if (animTimer % 8 == 0) animFrame = (animFrame + 1) % 4;

    // Hurt flash timer
    if (isHurt) {
      hurtTimer--;
      if (hurtTimer <= 0) isHurt = false;
    }
  }

  void jump() {
    if (!isJumping) {
      isJumping = true;
      jumpForce = 16;
    }
  }

  @Override
  void render() {
    pushMatrix();
    translate(x, y);

    // Hurt flash
    if (isHurt && frameCount % 4 < 2) {
      tint(255, 80, 80);
    }

    // --- Body ---
    color bodyCol  = color(60, 90, 200);   // NU blue
    color accentCol= color(255, 190, 30);  // NU gold
    color skinCol  = color(230, 180, 140);
    color whiteCol = color(255);
    color blackCol = color(20);

    // Shadow
    noStroke();
    fill(0, 0, 0, 50);
    ellipse(0, 6, W - 4, 10);

    // Torso
    fill(bodyCol);
    noStroke();
    rect(-W/2, -H + 20, W, H - 20, 8);

    // Jersey number "NU"
    fill(accentCol);
    textAlign(CENTER, CENTER);
    textSize(11);
    text("NU", 0, -H/2 + 14);

    // Head
    fill(skinCol);
    ellipse(0, -H + 12, 36, 32);

    // Ears
    fill(skinCol);
    ellipse(-16, -H + 4, 14, 18);
    ellipse( 16, -H + 4, 14, 18);
    fill(color(200, 140, 100));
    ellipse(-16, -H + 6, 8, 12);
    ellipse( 16, -H + 6, 8, 12);

    // Eyes — animate blink every 90 frames
    fill(whiteCol);
    ellipse(-8, -H + 10, 10, 10);
    ellipse( 8, -H + 10, 10, 10);
    fill(blackCol);
    if (frameCount % 90 < 5) {
      // blink
      stroke(blackCol); strokeWeight(2);
      line(-12, -H + 10, -4, -H + 10);
      line(  4, -H + 10, 12, -H + 10);
      noStroke();
    } else {
      ellipse(-8, -H + 10, 5, 6);
      ellipse( 8, -H + 10, 5, 6);
      fill(255);
      ellipse(-6, -H + 9, 2, 2);
      ellipse(10, -H + 9, 2, 2);
    }

    // Snout / Nose
    fill(color(200, 140, 100));
    ellipse(0, -H + 18, 18, 12);
    fill(blackCol);
    ellipse(0, -H + 15, 10, 7);
    fill(skinCol);
    // Smile
    noFill(); stroke(blackCol); strokeWeight(1.5);
    arc(0, -H + 20, 12, 8, 0, PI);
    noStroke();

    // Arms (animated run)
    fill(bodyCol);
    float armSwing = sin(animFrame * HALF_PI) * 12;
    rect(-W/2 - 10, -H + 24 + armSwing, 10, 22, 5);
    rect( W/2,      -H + 24 - armSwing, 10, 22, 5);

    // Hands
    fill(skinCol);
    ellipse(-W/2 - 5, -H + 48 + armSwing, 12, 12);
    ellipse( W/2 + 5, -H + 48 - armSwing, 12, 12);

    // Legs (animated)
    fill(color(30, 30, 100));
    float legSwing = sin(animFrame * HALF_PI) * 10;
    rect(-14, 0,  13, 22, 5);
    rect(  2, 0,  13, 22, 5);

    // Sneakers
    fill(accentCol);
    rect(-18, 20, 18, 9, 3);
    rect(  2, 20, 18, 9, 3);

    noTint();
    popMatrix();
  }

  @Override
  void onCollide() {
    if (!isHurt) {
      lives--;
      isHurt    = true;
      hurtTimer = 60;
    }
  }

  void updateScore(int pts) { score += pts; }
  void loseLife()           { lives = max(0, lives - 1); }
  int  getScore()           { return score / 10; }
  int  getLives()           { return lives; }
  boolean isDead()          { return lives <= 0; }

  // Returns hitbox as float[]{x1,y1,x2,y2}
  float[] getHitbox() {
    return new float[]{ x - W/2 + 6, y - H + 4, x + W/2 - 6, y + 4 };
  }
}
