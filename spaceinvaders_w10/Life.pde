class Life{
  int lx, ly, lwidth, lheight;
  color c;
  
  Life(int _x, int _y) {
    lwidth = 35;
    lheight = 15;
    lx = _x;
    ly = _y;
    c = #00FF00;
  }
  
  void display(){
    stroke(0);
    fill(c);
    rect(lx, ly, lwidth, lheight);
  }
  
  
}
