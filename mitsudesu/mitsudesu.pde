//通信機能を削除
import ddf.minim.*;



Minim minim;
AudioPlayer[] SEs = new AudioPlayer[7];
AudioPlayer bgm;
PImage[] imgs = new PImage[6];
SrcManager src;
Board board;
Hand shand,chand;
Mouse mouse;
boolean mouseClicked = false;
int gseq;
/*0:title
  1:connecting→削除
  2:sturn
  3:cturn
  4:gameover*/
int spoint,cpoint;

void setup(){
  size(900,600);
  colorMode(HSB,100);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);
  textLeading(0.1);
  instanciate();
  loadAudio();
  gameInit();
}

void instanciate(){
  minim = new Minim(this);
  src = SrcManager.getInstance(this); 
  int offsetx = 120;
  shand = new Hand(offsetx,height/2,1);
  chand = new Hand(width-offsetx,height/2,2);
  board = new Board();   
  mouse = new Mouse();
}

void loadAudio(){
   SEs[0] = minim.loadFile("mid-syu.mp3");
   SEs[1] = minim.loadFile("mid-setsu.mp3");
   SEs[2] = minim.loadFile("mid-pei.mp3");
   SEs[3] = minim.loadFile("push.mp3");
   SEs[4] = minim.loadFile("she_is_yuriko.mp3");
   SEs[5] = minim.loadFile("mitsudesu.mp3");
   SEs[6] = minim.loadFile("social_distance.mp3");
   for(int i=0;i<7;i++){
     SEs[i].setGain(50);
   }
   bgm = minim.loadFile("YOIYAMI.mp3");
   bgm.setGain(-0);
}

void SErewind(){
  for(int i=0;i<7;i++)
    SEs[i].rewind();
}

void playSE(int num){
  SEs[num].play();
}

void gameInit(){
  gseq = 0;
  spoint = 2;
  cpoint = 2;
  board.clear();
  SEs[4].rewind();
  SEs[4].play();
  bgm.play();
  bgm.loop();
}

void draw(){
  dispBackground();
  fill(0);
  switch(gseq){
    case 0:
      image(src.imgs[7],width/2,220);
      textSize(45);
      fill(0);
      text("click  to  start",width/2,height-100);
      if(mousePressed){
        gseq = 2;
        SEs[5].rewind();
        SEs[5].play();
      }
        break;
      case 2:
         dispField();
         board.drawCursor(16,50,98);
         shand.drawCursor(16,50,98);
         mouse.drawSelectedMoji();
         boolean isPulledOut_s = pullOutMoji(shand);
         if(isPulledOut_s){
           gseq = 3;
           calculateArea(2);
           countPoint();
           if(gameSet()){
           gseq = 4;
           SEs[6].rewind();
           SEs[6].play();
           }
         }
        break;
      case 3:
           dispField();
           board.drawCursor(50,30,88);
           chand.drawCursor(50,30,88);
           mouse.drawSelectedMoji();
         boolean isPulledOut_c = pullOutMoji(chand);
         if(isPulledOut_c){
           gseq = 2;
           calculateArea(3);
           countPoint();
           if(gameSet()){
           gseq = 4;
           SEs[6].rewind();
           SEs[6].play();
           }
         }
        break;
      case 4:
        dispField();
        dispResult();
        /*if(mouseClicked){
          mouseClicked = false;
          gameInit();
        }*/
        break;
      default:
        println("意図しないSTATE"+gseq+"に変更されました。draw()1");
  }
}

boolean pullOutMoji(Hand hand){
    if(mouseClicked){
      mouseClicked = false;
      if(hand.getMoji() != null){
          if(mouse.getMoji() == hand.getMoji()){
            mouse.setMoji(null);
          }else{
            mouse.setMoji(hand.getMoji());
          }
      }else if(board.isOnBoard()){
          if(board.getMojiFromMouse() == null && mouse.getMoji() != null){
            board.setMojiFromMouse(mouse.getMoji().getImg());
            board.setAreaFromMouse(hand);//AREA.server);
            mouse.setMoji(null);
            return true;
          }
      } 
    }
    return false;
}

void calculateArea(int turn){
  for(int y=1;y<=6;y++)
    for(int x=1;x<=6;x++){
      //println("x="+x+",y="+y+"_calculateArea()1");
      int currentArea = board.getArea(x,y);
      if(currentArea == 0) continue;//free cell
      Moji currentMoji = board.getMoji(x,y);
      if(x != 6){
        int nextArea = board.getArea(x+1,y);
        Moji nextMoji = board.getMoji(x+1,y);
        if(currentArea != nextArea && nextArea != 0){
            if((currentMoji.equals(0) 
                && (nextMoji.equals(1)||nextMoji.equals(2)||nextMoji.equals(3)))){
                if(!board.horChangeAreaTable[x-1][y-1]){
                  if(turn == 2){//server
                    board.setArea(1,x,y);
                    board.setArea(1,x+1,y);
                    board.horChangeAreaTable[x-1][y-1] = true;
                  }
                  if(turn == 3){//client
                    board.setArea(2,x,y);
                    board.setArea(2,x+1,y);
                    board.horChangeAreaTable[x-1][y-1] = true;
                  }
                  SErewind();
                  if(nextMoji.equals(1)) playSE(0);
                  if(nextMoji.equals(2)) playSE(1);
                  if(nextMoji.equals(3)) playSE(2);
                  println("x="+x+",y="+y+"から右へ繋がっています。_calculateArea()");
                }
          }
        }
      }
      if(y != 6){
        int nextArea = board.getArea(x,y+1);
        Moji nextMoji = board.getMoji(x,y+1);
        //println("nextMoji="+nextMoji+"_calcualateArea()1");
        if(currentArea != nextArea && nextArea != 0){
          if((currentMoji.equals(0) 
                  && (nextMoji.equals(1)||nextMoji.equals(2)||nextMoji.equals(3)))){
                  if(!board.verChangeAreaTable[x-1][y-1]){
                    if(turn == 2){//server
                      board.setArea(1,x,y);
                      board.setArea(1,x,y+1);
                      board.verChangeAreaTable[x-1][y-1] = true;
                    }
                    if(turn == 3){//client
                      board.setArea(2,x,y);
                      board.setArea(2,x,y+1);
                      board.verChangeAreaTable[x-1][y-1] = true;
                    }
                    SErewind();
                    if(nextMoji.equals(1)) playSE(0);
                    if(nextMoji.equals(2)) playSE(1);
                    if(nextMoji.equals(3)) playSE(2);
                    println("x="+x+",y="+y+"から下へ繋がっています。_calculateArea()");
                  }
         }
         }
      }
    }
  //println("calculated!");
}

void countPoint(){
  spoint = 0;
  cpoint = 0;
  for(int y=1;y<=6;y++)
    for(int x=1;x<=6;x++){
      if(board.getArea(x,y) == 1){
        spoint++;
      }
      if(board.getArea(x,y) == 2){
        cpoint++;
      }
    }
}

boolean gameSet(){
  if(spoint >= 19 || cpoint >= 19) return true;
  return false;
}

float offset = 0;

void dispBackground(){  
  float speed = 0.05;
  offset+=speed;
  if(offset >= 2*PI){
    offset = 0;
  }
  noStroke();
  for(int i=0;i<50;i++){
  fill(17+2*sin(offset-speed*i),40,88);
  rect(width/2,height/40 + (height/50)*(i-1),width,height/50);
  }
  
  tint(100,8);
  image(src.imgs[8],width/2,height/2,width,height);
  noTint();
}

void dispField(){
  noStroke();
  if(gseq == 2)fill(16,50,98);
  else  fill(16,50,30);
  arc(0,0,400,400,0,PI/2);
  if(gseq == 3)fill(50,30,88);
  else  fill(50,30,30);
  arc(width,0,400,400,PI/2,PI);
  int offsetX = 70;
  fill(0);
  textSize(100);
    text(spoint,offsetX,120);
    text(cpoint,width-offsetX,120);
  textSize(18);
    text("player1",offsetX-25,35);
    text("player2",width-offsetX+25,35);
  chand.drawHand();
  shand.drawHand();
  board.drawBoard();
  image(src.imgs[6],width/2,height-50);
  textSize(30);
  fill(0);
  if(gseq == 2)text("↑\nanata\nno\nturn",offsetX+50,height-150);
  if(gseq == 3)text("↑\nanata\nno\nturn",width-offsetX-50,height-150);
}

void dispResult(){
  fill(100,85);
  rect(width/2,height/2,width,height);
  int offsetX = 170,offsetY = 270;
  fill(0);
  textSize(140);
  text(spoint,offsetX,offsetY);
  text(cpoint,width-offsetX,offsetY);
  textSize(30);
  text("player1",offsetX,offsetY+50);
  text("player2",width-offsetX,offsetY+50);
  String winstr = null;
  if(spoint >= 19)winstr = "player1 win!";
  else if(cpoint >= 19)winstr = "player2 win!";
  textSize(100);
  text(winstr,width/2,offsetY+200);
  textSize(30);
  text("click  to  play  again",width/2,offsetY+250);
}

void mouseClicked(){
  mouseClicked = true;
  SEs[3].rewind();
  SEs[3].play();
}
