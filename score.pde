PImage img, img2, img3, img4, apple1, apple2, apple3, apple4, finger, img5, img6, img7;

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;
import processing.video.*;  //ビデオライブラリをインポート
import processing.opengl.*;
Capture video;  //Capture型の変数videoを宣言
MidiBus myBus; //The MidiBus
int pitchbend=0;
int notebus_different=0;
Note[][]note=new Note[4][8];      
ColorRect []c=new ColorRect[22];
int note_y, note_x=0;
float special_moving=0.0;
int channel = 0;
int pitch = 64;
int velocity = 127;
int status_byte = 0xA0; // For instance let us send aftertouch
int channel_byte = 0; // On channel 0 again
int first_byte = 64; // The same note;
int second_byte = 80; // But with less velocity
int video_width=640;
int video_height=540;
ArrayList<Note> played_note;
int special_width;
boolean ismoving=false;
float moving;
float ScoreTop=90.0;
int sum_miss=0;
boolean missCounter=false;
int sum_safe=0;
PImage []app=new PImage[16];
void setup() {
  fullScreen(P2D);// 画面サイズ（適宜調整）
  // size(2500, 1500);
  video = new Capture( this, video_width, video_height, "USB_Camera", 30);  //カメラからのキャプチャーをおこなうための変数を設定

  video.start();  //Processing ver.2.0以上はこのコードが必要
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus object
  img=loadImage("score1.png");//画像を読み込む
  img2=loadImage("score3.png");//画像を読み込む
  img3=loadImage("score4.png");//画像を読み込む
  img4=loadImage("point.png");//画像を読み込む
  img5=loadImage("score_cut.png");//画像左上
  img6=loadImage("right_transparency.png");
  img7=loadImage("left_transparency.png");
  apple1=loadImage("orangeApple.png");
  apple2=loadImage("redApple.png");
  apple3=loadImage("blueApple.png");
  apple4=loadImage("blackApple.png");
  finger=loadImage("how_finger.png");
  
  for(int i=0;i<16;i++){
    app[i]=loadImage("apple"+i+".jpg");
  }
  note[note_y][0]=new Note(919, 175, 69, -200, -200);
  note[note_y][1]=new Note(1044, 169, 71, 528, 487);
  note[note_y][2]=new Note(1172, 165, 73, 531, 569);
  note[note_y][3]=new Note(1299, 158, 74, 536, 609);
  note[note_y][4]=new Note(1443, 154, 76, -200, -200);
  note[note_y][5]=new Note(1577, 146, 78, 551, 483);
  note[note_y][6]=new Note(1712, 142, 79, 551, 532);
  note[note_y][7]=new Note(1846, 136, 81, 556, 606);

  c[0]=new ColorRect(0, 0, 255);
  c[1]=new ColorRect(38, 92, 170);
  c[2]=new ColorRect(65, 131, 197);
  c[3]=new ColorRect(112, 160, 214);
  c[4]=new ColorRect(38, 187, 238);
  c[5]=new ColorRect(131, 206, 237);
  c[6]=new ColorRect(160, 213, 205);
  c[7]=new ColorRect(82, 186, 155);
  c[8]=new ColorRect(9, 127, 93);
  c[9]=new ColorRect(29, 117, 57);
  c[10]=new ColorRect(36, 155, 58);

  c[11]=new ColorRect(87, 175, 79);
  c[12]=new ColorRect(111, 189, 105);
  c[13]=new ColorRect(211, 227, 142);
  c[14]=new ColorRect(248, 229, 141);
  c[15]=new ColorRect(245, 211, 60);
  c[16]=new ColorRect(244, 161, 55);
  c[17]=new ColorRect(243, 162, 134);
  c[18]=new ColorRect(246, 189, 187);
  c[19]=new ColorRect(238, 129, 127);
  c[20]=new ColorRect(234, 93, 87);
  c[21]=new ColorRect(255, 0, 0);

  for (int j=1; j<4; j++) {
    for (int k=0; k<8; k++) {
      note[note_y+j][k]=new Note(note[note_y][k].getX(), note[note_y][k].getY()+212*j, note[note_y][k].NoteNumber(), note[note_y][k].Point_X(), note[note_y][k].Point_Y());
    }
  }
}
void draw() {
  background(0);
  pushMatrix(); 
  translate(200, 900);
  rotate(radians(-90));
  image(video, 10, 10, video_width, video_height);
  popMatrix();
  black_rect();
  myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff
  myBus.sendMessage(status_byte, channel_byte, first_byte, second_byte);
  myBus.sendMessage(
    new byte[] {
    (byte)0xF0, (byte)0x1, (byte)0x2, (byte)0x3, (byte)0x4, (byte)0xF7
    }
    );
  try { 
    SysexMessage message = new SysexMessage();
    message.setMessage(
      0xF0, 
      new byte[] {
      (byte)0x5, (byte)0x6, (byte)0x7, (byte)0x8, (byte)0xF7
      }, 
      5
      );
    myBus.sendMessage(message);
  } 
  catch(Exception e) {
  }
  moving_score();
  fill(0);
  rect(0, 0, 40, 178);
  rect(718, 40, 82, 178);
  image(img6, 40, 40, 88, 178);
  image(img7, 630, 40, 88, 178);
  fill(0);
  rect(800, 49, 1200, 741);
  image(img, 800, 100, 1200, 741);//img楽譜を配置
  /*if ((0<=note_x)&&(note_x<=3)) {
   image(img4, 90, 50, 550, 148);//img楽譜を配置
   }
   if ((4<=note_x)&&(note_x<8)) {
   image(img3, 90, 50, 550, 148);//img楽譜を配置
   }
   */
  note[note_y][note_x].bluerect(); 
  for (int m=0; m<c.length; m++) {
    c[m].color_rect();
    rect(1000+m*30, 20, 20, 20);
  }
  fill(255);
  textSize(20);
  text("low tone", 900, 20, 100, 40);
  text("high tone", 1670, 20, 100, 40);
  if (note[note_y][note_x].played_note.size()>0) {
    c[note[note_y][note_x].getNote(note[note_y][note_x].played_note.size()-1)].color_rect();
    rect(200, 160, 30, 30);
  }

  if ((note_x>=0) && (note_y>=0)) {
    for (int j=0; j<note_x; j++) {
      if ((j%10)>=4) {
        special_width=25;
      } else if ((j%10)<4) {
        special_width=0;
      }
      c[note[note_y][j].getNote(0)].color_rect();
      rect(910+special_width+(special_width/10*j)+125*j, 250+212*note_y, 20, 20);
      if (note[note_y][j].miss>=1) {
        fill(255);
        textSize(25);
        text("×", 910+special_width+(special_width/10*j)+125*j, 67+212*note_y, 40, 40);
      }
    }
    for (int z=0; z<=note_y-1; z++) {
      for (int s=0; s<8; s++) {
        if ((s%10)>=4) {
          special_width=25;
        } else if ((s%10)<4) {
          special_width=0;
        }
        c[note[z][s].getNote(0)].color_rect();
        rect(910+special_width+(special_width/10*s)+125*s, 250+212*z, 20, 20);
        if (note[z][s].miss>=1) {
          fill(255);
          textSize(25);
          text("×", 910+special_width+(special_width/10*s)+125*s, 67+212*z, 40, 40);
        }
      }
    }
  }
  image(finger, 105, 280, 190, 625);
  image(apple1, 142, 235, 30, 30);
  image(apple2, 168, 235, 30, 30);
  image(apple3, 194, 235, 30, 30);
  image(apple4, 220, 235, 30, 30);
fill(0);
rect(0,625,348,800);
  for (int z=0; z<=4; z++) {
    for (int s=0; s<4; s++) {
      special_width=0;
      image(apple3, 910+special_width+(special_width/10*s)+125*s, 210+212*z, 30, 30);
    }
  }
  for (int z=0; z<=4; z++) {
    for (int s=4; s<8; s++) {
      special_width=25;
      image(apple4, 910+special_width+(special_width/10*s)+125*s, 210+212*z, 30, 30);
    }
  }
  note[note_y][note_x].point_mark();
  sum_miss=0;
  sum_safe=0;
  for (int i=0; i<note.length; i++) {
    for (int j=0; j<note[i].length; j++) {
      if (note[i][j].Miss()>=1) {
        sum_miss++;
      }
    }
  }
  for (int i=0; i<=note_y; i++) {
    for (int j=0; j<=note_x; j++) {
      if (note[i][j].Miss()<1) {
        sum_safe++;
      }
    }
  }
//  println("Sm:"+sum_miss);
 println("sum_safe:"+sum_safe);
 for(int i=0;i<app.length;i++){
   if(sum_safe/2==i){
     image(app[i],0,560,600/2,849/2);
   }
 
 }
  fill(255);
  text(note_x+", "+note_y,0,height);
}


void captureEvent(Capture video) {
  video.read();
}

void black_rect() {
  fill(0);
  rect(650, 245, 130, 800);
  rect(200, 245, 160, 800);
}

void moving_score() {
  if ((note_x>=0) &&(note_y>=0)) {
    if ((ismoving==true)) {
      moving+=0.04;
    }
    if (moving>=3.3) {
      moving=0.0;
      ismoving=false;
    }
    if ((note_x==0)&&(note_y==1)) {
      special_moving=28.0;
    } else if ((note_x==0)&&(note_y==2)) {
      special_moving=80.0;
    } else if ((note_x==0)&&(note_y==3)) {
      special_moving=150.0;
    }
   // println("ScoreTop:"+ScoreTop);
   // println("moving:"+moving);
    ScoreTop=ScoreTop-moving;
    image(img5, ScoreTop-special_moving, 50, 1141, 148);//移動する楽譜の第1連
    image(img5, ScoreTop+1141-special_moving, 50, 1141, 148);//移動する楽譜の第2連
    image(img5, ScoreTop+1141*2-special_moving, 50, 1141, 148);//移動する楽譜の第3連
    image(img5, ScoreTop+1141*3-special_moving, 50, 1141, 148);//移動する楽譜の第4連
  //  println("special_movinf:"+note_y+"A"+special_moving);
  }
}

void mouseClicked() {
  println("x"+mouseX+" "+"y"+mouseY);
  return;
}
void rawMidi(byte[] data) { // You can also use rawMidi(byte[] data, String bus_name) 
  println();
  print("Status Byte/MIDI Command:"+(int)(data[0] & 0xFF));
  if (((int)(data[0] & 0xFF) >= 224)&&((int)(data[0] & 0xFF) <= 227)) {
    pitchbend = (int)(data[2] & 0xFF) * 128 + (int)(data[1] & 0xFF);
//    print(": " + pitchbend);
  } 
  for (int i = 1; i < data.length; i++) {
//    print(": "+(i+1)+": "+(int)(data[i] & 0xFF));
  }
  for (int i = 1; i < data.length; i++) {
//    print(": "+(i+1)+": "+(int)(data[i] & 0xFF));
  }
  if (((int)(data[0] & 0xFF) >= 144)&&((int)(data[0] & 0xFF) <= 171)) {
    notebus_different=((data[1] & 0xFF)-note[note_y][note_x].NoteNumber())*333+pitchbend-8192;
    note[note_y][note_x].addNote(notebus_different);
 //   println("CCCC"+notebus_different);
 //   println("AAAA"+note[0][0].getNote(note[0][0].played_note.size()-1));
  }
  if (((int)(data[0] & 0xFF) >= 128)&&((int)(data[0] & 0xFF) <= 131)) {
    println();

    if ((int)(data[1] & 0xFF)!=note[note_y][note_x].NoteNumber() ) {
      note[note_y][note_x].PlusMiss();
    }

    if ((int)(data[1] & 0xFF)==note[note_y][note_x].NoteNumber()) {
      note_x++;
      ismoving=true;
      if (note_x!=0&&note_x==8) {
        note_y++;
        note_x=0;
        if (note_y>3) {
          note_y=0;
        }
      }
    }
  }
}