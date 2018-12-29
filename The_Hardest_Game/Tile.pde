class Tile {
  PVector position;
  color c = color(#6496FF);
  boolean passable = false;
  boolean goal = false;

  Tile(float x, float y) {
    position = new PVector(x, y);
  }
  
  Tile(float x, float y, boolean passable, boolean goal, color c) {
    position = new PVector(x, y);
    this.passable = passable;
    this.goal = goal;
    this.c = c;
  }

  void draw() {
    fill(c);
    noStroke();
    rect(position.x, position.y, TILE_SIZE, TILE_SIZE);
  }
}
