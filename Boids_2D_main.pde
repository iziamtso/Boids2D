import g4p_controls.*;




Flock flockRed;
Flock flockGreen;
Flock flockBlue;

Constants set;
Brush brush;

//PGraphics cursor;
PGraphics main;


void setup() {
  frame.setTitle("Vector Boids");
  set = new Constants(250, 250, 0.4);
  brush = new Brush(100);
  
  size(set._width, set._height);
  frameRate(1000);
  showGUI(set._alpha);
  background(brush._eraseColor);
  
  
  flockRed = new Flock(color(255, 0, 0, 20));
  flockRed.createFlock(250, new PVector(width/3, width/3));
  
  flockGreen = new Flock(color(0, 255, 0, 20));
  flockGreen.createFlock(250, new PVector(width/2, width/2));
  
  flockBlue = new Flock(color(0, 0, 255, 20));
  flockBlue.createFlock(250, new PVector(width, width));
  
  set.createBuffers();
  brush.drawStrokes(set._main, mouseX, mouseY, false);
  set.setBackground(set._main, set._backg_color);
  
  loadPixels();
}

void draw() {

  if(!set._drawPath){
    updatePixels();
  }
  
  if(set._drawMode) {
     if(set._showDrawModeGUI) {
         brush.drawCursor(set._cursor);
         image(set._main, 0, 0);
         image(set._cursor, 0, 0);
         showDrawingGUI(brush._brushSize);
         set.clearCursorBuffer();
      }
     return;
  }

  flockRed.run(set._visibleBoids, set._alpha, set._vField);
  flockGreen.run(set._visibleBoids, set._alpha, set._greenField);
  flockBlue.run(set._visibleBoids, set._alpha, set._blueField);
  
  
  if(set._drawPath) {
    flockRed.drawPath();
    flockGreen.drawPath();
    flockBlue.drawPath();
  } 
  
  if(set._showGUI) { showGUI(set._alpha); }
}



void mousePressed() {
  if(mouseButton == LEFT) {
       brush.drawStrokes(set._main, mouseX, mouseY, true);
  }
  if(mouseButton == RIGHT) {
       brush.drawStrokes(set._main, mouseX, mouseY, false);
  }
   
}

void mouseDragged() {
   if(mouseButton == LEFT) {
        brush.drawStrokes(set._main, mouseX, mouseY, true);
   }
   if(mouseButton == RIGHT) {
        brush.drawStrokes(set._main, mouseX, mouseY, false);
   }  
}
