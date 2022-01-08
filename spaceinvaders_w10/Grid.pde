class Grid {
  int rows, cols, destroyCount, invaderCount;
  Invader[][] invaderGrid;
  int gwidth, gheight;
  float gXVel;
  int minLastMove;
  int leftFullCol;
  int rightFullCol;
  float centerColDist;
  int centerColShiftDist; //to be manually set 
  //is the number of shifts needed to shift one invader
  int destroyUpSpeed; //see speedUp() method
  int resetDelay;
  int lastReset;
  int resetCol, resetRow;

  Grid () {
    rows= 5;
    cols= 11;
    destroyCount=0;
    invaderCount=rows*cols;
    invaderGrid= new Invader[rows][cols];
    gwidth = width - edgeGuardH*2;
    gheight = 200;
    minLastMove = 1000; //helps determine starting lastMove of each row
    leftFullCol = 0;
    rightFullCol = cols-1;
    centerColDist = gwidth/(2*cols);
    centerColShiftDist = 5; //this is manually set
    gXVel = centerColDist / centerColShiftDist;
    destroyUpSpeed = 30; //this is manually set
    resetDelay = 10;
    lastReset = -resetDelay;
    resetCol = cols-1;
    resetRow = rows-1;


    //populate invaderGrid
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        int centerColX = (c*2+1)*gwidth/(2*cols) + edgeGuardH;
        if (r==0) {
          invaderGrid[r][c] = new SmallInvader(
            centerColX - SInvaderWidth/2, 
            edgeGuardV+(gheight*r/rows), 
            millis() + minLastMove*(5-r)/5, 
            gXVel);
        }
        if (r==1 || r==2) {
          invaderGrid[r][c] = new MediumInvader(
            centerColX - MInvaderWidth/2, 
            edgeGuardV+(gheight*r/rows), 
            millis() + minLastMove*(5-r)/5, 
            gXVel);
        }
        if (r==3 || r==4) {
          invaderGrid[r][c] = new LargeInvader(
            centerColX - LInvaderWidth/2, 
            edgeGuardV+(gheight*r/rows), 
            millis() + minLastMove*(5-r)/5, 
            gXVel);
        }
      }
    }

    //sets closet row to FIRST
    for (int c=0; c<cols; c++) {
      invaderGrid[4][c].FIRST = true;
    }
  }

  void display() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        invaderGrid[r][c].display();
      }
    }
  }


  void move() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        invaderGrid[r][c].move();
      }
    }
  }


  void upDestroyCount() {
    destroyCount++;
  }

  boolean empColCheck(int colIndex) {
    for (int r=0; r<rows; r++) {
      if (invaderGrid[r][colIndex].state == ALIVE) { //WARNING: colIndex will go out of bounds when last thing is destroyed, leftFullCol will become negative
        return false;
      }
    }
    return true;
  }

  boolean leftColUpdate() {
    if (empColCheck(leftFullCol)) {
      leftFullCol++;
      this.leftColUpdate();
    }
    return false;
  }

  boolean rightColUpdate() {
    if (empColCheck(rightFullCol)) {
      rightFullCol--;
      this.rightColUpdate();
    }
    return false;
  }

  void maxShiftUpdate() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        invaderGrid[r][c].maxShiftL = invaderGrid[r][c].maxShiftStart + 
          (leftFullCol*centerColShiftDist*2);
        //println(invaderGrid[r][c].maxShiftL);
        invaderGrid[r][c].maxShiftR = invaderGrid[r][c].maxShiftStart +
          ((cols-1 - rightFullCol)*centerColShiftDist*2);
        //println(invaderGrid[r][c].maxShiftR);
      }
    }
  }

  void speedUp() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        invaderGrid[r][c].moveDelay-=destroyUpSpeed;
      }
    }
  }


  void moveBullets() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        for (int i=0; i<invaderGrid[r][c].ibullets.size(); i++) {
          invaderGrid[r][c].ibullets.get(i).move();
        }
      }
    }
  }

  void displayBullets() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        for (int i=0; i<invaderGrid[r][c].ibullets.size(); i++) {
          invaderGrid[r][c].ibullets.get(i).display();
        }
      }
    }
  }

  void shoot() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        invaderGrid[r][c].shoot();
      }
    }
  }

  void bulletOutBounds() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        invaderGrid[r][c].bulletOutBounds();
      }
    }
  }

  void reset() {
    if (millis() >= resetDelay+lastReset) {
      invaderGrid[resetRow][resetCol].state = ALIVE;
      resetCol--;
      if (resetCol<0) {
        resetRow--;
        resetCol = cols-1;
      }
      if (resetRow<0) {
        gameState = RUNNING;
        for (int r=0; r<rows; r++) {
          for (int c=0; c<cols; c++) {
            invaderGrid[r][c].lastMove = millis() + minLastMove*(5-r)/5;
            invaderGrid[r][c].lastShoot = millis() + invaderGrid[r][c].shotDelay;
          }
        }
      }
      lastReset = millis();
    }
  }

  void timerReset() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        invaderGrid[r][c].lastMove += timeSinceDeath; //(since player death)
        invaderGrid[r][c].lastShoot += timeSinceDeath;
      }
    }
  }
  
  
  void removeAllBullets() {
    for (int r=0; r<rows; r++) {
      for (int c=0; c<cols; c++) {
        for (int i=0; i<invaderGrid[r][c].ibullets.size(); i++) {
          invaderGrid[r][c].ibullets.remove(0).display();
        }
      }
    }
  }
}
