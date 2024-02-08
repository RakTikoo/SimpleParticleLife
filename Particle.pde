public  class Particle {

  PVector pos, vel, acc;
  int type;
  float rad;
  float influence;
  
  
  int RED = 0, GREEN = 1, BLUE = 2, YELLOW = 3;
  
  //enum Type {RED, GREEN, BLUE, YELLOW};
  
  Particle(float pos_x, float pos_y, float vel_x, float vel_y, float acc_x, float acc_y, float rad, int type_in) {
    
    this.pos = new PVector(pos_x, pos_y);
    this.vel = new PVector(vel_x, vel_y);
    this.acc = new PVector(acc_x, acc_y);
    this.rad = rad;
    this.type = type_in;
    
    influence = 4*rad; // Only affected by particles in this range
  }
  
  
  
  
  
  
  
  color colorType() {

    if (this.type == RED) return color(255, 0, 0);   // R
    if (this.type == GREEN) return color(0, 255, 0);   // G
    if (this.type == BLUE) return color(0, 0, 255);   // B
    if (this.type == YELLOW) return color(255, 255, 0); // Y
    
    return color(0,0,0);
  }
  
  
  
  
  
  PVector particle_system(int type1, int type2) {
    PVector val = new PVector(0, 0);
    float x_setting[][] = 
    // R    G    B    YELLOW
    {  {0.05, -0.05, -0.05, -0.05}, // R
       {-0.05, -0.05, -0.05, 0.05}, // G 
       {-0.05, -0.05, -0.05, -0.05}, // B
       {-0.05, 0.05, 0.05, -0.05}  // Y
     };
     
     float y_setting[][] = 
    // R    G    B    YELLOW
    {  {0.05, -0.05, -0.05, -0.05}, // R
       {-0.05, -0.05, -0.05, 0.05}, // G 
       {-0.05, -0.05, -0.05, -0.05}, // B
       {-0.05, 0.05, 0.05, -0.05}  // Y
     };
     
    val.x = x_setting[type1][type2];
    val.y = y_setting[type1][type2];
 
    
    return val; 
  }
  
  
  
  
  
  
  void particle_system_apply(Particle other_p) {
    float dist = pow((this.pos.x - other_p.pos.x), 2);
    dist +=      pow((this.pos.y - other_p.pos.y), 2);
    dist =       sqrt(dist);
    PVector unit_vect = new PVector((other_p.pos.x - this.pos.x)/dist, (other_p.pos.y - this.pos.y)/dist);
    PVector del_acc = particle_system(this.type, other_p.type);
    if(dist < this.influence) // Can be influenced 
    {
      // Too close so pushout
      if(dist < (this.rad + other_p.rad)) { // Pushout
        this.vel.x += -0.1*unit_vect.x;
        this.vel.y += -0.1*unit_vect.y;
      }
      else {
        this.vel.x += (del_acc.x*unit_vect.x);
        this.vel.y += (del_acc.y*unit_vect.y);
      }
      
    
    
    }
    
  }
  
  
  
  void update() {
    this.vel.x += this.acc.x;
    this.vel.y += this.acc.y;
    this.pos.x += this.vel.x;
    this.pos.y += this.vel.y;
    
    noStroke();
    fill(colorType());
    circle(this.pos.x, this.pos.y, this.rad);
  }


}
