//todo: make it so after defeat a wave, reset with invaders closer to player (done)
//todo: countdown for when player is destroyed (done)
//    - made a death animation and stop until key input, no acutal countdown
//todo: consequence for reaching 0 lives -game over screen-
//todo: point system
//todo: increase fire rate as time goes on?
//todo: gain life when certain point threshold reached? -optional-

int LEFTMOVE = 0;
int RIGHTMOVE = 1;
int SHOOT = 2;
int DEAD = 10;
int ALIVE = 11;

int SInvaderWidth = 20;
int MInvaderWidth = 26;
int LInvaderWidth = 30;

int TERMINATED = 99;
int BLINK = 100;
int RESET = 101;
int RUNNING = 102;
int STOPPED = 103;
int DYING = 104;

Player p1;
Grid grid;
Lives lives;
int gameState;
int level;
boolean[] keys;
int numKeys = 3;
int edgeGuardH = 230;
int edgeGuardV = 160;
int timeOfDeath = 0;
int timeSinceDeath = 0;

void setup() {
  size(900, 800);
  background(0);
  gameState = RESET;
  level=1;
  keys = new boolean[numKeys];
  p1 = new Player();
  grid = new Grid();
  lives = new Lives(250, 750, 10);
}

void draw() {
  background(0);
  println(millis());
  
  
  /*
  //visualize grid area
   stroke(255);
   line(150,0,150,height);
   line(750,0,750,height);
   */

  p1.displayBullets();      //player bullets first
  p1.display();             //to hide player bullets
  grid.displayBullets();    //to go over dead player
  grid.display();           //grid to go over grid bullets
  lives.display();
  displayLivesText();
  
  invaderDetectDestroy(p1.pbullets, grid);
  playerDetectDestroy(p1, grid);
  p1.bulletOutBounds();
  grid.bulletOutBounds();
  checkWon();
  
  if (gameState==RESET){ //follows a BLINK
    grid.reset();
  }
  
  if (gameState==BLINK){ //follow a level clear
    background(0);
    edgeGuardV+=16*2;  //lowers new invaders closer to player
    p1 = new Player();
    grid = new Grid();
    gameState = RESET;
  }
  
  if (gameState==DYING){ //follows a player destruction
    p1.py++;             //may need to make it so when 0 lives, gameState goes to 
    p1.pheight--;                  //terminate instead
    if(p1.pheight<=0){
      gameState = STOPPED;
    }
  }
  
  if (gameState==STOPPED){        //follows compete DEATH of player
    if (keys[SHOOT] || keys[LEFTMOVE] || keys[RIGHTMOVE]){
      grid.removeAllBullets();
      p1 = new Player();
      timeSinceDeath = millis() - timeOfDeath;
      grid.timerReset();
      gameState = RUNNING;
    }
  }
  
  if (gameState==RUNNING) { //follows a full reset of invaders in grid
    grid.move();
    grid.moveBullets();
    grid.shoot();
    
    p1.moveBullets();
    p1.move();
    p1.shoot();

    grid.leftColUpdate();
    grid.rightColUpdate();
    grid.maxShiftUpdate();
  }
}

void invaderDetectDestroy(ArrayList<Bullet> alB, Grid g) {
  for (int r=0; r<g.rows; r++) {
    for (int c=0; c<g.cols; c++) {
      for (int i=0; i<alB.size(); i++) {
        if (g.invaderGrid[r][c].detect(alB.get(i)) && 
          g.invaderGrid[r][c].state == ALIVE) {  
          g.invaderGrid[r][c].destroy();
          if(r-1 >= 0){        //makes next invader FIRST, corrects their lastShoot
            g.invaderGrid[r-1][c].FIRST = true;
            g.invaderGrid[r-1][c].lastShoot = millis() +
                                              g.invaderGrid[r-1][c].shotDelay;
          }
          g.upDestroyCount();
          g.speedUp();
          alB.remove(i);
          println(g.invaderGrid[r][c].moveDelay);
        }
      }
    }
  }
}

void playerDetectDestroy(Player p, Grid g){
  for (int r=0; r<g.rows; r++) {
    for (int c=0; c<g.cols; c++) {
      for (int i=0; i<g.invaderGrid[r][c].ibullets.size(); i++) {
        if (p.detect(g.invaderGrid[r][c].ibullets.get(i)) && 
            p.state == ALIVE) {
              g.invaderGrid[r][c].ibullets.remove(i);
              p.destroy();
              lives.loseLife();
              gameState = DYING;
              timeOfDeath = millis();
            }          
      }
    } 
  }
}

void checkWon(){
  if (grid.destroyCount==grid.invaderCount){
    gameState = BLINK;
    level++;
  }
}

void displayLivesText() {
  textSize(17);
  fill(255);
  textAlign(LEFT, TOP);
  text(lives.numLeft, 225, 745);
}



void keyPressed() {
  if (key=='a') {
    keys[LEFTMOVE]=true;
  }
  if (key=='d') {
    keys[RIGHTMOVE]=true;
  }
  if (key=='w') {
    keys[SHOOT]=true;
  }
}

void keyReleased() {
  if (key=='a') {
    keys[LEFTMOVE]=false;
  }
  if (key=='d') {
    keys[RIGHTMOVE]=false;
  }
  if (key=='w') {
    keys[SHOOT]=false;
  }
}
