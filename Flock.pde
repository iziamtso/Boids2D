class Flock{
  
 private ArrayList<Boid> boids;
 private color m_flockColor;
 private int m_numOfBoids;
 private PVector m_startLocaton;
 
 Flock(color flockColor){
    m_flockColor = flockColor;
    m_numOfBoids = 0;
    boids = new ArrayList<Boid>(); 
 }
 
 void run(boolean sw, float alpha, VectorField vField)
 {
    for (Boid b : boids) {
      b.run(boids, sw, alpha, vField);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
  
  Boid getBoid(int i) {
    return boids.get(i);
  }
  
  color getFlockColor() {
     return m_flockColor; 
  }
  
  void createFlock(int value, PVector startLocation) {
     m_numOfBoids = value;
     m_startLocaton = startLocation;
     for (int i = 0; i < value; i++) {
        boids.add(new Boid(width/3,height/3, m_flockColor));
     }
  }
  
  
  void drawPath() {
  for(int i = 0; i < boids.size(); i++){
     Boid b = boids.get(i);
     
     stroke(m_flockColor);    
    
     strokeWeight(3);
     point(b.location.x, b.location.y); 
     strokeWeight(1);
   }
}

}
