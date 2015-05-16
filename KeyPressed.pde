
void keyPressed(){
   switch(key){
     case 'k':
     set.swVisibleBoids();
        draw();
       set.getField();
       set.swVisibleBoids();
       break;
     case 'l':
        set.swVisibleBoids();
        draw();
        set.getImage();
        set.swVisibleBoids();
        break;
     case 'v': 
        set.swVisibleBoids();
        break;
     case '5':
       set._showGUI = false; 
       set.swVisibleBoids();
       set.swDrawPath();
       background(255);
       break;
     case 'd': 
       set.swDrawMode();
       break;
     case 'b':
       set.blur();
       break;  
     case ',':
       brush.decBrush();
       break;
     case '.':
       brush.incBrush();
       break;
     case 'c':
        brush._color = G4P.selectColor();
        break;
     case 'x':
        set._showDrawModeGUI = false;
        draw();
        set.convertDrawingToVF();
        set._showDrawModeGUI = true;
        break;
     case 's':
       save("File " + day()+hour() + minute()+second()+ ".jpg");
     case 'g':
       if(set._drawPath){
          set.swDrawPath();
          break; 
       }
       set.swVisibleGUI();
       break;
     case '-':
       set.decreaseAlpha();
       break;
     case '+':
       set.increaseAlpha();
       break;
     case 'e':
       set._main.clear();
       break;  
     default: 
        break; 
    }
}
