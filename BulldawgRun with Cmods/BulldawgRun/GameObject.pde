// ============================================================
//  ABSTRACT
// ============================================================

abstract class GameObject implements Renderable, Collidable {
  protected float x, y;
  protected float speed;
  protected boolean isActive;

  GameObject(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.isActive = true;
  }

  void update() {
    x -= speed;
    if (x < -100) isActive = false;
  }

  float getX()           { return x; }
  float getY()           { return y; }
  float getSpeed()       { return speed; }
  void  setActive(boolean b) { isActive = b; }

  abstract void render();
  abstract void onCollide();
}
