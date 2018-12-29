class LevelEditor {
  PVector spawn = new PVector();
  Player player;
  Tile[][] mapdata;
  ArrayList<Coin> coins = new ArrayList<Coin>();
  ArrayList<MovingDot> movingDots = new ArrayList<MovingDot>();
  ArrayList<Spinner> spinners = new ArrayList<Spinner>();
  boolean movingDotInSetup = false;
  boolean spinnerInSetup = false;

  LevelEditor() {
    int rows = floor(height/TILE_SIZE);
    int cols = floor(width/TILE_SIZE);
    mapdata = new Tile[rows][cols];
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        if (i<=1 || j <=1 || i>=rows-3 || j>cols-3) {
          mapdata[i][j] = new Tile(j*TILE_SIZE, i*TILE_SIZE);
        } else if (i%2 == 0 ^ j%2 == 0) {
          mapdata[i][j] = new Tile(j*TILE_SIZE, i*TILE_SIZE, true, false, 255);
        } else {
          mapdata[i][j] = new Tile(j*TILE_SIZE, i*TILE_SIZE, true, false, 230);
        }
      }
    }
  }

  void draw() {
    for (Tile[] rows : mapdata) {
      for (Tile tile : rows) {
        tile.draw();
      }
    }
    for (Coin coin : coins) {
      coin.draw();
    }
    for (MovingDot mdot : movingDots) {
      mdot.draw();
    }
    for (Spinner spinner : spinners) {
      spinner.draw();
    }
    if (player != null) {
      player.draw();
    }
    float mx = floor(mouseX/TILE_SIZE)*TILE_SIZE;
    float my = floor(mouseY/TILE_SIZE)*TILE_SIZE;
    noFill();
    stroke(0);
    rect(mx, my, TILE_SIZE, TILE_SIZE);
  }

  void addTile(int type, int i, int j) {
    if (movingDotInSetup) {
      movingDots.get(movingDots.size()-1).setEnd(mouseX, mouseY);
      mousePressed = false;
      movingDotInSetup = false;
      return;
    }
    
    if (spinnerInSetup) {
      mousePressed = false;
      spinnerInSetup = false;
      return;
    }
    
    try {
      switch(type) {
      case 1:
        if (i%2 == 0 ^ j%2 == 0) {
          mapdata[i][j] = new Tile(j*TILE_SIZE, i*TILE_SIZE, true, false, 255);
        } else {
          mapdata[i][j] = new Tile(j*TILE_SIZE, i*TILE_SIZE, true, false, 230);
        }
        break;
      case 2:
        mapdata[i][j] = new Tile(j*TILE_SIZE, i*TILE_SIZE, true, false, #50FF8B);
        break;
      case 3:
        mapdata[i][j] = new Tile(j*TILE_SIZE, i*TILE_SIZE, true, true, #50FF8B);
        break;
      case 4:
        spawn.set(j*TILE_SIZE+ENTITY_SIZE/2, i*TILE_SIZE+ENTITY_SIZE/2);
        player = new Player(spawn.x, spawn.y);
        break;
      case 5:
        movingDots.add(new MovingDot(mouseX, mouseY));
        mousePressed = false;
        movingDotInSetup = true;
        break;
      case 6:
        coins.add(new Coin(mouseX, mouseY));
        break;
      case 7:
        spinners.add(new Spinner(mouseX, mouseY));
        mousePressed = false;
        spinnerInSetup = true;
        break;
      default:
        mapdata[i][j] = new Tile(j*TILE_SIZE, i*TILE_SIZE);
        break;
      }
    } 
    catch(ArrayIndexOutOfBoundsException e) {
      return;
    }
  }
  
  Spinner getLatestSpinner() {
    return spinners.get(spinners.size()-1);
  }

  void addMovingDot(float startx, float starty, float endx, float endy) {
    movingDots.add(new MovingDot(startx, starty, endx, endy));
  }

  void addMovingDot(int startx, int starty, int endx, int endy) {
    movingDots.add(new MovingDot((startx+0.5)*TILE_SIZE, (starty+0.5)*TILE_SIZE, (endx+0.5)*TILE_SIZE, (endy+0.5)*TILE_SIZE));
  }

  void saveMap(String path) {
    StringList leveldata = new StringList();

    leveldata.append("spawn:"+spawn.x+","+spawn.y);
    leveldata.append("size:"+mapdata[0].length+","+mapdata.length); //columns then rows (width and height)
    leveldata.append("settings:"+TILE_SIZE+";"+ENTITY_SIZE+";"+OBJECT_SIZE+";"+SPEED);

    for (int i=0; i<mapdata.length; i++) {
      for (int j=0; j<mapdata[0].length; j++) {
        Tile tile = mapdata[i][j];
        String current = "tile:"+j+","+i+";"+tile.position.x+","+tile.position.y+";"+tile.c+";"+tile.passable+";"+tile.goal;
        leveldata.append(current);
      }
    }

    for (Coin coin : coins) {
      String current = "coin:"+coin.position.x+","+coin.position.y;
      leveldata.append(current);
    }

    for (MovingDot mdot : movingDots) {
      String current = "mdot:"+mdot.start.x+","+mdot.start.y+";"+mdot.end.x+","+mdot.end.y;
      leveldata.append(current);
    }
    
    for (Spinner spinner : spinners) {
      String current = "spinner:"+spinner.center.x+","+spinner.center.y+";"+spinner.spacing+";"+spinner.wings+";"+spinner.amount;
      leveldata.append(current);
    }

    saveStrings(path, leveldata.array());
  }
}
