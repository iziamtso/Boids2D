class VectorField{
 
  PVector[][] field; 
  PVector gridSize;
  float pStep;
  float pStepSize;
  
  int multX;
  int multY;
  
  int vfWidth;
  int vfHeight;
  int m_type = -1;
  
  VectorField(int x, int y){
    gridSize = new PVector(x,y);
    field = new PVector[x][y];
    pStep = 0.f;
    pStepSize = .01;
    
    createField();
  }
  
  VectorField(PImage img, int type){
    m_type = type;
    gridSize = new PVector(img.width - 1, img.height - 1);
    field = new PVector[img.width] [img.height];
    vfWidth = img.width - 1;
    vfHeight = img.height - 1;
    multX = 1;
    multY = 1;
    createImageField(img);
  }
  
   VectorField(PImage img, int gridWidth, int gridHeight){
    gridSize = new PVector(img.width - 1, img.height - 1);
    //gridSize = new PVector(gridWidth, gridHeight);
    field = new PVector[gridWidth] [gridHeight];
    multX = img.width / gridWidth;
    multY = img.height / gridHeight;
    
    vfWidth = gridWidth;
    vfHeight = gridHeight;
    println(multX, multY);
    createImageField(img);
  }
  
  void createImageField(PImage img) {
      for(int x=0; x < gridSize.x; x += multX){ //1023
        for(int y=0; y < gridSize.y; y += multY){ //1023
              //speed this up with pixel[]
              color currColor = img.get(x, y);
              color currHColor = img.get(x+multX, y);
              color currVColor = img.get(x, y+multY);
              
              //assert red(currColor) == green(currColor) : "Red value is not equal to green value"; //assrt needs false to terminate the program
              //assert  red(currColor) == blue(currColor) : "Red value is not equal to blue value";
           
              float currValue = 0;
              float currHValue = 0;
              float currVValue = 0;
           
              if(m_type == 1) {
                currValue = red(currColor);
                currHValue = red(currHColor);
                currVValue = red(currVColor);
              }
              else if(m_type == 2) {
                currValue = green(currColor);
                currHValue = green(currHColor);
                currVValue = green(currVColor);
              }
              else if(m_type == 3) {
                currValue = blue(currColor);
                currHValue = blue(currHColor);
                currVValue = blue(currVColor);
              }
              
              int X = x / multX;
              int Y = y / multY;
        
              field[X][Y] = new PVector(currHValue - currValue, currVValue - currValue);
              //System.out.println(  currVValueRed - currValueRed);
              field[X][Y].div(255); 
              //System.out.println("Value is: " + field[X][Y]);
              
        }
      }
  }
  
  void createField(){
     for(int i=0; i < gridSize.x; i++){
      for(int j=0; j < gridSize.y; j++){
        float theta = 2*PI*noise(i*.1, j*.1);
//        println("angle in radians: "+theta);
        float amp = 20.f;
        field[i][j] = new PVector(amp*cos(theta),amp*sin(theta));
      }
    }   
  }
  
  void updateField(){
    
    pStep+=pStepSize;
    
    for(int i=0; i<gridSize.x; i++){
      for(int j=0; j<gridSize.y; j++){
        float theta = 2*PI*noise(i*.1 + pStep, j*.1 + pStep);
        float amp = 30.f;
        field[i][j] = new PVector(amp*cos(theta),amp*sin(theta));
      }
    }
  }
  
  void setStepSize(float s){
    pStepSize = s;
  }
  
  PVector velocityAtLocation(float x, float y){
//    PVector velocity = new PVector();
//    int locX = int(x*gridSize.x/width);
//    int locY = int(y*gridSize.y/height);
//    PVector vx1 = field[locX][locY];

    //Bilinear interpolation
    
    int X = int(x*gridSize.x/width); //X scaled to vector field coordinates 1024 * 1/4 = 128
    int Y = int(y*gridSize.y/height); //Y scaled to vector field coordinates
    
    int locX = int(X/multX);
    int locY = int(Y/multY);
    //System.out.println(locX);
    
    int locXInc = locX + 1;
    int locYInc = locY + 1;
    
    PVector Q11 =  new PVector(); 
    Q11.x = field[locX][locY].x;
    Q11.y = field[locX][locY].y;
    
    int x1 = int(((locX)*width) / gridSize.x);
    int y1 = int(((locY)*height) / gridSize.y);
    
    if(locXInc > vfWidth - 1){
        locXInc = 0;
    }
    if(locYInc > vfHeight - 1){
       locYInc = 0; 
    }
    
    PVector Q21 = new PVector();
    Q21.x = field[locXInc][locY].x;
    Q21.y = field[locXInc][locY].y;
    
    int x2 = int((locXInc * width) / gridSize.x);
    
    PVector Q12 = new PVector();
    Q12.x = field[locX][locYInc].x;
    Q12.y = field[locX][locYInc].y;
    
    int y2 = int((locYInc * height) / gridSize.y);
    
    PVector Q22 = new PVector();
    Q22.x = field[locXInc][locYInc].x;
    Q22.y = field[locXInc][locYInc].y;
    
    // R1 = ((x2 – x)/(x2 – x1))*Q11 + ((x – x1)/(x2 – x1))*Q21
    PVector R1 = new PVector();
    Q11.mult((x2 - x) / (x2 - x1));
    Q21.mult((x - x1) / (x2 - x1));
    R1.add(Q11);
    R1.add(Q21);
    //System.out.println("R1: " + R1);
    
    //R2 = ((x2 – x)/(x2 – x1))*Q12 + ((x – x1)/(x2 – x1))*Q22
    PVector R2 = new PVector();
    Q12.mult((x2 - x) / (x2 - x1));
    Q22.mult((x - x1) / (x2 - x1));
    R2.add(Q12);
    R2.add(Q22);
    //System.out.println("R2: " + R2);
    
    //P = ((y2 – y)/(y2 – y1))*R1 + ((y – y1)/(y2 – y1))*R2
    PVector tmp_copy = new PVector(0,0);
    R1.mult((y2 - y) / (y2 - y1));
    R2.mult((y - y1) / (y2 - y1));
    tmp_copy.add(R1);
    tmp_copy.add(R2);
    
    PVector velocity = new PVector();
    velocity.x = tmp_copy.x;
    velocity.y = tmp_copy.y;
    
    velocity.normalize();
    System.out.println(velocity);
    
    return velocity;
  }
  
  void drawVectorField(int arrowSize){
    for(int i=0; i<vfWidth;  i++){ 
      for(int j=0; j<vfHeight;  j++){ 
        pushMatrix();
          translate((i+0.5)*width/vfWidth, (j+0.5)*height/vfHeight);
          stroke(255);
          fill(255, 200, 0, 50);
          strokeWeight(.1);
          //ine(0, 0, field[i][j].x, field[i][j].y);
          arrowLine(0, 0, field[i][j].x, field[i][j].y, 0, radians(10), true, arrowSize);
          strokeWeight(1);
        popMatrix();
      }
    }
  }
  
  void arrowLine(float x0, float y0, float x1, float y1, float startAngle, float endAngle, boolean solid,  int arrowSize)
  {
    //line(x0, y0, x1, y1);
    if (startAngle != 0)
    {
      arrowhead(x0, y0, atan2(y1 - y0, x1 - x0), startAngle, solid, arrowSize);
    }
    if (endAngle != 0)
    {
      arrowhead(x1, y1, atan2(y0 - y1, x0 - x1), endAngle, solid, arrowSize);
    }
  }
 
  /*
   * Draws an arrow head at given location
   * x0 - arrow vertex x-coordinate
   * y0 - arrow vertex y-coordinate
   * lineAngle - angle of line leading to vertex (radians)
   * arrowAngle - angle between arrow and line (radians)
   * solid - true for a solid arrow, false for an "open" arrow
   */
  void arrowhead(float x0, float y0, float lineAngle, float arrowAngle, boolean solid, int arrowSize)
  {
    float phi;
    float x2;
    float y2;
    float x3;
    float y3;
    float SIZE = arrowSize;
     
    x2 = x0 + SIZE * cos(lineAngle + arrowAngle);
    y2 = y0 + SIZE * sin(lineAngle + arrowAngle);
    x3 = x0 + SIZE * cos(lineAngle - arrowAngle);
    y3 = y0 + SIZE * sin(lineAngle - arrowAngle);
    if (solid)
    {
      triangle(x0, y0, x2, y2, x3, y3);
    }
    else
    {
      line(x0, y0, x2, y2);
      line(x0, y0, x3, y3);
    } 
  }
}

