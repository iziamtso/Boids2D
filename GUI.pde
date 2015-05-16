import java.util.ArrayList;
import java.awt.Rectangle;


 // Graphic frames used to group controls
 ArrayList<Rectangle> rects = new ArrayList<Rectangle>();
 GButton btnMdialog;
 GTextField fieldX;
 GTextField fieldY;
 GLabel dtitle;
 GLabel dmess;
 GLabel title;

   

 public void createMessageDialogGUI(int x, int y, int w, int h, int border) {
    // Store picture frame
    rects.add(new Rectangle(x, y, w, h));
    // Set inner frame position
    x += border; 
    y += border;
    w -= 2*border; 
    h -= 2*border;
    title = new GLabel(this, x, y, w, 20);
    title.setText("Dimensions for vector field", GAlign.LEFT, GAlign.MIDDLE);
    title.setOpaque(true);
    title.setTextBold();
    btnMdialog = new GButton(this, x, y+26, 80, 40, "Apply");
    //btnMdialog.fireAllEvents(true);
   
   
    dtitle = new GLabel(this, x+w-190, y+20, 190, 20);
    dtitle.setText("Dialog title", GAlign.LEFT, GAlign.MIDDLE);
    fieldX = new GTextField(this, x+w-190, y+40, 190, 20);
    fieldX.setPromptText("Enter X dimention");
    
    dmess = new GLabel(this, x+w-190, y+60, 190, 20);
    dmess.setText("Dialog message", GAlign.LEFT, GAlign.MIDDLE);
    fieldY = new GTextField(this, x+w-190, y+78, 190, 20);
    fieldY.setPromptText("Enter Y dimention");
 }
 


 public PVector handleButtonEvents(GButton button, GEvent event) {
   PVector vect  = null;
    if(button == btnMdialog){
        String x = fieldX.getText();
        String y = fieldY.getText();
        

        fieldX.markForDisposal();
        fieldY.markForDisposal();
        btnMdialog.markForDisposal();
        title.markForDisposal();
        dmess.markForDisposal();
        dtitle.markForDisposal();
        
        int _x = Integer.parseInt(x.trim());
        int _y = Integer.parseInt(y.trim());
        vect = new PVector(_x, _y);
     }
     return vect; 
  }
  
public void showGUI(float alpha) {
   int lineSize = 18;
   
   fill(0, 100);
   stroke(0, 100);
   rect(0, height/10*9, width, height); 
   textSize(lineSize - 3);
   fill(255, 200);
   text("Draw tracing path...................5", 5, (height/10*9) + lineSize);
   text("Save current frame..................S", 5, (height/10*9) + lineSize * 2);
   text("Increase/Decrease Alpha.....[+/-]", 5, (height/10*9) + lineSize * 3);
   text("Apply image vector field..........L", 5, (height/10*9) + lineSize * 4);
   text("Apply procedural vector field...K", 5, (height/10*9) + lineSize * 5);
   fill(255, 200, 0, 200);
   text("  " + alpha + " " , 255, (height/10*9) + lineSize * 3);
   
   stroke(255, 200);
   strokeWeight(4);
   line(330, (height/10*9) + lineSize, 330, (height/10*9) + lineSize * 5);
   strokeWeight(1);
   //Column 2
   fill(255, 200);
   text("Draw vector field.............D", 345, (height/10*9) + lineSize);
}

//-------------------------------------------------------------------------
//GUI for drawing mode
//-------------------------------------------------------------------------

public void showDrawingGUI(int brushSize) {
   int lineSize = 18;
   
   fill(0, 100);
   stroke(0, 100);
   rect(0, height/20*19, width, height); 
   textSize(lineSize - 3);
   fill(255, 200);
   
   //Column 1
   text("Increase/Decrease brush size.....[</>]", 5, height/20*19 + lineSize);
   text("To go back without applying..........D", 5, height/20*19 + lineSize * 2);
   fill(255, 200, 0, 200);
   text("  " + brush._brushSize + " " , 285, (height/20*19) + lineSize);
   //Separator
   stroke(255, 200);
   strokeWeight(4);
   line(340, (height/20*19) + lineSize, 340, (height/20*19) + lineSize * 2);
   strokeWeight(1);
   fill(255, 200); 
   //Column 2
   text("To choose color.................................C", 360, height/20*19 + lineSize);
   text("To convert drawing to a vector filed...X", 360, height/20*19 + lineSize * 2);
   
   stroke(255, 200, 0, 200);
   fill(brush._color);
   rect(655, height/20*19 + lineSize - 15, 20, 20);
   //text("To go back without applying..........D", 5, height/20*19 + lineSize * 2);
   
   //Separator
   stroke(255, 200);
   strokeWeight(4);
   line(695, (height/20*19) + lineSize, 695, (height/20*19) + lineSize * 2);
   strokeWeight(1);
   fill(255, 200); 
   //Column 3
   text("Clear canvas...........................E", 710, height/20*19 + lineSize);
   text("Blur(gaussian)......................... B", 710, height/20*19 + lineSize*2);
}
