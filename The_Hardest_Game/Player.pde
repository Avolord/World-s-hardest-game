public class Player {
  PVector position;
  boolean right, left, up, down;
  int deaths = 0;

  Player(float x, float y) {
    position = new PVector(x, y);
  }

  void draw() {
    stroke(0);
    fill(255, 0, 0);
    rect(position.x, position.y, ENTITY_SIZE, ENTITY_SIZE);
  }

  void move(float x, float y) {
    position.add(x, y);
  }
  
  void move() {
    if (right)
      position.add(SPEED, 0);
    if (left)
      position.add(-SPEED, 0);
    if (up)
      position.add(0,-SPEED);
    if (down)
      position.add(0,SPEED);
  }
  
  void moveBack() {
    if (right)
      position.sub(SPEED, 0);
    if (left)
      position.sub(-SPEED, 0);
    if (up)
      position.sub(0,-SPEED);
    if (down)
      position.sub(0,SPEED);
  }
  
  boolean tileColission(float x, float y) {
    return (
    position.x < x + TILE_SIZE &&
    position.x + ENTITY_SIZE > x &&
    position.y < y + TILE_SIZE &&
    position.y + ENTITY_SIZE > y
    );
  }
}
