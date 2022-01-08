class Player {
  int px, py, pwidth, pheight;
  color c;
  int vel;
  ArrayList<Bullet> pbullets;
  int shotDelay;
  int lastShoot;
  int pEdgeGuard;
  int state;

  Player() {
    pwidth = 35;
    pheight = 15;
    px = width/2 - pwidth/2;
    py = height*7 / 9;
    c = #00FF00;
    vel = 3;
    pbullets =  new ArrayList<Bullet>();
    shotDelay = 1000;  //1 second
    lastShoot = -shotDelay;     //never fired a shot
    pEdgeGuard = 150;
    state = ALIVE;
  }

  void display() {
    
    //visualize play area
    stroke(255);
    line(pEdgeGuard,0,pEdgeGuard,height);
    line(width-pEdgeGuard,0,width-pEdgeGuard,height);
    stroke(0);
    
    
    fill(c);
    rect(px, py, pwidth, pheight);
  }

  void move() {
    if (keys[LEFTMOVE]) {
      px-=vel;
    }
    if (keys[RIGHTMOVE]) {
      px+=vel;
    }
    if (px<=pEdgeGuard){
      px=pEdgeGuard;
    }
    if (px>=width-pEdgeGuard-pwidth){
      px=width-pEdgeGuard-pwidth;
    }
  }


  void shoot() {
    if (keys[SHOOT] && state==ALIVE) {
      if (millis() >= shotDelay+lastShoot) {
        pbullets.add(new Bullet(px+pwidth/2, py+pheight/2, -10, #00FF00));
        lastShoot = millis();
      }
    }
  }


  void moveBullets() {
    for (int i=0; i<pbullets.size(); i++) {
      pbullets.get(i).move();
    }
  }

  void displayBullets() {
    for (int i=0; i<pbullets.size(); i++) {
      pbullets.get(i).display();
    }
  }
  
  void bulletOutBounds() {
    for (int i=0; i<pbullets.size(); i++) {
      if (pbullets.get(i).outBounds()) {  
        pbullets.remove(i);
      }
    }
  }
  
  
  boolean detect(Bullet b) {
    if (b.bx >= px-b.bwidth && b.bx <= px+pwidth &&
      b.by >= py-b.bheight && b.by <= py+pheight) {
      return true;
    }
    return false;
  }
  
  void destroy(){
    //c=0;
    state=DEAD;
  }
  
  
}
