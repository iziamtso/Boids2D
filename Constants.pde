import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.JDialog;

public class Constants{
   private float _alpha;
   public int _black;
   public int _white;
   public int _colorGenFlock;
   
   public VectorField _vField;
   public VectorField _greenField;
   public VectorField _blueField;
   
   public boolean _drawMode;
   public boolean _showDrawModeGUI;
   
   public boolean _visibleBoids;
   public boolean _drawPath;
   public boolean _showGUI;
   
   public PImage _vectorImage; 
   
   //size
   public int _width;
   public int _height;
   
   public int _frameRate;
   public int _arrowSize;
   private int _maxArrowSize;
   private color _backg_color;
   
   public PGraphics _cursor;
   public PGraphics _main;
   
   public Constants(int black, int white, float alpha) {
     _alpha = alpha;
     _black = black;
     _white = white;
     _colorGenFlock = 0;
     
     _visibleBoids = true;
     _drawPath = false;
     _showGUI = false;
     
     _width = 1024;
     _height = 1024;
     _frameRate = 1000;
     
     _vField = null;
     _greenField  = null;
     _blueField  = null;
     
     _arrowSize = 4;
     _maxArrowSize = 12;
     _drawMode = false;
     _showDrawModeGUI = true;
     _backg_color = color(125);
   }
   
   
   
   public void createBuffers() {
      _cursor = createGraphics(_width, _height);
      _main = createGraphics(_width, _height);
      //for (int y = 1; y < _main.height - 1; y++) {   // Skip top and bottom edges
        //for (int x = 1; x < _main.width - 1; x++) {
          //_main.pixels[y*_main.width + x] = color(125);
        //}
      //}
      //_main.updatePixels();
   }
   
   public void clearCursorBuffer(){
      _cursor.clear(); 
   }
   
   public void clearMainBuffer(){
      _main.clear(); 
   }
   
   public void decreaseAlpha(){
     _alpha = _alpha - 0.1; 
   }
   
   public void increaseAlpha(){
     _alpha = _alpha + 0.1; 
   }
   
   public void swVisibleBoids() {
       _visibleBoids = !_visibleBoids;
   }
   
   public void swVisibleGUI() {
       _showGUI = !_showGUI;
   }

   public void swDrawPath() {
       _drawPath = !_drawPath;
   }
   
   public void swDrawMode() { 
       _drawMode = !_drawMode;   
   }
   
   public void getImage() {
     background(125);
     JFileChooser chooser = new JFileChooser(dataPath(""));
     FileNameExtensionFilter filter = new FileNameExtensionFilter("JPG & GIF & PNG Images", "jpg", "gif", "png");
     chooser.setFileFilter(filter);
     int returnVal = chooser.showOpenDialog(null);
     if (returnVal == JFileChooser.APPROVE_OPTION) {
        println("You chose to open this file: " + chooser.getSelectedFile().getName());
        _vectorImage = loadImage(chooser.getSelectedFile().getName());
        
        //Construct vector out of this image
//        _vField = new VectorField(_vectorImage);
//        _arrowSize = width / _vectorImage.width;
//        if(_arrowSize > _maxArrowSize) { _arrowSize = _maxArrowSize; }
//        _vField.drawVectorField(_arrowSize);
//        loadPixels();

        _vField = new VectorField(_vectorImage, 1);
        _greenField = new VectorField(_vectorImage, 2);
        _blueField = new VectorField(_vectorImage, 3);
        
        _arrowSize = width / _vectorImage.width;
        if(_arrowSize > _maxArrowSize) { _arrowSize = _maxArrowSize; }
        _vField.drawVectorField(_arrowSize);
        loadPixels();

     }
     else {
        println("Something went wrong the image file in function getImage()!!!!");
     }
   }
   
   public void getField() {
     background(125);
     createMessageDialogGUI(20, 220, 300, 184, 6);
     
     PVector v = new PVector(20, 20);
     _vField = new VectorField(20, 20);
     _arrowSize = width / 20;
     if(_arrowSize > _maxArrowSize) { _arrowSize = _maxArrowSize; }
     _vField.drawVectorField(_arrowSize);
     loadPixels();
   }
   
   public void convertDrawingToVF() {
       //Construct vector out of this image
       //Turn of the drawing GUI
        background(125);
        loadPixels();
        _vField = new VectorField(_main, 128, 128);
        
        _arrowSize = width / 128;
        if(_arrowSize > _maxArrowSize) { _arrowSize = _maxArrowSize; }
        _vField.drawVectorField(_arrowSize);
        loadPixels();
        _drawMode = false; 
   }
   
   public void blur() {
      float v = 1.0 / 9.0;
      float scale = 273;
      float[][] kernel = {{ 1/scale, 4/scale,  7/scale,  4/scale,  1/scale }, 
                          { 4/scale, 16/scale, 26/scale, 16/scale, 4/scale }, 
                          { 7/scale, 26/scale, 41/scale, 26/scale, 7/scale },
                          { 4/scale, 16/scale, 26/scale, 16/scale, 4/scale },
                          { 1/scale, 4/scale,  7/scale,  4/scale,  1/scale },  
                         };
                          
      // Create an opaque image of the same size as the original
      //PImage edgeImg = createImage(_main.width, _main.height, RGB);
      //_main.background(150, 0, 0);
       
      PGraphics copy_of_main = _main;
     
    
      // Loop through every pixel in the image
      for (int y = 2; y < _main.height-2; y++) {   // Skip top and bottom edges
        for (int x = 2; x < _main.width-2; x++) {  // Skip left and right edges
          float sumR = 0; // Kernel sum for this pixel
          float sumA = 0;
          for (int ky = -2; ky <= 2; ky++) {
            for (int kx = -2; kx <= 2; kx++) {
              // Calculate the adjacent pixel for this kernel point
              int pos = (y + ky)*_main.width + (x + kx);
              // Image is grayscale, red/green/blue are identical
              float valR = red(_main.pixels[pos]);
              float valA = alpha(_main.pixels[pos]);
              // Multiply adjacent pixels based on the kernel values
              sumR += kernel[ky+2][kx+2] * valR;
              //sumA += kernel[ky+1][kx+1] * valA;
            }
          }
          // For this pixel in the new image, set the gray value
          // based on the sum from the kernel
          //No black, if there is no color just ignore it
          //if(sumR == 0){
           // copy_of_main.pixels[y*_main.width + x] = color(125);
         // }
          //if(sumR > 0) {
            copy_of_main.pixels[y*_main.width + x] = color(sumR);
          //}
        }
      }
      copy_of_main.updatePixels();
      _main = copy_of_main;
      loadPixels();
      
   }
   
   public void setBackground(PGraphics ob, color c) {
     for (int y = 0; y < ob.height; y++) {   
        for (int x = 0; x < ob.width; x++) {
          ob.pixels[y*ob.width + x] = c;
        }
      }
   }
}
