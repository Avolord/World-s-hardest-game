static class Collision {
  private Collision() {
  }

  static boolean rectangles(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    return (
      x1 < x2 + w2 &&
      x1 + w1 > x2 &&
      y1 < y2 + h2 &&
      y1 + h1 > y2
      );
  }

  static boolean rectangles(PVector p1, float w1, float h1, PVector p2, float w2, float h2) {
    return (
      p1.x < p2.x + w2 &&
      p1.y + w1 > p2.x &&
      p1.y < p2.y + h2 &&
      p1.y + h1 > p2.y
      );
  }

  static boolean squares(PVector p1, float s1, PVector p2, float s2) {
    return (
      p1.x < p2.x + s2 &&
      p1.x + s1 > p2.x &&
      p1.y < p2.y + s2 &&
      p1.y + s1 > p2.y
      );
  }

  static boolean rectangleCircle(float x1, float y1, float w, float h, float x2, float y2, float r) {
    float dx = abs(x1 - x2 + w/2);
    float dy = abs(y1 - y2 + h/2);
    if (dx > (w/2 + r)) { 
      return false;
    }
    if (dy > (h/2 + r)) { 
      return false;
    }
    if (dx <= (w/2)) { 
      return true;
    } 
    if (dy <= (h/2)) { 
      return true;
    }
    float cDist_sq = (dx - w/2)*(dx - w/2) + (dy - h/2)*(dy - h/2);

    return (cDist_sq <= (pow(r, 2)));
  }

  static boolean squareCircle(PVector p1, float s, PVector p2, float r) {
    float dx = abs(p1.x - p2.x + s/2);
    float dy = abs(p1.y - p2.y + s/2);
    if (dx > (s/2 + r)) { 
      return false;
    }
    if (dy > (s/2 + r)) { 
      return false;
    }
    if (dx <= (s/2)) { 
      return true;
    } 
    if (dy <= (s/2)) { 
      return true;
    }
    float cDist_sq = (dx - s/2)*(dx - s/2) + (dy - s/2)*(dy - s/2);

    return (cDist_sq <= (pow(r, 2)));
  }
}
