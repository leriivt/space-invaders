class Bullet{
  float bx, by;
  int bwidth, bheight;
  int vel;
  color c;
  
  Bullet(float spawnX, float spawnY, int _vel, color _c){
    bwidth = 3;
    bheight = 15;
    bx=spawnX-bwidth/2;
    by=spawnY-bheight/2; 
    vel = _vel;    
    c = _c;
  }
  
  void display(){
    stroke(0);
    fill(c);
    rect(bx, by, bwidth, bheight);
  }
  
  void move(){
    by+=vel;
  }
  
  boolean outBounds(){
    if (by<=50 || by>=height-50){
      return true;
    }
    return false;
  }
}
