
public float TILE_SIZE = 30;
public float ENTITY_SIZE = 15;
public float OBJECT_SIZE = 7.5;
public float SPEED = 2;

boolean main_menu = false;
boolean level_editor_enabled = false;
boolean currently_saving = false;
boolean loading_map = false;

String filename = "\\";
int current_type = 2;

Level level;
LevelEditor editor;


void setup() {
  size(720, 480);
  background(#6496FF);
  strokeWeight(3);
  ellipseMode(CENTER);
  ellipseMode(RADIUS);

  level = new Level("levels\\level4.txt");
  editor = new LevelEditor();
}

void draw() {
  background(#6496FF);
  if (level_editor_enabled) {
    editor.draw();
    show_current_type();
    addTilesOnMousePress();
  } else {
    level.draw();
  }
}

void show_current_type() {
  fill(255, 0, 0);
  textSize(20);

  if (editor.movingDotInSetup || editor.spinnerInSetup) {
    text("setup...", 10, 30);
    return;
  }

  switch(current_type) {
  case 0:
    text("wall", 10, 30);
    break;
  case 1:
    text("floor", 10, 30);
    break;
  case 2:
    text("start", 10, 30);
    break;
  case 3:
    text("goal", 10, 30);
    break;
  case 4:
    text("player-spawn", 10, 30);
    break;
  case 5:
    text("moving-dot", 10, 30);
    break;
  case 6:
    text("coin", 10, 30);
    break;
  case 7:
    text("spinner", 10, 30);
    break;
  }
}

void keyPressed() {
  if (currently_saving) {
    switch(keyCode) {
    case 8:
      if(filename.length() > 0) {
        filename = filename.substring(filename.length()-2);
      }
      break;
    case 10:
      selectFolder("Select a folder to process:", "folderSelected");
      currently_saving = false;
      break;
    default:
      filename = filename.concat(String.valueOf(key));
    }
    println(filename);
    return;
  }
  switch(key) {
  case 'w':
    level.player.up = true;
    break;
  case 'a':
    level.player.left = true;
    break;
  case 's':
    level.player.down = true;
    break;
  case 'd':
    level.player.right = true;
    break;
  case 'l':
    level_editor_enabled = (level_editor_enabled) ? false : true;
    break;
  case 'p':
  if (level_editor_enabled) {
    currently_saving = true;
  }
    break;
  case '0':
  case '1':
  case '2':
  case '3':
  case '4':
  case '5':
  case '6':
  case '7':
    current_type = Integer.parseInt(String.valueOf(key));
    break;
  }
}

void keyReleased() {
  if(level_editor_enabled) {
    return;
  }
  switch(key) {
  case 'w':
    level.player.up = false;
    break;
  case 'a':
    level.player.left = false;
    break;
  case 's':
    level.player.down = false;
    break;
  case 'd':
    level.player.right = false;
    break;
  }
}

void mouseWheel(MouseEvent event) {
  if(level_editor_enabled && editor.spinnerInSetup) {
    editor.getLatestSpinner().editSpacing(event.getCount()*3);
  }
}

void addTilesOnMousePress() {
  if (mousePressed) {
    int mx = floor(mouseX/TILE_SIZE);
    int my = floor(mouseY/TILE_SIZE);
    editor.addTile(current_type, my, mx);
  }
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    
    if (level_editor_enabled) {
      println("saving map...");
      editor.saveMap(selection.getAbsolutePath()+filename+".txt");
      println("map saved to: "+selection.getAbsolutePath()+filename+".txt");
    }
  }
}
