class Invader {
  float ix, iy;
  int iwidth, iheight;
  color c;
  int state;
  ArrayList<Bullet> ibullets;
  int moveDelay;
  int lastMove;
  float xVel, yVel;
  int shiftPos;
  int direction;
  int maxShiftStart;
  int maxShiftL;
  int maxShiftR;
  PImage sprite;
  boolean FIRST;
  int shotDelay;
  int lastShoot;

  Invader(float _x, float _y, int _lastMove, float _xVel) {
    ix = _x;
    iy = _y;
    moveDelay = 1500; //manually set, was 1500
    lastMove = _lastMove;
    c = 255;
    ibullets =  new ArrayList<Bullet>();
    state = DEAD;
    xVel = _xVel;
    yVel = 16;
    shiftPos = 0;
    direction = 1;
    maxShiftStart = 10;  //this is manually set
    maxShiftL = maxShiftStart;
    maxShiftR = maxShiftStart;
    FIRST = false;
    shotDelay = int(random(2000, 7000));
    lastShoot = millis() + shotDelay;
  }

  void display() {
    fill(c);
    stroke(255);
    //  rect(ix,iy,iwidth,iheight);
    if (state==ALIVE) {
      image(sprite, ix, iy, iwidth, iheight);
    }
  }


  void destroy() {
    c=0;
    state = DEAD;
  }

  boolean detect(Bullet b) {
    if (b.bx >= ix-b.bwidth && b.bx <= ix+iwidth &&
      b.by >= iy-b.bheight && b.by <= iy+iheight) {
      return true;
    }
    return false;
  }


  void moveBullets() {
    for (int i=0; i<ibullets.size(); i++) {
      ibullets.get(i).move();
    }
  }

  void displayBullets() {
    for (int i=0; i<ibullets.size(); i++) {
      ibullets.get(i).display();
    }
  }

  void move() {
    if (millis() >= moveDelay+lastMove) {
      ix+=xVel;
      shiftPos+=direction;
      lastMove = millis();
      if (shiftPos==maxShiftR || shiftPos==-maxShiftL) {
        direction*=-1;
        xVel*=-1;
      }
      if (shiftPos==maxShiftR-1 && direction==-1 || 
        shiftPos==-maxShiftL+1 && direction==1) {
        iy+=yVel;
      }
    }
  }


  void shoot() {
    if (FIRST && state!=DEAD) {
      if (millis() >= shotDelay+lastShoot) {
        ibullets.add(new Bullet(ix+iwidth/2, iy+iheight/2, 3, #FFFFFF));
        lastShoot = millis();
        shotDelay = int(random(2000, 10000));
      }
    }
  }

  void bulletOutBounds() {
    for (int i=0; i<ibullets.size(); i++) {
      if (ibullets.get(i).outBounds()) {  
        ibullets.remove(i);
      }
    }
  }
  
}
