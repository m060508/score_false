//marimochi_booboo

class Note {
  private int x;
  private int y;
  private int note_number;
  private int point_x;
  private int point_y;
  private int miss=0;
  private int safe=0;
  private ArrayList<Integer> played_note=new ArrayList();

  Note(int x, int y, int note_number, int point_x, int point_y) {
    this.x=x;
    this.y=y;
    this.note_number=note_number;
    this.point_x=point_x;
    this.point_y=point_y;
  }
  public int getX() {
    return this.x;
  }
  public int getY() {
    return this.y;
  }
  public int NoteNumber() {
    return this.note_number;
  }
  public int Point_X() {
    return this.point_x;
  }
  public int Point_Y() {
    return this.point_y;
  }
  public int Miss() {
    return this.miss;
  }
  public int Safe(){
    return this.safe;
  }

  void bluerect() {
    noStroke();
    fill(186, 233, 255);
    textSize(25);
    text("▼", x-20, 67+212*note_y, 40, 40);
    //text("▼", 100+160*(note_x%4), 38, 40, 40);
    text("▼", 210, 38, 40, 40);
  }

  void point_mark() {
    image(img4, point_x, point_y, 40, 40);
  }


  /*void falth_mark() {
    noStroke();
    fill(255);
    textSize(25);
    text("×", x-20, 67+212*note_y, 40, 40);
  }*/
  public void addNote(int n)
  {
    if (n<-300) {
      n=0;
    } else if ((-300<=n)&&(n<-270)) {
      n=1;
    } else if ((-270<=n)&&(n<-240)) {
      n=2;
    } else if ((-240<=n)&&(n<-210)) {
      n=3;
    } else if ((-210<=n)&&(n<-180)) {
      n=4;
    } else if ((-180<=n)&&(n<-150)) {
      n=5;
    } else if ((-150<=n)&&(n<-120)) {
      n=6;
    } else if ((-120<=n)&&(n<-90)) {
      n=7;
    } else if ((-90<=n)&&(n<-60)) {
      n=8;
    } else if ((-60<=n)&&(n<-30)) {
      n=9;
    } else if ((-30<=n)&&(n<0)) {
      n=10;
    } else if ((0<=n)&&(n<30)) {
      n=11;
    } else if ((30<=n)&&(n<60)) {
      n=12;
    } else if ((60<=n)&&(n<90)) {
      n=13;
    } else if ((90<=n)&&(n<120)) {
      n=14;
    } else if ((120<=n)&&(n<150)) {
      n=15;
    } else if ((150<=n)&&(n<180)) {
      n=16;
    } else if ((180<=n)&&(n<210)) {
      n=17;
    } else if ((210<=n)&&(n<240)) {
      n=18;
    } else if ((240<=n)&&(n<270)) {
      n=19;
    } else if ((270<=n)&&(n<300)) {
      n=20;
    } else if (300<=n) {
      n=21;
    }
    played_note.add(n);
  }
  public int getNote(int m) {
    return this.played_note.get(m);
  }
  public void PlusMiss(){
    this.miss++;
  }
}