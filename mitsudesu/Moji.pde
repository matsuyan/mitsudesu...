class Moji{
  Moji(PImage img){
    this.img = img;
    if(img != null){
      this.img.resize(size,size);
    }
  }
  
  private SrcManager src = SrcManager.getInstance();
  private PImage img;
  final static int size = Board.size/7;
  boolean onCursor = true;
  
 void draw(float x,float y){
   if(this.img != null){
     image(img,x,y);
   }
 }
 
 
 PImage getImg(){
   return this.img;
 }
 
 void setImg(PImage img){
   this.img = img;
 }
 
 int toInt(){
   if(this.img != null){
     for(int i=0;i<4;i++){
       if(this.img.equals(src.imgs[i])){
         return i;
       }
     }
   }
   return -999;
 }
 
 boolean equals(int toInt){
   //println("this.toInt()="+this.toInt()+"toint="+toInt+"_Moji.equals()1");
   if(this.toInt() == toInt){
     return true;
   }
   return false;
 }
 
}
