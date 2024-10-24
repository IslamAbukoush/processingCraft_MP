public class Selector {
  private float x = 0;
  private float y = 0;
  private float modX = 0;
  private float modY = 0;
  public void draw() {
    modX = playerX%blockSize - width/2 - blockSize/2;
    modY = playerY%blockSize - height/2 - blockSize/2;
    x = round((mouseX + modX)/blockSize)*blockSize - modX;
    y = round((mouseY + modY)/blockSize)*blockSize - modY;
    strokeWeight(3);
    stroke(0,0,0,155);
    noFill();
    rect(x, y, blockSize, blockSize);
    build();
  }
  
  private void build() {
    if(mousePressed && (mouseButton == LEFT) && canPlace) {
      int blockX = floor((x-width/2+playerX)/blockSize);
      int blockY = floor((y-height/2+playerY)/blockSize);
      print('\n');
      if(slot <= items.length) {
        client.write("#"+slot+","+blockX+","+blockY+"\n");
        mainPlayer.place();
      }
    }
  }
}
