public class Player {
  private float scale = 6;
  private PImage body;
  private PImage head;
  private PImage face;
  private float dr = PI/100;
  private float r = 0;
  private float rRange = PI/10;
  private float dr2 = PI/50;
  private float r2 = 0;
  private float r2Range = PI/8;
  private float angle = 0;
  private float x = 0, y = 0;

  private boolean isWalking = false;
  private boolean isPlacing = false;
  Player(float r, float x, float y) {
    this.angle = r;
    this.x = x;
    this.y = y;
    body = loadImage("body.png");
    head = loadImage("head.png");
    face = loadImage("face.png");
  }
  
  public void draw() {
    walk();
    placeAnimation();
    translate(width/2, height/2);
    float dx = mouseX - width/2;
    float dy = mouseY - height/2;
    angle = atan2(dy, dx);
    
    rotate(angle-PI/2+r+r2);
    if(slot <= textures.length) image(textures[slot-1], -8*scale, 1.5*scale, 5*scale, 5*scale);
    image(body, 0, 0, 16*scale, 4*scale);
    rotate(-r-r2);
    if(touchingFace()) {
      image(face, 0, 0, 8*scale, 8*scale);
    } else {
      image(head, 0, 0, 8*scale, 8*scale);
    }
    resetMatrix();
  }
  
  private void walk() {
    if(!isWalking && (r <= abs(dr) && r >= -abs(dr))) {
      return;
    }
    if(abs(r) >= rRange) dr *= -1;
    r += dr;
  }
  
  private void placeAnimation() {
    if(!isPlacing) return;
    if(abs(r2) >= r2Range || r2 == 0) dr2 *= -1;
    r2 += dr2;
    if(r2 >= 0) {
      r2 = 0;
      isPlacing = false;
    }
  }
  
  public void setIsWalking(boolean isWalking) {
     this.isWalking = isWalking;
  }
  
  public void place() {
    isPlacing = true;
  }
  
  public float getR() {
    return this.angle;
  }
  
  public void setPosition(float r, float x, float y) {
    this.x = x;
    this.y = y;
    this.angle = r;
  }
}
