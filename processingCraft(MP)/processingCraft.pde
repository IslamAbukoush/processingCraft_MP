import java.util.List;
import java.util.ArrayList;
import processing.net.*;
import java.util.HashMap;
import java.util.concurrent.CompletableFuture;

Client client;
Integer clientId;
HashMap<Integer, OtherPlayer> players;

PrintWriter output;

Selector selector = new Selector();
Cursor cursor = new Cursor();
Player mainPlayer;
Field field;

ItemsBar itemsBar;
float blockScale = 5;
float blockSize = 16*blockScale;
List<Block> blocks = new ArrayList<Block>();

float oldX = 0;
float oldY = 0;
float playerX = 0;
float playerY = 0;
float hitBox = 35;

float playerSpeed = 4;

boolean wPressed = false;
boolean sPressed = false; 
boolean aPressed = false; 
boolean dPressed = false;

boolean canPlace = true;

int slot = 1;

String[] items = {
  "cobblestone",
  "log",
  "glass",
  "wool",
  "planks",
  "stone",
  "brick"
};

PImage[] textures = new PImage[items.length];

void setup() {
  size(900,600);
  //fullScreen();
  noCursor();
  smooth(0);
  itemsBar = new ItemsBar();
  mainPlayer  = new Player(0,0,0);
  field = new Field();
  rectMode(CENTER);
  imageMode(CENTER);
  for(int i = 0; i < items.length; i++) {
    textures[i] = loadImage(items[i]+".png");
  }
  client = new Client(this, "127.0.0.1", 5204);  // Connect to the server
  println("Client connected to server.");
  players = new HashMap<Integer, OtherPlayer>();
}

void draw() {
  
  String data = "";
  if (client.available() > 0) {
    data = client.readString().trim();
    if (data.startsWith("DISCONNECT")) {
      // Handle player disconnection
      handleDisconnection(data);
    } else {
      // Handle ball position updates
      processUpdates(data);
    }
  }
  
  background(204);
  field.draw();
  canPlace = true;
  
  for(Block block : blocks) {
    if(block.getShouldRemove()) {
      block.remove();
      break;
    }
  }
  for(Block block : blocks) {
    block.draw();
  }
  selector.draw();
  for (Integer id : players.keySet()) {
    OtherPlayer player = players.get(id);
    player.draw();
  }
  
  
  oldX = playerX;
  oldY = playerY;
  
  if(wPressed) {
    playerY -= playerSpeed;
  }
  if(sPressed) {
    playerY += playerSpeed;
  }
  if(checkAllCollisions()) {
    playerY = oldY;
  }
  if(aPressed) {
    playerX -= playerSpeed;
  }
  if(dPressed) {
    playerX += playerSpeed;
  }
  if(checkAllCollisions()) {
    playerX = oldX;
  }
  if(oldX != playerX || oldY != playerY) {
    mainPlayer.setIsWalking(true);
  } else {
    mainPlayer.setIsWalking(false);
  }
  mainPlayer.draw();
  itemsBar.draw();
  cursor.draw();
  client.write(mainPlayer.getR() + " " + playerX + " " + playerY + " " + slot + "\n");
}

boolean checkAllCollisions() {
  boolean isCollided = false;
  for(Block block : blocks) {
    if(block.checkCollision()) {
      isCollided = true;
    }
  }
  return isCollided;
}

boolean touchingFace() {
  return (mouseX > width/2 - hitBox/2) && (mouseX < width/2 + hitBox/2) && (mouseY > height/2 - hitBox/2) && (mouseY < height/2 + hitBox/2);
}

float rem(float number, float divisor) {
  return ((number % divisor) + divisor) % divisor;
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    wPressed = true;
  }
  if (key == 's' || key == 'S') {
    sPressed = true;
  }
  if (key == 'a' || key == 'A') {
    aPressed = true;
  }
  if (key == 'd' || key == 'D') {
    dPressed = true;
  }
  if(keyCode > 48 && keyCode < 58) {
    slot = keyCode - 48;
  }
  if(key == 'r' || key == 'R') {
    output = createWriter("output.txt");
    for(Block block : blocks) {
      output.println(block.type + " " + block.x + " " + block.y);
    }
    output.close(); 
  }
  if(key == 'l' || key == 'L') {
    String[] lines = loadStrings("input.txt");

    for (String line : lines) {
      if(line.length() <= 0) continue;
      if(line.charAt(0) == '#' || line.charAt(0) == '\n') continue;
      String[] parts = line.split(" ");
      Block newBlock = new Block(Integer.valueOf(parts[1]), Integer.valueOf(parts[2]), parts[0]);
      blocks.add(newBlock);
    }
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    wPressed = false;
  }
  if (key == 's' || key == 'S') {
    sPressed = false;
  }
  if (key == 'a' || key == 'A') {
    aPressed = false;
  }
  if (key == 'd' || key == 'D') {
    dPressed = false;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  
  if (e > 0) {
    slot++;
  } else if (e < 0) {
    slot--;
  }
  if(slot < 1) slot = 9;
  slot = (slot - 1)%9+1;
}

void handleDisconnection(String data) {
  String[] parts = data.split(" ");
  int disconnectedId = int(parts[1]);
  
  // Remove the player with the given ID
  if (players.containsKey(disconnectedId)) {
    players.remove(disconnectedId);
    println("Player " + disconnectedId + " disconnected and removed.");
  }
}

void processUpdates(String data) {
  for(String line : data.split("\n")) {
    if(line.startsWith("%")) {
      String id = line.substring(1);
      clientId = Integer.valueOf(id);
      continue;
    }
    if(line.startsWith("#")) {
      CompletableFuture.runAsync(() -> {
        for(String block : line.substring(1).split(";")) {
          String[] info = block.split(",");
          if(info.length == 1) {
            int id = Integer.valueOf(info[0]);
            removeBlock(id);
            continue;
          }
          Block newBlock = new Block(Integer.valueOf(info[1]), Integer.valueOf(info[2]), Integer.valueOf(info[3]), Integer.valueOf(info[0]));
          blocks.add(newBlock);
        }
      });
      continue;
    }
    String[] playersData = line.split(";");
    if (playersData != null && !line.isEmpty()) {
      for (String plr : playersData) {
        if (!plr.isEmpty()) {
          String[] info = plr.split(",");
          setPlayers(int(info[0]), float(info[1]), float(info[2]), float(info[3]), int(info[4]));
        }
      }
    }
  }
}

// Update player positions
void setPlayers(int id, float r, float x, float y, int slot) {
  if(id == clientId) return;
  if (players.containsKey(id)) {
    OtherPlayer player = players.get(id);
    player.setPosition(r, x, y, slot);
  } else {
    players.put(id, new OtherPlayer(r, x, y, slot));
  }
}

void removeBlock(int id) {
  for(Block block : blocks) {
    if(block.getId() == id) {
      block.setShouldRemove(true);
      break;
    }
  }
}
