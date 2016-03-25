class ColorRect {
  private int r;
  private int g;
  private int b;
  ColorRect(int r, int g, int b) {
    this.r=r;
    this.g=g;
    this.b=b;
  }
  public int getR() {
    return this.r;
  }
  public int getG() {
    return this.g;
  }
  public int getB() {
    return this.b;
  }

  void color_rect() {
    noStroke();
    fill(r, g, b);
  }
  

}