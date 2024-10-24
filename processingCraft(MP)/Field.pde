public class Field {
  private float x = 0; 
  private float y = 0;
  private float size = 128*blockScale;
  private PImage fieldPng;
  
  Field() {
    fieldPng = loadImage("bg.png");
  }
  
  public void draw() {
    imageMode(CORNER);
    x = width/2-rem(playerX-size/4, size/2)+size/4;
    y = height/2-rem(playerY-size/4, size/2)+size/4;
    image(fieldPng, x, y, size, size);
    image(fieldPng, x-size, y, size, size);
    image(fieldPng, x, y-size, size, size);
    image(fieldPng, x-size, y-size, size, size);
    imageMode(CENTER);
  }
}
