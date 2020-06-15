class Hand{
  
  Hand(float posx,float posy,int handNum){
    this.posx = posx;
    this.posy = posy;
    this.handNum = handNum;
    this.img = src.imgs[5];
    this.img.resize(size,size*4);
    for(int i=0;i<4;i++){
      mojis[i] = new Moji(src.imgs[i]);
    }
  }
  
  private float posx,posy;
  public  int   handNum;
  SrcManager src = SrcManager.getInstance();
  PImage img;
  final static int size = 70;
  Moji[] mojis = new Moji[4];
  
  
  void drawHand(){
    image(img,posx,posy);
    for(int i=0;i<4;i++){
      mojis[i].draw(posx,posy+(Moji.size+10)*(i-1.5));
    }
  }
  
  public void drawCursor(int h,int s,int v){
      for(int y=0;y<4;y++){
        boolean flgx = (posx-size/2) <= mouseX
                          && mouseX < (posx-size/2+size);
        boolean flgy = (posy-size*2) + size*y <= mouseY
                          && mouseY < (posy-size*2+size) + size*y;
        if(flgx && flgy){
           stroke(h,s,v);
           if(mousePressed){
            stroke(h,s,70);
           }
           strokeWeight(5);
           noFill();
           rect(posx,posy+(size)*(y-1.5),size-3,size-3);
        }
      }
    }
    
   Moji getMoji(){
     for(int y=0;y<4;y++){
        boolean flgx = (posx-size/2) <= mouseX
                          && mouseX < (posx-size/2+size);
        boolean flgy = (posy-size*2) + size*y <= mouseY
                          && mouseY < (posy-size*2+size) + size*y;
        if(flgx && flgy){
          return this.mojis[y];
        }                  
     }
     return null;
   }
  
  void setMoji(int num,Moji moji){
    this.mojis[num] = moji;
  }
}
