// ============================================================
//  ABSTRACT OBSTACLE
// ============================================================

abstract class Obstacle extends GameObject {
  protected String obstacleType;
  protected int    damage;
  protected float  scrollSpeed;

  // Hitbox dimensions (set by subclass)
  protected int obsW;
  protected int obsH;

  Obstacle(float x, float y, float scrollSpeed) {
    super(x, y, scrollSpeed);
    this.scrollSpeed = scrollSpeed;
    this.damage      = 1;
  }

  @Override
  void update() {
    x -= scrollSpeed;
    if (x < -120) isActive = false;
  }

  abstract void render();
  abstract void onCollide();
  abstract void spawnEffect();

  String getType()   { return obstacleType; }
  int    getDamage() { return damage; }

  // Returns hitbox as float[]{x1,y1,x2,y2}
  float[] getHitbox() {
    return new float[]{ x - obsW/2 + 4, y - obsH, x + obsW/2 - 4, y };
  }
}
