// ============================================================
//  JEEPNEY OBSTACLE — uses jeepney.png image
// ============================================================

class JeepneyObstacle extends Obstacle {
  private String honkSound;
  private int    laneCount;
  private PImage jeepImg;

  JeepneyObstacle(float x, float y, float scrollSpeed) {
    super(x, y, scrollSpeed);
    obstacleType = "Jeepney";
    honkSound    = "BEEP!";
    laneCount    = 1;
    obsW         = 110;
    obsH         = 60;
    damage       = 1;
    jeepImg      = loadImage("jeepney.png");
  }

  @Override
  void render() {
    pushMatrix();
    translate(x, y);

    noStroke();
    fill(0, 0, 0, 50);
    ellipse(0, 6, obsW - 10, 10);

    if (jeepImg != null) {
      imageMode(CENTER);
      image(jeepImg, 0, -obsH / 2, obsW, obsH);
    } else {
      fill(200, 30, 30);
      rect(-obsW/2, -obsH, obsW, obsH, 6);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(9);
      text("jeepney.png\nnot found", 0, -obsH/2);
    }

    popMatrix();
  }

  @Override
  void onCollide() { }

  @Override
  void spawnEffect() { }
}


// ============================================================
//  TRICYCLE OBSTACLE — uses tricycle.png image
// ============================================================

class BanigObstacle extends Obstacle {
  private PImage tricycleImg;

  BanigObstacle(float x, float y, float scrollSpeed) {
    super(x, y, scrollSpeed);
    obstacleType = "Tricycle";
    obsW         = 110;
    obsH         = 70;
    damage       = 1;
    tricycleImg  = loadImage("tricycle.png");
  }

  @Override
  void render() {
    pushMatrix();
    translate(x, y);

    noStroke();
    fill(0, 0, 0, 50);
    ellipse(0, 6, obsW - 10, 10);

    if (tricycleImg != null) {
      imageMode(CENTER);
      image(tricycleImg, 0, -obsH / 2, obsW, obsH);
    } else {
      fill(220, 140, 20);
      rect(-obsW/2, -obsH, obsW, obsH, 4);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(9);
      text("tricycle.png\nnot found", 0, -obsH/2);
    }

    popMatrix();
  }

  @Override
  void onCollide() { }

  @Override
  void spawnEffect() { }
}
