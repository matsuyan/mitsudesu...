/*enum AREA{
  free,server,client
}*/

class Board{
  Board(){
    pulledOutMoji = new Moji[6][6];
    area = new int[6][6];
    for(int y=0;y<6;y++)
     for(int x=0;x<6;x++) area[x][y] = 0;
    horChangeAreaTable = new boolean[6][6];
    verChangeAreaTable = new boolean[6][6];
    for(int y=0;y<6;y++)
     for(int x=0;x<6;x++) {
     horChangeAreaTable[x][y] = false;
     verChangeAreaTable[x][y] = false;
     
    this.img = src.imgs[4];
    this.img.resize(size,size);
     }
  }
  
  PImage img;
  private SrcManager src = SrcManager.getInstance();
  final static int size = 400;
  private float posx=width/2, posy=height/2;
  Moji[][] pulledOutMoji;
  boolean[][] horChangeAreaTable,verChangeAreaTable;
  int[][] area;
  
  void drawBoard(){
   image(img,posx,posy);
   dispColor();
   dispPulledOutMoji();
 }
 
 private void dispColor(){
   for(int y=0;y<6;y++)
      for(int x=0;x<6;x++){
        switch(area[x][y]){
          case 0://free:
             noFill();
            break;
          case 1://server:
              fill(16,50,98);
            break;
          case 2://client:
            fill(50,30,88);
           break;
        }
        noStroke();
        rect(posx+(size/6)*(x-2.5),posy+(size/6)*(y-2.5),size/6-3,size/6-3);
      }
 }
 
 private void dispPulledOutMoji(){
   for(int y=0;y<6;y++)
   for(int x=0;x<6;x++){
     if(pulledOutMoji[x][y] != null){
       pulledOutMoji[x][y]
       .draw(posx+(Moji.size+10)*(x-2.5),posy+(Moji.size+10)*(y-2.5));
     }
   }
 }

  public void drawCursor(int h,int s,int v){
      for(int y=0;y<6;y++)
      for(int x=0;x<6;x++){
        boolean flgx = (posx-size/2f)+(size/6f) * x <= mouseX
                          && mouseX < (posx-size/2f+size/6f)+(size/6f) * x;
        boolean flgy = (posy-size/2f)+(size/6f) * y <= mouseY
                          && mouseY < (posy-size/2f+size/6f)+(size/6f) * y;
        if(flgx && flgy){
           stroke(h,s,v);
           if(mousePressed){
            stroke(h,s,70);
           }
           strokeWeight(5);
           noFill();
           rect(posx+(size/6)*(x-2.5),posy+(size/6)*(y-2.5),size/6-3,size/6-3);
        }
      }
    }
 
 public void clear(){
   for(int y=1;y<=6;y++){
      for(int x=1;x<=6;x++){
        //setMoji(null,x,y);
        setArea(0,x,y);
        horChangeAreaTable[x-1][y-1] = false;
        verChangeAreaTable[x-1][y-1] = false;
      }
   }
      
    setMoji(src.imgs[int(random(0,4))],2,2);
    setArea(1,2,2);
    setMoji(src.imgs[int(random(0,4))],2,5);
    setArea(2,2,5);
    setMoji(src.imgs[int(random(0,4))],5,2);
    setArea(2,5,2);
    setMoji(src.imgs[int(random(0,4))],5,5);
    setArea(1,5,5);
 }
  
  public boolean isOnBoard(){
    if((posx-size/2 <= mouseX && mouseX < posx+size/2)
        && posy-size/2 <= mouseY && mouseY < posy+size/2){
        return true;
        }
        return false;
  } 
  
  public int getArea(int x,int y){
     if(x<1||6<x||y<1||6<y){
        println("選択されたマス目はありません。_board.getMoji()1");
       return -2000;
      }
    return this.area[x-1][y-1];
  }
  
  public void setArea(int area,int x,int y){
    this.area[x-1][y-1] = area;
  }
  
  public void setAreaFromMouse(Hand hand){
    int[] cell = new int[2];
    cell = getCellOnMouse();
    int area = hand.handNum;
    
    setArea(area,cell[0],cell[1]);
  }
  
  public Moji getMoji(int x,int y){
      if(x<1||6<x||y<1||6<y){
        println("選択されたマス目はありません。_board.getMoji()1");
       return null;
      }
      if(pulledOutMoji[x-1][y-1] != null){
       return pulledOutMoji[x-1][y-1];
     }else{
       //println("選択されたマス目"+x+","+y+"に文字はありません。_board.getMoji()1");
       return null;
     }
    }
  
  private Moji getMojiFromMouse(){
     for(int y=0;y<6;y++)
     for(int x=0;x<6;x++){
        boolean flgx = (posx-size/2f)+(size/6f) * x <= mouseX
                          && mouseX < (posx-size/2f+size/6f)+(size/6f) * x;
        boolean flgy = (posy-size/2f)+(size/6f) * y <= mouseY
                          && mouseY < (posy-size/2f+size/6f)+(size/6f) * y;
        if(flgx && flgy){
          //文字をgetする際にどのマス目から
          return this.pulledOutMoji[x][y];
        }                  
     }
     return null;
   }
   
   public void setMoji(PImage img,int x,int y){
     if(x<1||6<x||y<1||6<y){
        println("選択されたマス目はありません。_board.setMoji()1");
       return;
      }
     if(pulledOutMoji[x-1][y-1] == null){
       pulledOutMoji[x-1][y-1] = new Moji(img);
     }else{
       //println("選択されたマス目"+x+","+y+"は埋まっています。_board.setMoji()1");
     }
   }
   
   public void setMojiFromMouse(PImage img){
     int[] cell = new int[2];
     cell = getCellOnMouse();
     
     this.setMoji(img,cell[0],cell[1]);
   }
   
   private int[] getCellOnMouse(){
     int cellx,celly;
     
     float cellsize = size/6;
     float leftSideX = posx-size/2;
     if(leftSideX <= mouseX && mouseX < leftSideX + cellsize){
       cellx = 1;
     }else if(leftSideX + cellsize <=mouseX && mouseX < leftSideX + cellsize*2){
       cellx = 2;
     }else if(leftSideX + cellsize*2 <=mouseX && mouseX < leftSideX + cellsize*3){
       cellx = 3;
     }else if(leftSideX + cellsize*3 <=mouseX && mouseX < leftSideX + cellsize*4){
       cellx = 4;
     }else if(leftSideX + cellsize*4 <=mouseX && mouseX < leftSideX + cellsize*5){
       cellx = 5;
     }else if(leftSideX + cellsize*5 <=mouseX && mouseX < leftSideX + cellsize*6){
       cellx = 6;
     }else{
       cellx = 0;
     }
     float leftSideY = posy-size/2;
     if(leftSideY <= mouseY && mouseY < leftSideY + cellsize){
       celly = 1;
     }else if(leftSideY + cellsize <=mouseY && mouseY < leftSideY + cellsize*2){
       celly = 2;
     }else if(leftSideY + cellsize*2 <=mouseY && mouseY < leftSideY + cellsize*3){
       celly = 3;
     }else if(leftSideY + cellsize*3 <=mouseY && mouseY < leftSideY + cellsize*4){
       celly = 4;
     }else if(leftSideY + cellsize*4 <=mouseY && mouseY < leftSideY + cellsize*5){
       celly = 5;
     }else if(leftSideY + cellsize*5 <=mouseY && mouseY < leftSideY + cellsize*6){
       celly = 6;
     }else{
       celly = 0;
     }
     
     int[] cell = {cellx,celly};
     return cell;
   }
   
}

   
   
