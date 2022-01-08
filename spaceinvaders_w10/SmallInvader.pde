class SmallInvader extends Invader{
  
  SmallInvader(float _x, float _y, int _lastMove, float _xVel){
    super(_x, _y, _lastMove, _xVel);
    iwidth = SInvaderWidth;
    iheight = 20;
    sprite = loadImage("squid.png");
  }
  
}
