public class OtherPlayer {
  private float scale = 6;
  private PImage body;
  private PImage head;
  private PImage face;
  private float x = 0, y = 0, r = 0;
  private int slot;

  OtherPlayer(float r, float x, float y, int slot) {
    this.r = r;
    this.x = x;
    this.y = y;
    this.slot = slot;
    body = loadImage("body.png");
    head = loadImage("head.png");
    face = loadImage("face.png");
  }
  
  public void draw() {
    translate(x-playerX+width/2, y-playerY+height/2);
    rotate(r-PI/2);
    if(slot <= textures.length) image(textures[slot-1], -8*scale, 1.5*scale, 5*scale, 5*scale);
    image(body, 0, 0, 16*scale, 4*scale);
    image(head, 0, 0, 8*scale, 8*scale);
    resetMatrix();
  }
  
  public float getR() {
    return this.r;
  }
  
  public void setPosition(float r, float x, float y, int slot) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.slot = slot;
  }
}
