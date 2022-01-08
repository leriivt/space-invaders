class Lives{
  int numLeft;
  Life[] lifes;
  int x, y;
  int gap; //space inbetween the diplayed lives
  
  Lives(int _x, int _y, int _g){
    numLeft = 3;
    lifes = new Life[numLeft-1];
    x = _x;
    y = _y;
    gap = _g;
    for(int i =0;i<numLeft-1;i++){
      lifes[i] = new Life(x + gap*i + i*35, y);
    }
  }
  
  void display(){
    for(int i =0;i<numLeft-1;i++){
      lifes[i].display();
    }
  }
  
  void loseLife(){
    numLeft--;
    for(int i =0;i<numLeft-1;i++){
      lifes[i] = new Life(x + gap*i + i*35, y);
    }
  }
  
  void gainLife(){
    numLeft++;
    for(int i =0;i<numLeft-1;i++){
      lifes[i] = new Life(x + gap*i + i*35, y);
    }
  }
}
