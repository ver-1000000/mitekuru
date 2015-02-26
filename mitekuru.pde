import processing.video.*;
import ddf.minim.*;

AudioPlayer player;
Minim minim;
Capture video;

int videoW=160, videoH=120, mon=4, renge=120; //camWithSize, camHeightSize, enable imploved display, tolerance level
int sumX, sumY, pNum, vchin;
float x, y, ex, ey, bright, easing = 1;
color[] exColor=new color[videoW*videoH];
boolean movement;
PImage body, eye_w, eye_b, chin;

void setup() {
  frameRate(60);
  size(displayWidth*2, displayHeight, JAVA2D);
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  frame.setLocation(0, 0);
  video = new Capture(this, videoW, videoH);
  video.start();
  body = loadImage("body.png");
  eye_w = loadImage("eye_w.png");
  eye_b = loadImage("eye_b.png");
  chin = loadImage("chin.png");
  minim = new Minim(this);
}

void draw() {
  float dx = x - ex;
  float dy = y - ey;
  if (abs(dx) > 1) {
    ex += dx * easing;
    ey += dy * easing;
  }
  video.read();
  loadPixels();
  movement=false;
  for (int i=0;i<videoW*videoH;i++) {
    float diff=abs(brightness(exColor[i])-brightness(video.pixels[i]));
    if (diff>renge) {
      movement=true;
      pixels[i]=color(0, 255, 255);
      sumX+=i%videoW;
      sumY+=i/videoW;
      pNum++;
    }
    bright += brightness(video.pixels[i]);
    exColor[i]=video.pixels[i];
  }
  if (pNum>1800&&vchin<=0) {
    float rd = random(100);
    if (rd<=60) {
      player = minim.loadFile("fufu.wav", 256);
      vchin=20;
    }
    else if (rd<=80) {
      player = minim.loadFile("miteiru.wav", 256);
      vchin=10;
    }
    else{
      player = minim.loadFile("yana.wav", 256);
      vchin=3;
    }
    player.play();
  }
  updatePixels();
  if (movement==true) {
    x=sumX/pNum;
    y=sumY/pNum;      
    sumX=0;
    sumY=0;
    pNum=0;
  }
  if (vchin>0)vchin--;
  for (int i=1;i<=mon;i++) {
    int d = width*(i-1)/mon;
    float k = .15-(.15/i);
    if (frameCount%1500<60||frameCount%1400<60) {
      k=random(-1, 1);
      vchin=int(random(6));
    }
    image(eye_w, d+(width/(mon*3.4)), height/2.8, width/mon/5, height/5);
    image(eye_b, d+(width/(mon*(3.3+k)))-((ex-videoW/2)*.2), height/2.8+(ey-videoH/2)*.15, width/mon/5, height/5);
    image(body, d, 0, width/mon, height);
    image(chin, d+(width/(mon*2.67))+vchin%4*8, height*.646+vchin%4*16, width/mon/5, height/5);
  }
  if (bright/(videoW*videoW)<renge/2) {
    filter(THRESHOLD);
  }
  bright=0;
}

