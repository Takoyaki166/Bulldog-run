// ============================================================
//  GAME ENGINE — Core game logic
// ============================================================

class GameEngine {
  private Player              player;
  private ArrayList<Obstacle> obstacles;
  private Background          background;
  private int                 score;
  private boolean             isRunning;
  private float               gameSpeed;
  private int                 spawnTimer;
  private int                 spawnInterval;
  private ArrayList<Particle> particles;

  // Collision flash
  private int hitFlash = 0;

  GameEngine() {
    obstacles     = new ArrayList<Obstacle>();
    particles     = new ArrayList<Particle>();
    gameSpeed     = 10;
    spawnTimer    = 0;
    spawnInterval = 90;
    isRunning     = false;
  }

  void startGame() {
    float groundY = height - 170;
    player        = new Player(100, groundY);
    background    = new Background();
    obstacles.clear();
    particles.clear();
    score         = 0;
    isRunning     = true;
    gameSpeed     = 10;
    spawnTimer    = 0;
    spawnInterval = 100;
    hitFlash      = 0;
  }

  void pauseGame()  { isRunning = false; }
  void resumeGame() { isRunning = true;  }

  void update() {
    if (!isRunning) return;

    // Speed ramps up fast — starts at 10, races to 28
    gameSpeed = 10 + getScore() * 0.018;
    gameSpeed = min(gameSpeed, 28);

    // Pass speed to background so it scrolls faster too
    background.speed = gameSpeed;
    background.update();
    player.update();

    // Spawn obstacles — interval shrinks as speed grows
    spawnTimer++;
    int dynInterval = max(30, spawnInterval - getScore() / 8);
    if (spawnTimer >= dynInterval) {
      spawnObstacle();
      spawnTimer = 0;
    }

    // Update obstacles
    for (int i = obstacles.size() - 1; i >= 0; i--) {
      Obstacle obs = obstacles.get(i);
      obs.scrollSpeed = gameSpeed;
      obs.update();
      if (!obs.isActive) {
        obstacles.remove(i);
        continue;
      }

      if (checkCollisions(obs)) {
        player.onCollide();
        obs.onCollide();
        obs.isActive = false;
        obstacles.remove(i);
        spawnHitParticles(obs.x, obs.y);
        hitFlash = 12;
      }
    }

    // Update particles
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (!p.alive) particles.remove(i);
    }

    if (hitFlash > 0) hitFlash--;

    // Check game over
    if (player.isDead()) {
      isRunning = false;
    }
  }

  boolean checkCollisions(Obstacle obs) {
    float[] pb = player.getHitbox();
    float[] ob = obs.getHitbox();
    return pb[0] < ob[2] && pb[2] > ob[0] &&
           pb[1] < ob[3] && pb[3] > ob[1];
  }

  void spawnObstacle() {
    float groundY = height - 170;
    float sx      = width + 60;

    // Randomly pick Jeepney, Banig, or Tricycle
    Obstacle obs;
    float roll = random(1);
    if (roll < 0.45) {
      obs = new JeepneyObstacle(sx, groundY, gameSpeed);
    } else if (roll < 0.75) {
      obs = new BanigObstacle(sx, groundY, gameSpeed);
    } else {
      obs = new TricycleObstacle(sx, groundY, gameSpeed);
    }
    obstacles.add(obs);
  }

  void spawnHitParticles(float ox, float oy) {
    for (int i = 0; i < 16; i++) {
      particles.add(new Particle(ox, oy - 20));
    }
  }

  void renderAll() {
    background.render();

    // Render obstacles
    for (Obstacle obs : obstacles) {
      obs.render();
    }

    player.render();

    // Particles
    for (Particle p : particles) {
      p.render();
    }

    // Hit flash overlay
    if (hitFlash > 0) {
      fill(255, 0, 0, hitFlash * 12);
      noStroke();
      rect(0, 0, width, height);
    }
  }

  int     getScore()   { return player != null ? player.getScore() : 0; }
  int     getLives()   { return player != null ? player.getLives() : 0; }
  boolean isGameOver() { return !isRunning && player != null && player.isDead(); }
  boolean isPlaying()  { return isRunning; }

  void handleJump() {
    if (isRunning && player != null) player.jump();
  }

  Player              getPlayer()    { return player; }
  ArrayList<Obstacle> getObstacles() { return obstacles; }
}


// ============================================================
//  PARTICLE — visual hit effect
// ============================================================

class Particle {
  float   x, y, vx, vy;
  color   col;
  float   life;
  boolean alive;
  float   sz;

  Particle(float x, float y) {
    this.x  = x;
    this.y  = y;
    float angle = random(TWO_PI);
    float spd   = random(2, 7);
    vx   = cos(angle) * spd;
    vy   = sin(angle) * spd - 2;
    col  = color(random(200, 255), random(150, 220), random(20, 80));
    life = 1.0;
    alive = true;
    sz   = random(4, 10);
  }

  void update() {
    x    += vx;
    y    += vy;
    vy   += 0.3;
    life -= 0.04;
    if (life <= 0) alive = false;
  }

  void render() {
    noStroke();
    fill(red(col), green(col), blue(col), life * 255);
    ellipse(x, y, sz * life, sz * life);
  }
}
