class Spinner {
  PVector center;
  ArrayList<PVector> spinningDots;
  float spacing = 10;
  float wings = 4;
  float amount = 4;
  color c = color(#082EFC);

  Spinner(float x, float y) {
    spinningDots = new ArrayList<PVector>();
    center = new PVector(x, y);
    createSpinner();
  }
  
  Spinner(float x, float y, float spacing, float wings, float amount) {
    this.spacing = spacing;
    this.wings = wings;
    this.amount = amount;
    spinningDots = new ArrayList<PVector>();
    center = new PVector(x, y);
    createSpinner();
  }
  
  void editSpacing(float amount) {
    spacing = (spacing > 0 && spacing < 100) ? spacing + amount : spacing - amount;     
    spinningDots = new ArrayList<PVector>();
    createSpinner();
  }
  
  boolean playerCollision(PVector position) {
    if(Collision.squareCircle(position, ENTITY_SIZE, center, OBJECT_SIZE)) {
      return true;
    }   
    for(PVector dot : spinningDots) {
      if(Collision.squareCircle(position, ENTITY_SIZE, dot, OBJECT_SIZE)) {
        return true;
      }
    }   
    return false;
  }

  private void createSpinner() {
    float angle = TWO_PI / wings;
    for (int multiplier=1; multiplier<=amount; multiplier++) {
      for (int i=1; i<=wings; i++) {
        PVector spinningDotPos = new PVector(
          center.x + cos(i*angle) * multiplier * spacing, 
          center.y + sin(i*angle) * multiplier * spacing
          );
        spinningDots.add(spinningDotPos);
      }
    }
  }
  
  void spin() {
    for(PVector dot : spinningDots) {
      dot.sub(center);
      dot.rotate(0.01);
      dot.add(center);
    }
  }
  
  void spin(float speed) {
    for(PVector dot : spinningDots) {
      dot.sub(center);
      dot.rotate(speed);
      dot.add(center);
    }
  }
  
  void draw() {
    stroke(0);
    fill(c);
    ellipse(center.x, center.y, OBJECT_SIZE, OBJECT_SIZE);
    for(PVector dot : spinningDots)
      ellipse(dot.x, dot.y, OBJECT_SIZE, OBJECT_SIZE);
  }
}
