public class Block {
  
  private int x = 0;
  private int y = 0;
  private int id;
  private int blockSlot = 0;
  private float realX = 0; 
  private float realY = 0;
  private String type;
  private PImage texture;
  private boolean shouldRemove = false;
  
  Block(int x, int y, int id) {
    this.x = x;
    this.y = y;
    this.id = id;
    this.type = items[slot-1];
    this.blockSlot = slot;
    texture = textures[slot-1];
    realX = x*blockSize - playerX+width/2+blockSize/2;
    realY = y*blockSize - playerY+height/2+blockSize/2;
    if(checkCollision()) {
      this.shouldRemove = true;
    }
  }
  
  Block(int x, int y, int id, int slot) {
    this.x = x;
    this.y = y;
    this.id = id;
    this.type = items[slot-1];
    this.blockSlot = slot;
    texture = textures[slot-1];
    realX = x*blockSize - playerX+width/2+blockSize/2;
    realY = y*blockSize - playerY+height/2+blockSize/2;
    if(checkCollision()) {
      shouldRemove = true;
      client.write("#"+id+"\n");
    }
  }
  Block(int x, int y, String type) {
    this.x = x;
    this.y = y;
    this.type = type;
    texture = loadImage(type+".png");
    realX = x*blockSize - playerX+width/2+blockSize/2;
    realY = y*blockSize - playerY+height/2+blockSize/2;
    if(checkCollision()) {
      shouldRemove = true;
      client.write("#"+id+"\n");
    }
  }
  
  
  public boolean getShouldRemove() {
    return shouldRemove;
  }
  
  public void setShouldRemove(boolean b) {
    shouldRemove = b;
  }
  
  public int getId() {
    return this.id;
  }
  
  public void remove() {
    blocks.remove(this);
  }
  
  public void draw() {
    realX = x*blockSize - playerX+width/2+blockSize/2;
    realY = y*blockSize - playerY+height/2+blockSize/2;
    if(realX+blockSize > 0 && realX-blockSize < width && realY+blockSize > 0 && realY-blockSize < height) {
      image(texture, realX, realY, blockSize, blockSize);
      if(mouseX >= realX-blockSize/2 && mouseX <= realX+blockSize/2 && mouseY >= realY-blockSize/2 && mouseY <= realY+blockSize/2) {
        canPlace = false;
        if(mousePressed) {
          if(mouseButton == RIGHT) {
            client.write("#"+id+"\n");
            mainPlayer.place();
          }
          if(mouseButton == CENTER) {
            slot = blockSlot;
          }
        }
      }
    }
  }
  
  public boolean checkCollision() {
    boolean isDown = y*blockSize+blockSize < playerY-hitBox/2;
    boolean isUp = y*blockSize > playerY+hitBox/2;
    boolean isRight = x*blockSize+blockSize < playerX-hitBox/2;
    boolean isLeft = x*blockSize > playerX+hitBox/2;
    boolean result = !isDown && !isUp && !isRight && !isLeft;
    return result;
  }
}
