class LargeInvader extends Invader{
  
  LargeInvader(float _x, float _y, int _lastMove, float _xVel){
    super(_x, _y, _lastMove, _xVel);
    iwidth = LInvaderWidth;
    iheight = 20;
    sprite = loadImage("eclipse.png");
  }
  
}
