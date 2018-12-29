class Level {
  PVector spawn = new PVector();
  Player player;
  Tile[][] mapdata;
  ArrayList<Coin> coins = new ArrayList<Coin>();
  ArrayList<MovingDot> movingDots = new ArrayList<MovingDot>();
  ArrayList<Spinner> spinners = new ArrayList<Spinner>();
  int collected_coins = 0;

  Level(String path) {
    loadMap(path);
    player = new Player(spawn.x, spawn.y);
  }

  void draw() {
    for (Tile[] rows : mapdata) {
      for (Tile tile : rows) {
        tile.draw();
      }
    }
    for (MovingDot mdot : movingDots) {
      mdot.move();
      mdot.draw();
      if (Collision.squareCircle(player.position, ENTITY_SIZE, mdot.position, OBJECT_SIZE)) {
        respawn();
      }
    }
    for (Spinner spinner : spinners) {
      spinner.spin(SPEED/60);
      spinner.draw();
      if (spinner.playerCollision(player.position)) {
        respawn();
      }
    }
    for (Coin coin : coins) {
      coin.draw();
      if (!coin.collected && Collision.squareCircle(player.position, ENTITY_SIZE, coin.position, OBJECT_SIZE)) {
        collected_coins++;
        coin.collected = true;
      }
    }
    solvePlayerColission();
    player.draw();
  }

  void respawn() {
    player.deaths++;
    println("You died!\nDEATH(S): "+player.deaths);
    player.position.set(spawn);
    collected_coins = 0;

    for (Coin coin : coins) {
      coin.collected = false;
    }
  }

  void progress() {
    if (collected_coins >= coins.size()) {
      println("Congratulations, you passed the level with "+player.deaths+" death(s)!");
      player.position.set(spawn);
      collected_coins = 0;

      for (Coin coin : coins) {
        coin.collected = false;
      }
    }
  }

  void evaluateTile(int type, int i, int j) {
    switch(type) {
    case 1:
      if (i%2 == 0 ^ j%2 == 0) {
        mapdata[i][j] = new Tile(i*TILE_SIZE, j*TILE_SIZE, true, false, 255);
      } else {
        mapdata[i][j] = new Tile(i*TILE_SIZE, j*TILE_SIZE, true, false, 230);
      }
      break;
    case 2:
      mapdata[i][j] = new Tile(i*TILE_SIZE, j*TILE_SIZE, true, false, #50FF8B);
      break;
    case 3:
      mapdata[i][j] = new Tile(i*TILE_SIZE, j*TILE_SIZE, true, true, #50FF8B);
      break;
    default:
      mapdata[i][j] = new Tile(i*TILE_SIZE, j*TILE_SIZE);
      break;
    }
  }

  void addMovingDot(float startx, float starty, float endx, float endy) {
    movingDots.add(new MovingDot(startx, starty, endx, endy));
  }

  void addMovingDot(int startx, int starty, int endx, int endy) {
    movingDots.add(new MovingDot((startx+0.5)*TILE_SIZE, (starty+0.5)*TILE_SIZE, (endx+0.5)*TILE_SIZE, (endy+0.5)*TILE_SIZE));
  }

  void solvePlayerColission() {
    PVector old = player.position.copy();
    player.move();
    boolean blocked = false;
    for (Tile[] rows : mapdata) {
      for (Tile tile : rows) {
        if (!tile.passable && Collision.squares(player.position, ENTITY_SIZE, tile.position, TILE_SIZE)) {
          blocked = true;
          break;
        }
        if (tile.goal && Collision.squares(player.position, ENTITY_SIZE, tile.position, TILE_SIZE)) {
          progress();
          return;
        }
      }
    }
    if (blocked) {
      player.position = old;
    }
  }

  void loadMap(String path) {
    String[] leveldata;
    try {
      leveldata = loadStrings(path);
    } 
    catch(NullPointerException e) {
      println("could'nt load the requested level!");
      return;
    }

    for (String obj : leveldata) {
      String[] type_data_seperation = obj.split(":");
      switch(type_data_seperation[0]) {
      case "spawn":
        final String[] SpawnPosString = type_data_seperation[1].split(",");
        spawn.set(Float.parseFloat(SpawnPosString[0]), Float.parseFloat(SpawnPosString[1]));
        break;
      case "size":
        final String[] Dimensions = type_data_seperation[1].split(",");
        mapdata = new Tile[Integer.parseInt(Dimensions[0])][Integer.parseInt(Dimensions[1])];
        break;
      case "tile":
        readTileFromString(type_data_seperation[1]);
        break;
      case "mdot":
        readMovingDotFromString(type_data_seperation[1]);
        break;
      case "coin":
        readCoinFromString(type_data_seperation[1]);
        break;
      case "spinner":
        readSpinnerFromString(type_data_seperation[1]);
        break;
      case "settings":
        readSettingsFromString(type_data_seperation[1]);
        break;
      }
    }
  }

  void readTileFromString(String data) {
    String[] individual_data = data.split(";");
    String[] indecies = individual_data[0].split(",");
    String[] pos_values = individual_data[1].split(",");

    float x = Float.parseFloat(pos_values[0]);
    float y = Float.parseFloat(pos_values[1]);
    color c = Integer.parseInt(individual_data[2]);
    boolean passable = Boolean.parseBoolean(individual_data[3]);
    boolean goal = Boolean.parseBoolean(individual_data[4]);


    mapdata[Integer.parseInt(indecies[0])][Integer.parseInt(indecies[1])] =  new Tile(x, y, passable, goal, c);
  }

  void readSettingsFromString(String data) {
    String[] individual_data = data.split(";");

    TILE_SIZE = Float.parseFloat(individual_data[0]);
    println("Loaded a Tile-size of: "+TILE_SIZE);

    ENTITY_SIZE = Float.parseFloat(individual_data[1]);
    println("Loaded an Entity-size of: "+ENTITY_SIZE);

    OBJECT_SIZE = Float.parseFloat(individual_data[2]);
    println("Loaded an Object-size of: "+OBJECT_SIZE);

    SPEED = Float.parseFloat(individual_data[3]);
    println("Loaded a Speed of: "+SPEED);
  }

  void readCoinFromString(String data) {
    String[] individual_data = data.split(";");
    String[] pos_values = individual_data[0].split(",");
    float x = Float.parseFloat(pos_values[0]);
    float y = Float.parseFloat(pos_values[1]);

    coins.add(new Coin(x, y));
  }

  void readSpinnerFromString(String data) {
    String[] individual_data = data.split(";");
    String[] pos_values = individual_data[0].split(",");
    float x = Float.parseFloat(pos_values[0]);
    float y = Float.parseFloat(pos_values[1]);
    float spacing = Float.parseFloat(individual_data[1]);
    float wings = Float.parseFloat(individual_data[2]);
    float amount = Float.parseFloat(individual_data[3]);
    
    spinners.add(new Spinner(x,y,spacing,wings,amount));
  }

  void readMovingDotFromString(String data) {
    String[] individual_data = data.split(";");
    String[] start = individual_data[0].split(",");
    String[] end = individual_data[1].split(",");

    float startx = Float.parseFloat(start[0]);
    float starty = Float.parseFloat(start[1]);
    float endx = Float.parseFloat(end[0]);
    float endy = Float.parseFloat(end[1]);

    movingDots.add(new MovingDot(startx, starty, endx, endy));
  }
}
