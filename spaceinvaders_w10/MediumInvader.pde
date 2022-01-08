class MediumInvader extends Invader{
  
  MediumInvader(float _x, float _y, int _lastMove, float _xVel){
    super(_x, _y, _lastMove, _xVel);
    iwidth = MInvaderWidth;
    iheight = 20;
    sprite = loadImage("crab.png");
  }
  
}
