PVector bound_min, bound_max;

//enum Types {RED, GREEN, BLUE, YELLOW}
int max_particles = 2500;

Particle[] particles;

float grid_size;
int grid[][][];
int grid_ptr[][];
int grid_cnt_x, grid_cnt_y;

void setup() {
  size(500, 500);
   
  bound_min = new PVector(0, 0);
  bound_max = new PVector(width, height);
  
  
  particles = new Particle[max_particles];
  grid_size = 0;
  for(int i = 0 ; i < particles.length ; i++) {
    particles[i] = new Particle(random(bound_min.x, bound_max.x), random(bound_min.y, bound_max.y), random(0, 0), random(0, 0), 0.0, 0.0, random(1, 5), floor(random(0, 3.99)));
    //particles[i] = new Particle(0, 0, 0, 1, 0.0, 0.0, random(5, 5), floor(random(0, 3.99)));
    if (particles[i].influence*2 > grid_size) grid_size = particles[i].influence*2;
  }
  grid_cnt_x = ceil(width/grid_size);
  grid_cnt_y = ceil(height/grid_size);
  grid = new int[grid_cnt_x][grid_cnt_y][max_particles]; // Each grid at max can have all particles
  grid_ptr = new int[grid_cnt_x][grid_cnt_y]; // Last Valid Element ptr for grid
  
  for(int i = 0; i < grid_cnt_x; i++) 
    for(int j = 0; j < grid_cnt_y; j++)
      grid_ptr[i][j] = 0;
  
  //grid_size = ceil(grid_size*3);  
  println(grid_size);
}





void draw() {
  background(0);
  stroke(255, 125);
  // Draw Bounds
  /*
  
  //Left
  line(bound_min.x, bound_min.y, bound_min.x, bound_max.y);
  //Right
  line(bound_max.x, bound_min.y, bound_max.x, bound_max.y);
  //Top
  line(bound_min.x, bound_max.y, bound_max.x, bound_max.y);
  //Bottom
  line(bound_min.x, bound_min.y, bound_max.x, bound_min.y);
  */
  
  
  // Draw Grid
  /*
  float grid_x = 0;
  while(grid_x < width) {
    line(grid_x, 0, grid_x, height);
    grid_x += grid_size;
  }
  
  float grid_y = 0;
  while(grid_y < width) {
    line(0, grid_y, width, grid_y);
    grid_y += grid_size;
  }
  */
  
  
  // Paritcle Update
  for(int i = 0 ; i < particles.length ; i++) {
    particles[i].update();
    
    // Bounds check
    if(particles[i].pos.x < bound_min.x) {
      particles[i].pos.x = bound_min.x;
      particles[i].vel.x *= -1.0;
    }
    if(particles[i].pos.x > bound_max.x) {
      particles[i].pos.x = bound_max.x;
      particles[i].vel.x *= -1.0;
    }
    if(particles[i].pos.y < bound_min.y) {
      particles[i].pos.y = bound_min.y;
      particles[i].vel.y *= -1.0;
    }
    if(particles[i].pos.y > bound_max.y) {
      particles[i].pos.y = bound_max.y;
      particles[i].vel.y *= -1.0;
    }
    
    // Dampning factor
    particles[i].vel.x *= 0.9;
    particles[i].vel.y *= 0.9;
    
    
    // Update grid
    int idx = floor(particles[i].pos.x/grid_size);
    int idy = floor(particles[i].pos.y/grid_size);
    
    grid[idx][idy][grid_ptr[idx][idy]] = i; // This particle is in this grid
    grid_ptr[idx][idy] += 1; 
    
    if (grid_ptr[idx][idy] < max_particles) 
      grid[idx][idy][grid_ptr[idx][idy]] = -1; // Set grid particle end
    
  }
  
  
  // Particle System Check using optimized grid method
  for(int i = 0; i < particles.length; i++) {
    int curr_idx = floor(particles[i].pos.x/grid_size);
    int curr_idy = floor(particles[i].pos.y/grid_size);
    
    // Check Current Grid
    int idx = curr_idx;
    int idy = curr_idy;
    for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
      if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
    }
   
    
    // Check left grid
    if(curr_idx - 1 > 0) {
      idx = curr_idx - 1; 
      idy = curr_idy;
      for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
        if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
      }
    }
    
    // Check right grid
    if(curr_idx + 1 < grid_cnt_x) {
      idx = curr_idx + 1; 
      idy = curr_idy;
      for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
        if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
      }
    }
    
    // Check bottom grid
    if(curr_idy - 1 > 0) {
      idx = curr_idx; 
      idy = curr_idy - 1;
      for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
        if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
      }
    }
    
    // Check top grid
    if(curr_idy + 1 < grid_cnt_y) {
      idx = curr_idx; 
      idy = curr_idy + 1;
      for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
        if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
      }
    }
    
    // Check top left grid
    if(curr_idx - 1 > 0 && curr_idy + 1 < grid_cnt_y) {
      idx = curr_idx - 1; 
      idy = curr_idy + 1;
      for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
        if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
      }
    }
    
    // Check top right grid
    if(curr_idx + 1 < grid_cnt_x && curr_idy + 1 < grid_cnt_y) {
      idx = curr_idx + 1; 
      idy = curr_idy + 1;
      for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
        if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
      }
    }
    
    // Check bottom left grid
    if(curr_idx - 1 > 0 && curr_idy - 1 > 0) {
      idx = curr_idx - 1; 
      idy = curr_idy - 1;
      for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
        if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
      }
    }
    
    // Check bottom right grid
    if(curr_idx + 1 < grid_cnt_x && curr_idy - 1 > 0) {
      idx = curr_idx + 1; 
      idy = curr_idy - 1;
      for(int j = 0; j < max_particles && grid[idx][idy][j] != -1; j++) {
        if(grid[idx][idy][j] != i) particles[i].particle_system_apply(particles[grid[idx][idy][j]]); 
      }
    }

    
    
    
  }
  
  /*
  // Unoptimized method
  for(int i = 0; i < particles.length; i++)
    for(int j = 0; j < particles.length; j++) 
      if(i != j)
        particles[i].particle_system_apply(particles[j]); 
  */     
       
  // Grid ptr reset
  for(int i = 0; i < grid_cnt_x; i++) 
    for(int j = 0; j < grid_cnt_y; j++)
      grid_ptr[i][j] = 0;
  
}
