public class ItemsBar {
  private PImage bar;
  private PImage square;
  private List<PImage> itemImages;
  private float scale = 3;
  ItemsBar() {
    bar = loadImage("itembar.png");
    square = loadImage("square.png");
    itemImages = new ArrayList<PImage>();
    for(String name : items) {
      itemImages.add(loadImage(name+".png"));
    }
  }
  public void draw() {
    image(bar, width/2, height*0.9, 182*scale, 22*scale);
    image(square, width/2+(20*scale*(slot - 5)), height*0.9, 24*scale, 24*scale);
    for(int i = 0; i < itemImages.size(); i++) {
      image(itemImages.get(i), width/2 + (20*scale*(i-4)), height*0.9, 16*scale, 16*scale);
    }
  }
}
