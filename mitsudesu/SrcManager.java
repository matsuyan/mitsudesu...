import processing.core.*;

class SrcManager{
  private static SrcManager instance;
  private static PApplet app;
  public PImage[] imgs = new PImage[9];
  //private AudioPlayer[] SEs = new AudioPlayer[3];
  
  private SrcManager(){
    imgs[0] = app.loadImage("src/img/mitsu.png");
    imgs[1] = app.loadImage("src/img/syu.png");
    imgs[2] = app.loadImage("src/img/setsu.png");
    imgs[3] = app.loadImage("src/img/pei.png");
    imgs[4] = app.loadImage("src/img/game_board.png");
    imgs[5] = app.loadImage("src/img/hand.png");
    imgs[6] = app.loadImage("src/img/19mai.png");
    imgs[6].resize(500,60);
    imgs[7] = app.loadImage("src/img/title.png");
    imgs[7].resize(700,400);
    imgs[8] = app.loadImage("src/img/yuriko.jpg");
  }
  
  public static SrcManager getInstance(PApplet papp){
    if(instance == null){
      app = papp;
      instance = new SrcManager();
    }
    return instance;
  }
  
  public static SrcManager getInstance(){
    return instance;
  }
}
