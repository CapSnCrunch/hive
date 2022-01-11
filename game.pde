class Game {
  int size = 3;
  int scale = 60;
  int offset = 1;
  Bug[][] grid = new Bug[this.size][this.size];
  
  int turn = 0;
  Player[] players = {new Player(), new Player()};
  
  Game(){
  }
  
  void display(){
    highlightHoveredTile();
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        if(this.grid[i][j] != null){
          this.grid[i][j].display(i - this.offset, j - this.offset, this.scale);
        } else if (this.hasNeighbor(i, j)){
          PVector Q = new PVector(1, 0).mult(this.scale);
          PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
          PImage emptyTile = loadImage("bugs/empty.png");
          emptyTile.resize(0, int(this.scale));
          image(emptyTile, Q.x * (i-this.offset) + R.x * (j-this.offset) + width/2, Q.y * (i-this.offset) + R.y * (j-this.offset) + height/2);
        }
      }
    }
  }
  
  int[] getCurrentHoverPosition(){
    PVector Q = new PVector(1, 0).mult(this.scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        PVector cellPosition = new PVector(width/2, height/2);
        if(dist(mouseX, mouseY, cellPosition.x + Q.x*(i-this.offset) + R.x*(j-this.offset), cellPosition.y + Q.y*(i-this.offset) + R.y*(j-this.offset)) < this.scale/2){
          int[] hoverPosition = {i, j};
          return hoverPosition;
        }
      }
    }
    int[] hoverPosition = {0, 0};
    return hoverPosition;
  }
  
  void highlightHoveredTile(){
    int[] currentHoverPosition = this.getCurrentHoverPosition();
    int i = currentHoverPosition[0];
    int j = currentHoverPosition[1];
    
    PVector Q = new PVector(1, 0).mult(this.scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
  
    PVector highlightPosition = new PVector(width/2, height/2);
    highlightPosition = highlightPosition.add(Q.mult(i - this.offset));
    highlightPosition = highlightPosition.add(R.mult(j - this.offset));
    
    if(this.grid[i][j] != null){
      // Display highlight ring around bug
      PImage ring = loadImage("bugs/ring.png");
      ring.resize(0, int(this.scale*1.22));
      image(ring, highlightPosition.x, highlightPosition.y);
    } else if (hasNeighbor(i, j)){
      // Display highlighted empty tile
      PImage emptyTile = loadImage("bugs/empty.png");
      emptyTile.resize(0, int(this.scale));
      image(emptyTile, highlightPosition.x, highlightPosition.y);
    }
  }
  
  boolean hasNeighbor(int i, int j){
    // Neighbor 1
    if (i-1 > 0){
      if (this.grid[i-1][j] != null){
        return true;
      }
    }
    
    // Neighbor 2
    if (i+1 < this.size){
      if (this.grid[i+1][j] != null){
        return true;
      }
    }
    
    // Neighbor 3
    if (j-1 > 0){
      if (this.grid[i][j-1] != null){
        return true;
      }
    }
    
    // Neighbor 4
    if (j+1 < this.size){
      if (this.grid[i][j+1] != null){
        return true;
      }
    }
    
    // Neighbor 5
    if (i+1 < this.size && j-1 > 0){
      if (this.grid[i+1][j-1] != null){
        return true;
      }
    }
    
    // Neighbor 6
    if (i-1 > 0 && j+1 < this.size){
      if (this.grid[i-1][j+1] != null){
        return true;
      }
    }
    
    return false;
  }
  
  void addBug(Bug bug, int q, int r){
    println("adding bug at", q+this.offset, r+this.offset);
    this.grid[q + this.offset][r + this.offset] = bug;
    if (q + this.offset == 0 || r + this.offset == 0 || q + this.offset + 1 == this.size || r + this.offset + 1 == this.size){
      Bug[][] tempGrid = new Bug[this.size + 2][this.size + 2];
      for (int i = 0; i < this.size; i++){
        for (int j = 0; j < this.size; j++){
          tempGrid[i+1][j+1] = this.grid[i][j];
        }
      }
      this.grid = tempGrid;
      this.size = this.size + 2;
      this.offset += 1;
    }
  }
}
