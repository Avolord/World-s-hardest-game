class MovingDot {
  PVector position;
  PVector start, end;
  PVector direction;
  color c = color(#082EFC);

  MovingDot(float x, float y, float x2, float y2) {
    position = new PVector(x, y);
    start = new PVector(x, y);
    end = new PVector(x2, y2);
    direction = PVector.sub(end, start);
    direction.setMag(SPEED);
  }
  
  MovingDot(float x, float y) {
    position = new PVector(x, y);
    start = new PVector(x, y);
    end = new PVector(x, y);
    direction = new PVector();
  }
  
  void setEnd(float x, float y) {
    end = new PVector(x, y);
    direction = PVector.sub(end, start);
    direction.setMag(SPEED);
  }

  void move() {
    position.add(direction);
    if(position.dist(start) < 1 || position.dist(end)<SPEED ) {
      direction.mult(-1);
    }
  }

  void draw() {
    stroke(0);
    fill(c);
    if(end.equals(start)) {
      noFill();
    }
    
    ellipse(position.x, position.y, OBJECT_SIZE, OBJECT_SIZE);
  }
}
