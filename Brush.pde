class Brush {
    public int _brushSize;
    private color _color;
    public color _eraseColor;
    
    public Brush(int brushSize) {
       _brushSize = brushSize;
       _color = color(150);
       _eraseColor = color(125);  
    }
    
    public void drawStrokes(PGraphics m, int x, int y, boolean draw) {
       m.beginDraw();
       if(draw) { 
         m.fill(_color);
         m.stroke(_color); 
       }
       else { 
         color c = color(_eraseColor, 255);
         m.fill(c); 
         m.stroke(c);
       }
       m.ellipse(x, y, _brushSize, _brushSize); 
       //drawGradient(x, y, m);
       m.endDraw();
    }
    
    public void drawCursor(PGraphics pg) {
       pg.beginDraw();
       pg.noFill();
       pg.stroke(_color);
       pg.ellipse(mouseX, mouseY, _brushSize, _brushSize);
       pg.stroke(0);
       pg.endDraw();
    }
  
    public void drawGradient(float x, float y, PGraphics m) {
      int radius = _brushSize;
      float h = _eraseColor;
      for (int r = radius; r > 0; --r) {
        m.fill(h);
        //m.noStroke();
        m.ellipse(x, y, r, r);
        h = h - 1;
      }
    }
    
    public void incBrush() {
        _brushSize += 1;
    }
    
    public void decBrush() {
      if(_brushSize > 0){
        _brushSize -= 1;
      }
    }
}
