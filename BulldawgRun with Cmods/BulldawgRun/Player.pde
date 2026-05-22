// ============================================================
//  PLAYER — butch the Bulldog (NU Mascot)
// ============================================================

class Player extends GameObject {
  private int     lives;
  private int     score;
  private boolean isJumping;
  private float   jumpForce;
  private float   gravity;
  private float   groundY;
  private boolean isHurt;
  private int     hurtTimer;

  private PImage  img;

  // hitbox dimensions
  final int W = 64;
  final int H = 52;

  Player(float x, float y) {
    super(x, y, 0);
    lives      = 3;
    score      = 0;
    isJumping  = false;
    jumpForce  = 0;
    gravity    = 0.8;
    groundY    = y;
    isHurt     = false;
    hurtTimer  = 0;

    img = loadImage("butch.png");
  }

  @Override
  void update() {
    if (isJumping) {
      y         -= jumpForce;
      jumpForce -= gravity;
      if (y >= groundY) {
        y         = groundY;
        isJumping = false;
        jumpForce = 0;
      }
    }
    score++;
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

    // flash
    if (isHurt && frameCount % 4 < 2) tint(255, 80, 80);
    else noTint();

    // shadow
    noStroke();
    fill(0, 0, 0, 50);
    ellipse(0, 6, W, 10);

    // draw Butch image centered on the player position
    imageMode(CENTER);
    image(img, 0, -H / 2, W, H);

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

  float[] getHitbox() {
    return new float[]{ x - W/2 + 6, y - H + 4, x + W/2 - 6, y + 4 };
  }
}
