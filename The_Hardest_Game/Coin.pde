class Coin {
  PVector position;
  color c = color(#F9FA26);
  boolean collected = false;

  Coin(float x, float y) {
    position = new PVector(x, y);
  }

  void draw() {
    if (!collected) {
      stroke(0);
      fill(c);    
      ellipse(position.x, position.y, OBJECT_SIZE, OBJECT_SIZE);
    }
  }
}
