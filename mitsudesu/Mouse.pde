import ddf.minim.*;
class Mouse{
  private Moji selectedMoji;
  
  void drawSelectedMoji(){
    if(hasMoji()){
      selectedMoji.draw(mouseX,mouseY);
    }
  }
  
  boolean hasMoji(){
    if(this.selectedMoji == null){
      return false;
    }
    return true;
  }
  
  Moji getMoji(){
    return this.selectedMoji;
  }
  
  void setMoji(Moji moji){
    this.selectedMoji = moji;
  }
}
