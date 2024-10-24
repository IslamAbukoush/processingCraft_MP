public class Player {
  private int id;  // ID is now an int
  private Client client;
  private float x = 0, y = 0, r = 0;
  private int slot = 1;

  Player(Client client, int id) {
    this.client = client;
    this.id = id;
  }

  Client getClient() {
    return this.client;
  }

  float getX() {
    return this.x;
  }

  float getY() {
    return this.y;
  }
  
  float getR() {
    return this.r;
  }

  int getId() {  // Return the ID as an int
    return this.id;
  }
  
  int getSlot() {
    return this.slot;
  }
}
