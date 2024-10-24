public class Cursor {
  private float size = 10;
  private color clr = color(155);
  public void draw() {
    fill(clr);
    stroke(clr);
    rect(mouseX, mouseY, size*2, size/2, blockSize);
    rect(mouseX, mouseY, size/2, size*2, blockSize);
  }
}
