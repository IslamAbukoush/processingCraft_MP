import processing.net.*;  
import java.util.List;
import java.util.ArrayList;

Server server;
List<Player> players;
int id = 0;
int blockId = 0;
String blocks = "";

void setup() {
  server = new Server(this, 5204);  // Open the server on port 5204
  players = new ArrayList<Player>();
  println("Server started.");
}

void draw() {
  Client client = server.available();
  
  // If a new client connects
  if (client != null && !hasClient(client)) {
    players.add(new Player(client, players.size()+1));  // Incrementing id as an int
    client.write("%"+(players.size())+"\n");
    println("New client connected.");
  }
  
  // Check if any players have disconnected
  checkForDisconnections();
  
  for (Player player : players) {
    if (player.client.available() > 0) {
      String input = player.client.readString().trim();
      for(String line : input.split("\n")) {
        if(line.startsWith("#")) {
          String l = line.substring(1);
          if(l.split(",").length == 1) blocks += l + ";";
          else {
            blocks += line.substring(1) + "," + blockId + ";";
            blockId++;
          }
        } else {
          updatePosition(input, player);
        }
      }
    }
  }
  // After processing inputs, broadcast updated positions
  broadcastPositions();
}

void updatePosition(String input, Player player) {
  String[] pos = input.split(" ");
  player.x = float(pos[1]);
  player.y = float(pos[2]);
  player.r = float(pos[0]);
  player.slot = int(pos[3]);
}

void broadcastPositions() {
  StringBuilder data = new StringBuilder();
  for (Player player : players) {
    float xPos = player.getX();
    float yPos = player.getY();
    Integer slot = player.getSlot();
    if (Float.isNaN(xPos) || Float.isNaN(yPos) || slot < 1) continue;
    data.append(player.getId()).append(",").append(player.getR()).append(",").append(player.getX()).append(",").append(player.getY()).append(",").append(player.getSlot()).append(";");
  }

  String dataStr = data.toString();
  for (Player player : players) {
    if (!dataStr.isEmpty()) {
      player.client.write(dataStr + "\n");
    }
    if(!blocks.isEmpty()) {
      player.client.write("#"+blocks+"\n");
    }
  }
  blocks = "";
}

// Check if a player has disconnected and remove them
void checkForDisconnections() {
  for (int i = players.size() - 1; i >= 0; i--) {  // Iterate backward to avoid issues while removing
    Player player = players.get(i);
    if (!player.client.active()) {  // Player is disconnected
      println("Client " + player.getId() + " disconnected.");
      players.remove(i);
      broadcastDisconnection(player.getId());  // Pass the ID as an int
    }
  }
}

// Broadcast player disconnection to other players
void broadcastDisconnection(int playerId) {
  for (Player player : players) {
    player.client.write("DISCONNECT " + playerId + "\n");  // Inform about disconnection
  }
}

boolean hasClient(Client client) {
  for (Player player : players) {
    if (player.getClient() == client) {
      return true;
    }
  }
  return false;
}
